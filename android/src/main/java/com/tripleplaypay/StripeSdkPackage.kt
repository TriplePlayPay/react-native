package com.tripleplaypay.reactnative

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.tripleplaypay.reactnative.addresssheet.AddressSheetViewManager
import com.tripleplaypay.reactnative.pushprovisioning.AddToWalletButtonManager

class StripeSdkPackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return listOf<NativeModule>(StripeSdkModule(reactContext))
    }

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
      return listOf<ViewManager<*, *>>(
        CardFieldViewManager(),
        AuBECSDebitFormViewManager(),
        StripeContainerManager(),
        CardFormViewManager(),
        GooglePayButtonManager(),
        AddToWalletButtonManager(reactContext),
        AddressSheetViewManager()
      )
    }
}
