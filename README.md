
# TPP React Native SDK


## Getting Started

### iOS

To get started with the TPP React Native SDK on iOS, follow these steps:

1. Install the TPP React Native SDK and link the pods:
   ```bash
   npm install @tripleplaypay/react-native
   npx pod-install
   ```
2. Add the Bluetooth permission to your app's `Info.plist` file:
   - The app's `Info.plist` must contain an `NSBluetoothAlwaysUsageDescription` key with a string value explaining to the user how the app uses this data.

3. Add the `MagTekSDK.xcframework` from `Pods > TPP-MagTekSDK > Frameworks` into your target project's General > Frameworks, Libraries, and Embedded Content section. Set it to `Embed & Sign`.

4. Import the `@tripleplaypay/react-native` module in your project:

   ```jsx
   import {TPPSDKModule} from '@tripleplaypay/react-native';
   ```

5. Prior to any usage, initialize the SDK with your publishable key:

   ```jsx
   TPPSDKModule.initialize('test-key-example');
   ```
