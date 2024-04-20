import Foundation

struct MagTekBluetoothInfo {
    let name: String
    let rssi: Int32
    let address: String
}

public enum MagTekTransactionEvent: UInt8 { // range from 0x00 -> 0x0a
    case noEvents = 0x00, cardInserted, paymentMethodError, progressChange, waiting, timeout,
         complete, canceled, cardRemoved, contactless, cardSwipe
}

public enum MagTekTransactionStatus: UInt8 { // range all over the place, we have to be explicit
    case noStatus = 0x00, waiting, reading, selectingApplication, selectingCardholderLanguage, selectingCardholderApplication,
         initiatingApplication, readingApplicationData, offlineAuthentication, processingRestrictions, cardholderVerification,
         terminalRiskManagement, terminalActionAnalysis, generatingCryptogram, cardActionAnalysis, onlineProcessing,
         waitingForProcessing, complete, error, approved, declined, canceledByMSR, emvConditionsNotSatisfied,
         emvCardBlocked, contactSelectionFailed, emvCardNotAccepted, emptyCandidateList, applicationBlocked
    case hostCanceled = 0x91
    case applicationSelectionFailed = 0x28, removedCard, collisionDetected, referToHandheldDevice, contactlessComplete,
         requestSwitchToMSR, wrongCardType, noInterchangeProfile
}

class MagTekBLEController: NSObject, MTSCRAEventDelegate {
    private enum MagTekCommand: String {
        case setMSR = "580101"
        case setBLE = "480101"
        case setDateTimePrefix = "030C001800"
    }
    
    private var devices: [String: MagTekBluetoothInfo] = [:]
    private var deviceSerial: String = "00000000000000000000000000000000"
    
    private var bluetoothState: MTSCRABLEState?
    private var scanning: Bool = false
    
    // internal state
    private var displayMessage: String = ""
    private var transactionEvent: MagTekTransactionEvent = .noEvents
    private var transactionStatus: MagTekTransactionStatus = .noStatus
    
    // callback declarations
    public var onDeviceDiscovered: ((String, Int32) -> ())?
    public var onConnection: ((Bool) -> ())?
    public var onTransaction: ((String, MagTekTransactionEvent, MagTekTransactionStatus) -> ())?
    public var onError: ((String) -> ())?
    
    private var debug: Bool = false
    
    private let lib: MTSCRA = MTSCRA()
    private let apiKey: String
    public init(_ deviceType: Int, apiKey: String) {
        self.apiKey = apiKey

        super.init()
        self.lib.setDeviceType(UInt32(deviceType))
        self.lib.setConnectionType(UInt(BLE_EMV))
        self.lib.delegate = self
    }
    
    // -- MT CALLBACKS --
    func bleReaderStateUpdated(_ state: MTSCRABLEState) { self.bluetoothState = state }
    
    func onDeviceList(_ instance: Any!, connectionType: UInt, deviceList: [Any]!) {
        for device in (deviceList as! [MTDeviceInfo])  {
            if !devices.keys.contains(device.name) {
                self.devices[device.name] = MagTekBluetoothInfo(
                    name: device.name,
                    rssi: device.rssi,
                    address: device.address
                )
                self.onDeviceDiscovered?(device.name, device.rssi)
            }
        }
    }
    
//    func onTransactionStatus(_ data: Data!) {
//        self.transactionEvent = MagTekTransactionEvent(rawValue: data[0])!
//        self.transactionStatus = MagTekTransactionStatus(rawValue: data[2])!
//        self.onTransaction?(self.displayMessage, self.transactionEvent, self.transactionStatus)
//    }
    
//    func onTransactionResult(_ data: Data!) {}
//    
    func onDisplayMessageRequest(_ data: Data!) {
        self.displayMessage = ""
        for token in data {
            self.displayMessage += String(UnicodeScalar(token))
        }
        self.onTransaction?(self.displayMessage, self.transactionEvent, self.transactionStatus)
    }
    
//    func onARQCReceived(_ data: Data!) {
//        print("ARQC:")
//        
//        var arqc: String = "" // format the same way magtek would
//        for byte in data {
//            arqc += String(format: "%02X", byte)
//        }
//        
//        let url = URL(string: "http://192.168.1.153/api/emv")
//        var request = URLRequest(url: url!)
//        
//        request.httpMethod = "POST"
//        // data includes non-printable characters because it's in TLV format, so we'll pass it as b64
//        request.httpBody = try! JSONSerialization.data(withJSONObject: ["payload": arqc])
//        request.setValue(self.apiKey, forHTTPHeaderField: "Authorization") // set the API key header
//        
//        // make an HTTP request
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                self.onTransaction?(String(data: data, encoding: .utf8)!, self.transactionEvent, self.transactionStatus)
//            } else if let error = error {
//                print(error)
//            }
//        }
//        
//        task.resume()
//    }
    
    // -- END CALLBACKS --
    
    // public utility functions
    public func startDeviceDiscovery() {
        self.devices = [:] // clear devices before scanning
        if let state = self.bluetoothState {
            if (state == 0 || state == 3) { // 0 = Ok, 3 = Disconnected (which is also Ok...)
                self.lib.startScanningForPeripherals()
            }
        }
    }
    
    public func connect(_ deviceName: String, _ timeout: TimeInterval) {
        if let device = self.devices[deviceName] {
            self.lib.setAddress(device.address)
            self.lib.openDevice()
            
            let interval: Double = 0.1
            var elapsed: Double = timeout
            
            Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { timer in
                if elapsed <= 0.0 {
                    timer.invalidate()
                    self.onConnection?(false)
                }
                
                if self.lib.isDeviceConnected() && self.lib.isDeviceOpened() {
                    timer.invalidate()
                    self.lib.clearBuffers() // clear the message buffers after connecting

                    self.deviceSerial = self.lib.getDeviceSerial() ?? self.deviceSerial
                    self.lib.sendCommandSync(MagTekCommand.setMSR.rawValue) // put device into MSR mode
                    self.lib.sendCommandSync(MagTekCommand.setBLE.rawValue) // set response mode to BLE, then set date + time
                    self.lib.sendExtendedCommandSync(MagTekCommand.setDateTimePrefix.rawValue + self.deviceSerial + getDateByteString())
                    
                    self.onConnection?(true)
                }
                
                elapsed -= interval
            })
        }
    }
    
    public func cancelDeviceDiscovery() { self.lib.stopScanningForPeripherals() }
    public func cancelTransaction() { self.lib.cancelTransaction() }
    
    public func disconnect() {
        self.lib.clearBuffers()
        self.lib.closeDevice()
    }
    
    public func getSerialNumber() -> String {
        if self.lib.isDeviceConnected() {
            return self.lib.getDeviceSerial()
        } else {
            return "disconnected"
        }
    }
    
    public func startTransaction(_ amount: String, cashback: String) {
        var amountBytes = n12Bytes(amount)
        var cashbackBytes = n12Bytes(cashback)
        var currencyCode = hexStringBytes("0840")
        
        self.lib.startTransaction(60,
            cardType: 7, // always offer all 3
            option: 0, // we aren't using quick EMV
            amount: &amountBytes,
            transactionType: 0, // sale
            cashBack: &cashbackBytes,
            currencyCode: &currencyCode,
            reportingOption: 2) // verbose reporting
    }
    
    // public setters
    public func setDebug(_ debug: Bool) {
        MTSCRA.enableDebugPrint(debug)
        self.debug = debug
    }
}
