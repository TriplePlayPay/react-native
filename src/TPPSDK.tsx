// MagTekModule.tsx

import { useEffect, useState } from 'react';
import { NativeEventEmitter, NativeModules } from 'react-native';

const { TPPSDK } = NativeModules;
const tppSDKModuleEmitter = new NativeEventEmitter(TPPSDK);

type DeviceInfo = {
  name: string;
  rssi: number;
};

type TransactionResult = {
  message: string;
  event: string;
  status: string;
};

export const TPPSDKModule = {
  /**
   * Initialize the TPPSDK. This must be called first
   * @param publishableKey Your TPP Publishable Key
   */
  initialize(publishableKey: string): void {
    TPPSDK.initialize(publishableKey);
  },

  /**
   * Starts MagTek device discovery.
   * This will return devices one at a time as they are found
   * @param callback The callback to call when the device discovery is complete
   */
  startDeviceDiscovery(callback: (result: DeviceInfo) => void): void {
    TPPSDK.startDeviceDiscovery((result: DeviceInfo) => {
      console.log('Device Result (internal):', result);
      if (result) {
        callback(result);
      }
    });
  },

  cancelDeviceDiscovery(): void {
    TPPSDK.cancelDeviceDiscovery();
  },

  /**
   * Connects to a chosen MagTek device
   * @param deviceName The name of the device to connect to
   * @param timeout The timeout in seconds
   * @param callback The callback to call when the connection is complete
   */
  connect(
    deviceName: string,
    timeout: number,
    callback: (connected: boolean) => void
  ): void {
    TPPSDK.connect(deviceName, timeout, (result: boolean) => {
      callback(result);
    });
  },

  disconnect(): void {
    TPPSDK.disconnect();
  },

  /**
   * Starts a transaction with a MagTek device
   * @param amount The amount to charge

   */
  startTransaction(amount: string): void {
    TPPSDK.startTransaction(amount);
  },

  /**
   * Retrieves the serial number of the connected MagTek device
   * @param callback The callback to call when the serial number is retrieved
   */
  getSerialNumber(callback: (serialNumber: string) => void): void {
    TPPSDK.getSerialNumber((result: string) => {
      if (result) {
        callback(result);
      }
    });
  },

  cancelTransaction(): void {
    TPPSDK.cancelTransaction();
  },

  useTransactionUpdates: () => {
    const [transactionResult, setTransactionResult] =
      useState<TransactionResult | null>(null);

    useEffect(() => {
      const subscription = tppSDKModuleEmitter.addListener(
        'TransactionUpdate',
        (result: TransactionResult) => {
          console.log('Transaction Update:', result);
          setTransactionResult(result);
        }
      );

      return () => {
        subscription.remove();
      };
    }, []);

    const startTransaction = (amount: string) => {
      TPPSDKModule.startTransaction(amount);
    };

    return { transactionResult, startTransaction };
  },
};

export type TPPSDKModuleType = typeof TPPSDKModule;

console.log('Available native modules:', NativeModules);
