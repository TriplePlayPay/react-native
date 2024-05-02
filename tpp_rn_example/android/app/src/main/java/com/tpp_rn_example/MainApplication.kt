package com.tpp_rn_example

import android.app.Application
import com.facebook.react.*
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.load
import com.facebook.react.defaults.DefaultReactHost.getDefaultReactHost
import com.facebook.react.defaults.DefaultReactNativeHost
import com.facebook.soloader.SoLoader
import com.tripleplaypay.reactnative.BuildConfig

class MainApplication : Application(), ReactApplication {

  override val reactNativeHost: ReactNativeHost =
    object : DefaultReactNativeHost(this) {
      override fun getPackages(): List<ReactPackage> =
        listOf()
        // PackageList(this).packages.apply {
        //   // Packages that cannot be autolinked yet can be added manually here, for example:
        //   add(MyReactNativePackage())
        //   add(TPPSDKPackage())
        // }

      override fun getJSMainModuleName(): String = "index"

      override fun getUseDeveloperSupport(): Boolean = BuildConfig.DEBUG

      override val isNewArchEnabled: Boolean = true; // BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
      override val isHermesEnabled: Boolean = true; // BuildConfig.IS_HERMES_ENABLED
    }

  override val reactHost: ReactHost
    get() = getDefaultReactHost(this.applicationContext, reactNativeHost)

  override fun onCreate() {
    super.onCreate()
    SoLoader.init(this, false)
    if (BuildConfig.IS_INTERNAL_BUILD) {
      // If you opted-in for the New Architecture, we load the native entry point for this app.
      load()
    }
  }
}
