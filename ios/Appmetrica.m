#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RoboroxAppmetrica, NSObject)

RCT_EXTERN_METHOD(initPush:(*NSString)deviceToken)

RCT_EXTERN_METHOD(reportUserProfile:(NSDictionary)profile)

@end
