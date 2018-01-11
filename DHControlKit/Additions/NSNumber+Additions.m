//
//  NSNumber+Additions.m
//  DHFramework
//
//  Created by daixinhui on 16/3/21.
//  Copyright © 2016年 daixinhui. All rights reserved.
//

#import "NSNumber+Additions.h"

@implementation NSNumber (Additions)

+ (NSNumber *)numberWithString:(NSString *)string
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *str = [[string stringByTrimmingCharactersInSet:set] lowercaseString];
    if (!str || !str.length) {
        return nil;
    }
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]
                };
    });
    id num = dic[str];
    if (num) {
        if (num == [NSNull null]) {
            return nil;
        }
    }
    //hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) {
        sign = 1;
    }else if ([str hasPrefix:@"-0x"]){
        sign = -1;
    }
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc) {
            return [NSNumber numberWithLong:(long)num * sign];
        }else{
            return nil;
        }
    }
    //normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

@end
