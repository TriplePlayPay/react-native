
# TPP React Native SDK
## Getting Started
Install the SDK
```bash
npm install @tripleplaypay/react-native
```
### iOS
To get started with the TPP React Native SDK on iOS, follow these steps:
1. Install the TPP React Native SDK and link the pods:
```bash
npx pod-install
```
2. Open the XCWorkspace file under `ios/` in XCode. You can do so from the commandline like this:
```bash
open ./ios/MyProject.xcworkspace
```
3. Add the Bluetooth permission to your app's `Info.plist` file:
  - The app's `Info.plist` must contain an `NSBluetoothAlwaysUsageDescription` key with a string value explaining to the user how the app uses this data.
  - You can easily configure this from the Info tab. Click on the `+` button under any of the entries and select `Privacy - Bluetooth Always Usage Description` and make sure to place an accurate description in the text box next to it.
3. Under the signing and capabilities tab, make sure to set up your Apple account for signing the application.
4. Add the `MagTekSDK.xcframework.
  - Under the `General` tab, Click on the `+` symbol
  - Select the library `Workspace > Pods > MagTekSDK.xcframework`
  - Click add
5. Make sure to build the project in XCode first, this will place the app on your phone. Afterwards you can run the react-native server using:
```bash
npx react-native start
```

### Android

If our Android MagTek SDK doesn't resolve, you may need to add our repo to the `allprojects` section of your android app's gradle file, like so:

```
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri('https://maven.pkg.github.com/TriplePlayPay/TPP-Android-MagTekSDK')
            credentials {
                username "${GITHUB_USER}"
                password "${GITHUB_TOKEN}"
            }
        }
    }
}
```

### Usage:

1. Import the `@tripleplaypay/react-native` module in your project:
```jsx
import {TPPSDKModule} from '@tripleplaypay/react-native';
```

2. Prior to any usage, initialize the SDK with your publishable key:
```jsx
TPPSDKModule.initialize('test-key-example');
```

3. To initiate a transaction, use the `useTransactionUpdates` hook to get the `startTransaction` method and a stateful `transactionResult` object that updates during each phase of the transaction processing. 
   
   Use the hook inside of a react component so that transactionResult changes will trigger re-render effects:

```tsx
const {transactionResult, startTransaction} = TPPSDKModule.useTransactionUpdates();

// Start the transaction
startTransaction('10.00');

```
The `message` property on `transactionResult` will begin statefully updating with messages such as:
"PRESENT CARD" when it is ready for the user to pay, "APPROVED" if the transaction submitted to TPP servers successfully, or "DECLINED" for other failures.