// TPPSDKModule.kt

package com.tripleplaypay

import android.app.Activity
import android.util.Log
import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.tripleplaypay.magteksdk.MagTekCardReader
import java.lang.RuntimeException
import java.util.function.Supplier

private const val TAG = "TPPSDKModule"

@ReactModule(name = TPPSDKModule.NAME)
class TPPSDKModule(
  reactContext: ReactApplicationContext,
  private val activityGetter: Supplier<Activity>
) :
  ReactContextBaseJavaModule(reactContext) {
  companion object {
    private var reader: MagTekCardReader? = null
    public const val NAME: String = "TPPSDK";
  }

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  fun initialize(apiKey: String) {
    Log.d(TAG, "initialize: entered");
    Thread {
      Log.d(TAG, "initialize: polling for activity");
      var activity: Activity? = null;
      for (i in 0..5) {
        Log.d(TAG, "initialize: polling for activity, round ${i}");
        var a = reactApplicationContext.currentActivity
        Log.d(TAG, "initialize: polling for activity, round ${i} - RAC null: ${a == null}");
        if (a == null) {
          a = this.activityGetter.get()
          Log.d(TAG, "initialize: polling for activity, round ${i} - getter null: ${a == null}");
        }

        if (a != null) {
          activity = a;
          break
        }

        Log.d(TAG, "initialize: polling for activity, round ${i} - gave up, sleeping");
        Thread.sleep(1000L);
      }

      if (activity == null)
        throw RuntimeException("no current activity - should not happen")
      reader = MagTekCardReader(activity, apiKey)
    }.start()

    /*
    val activityContext =
      reactApplicationContext.currentActivity
    if (activityContext == null)
      throw RuntimeException("no current activity - should not happen")
    reader = MagTekCardReader(activityContext, apiKey)
    */
    // reader = MagTekCardReader(reactApplicationContext.getApplicationContext(), apiKey/*, debug = true*/)
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
