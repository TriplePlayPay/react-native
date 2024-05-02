// TPPSDKModule.kt

package com.tripleplaypay

import com.facebook.react.bridge.*

//import com.tripleplaypay

@ReactModule(name = TPPSDKModule.NAME)
class TPPSDKModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    companion object {
        private var reader: MagTekCardReader? = null
    }

    public static final String NAME = "TPPSDK";

    override fun getName(): String {
        return NAME
    }

    @ReactMethod
    fun initialize(apiKey: String) {
        reader = MagTekCardReader(reactContext, apiKey, debug = true)
    }

    @ReactMethod
    fun startDeviceDiscovery(callback: Callback) {
        reader?.startDeviceDiscovery { name, rssi ->
            val deviceInfo = Arguments.createMap().apply {
                putString("name", name)
                putInt("rssi", rssi)
            }
            callback.invoke(deviceInfo)
        }
    }

    @ReactMethod
    fun cancelDeviceDiscovery() {
        reader?.cancelDeviceDiscovery()
    }

    @ReactMethod
    fun connect(deviceName: String, timeout: Double, callback: Callback) {
        reader?.connect(deviceName, timeout.toLong()) { connected ->
            callback.invoke(connected)
        }
    }

    @ReactMethod
    fun disconnect() {
        reader?.disconnect()
    }

    @ReactMethod
    fun startTransaction(amount: String, callback: Callback) {
        reader?.startTransaction(amount) { message, event, status ->
            val transactionResult = Arguments.createMap().apply {
                putString("message", message)
                putString("event", MagTekCardReader.getEventMessage(event))
                putString("status", MagTekCardReader.getStatusMessage(status))
            }
            callback.invoke(transactionResult)
        }
    }

    @ReactMethod
    fun getSerialNumber(callback: Callback) {
        val serialNumber = reader?.getSerialNumber() ?: ""
        callback.invoke(serialNumber)
    }

    @ReactMethod
    fun cancelTransaction() {
        reader?.cancelTransaction()
    }
}
