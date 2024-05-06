/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useEffect, useState} from 'react';
// import type {PropsWithChildren} from 'react';
import {
  Button,
  SafeAreaView,
  // ScrollView,
  // StatusBar,
  StyleSheet,
  Text,
  // useColorScheme,
  // View,
} from 'react-native';

import {TPPSDKModule} from '@tripleplaypay/react-native';

// import // Colors,
// DebugInstructions,
// Header,
// LearnMoreLinks,
// ReloadInstructions,
// 'react-native/Libraries/NewAppScreen';

// type SectionProps = PropsWithChildren<{
//   title: string;
// }>;

// function Section({children, title}: SectionProps): React.JSX.Element {
//   const isDarkMode = useColorScheme() === 'dark';
//   return (
//     <View style={styles.sectionContainer}>
//       <Text
//         style={[
//           styles.sectionTitle,
//           {
//             color: isDarkMode ? Colors.white : Colors.black,
//           },
//         ]}>
//         {title}
//       </Text>
//       <Text
//         style={[
//           styles.sectionDescription,
//           {
//             color: isDarkMode ? Colors.light : Colors.dark,
//           },
//         ]}>
//         {children}
//       </Text>
//     </View>
//   );
// }

function App(): React.JSX.Element {
  // const isDarkMode = useColorScheme() === 'dark';

  // const backgroundStyle = {
  //   backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  // };

  const [deviceInfo, setDeviceInfo] = useState<any>(null);
  const [connected, setConnected] = useState(false);
  // const [transactionResult, setTransactionResult] = useState<any>(null);
  const [serialNumber, setSerialNumber] = useState('');
  const {transactionResult, startTransaction} =
    TPPSDKModule.useTransactionUpdates();

  useEffect(() => {
    // console.log('TPP SDK MODULE 2:', TPPSDKModule);
    try {
      TPPSDKModule.initialize('testapikey');
    } catch (error) {
      console.log('Error initializing TPP SDK:', error);
    }

    setTimeout(() => {
      // console.log('TPP SDK MODULE 2:', TPPSDKModule);
      TPPSDKModule.startDeviceDiscovery(result => {
        setDeviceInfo(result);
      });
    }, 8000);
    return () => {
      TPPSDKModule.cancelDeviceDiscovery();
    };
  }, []);

  const handleStartSearching = () => {
    TPPSDKModule.startDeviceDiscovery(result => {
      console.log('Device Result:', result);
      setDeviceInfo(result);
    });
  };

  const handleConnect = () => {
    console.log('Attempting to Connect');
    if (deviceInfo) {
      TPPSDKModule.connect(deviceInfo.name, 5000, result => {
        console.log('RN Connect callback fired', result);
        setConnected(result);
      });
    }
  };

  const handleDisconnect = () => {
    TPPSDKModule.disconnect();
    setConnected(false);
  };

  const handleStartTransaction = () => {
    startTransaction('10.00');
  };

  const handleGetSerialNumber = () => {
    TPPSDKModule.getSerialNumber(result => {
      setSerialNumber(result);
    });
  };

  const handleCancelTransaction = () => {
    TPPSDKModule.cancelTransaction();
    // setTransactionResult(null);
  };

  // const styles = StyleSheet.create({

  // });

  return (
    <SafeAreaView style={styles.sectionContainer}>
      <>
        <Text>Device Info: {JSON.stringify(deviceInfo)}</Text>
        <Text>Connected: {connected ? 'Yes' : 'No'}</Text>
        <Button title="Connect" onPress={handleConnect} disabled={connected} />
        <Button
          title="Disconnect"
          onPress={handleDisconnect}
          disabled={!connected}
        />
        <Button
          title="Start Transaction"
          onPress={handleStartTransaction}
          disabled={!connected}
        />
        <Text>Transaction Result: {JSON.stringify(transactionResult)}</Text>
        <Button
          title="Get Serial Number"
          onPress={handleGetSerialNumber}
          disabled={!connected}
        />
        <Text>Serial Number: {serialNumber}</Text>
        <Button
          title="Cancel Transaction"
          onPress={handleCancelTransaction}
          disabled={!transactionResult}
        />

        <Button
          title="Stop Searching"
          onPress={TPPSDKModule.cancelDeviceDiscovery}
        />
        <Button title="Start Searching" onPress={handleStartSearching} />
        <Text style={{color: 'red'}}>
          Transaction Result: {JSON.stringify(transactionResult)}
        </Text>
      </>
    </SafeAreaView>
  );
}
const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
    color: 'red',
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
  centerView: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

export default App;
