//
//  DHSystemManager.h
//  DHControlKit
//
//  Created by daixinhui on 2018/11/26.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import <Foundation/Foundation.h>

//判断设备分辨率
typedef NS_ENUM(NSInteger,UserDeviceResolution) {
    UserDeviceResolutionOther,//其他
    UserDeviceResolution3_5,//3.5" (iPhone4、4s)
    UserDeviceResolution4_0,//4.0" (iPhone5、5c、5s、SE)
    UserDeviceResolution4_7,//4.7" (iPhone6、7、8、6s、7s)
    UserDeviceResolution5_5,//5.5" (iPhone6p、7p、8p、6sp、7sp)
    UserDeviceResolution5_8,//5.8 (iPhoneX、XS)
    UserDeviceResolution6_1,//6.1" (iPhoneXR)
    UserDeviceResolution6_5,//6.5 (iPhoneXMax)
};

#define DHSYSTEM_MANAGER_SHARED     ([DHSystemManager sharedManager])

NS_ASSUME_NONNULL_BEGIN

@interface DHSystemManager : NSObject

/** 单例 */
+ (DHSystemManager *)sharedManager;

/** 获取分辨率枚举 */
- (UserDeviceResolution)getUserDeviceResolution;

@end

/** 判断设备分辨率
 @param resolution UserDeviceResolution
 @return BOOL
 */
static inline BOOL IS_DEVICE(UserDeviceResolution resolution) {
    return ([DHSYSTEM_MANAGER_SHARED getUserDeviceResolution] == resolution);
}

/**
 判断设备分辨率 大于等于
 
 @param resolution UserDeviceResolution
 @return BOOL
 */
static inline BOOL greaterThanOrEqualTo(UserDeviceResolution resolution) {
    return ([STSYSTEM_MANAGER_SHARED getUserDeviceResolution] >= resolution);
}

/**
 判断设备分辨率 小于等于
 
 @param resolution UserDeviceResolution
 @return BOOL
 */
static inline BOOL lessThanOrEqualTo(UserDeviceResolution resolution) {
    return ([STSYSTEM_MANAGER_SHARED getUserDeviceResolution] <= resolution);
}


NS_ASSUME_NONNULL_END
