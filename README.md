
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

3. Add the Bluetooth permission to your app's `Info.plist` file:
   - The app's `Info.plist` must contain an `NSBluetoothAlwaysUsageDescription` key with a string value explaining to the user how the app uses this data.

4. Add the `MagTekSDK` from `Pods > TPP-MagTekSDK > Frameworks` into your target project's General > Frameworks, Embedded Binaries, and Linked Frameworks sections. Set to `Embed & Sign`.
  
5. Import the `@tripleplaypay/react-native` module in your project:

   ```jsx
   import {TPPSDKModule} from '@tripleplaypay/react-native';
   ```

6. Prior to any usage, initialize the SDK with your publishable key:

   ```jsx
   TPPSDKModule.initialize('test-key-example');
   ```
