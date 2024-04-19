
# TPP React Native SDK


## Getting Started

### iOS

To get started with the TPP React Native SDK on iOS, follow these steps:

1. Install the TPP React Native SDK:

   ```bash
   npm install @tripleplaypay/react-native
   ```

2. Add the Bluetooth permission to your app's `Info.plist` file:
   - The app's `Info.plist` must contain an `NSBluetoothAlwaysUsageDescription` key with a string value explaining to the user how the app uses this data.

3. Add the `MagTekSDK` from `Pods > TPP-MagTekSDK > Frameworks` into your target project's General > Frameworks, Embedded Binaries, and Linked Frameworks sections. Set to `Embed & Sign`.