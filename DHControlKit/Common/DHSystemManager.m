//
//  DHSystemManager.m
//  DHControlKit
//
//  Created by daixinhui on 2018/11/26.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import "DHSystemManager.h"
#import <sys/utsname.h>

//iPhone
static NSString *iPhone3_1  = @"iPhone3,1";//iPhone 4
static NSString *iPhone3_2  = @"iPhone3,2";//iPhone 4
static NSString *iPhone3_3  = @"iPhone3,3";//iPhone 4
static NSString *iPhone4_1  = @"iPhone4,1";//iPhone 4s
static NSString *iPhone5_1  = @"iPhone5,1";//iPhone 5
static NSString *iPhone5_2  = @"iPhone5,2";//iPhone 5
static NSString *iPhone5_3  = @"iPhone5,3";//iPhone 5c
static NSString *iPhone5_4  = @"iPhone5,4";//iPhone 5c
static NSString *iPhone6_1  = @"iPhone6,1";//iPhone 5s
static NSString *iPhone6_2  = @"iPhone6,2";//iPhone 5s
static NSString *iPhone7_1  = @"iPhone7,1";//iPhone 6 Plus
static NSString *iPhone7_2  = @"iPhone7,2";//iPhone 6
static NSString *iPhone8_1  = @"iPhone8,1";//iPhone 6S
static NSString *iPhone8_2  = @"iPhone8,2";//iPhone 6S Plus
static NSString *iPhone8_4  = @"iPhone8,4";//iPhone SE
static NSString *iPhone9_1  = @"iPhone9,1";//iPhone 7
static NSString *iPhone9_2  = @"iPhone9,2";//iPhone 7 Plus
static NSString *iPhone9_3  = @"iPhone9,3";//iPhone 7
static NSString *iPhone9_4  = @"iPhone9,4";//iPhone 7 Plus
static NSString *iPhone10_1 = @"iPhone10,1";//iPhone 8
static NSString *iPhone10_2 = @"iPhone10,2";//iPhone 8 Plus
static NSString *iPhone10_3 = @"iPhone10,3";//iPhone X
static NSString *iPhone10_4 = @"iPhone10,4";//iPhone 8
static NSString *iPhone10_5 = @"iPhone10,5";//iPhone 8 Plus
static NSString *iPhone10_6 = @"iPhone10,6";//iPhone X
static NSString *iPhone11_2 = @"iPhone11,2";//iPhone XS
static NSString *iPhone11_4 = @"iPhone11,4";//iPhone XS Max
static NSString *iPhone11_6 = @"iPhone11,6";//iPhone XS Max
static NSString *iPhone11_8 = @"iPhone11,8";//iPhone XR

//iPod

//iPad

@interface DHSystemManager ()

@property (nonatomic, copy) NSString *iPhoneModelNumStr;

@end

@implementation DHSystemManager

//MARK: - instancetype

DXH_OBJECT_SINGLETON_BOILERPLATE(DHSystemManager, sharedManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

//MARK: - lazy methods

- (NSString *)iPhoneModelNumStr
{
    if (!_iPhoneModelNumStr) {
        struct utsname systemInfo;
        uname(&systemInfo);
        _iPhoneModelNumStr = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    }
    return _iPhoneModelNumStr;
}

//MARK: - private methods

- (void)defaultSettings
{
    
}

//MARK: - public methods

- (UserDeviceResolution)getUserDeviceResolution
{
    UserDeviceResolution userDevice = UserDeviceResolutionOther;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat resolution = height * scale;
    if (height == 480.0f) {
        userDevice = UserDeviceResolution3_5;
    }else if (height == 568.0f) {
        userDevice = UserDeviceResolution4_0;
    }else if (height == 667.0f) {
        userDevice = UserDeviceResolution4_7;
    }else if (height == 736.0f) {
        userDevice = UserDeviceResolution5_5;
    }else if (height == 812.0f) {
        userDevice = UserDeviceResolution5_8;
    }else if (height == 896.0f && resolution == 1792.0f) {
        userDevice = UserDeviceResolution6_1;
    }else if (height == 896.0f && resolution == 2688.0f) {
        userDevice = UserDeviceResolution6_5;
    }
    return userDevice;
}

@end
