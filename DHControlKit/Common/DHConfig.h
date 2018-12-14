//
//  DHConfig.h
//  DHControlKit
//
//  Created by 代新辉 on 2018/1/11.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import <sys/utsname.h>

#ifndef DHConfig_h
#define DHConfig_h
//物理尺寸
#define KEY_WINDOW_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define KEY_WINDOW_WIDTH     [[UIScreen mainScreen] bounds].size.width

#define KApplication        [UIApplication sharedApplication]
#define KKeyWindow          [UIApplication sharedApplication].keyWindow
#define KAppDelegate        [UIApplication sharedApplication].delegate
#define KNotificationCenter [NSNotificationCenter defaultCenter]
#define USER_DEFAULT        [NSUserDefaults standardUserDefaults]

//APP版本号
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define BundleID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

//系统版本号
#define KSystemVersion      [[UIDevice currentDevice] systemVersion]
#define IS_IOS_11           ([KSystemVersion doubleValue] >= 11.0)
#define IS_IOS_10           ([KSystemVersion doubleValue] >= 10.0)
// 弱引用/强引用
#define KWeakSelf(type)     __weak typeof(type) weak##type = type;
#define kStrongSelf(type)   __strong typeof(type) type = weak##type;

//判断属性非空
/** 判断array */
static inline BOOL IS_ARRAY_OBJECT(id object){
    return [object isKindOfClass:[NSArray class]] && [(NSArray*)object count] > 0;
}
/** 判断set */
static inline BOOL IS_SET_OBJECT(id object){
    return [object isKindOfClass:[NSSet class]] && [(NSSet*)object count] > 0;
}
/** 判断字符串 */
static inline BOOL IS_NSSTRING_OBJECT(id object){
    return [object isKindOfClass:[NSString class]] && [(NSString*)object length] > 0;
}
/** 判断字典 */
static inline BOOL IS_DICT_OBJECT(id object){
    return [object isKindOfClass:[NSDictionary class]] && [(NSDictionary*)object count] > 0;
}
#endif /* DHConfig_h */
