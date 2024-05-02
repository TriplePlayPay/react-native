package com.tripleplaypay

import android.app.Activity
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import java.util.function.Supplier


class TPPSDKPackage(private val activityGetter: Supplier<Activity>) : ReactPackage {

  override fun createNativeModules(reactContext: ReactApplicationContext): MutableList<NativeModule> {
    return mutableListOf(TPPSDKModule(reactContext, activityGetter))
  }

  override fun createViewManagers(reactContext: ReactApplicationContext): MutableList<ViewManager<*, *>> {
    // If you have custom view managers, they would be added here.
    return mutableListOf()
  }
}
