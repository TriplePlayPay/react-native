// MagTekModule.swift

import Foundation


@objc(TPPSDK)
class TPPSDK:  RCTEventEmitter {
    
    private static var reader: MagTekCardReader?
    
    @objc func initialize(_ apiKey: String) {
        TPPSDK.reader = MagTekCardReader(apiKey, debug: true)
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }

    override func supportedEvents() -> [String]! {
    return []
}
    
    @objc func startDeviceDiscovery(_ callback: @escaping RCTResponseSenderBlock) {
        TPPSDK.reader?.startDeviceDiscovery { name, rssi in
            callback([["name": name, "rssi": rssi]])
        }
    }
    
    @objc func cancelDeviceDiscovery() {
        TPPSDK.reader?.cancelDeviceDiscovery()
    }
    
    @objc func connect(_ deviceName: String, timeout: TimeInterval, callback: @escaping RCTResponseSenderBlock) {
        TPPSDK.reader?.connect(deviceName, timeout: timeout) { connected in
            callback([connected])
        }
    }
    
    @objc func disconnect() {
        TPPSDK.reader?.disconnect()
    }
    
    @objc func startTransaction(_ amount: String, callback: @escaping RCTResponseSenderBlock) {
        TPPSDK.reader?.startTransaction(amount) { [weak self] message, event, status in
            guard let reader = TPPSDK.reader else {
            callback([["message": "Reader not initialized", "event": "", "status": ""]])
            return
        }
            callback([["message": message, "event": MagTekCardReader.getEventMessage(event), "status": MagTekCardReader.getStatusMessage(status)]])
        }
    }
    
    @objc func getSerialNumber(_ callback: RCTResponseSenderBlock) {
        let serialNumber = TPPSDK.reader?.getSerialNumber() ?? ""
        callback([serialNumber])
    }
    
    @objc func cancelTransaction() {
        TPPSDK.reader?.cancelTransaction()
    }
}
