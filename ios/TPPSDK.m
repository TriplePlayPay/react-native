// TPPSDKModuleExposure.m

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(TPPSDK, RCTEventEmitter)

// Expose the module to React Native
// The first parameter is the name of the Swift class, and the second is the name you want to use in JavaScript.
// If the second parameter is nil, it uses the Swift class name by default.


// Expose methods
// Replace "methodName" with your actual method names
RCT_EXTERN_METHOD(startDeviceDiscovery:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(cancelDeviceDiscovery)
RCT_EXTERN_METHOD(connect:(NSString *)deviceName timeout:(nonnull NSNumber *)timeout callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(disconnect)
RCT_EXTERN_METHOD(startTransaction:(NSString *)amount callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(getSerialNumber:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(cancelTransaction)
RCT_EXTERN_METHOD(initialize:(NSString *)apiKey)

@end

