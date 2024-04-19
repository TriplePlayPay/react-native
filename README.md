
# TPP React Native SDK


## Getting Started

### iOS

To get started with the TPP React Native SDK on iOS, follow these steps:

1. Ensure your minimum iOS deployment target is set to 15.0 or later. If you have a Podfile, ensure it is set to 15.0 or later like this:

   ```ruby
   platform :ios, '15.0'
   ```

2. Install the TPP React Native SDK and link the pods:

   ```bash
   npm install @tripleplaypay/react-native
   npx pod-install
   ```
   **Note:** The `npx pod-install` command may fail if you did not have a Podfile before. If it fails, follow these steps:
   a. Open your `ios/Podfile` in a text editor. If it doesn't exist, create it in the `ios` directory of your project.

   b. Ensure the iOS version is set to 15.0 or later in your Podfile, like this:

      ```ruby
      platform :ios, '15.0'
      ```

   c. Run `npx pod-install` again. It should succeed this time.


3. Add the Bluetooth permission to your app's `Info.plist` file:
   - The app's `Info.plist` must contain an `NSBluetoothAlwaysUsageDescription` key with a string value explaining to the user how the app uses this data.

4. Add the `MagTekSDK.xcframework` from `Pods > TPP-MagTekSDK > Frameworks` into your target project's General > Frameworks, Libraries, and Embedded Content section. Set it to `Embed & Sign`.
  
5. Import the `@tripleplaypay/react-native` module in your project:

   ```jsx
   import {TPPSDKModule} from '@tripleplaypay/react-native';
   ```

6. Prior to any usage, initialize the SDK with your publishable key:

   ```jsx
   TPPSDKModule.initialize('test-key-example');
   ```
