package com.tpp_rn_example

import com.facebook.react.ReactActivity
import com.facebook.react.ReactActivityDelegate
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.fabricEnabled
import com.facebook.react.defaults.DefaultReactActivityDelegate

private const val TAG = "MainActivity"

class MainActivity : ReactActivity() {

  // override fun onCreate(
  //   savedInstanceState: Bundle?,
  //   persistentState: PersistableBundle?
  // ) {
  //   super.onCreate(savedInstanceState, persistentState)
  //   Log.d(TAG, "onCreate: saving the activity")
  //   // MainApplication.activity[0] = this;
  // }

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  override fun getMainComponentName(): String = "tpp_rn_example"

  /**
   * Returns the instance of the [ReactActivityDelegate]. We use [DefaultReactActivityDelegate]
   * which allows you to enable New Architecture with a single boolean flags [fabricEnabled]
   */
  override fun createReactActivityDelegate(): ReactActivityDelegate =
      DefaultReactActivityDelegate(this, mainComponentName, fabricEnabled)
}
