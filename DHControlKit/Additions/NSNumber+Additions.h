//
//  NSNumber+Additions.h
//  DHFramework
//
//  Created by daixinhui on 16/3/21.
//  Copyright © 2016年 daixinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * Provide a method to parse `NSString` for `NSNumber`.
 */
@interface NSNumber (Additions)
/**
 * Creates and returns an NSNumber object from a string.
 * Valid format:@"12",@"12.345",@" -OxFF",@" .23e99 "...
 * @param string    The string described an number.
 * return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END