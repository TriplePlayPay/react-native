// MagTekModule.swift

import Foundation
import MagTekSDK

@objc(TPPSDK)
class TPPSDK:  RCTEventEmitter {
  private static var reader: MagTekCardReader?
  private var transactionCallbackCalled: Bool = false

  @objc func initialize(_ apiKey: String) {
    TPPSDK.reader = MagTekCardReader(apiKey, debug: true)
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  override func supportedEvents() -> [String]! {
    return ["TransactionUpdate"]
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
    TPPSDK.reader?.connect(deviceName) { connected in
      print("connected: \(connected)")
      callback([connected])
    }
  }

  @objc func disconnect() {
    TPPSDK.reader?.disconnect()
  }

  @objc func startTransaction(_ amount: String) {
    TPPSDK.reader?.startTransaction(amount) { [weak self] message, event, status in
      let transactionInfo = [
        "message": message,
        "event": MagTekCardReader.getEventMessage(event),
        "status": MagTekCardReader.getStatusMessage(status)
      ]
      self?.sendEvent(withName: "TransactionUpdate", body: transactionInfo)
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
