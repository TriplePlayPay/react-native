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
    timeout = 10,
    callback: (connected: boolean) => void
  ): void {
    if (timeout <= 0) {
      timeout = 10;
    }
    TPPSDK.connect(deviceName, timeout, (result: boolean) => {
      callback(result);
    });
  },

  disconnect(): void {
    TPPSDK.disconnect();
  },

  // /**
  //  * Starts a transaction with a MagTek device
  //  * @param amount The amount to charge

  //  */
  // startTransaction(amount: string): void {
  //   TPPSDK.startTransaction(amount);
  // },

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

  /**
   * Cancels the transaction the device is waiting to start.
   * This will not cancel a transaction that has submitted its network
   * request.
   */
  cancelTransaction(): void {
    TPPSDK.cancelTransaction();
  },

  /**
   * Custom hook to manage transaction updates and state.
   * This hook provides:
   * - `transactionResult`: Holds a statefully updated result of a transaction as it
   * progresses through each phase, including message, event type, and status.
   * - `startTransaction`: Function to initiate a transaction with a specified amount.
   * @returns An object containing the transaction result state and a method to start a transaction.
   */
  useTransactionUpdates: () => {
    const [transactionResult, setTransactionResult] =
      useState<TransactionResult | null>(null);

    useEffect(() => {
      const subscription = tppSDKModuleEmitter.addListener(
        'TransactionUpdate',
        (result: TransactionResult) => {
          // console.log('Transaction Update:', result);
          setTransactionResult(result);
        }
      );

      return () => {
        subscription.remove();
      };
    }, []);

    /**
     * Initiates a transaction with the specified amount.
     * @param amount The monetary amount for the transaction.
     */
    const startTransaction = (amount: string) => {
      TPPSDK.startTransaction(amount);
    };

    return { transactionResult, startTransaction };
  },
};

export type TPPSDKModuleType = typeof TPPSDKModule;
