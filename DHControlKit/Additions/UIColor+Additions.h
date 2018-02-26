//
//  UIColor+Additions.h
//  SogouDictionary
//
//  Created by 代新辉 on 2017/10/26.
//  Copyright © 2017年 代新辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Additions)

/**
 *  将十六进制的颜色数值转为对应的UIColor
 *
 *  @param hexColor 色值的十六进制表示
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(long)hexColor;

/**
 *  将十六进制的颜色数值转为对应的UIColor,并设置透明度
 *
 *  @param hexColor 色值的十六进制表示
 *  @param opacity  透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

/**
 *  由十六进制字符串获取颜色
 *
 *  @param hexColorString 色值的十六进制 string 格式格式：0xffffff、ffffff、#ffffff 有效
 *
 *  @return 相对应的颜色 格式错误返回 [UIColor redColor]）
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColorString;

/**
 *  将十六进制的颜色数值转为对应的UIColor 并可以设置alpha
 *
 *  @param hexColorString 色值的十六进制 string 格式格式：0xffffff、ffffff、#ffffff 有效
 *  @param alpha          alpha
 *
 *  @return UIColor （格式错误返回 [UIColor redColor]）
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColorString alpha:(float)alpha;

/**
 随机生成颜色
 
 @return UIColor
 */
+ (UIColor *)colorRandom;

/**
 *根据输入的16进制的颜色数值，输出对应的RGB色值
 */
+ (CGFloat)redValueWithHex:(long)hexColor;

+ (CGFloat)greenValueWithHex:(long)hexColor;

+ (CGFloat)blueValueWithHex:(long)hexColor;

@end

NS_ASSUME_NONNULL_END
