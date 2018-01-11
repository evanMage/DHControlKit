//
//  UIColor+Additions.m
//  SogouDictionary
//
//  Created by 代新辉 on 2017/10/26.
//  Copyright © 2017年 代新辉. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor*)colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.0];
}

/**
 *  由十六进制字符串获取颜色
 *
 *  @param hexColorString 格式格式：0xffffff、0xffffff有效
 *
 *  @return 相对应的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColorString
{
    return [UIColor colorWithHexString:hexColorString alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexColorString alpha:(float)alpha
{
    //    NSString *str = @"0xff055008";
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    //    unsigned long red = strtoul([str UTF8String],0,16);
    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    NSString *str = hexColorString;
    if (str.length == 6) {
        str = [NSString stringWithFormat:@"0x%@",hexColorString];
    }else if ([hexColorString hasPrefix:@"#"] && str.length == 7) {
        str = [hexColorString stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    }else if (str.length < 6 || str.length > 8){
        return [UIColor redColor];//格式错误
    }
    unsigned long hexColor = strtoul([str UTF8String],0,0);
    return [UIColor colorWithHex:hexColor alpha:alpha];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (CGFloat)redValueWithHex:(long)hexColor
{
    return ((float)((hexColor & 0xFF0000) >> 16))/255.0;
}

+ (CGFloat)greenValueWithHex:(long)hexColor
{
    return ((float)((hexColor & 0xFF00) >> 8))/255.0;
}

+ (CGFloat)blueValueWithHex:(long)hexColor
{
    return ((float)(hexColor & 0xFF))/255.0;
}

@end
