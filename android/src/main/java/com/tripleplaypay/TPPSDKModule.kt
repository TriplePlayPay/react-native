// TPPSDKModule.kt

package com.tripleplaypay

import android.annotation.SuppressLint
import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.tripleplaypay.magteksdk.MagTekCardReader
import java.util.function.Supplier

private const val TAG = "TPPSDKModule"

@ReactModule(name = TPPSDKModule.NAME)
class TPPSDKModule(
  reactContext: ReactApplicationContext,
  private val activityGetter: Supplier<Activity?>
) :
  ReactContextBaseJavaModule(reactContext) {
  companion object {
    @SuppressLint("StaticFieldLeak")
    private var reader: MagTekCardReader? = null
    const val NAME: String = "TPPSDK";
  }

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  fun initialize(apiKey: String) {
    Log.d(TAG, "initialize: entered");
    val ii = arrayOf(0)
    val function: Array<Runnable?> = arrayOf(null);
    function[0] = Runnable {
      val activity = readActivityFromReactNativeOrOurStaticVar(ii)

      if (activity != null) {
        reader = MagTekCardReader(activity, apiKey)
        return@Runnable
      }

      if (ii[0] == 10)
        throw RuntimeException("no current activity - should not happen")
      ii[0]++;
      Handler(Looper.getMainLooper()).postDelayed({ function[0]?.run() }, 250L)
    }

    Handler(Looper.getMainLooper()).postDelayed({ function[0]?.run() }, 250L)

    /*
    val activityContext =
      reactApplicationContext.currentActivity
    if (activityContext == null)
      throw RuntimeException("no current activity - should not happen")
    reader = MagTekCardReader(activityContext, apiKey)
    */
    // reader = MagTekCardReader(reactApplicationContext.getApplicationContext(), apiKey/*, debug = true*/)
  }

  private fun readActivityFromReactNativeOrOurStaticVar(ii: Array<Int>): Activity? {
    Log.d(TAG, "initialize: polling, round ${ii[0]}");
    var activity = reactApplicationContext.currentActivity

    Log.d(TAG, "initialize: polling, round ${ii[0]} - RAC null: ${activity == null}")
    if (activity == null) {
      activity = this.activityGetter.get()
      Log.d(TAG, "initialize: polling, round ${ii[0]} - getter null: ${activity == null}")
    }
    return activity
  }

  @ReactMethod
  fun startDeviceDiscovery(callback: Callback) {
    reader?.startDeviceDiscovery(30_000L) { name, rssi ->
      val deviceInfo = Arguments.createMap().apply {
        putString("name", name)
        putInt("rssi", rssi)
      }
      callback.invoke(deviceInfo)
    }
  }

  @ReactMethod
  fun cancelDeviceDiscovery() {
    // reader?.cancelDeviceDiscovery()
  }

  @ReactMethod
  fun connect(deviceName: String, timeout: Double, callback: Callback) {
    reader?.connect(deviceName, timeout.toFloat()) { connected ->
      callback.invoke(connected)
    }
  }

  @ReactMethod
  fun disconnect() {
    reader?.disconnect()
  }

  @ReactMethod
  fun startTransaction(amount: String, callback: Callback) {
    // reader?.startTransaction(amount) { message, event, status ->
    //     val transactionResult = Arguments.createMap().apply {
    //         putString("message", message)
    //         putString("event", MagTekCardReader.getEventMessage(event))
    //         putString("status", MagTekCardReader.getStatusMessage(status))
    //     }
    //     callback.invoke(transactionResult)
    // }
  }

  @ReactMethod
  fun getSerialNumber(callback: Callback) {
    // val serialNumber = reader?.getSerialNumber() ?: ""
    // callback.invoke(serialNumber)
  }

  @ReactMethod
  fun cancelTransaction() {
    // reader?.cancelTransaction()
  }
}
