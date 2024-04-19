// MagTekModule.tsx

import { NativeModules } from 'react-native';

const { TPPSDK } = NativeModules;

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
    TPPSDK.connect(deviceName, timeout, (result: boolean[]) => {
      if (result.length > 0) {
        callback(result[0]);
      }
    });
  },

  disconnect(): void {
    TPPSDK.disconnect();
  },

  /**
   * Starts a transaction with a MagTek device
   * @param amount The amount to charge
   * @param callback The callback to call when the transaction is complete
   */
  startTransaction(
    amount: string,
    callback: (result: TransactionResult) => void
  ): void {
    TPPSDK.startTransaction(amount, (result: TransactionResult[]) => {
      if (result.length > 0) {
        callback(result[0]);
      }
    });
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
};

export type TPPSDKModuleType = typeof TPPSDKModule;
