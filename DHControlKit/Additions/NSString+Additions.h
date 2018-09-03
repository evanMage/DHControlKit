//
//  NSString+Additions.h
//  DHFramework
//
//  Created by daixinhui on 16/3/16.
//  Copyright © 2016年 daixinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Provide hash, encrypt, encode and some common method for 'NSString'.
 */
@interface NSString (Additions)

#pragma mark - Hash
///=============================================================================
/// @name Hash
///=============================================================================

/**
 * Returns a lowercase NSString for md2 hash
 */
- (nullable NSString *)md2String;

/**
 * Returns a lowercase NSString for md4 hash
 */
- (nullable NSString *)md4String;

/**
 * Returns a lowercase NSString for md5 hash.
 */
- (nullable NSString *)md5String;

/**
 * Returns a lowercase NSString for sha1 hash.
 */
- (nullable NSString *)sha1String;

/**
 * Returns a lowercase NSString for sha224 hash.
 */
- (nullable NSString *)sha224String;

/**
 * Returns a lowercase NSString for sha256 hash.
 */
- (nullable NSString *)sha256String;

/**
 * Returns a lowercase NSString for sha384 hash.
 */
- (nullable NSString *)sha384String;

/**
 * Returns a lowercase NSString for sha512 hash.
 */
- (nullable NSString *)sha512String;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA512StringWithKey:(NSString *)key;


#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 Returns an NSString for base64 encoded.
 */
- (nullable NSString *)base64EncodedString;

/**
 Returns an NSString from base64 encoded string.
 @param base64Encoding The encoded string.
 */
+ (nullable NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)stringByURLDecode;

/**
 Escape common HTML to Entity.
 Example: "a<b" will be escape to "a&lt;b".
 */
- (NSString *)stringByEscapingHTML;

#pragma mark - Drawing
///=============================================================================
/// @name Drawing
///=============================================================================

/**
 * Returns the size of the string if it were rendered with the specified constraints.
 * @param font          The font to use for computing the string size.
 * @param size          The maximum acceptable size for the string. This value is used to calculate where line breaks and wrapping would occur.
 * @param lineBreakMode The line break options for computing the size of the string. For a list of possible values, see NSLineBreakMode.
 * @return              The width and height of the resulting string's bounding box.
 * These values may be rounded up to the nearest whole number
 */

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 * Returns the width of the string if it were to be rendered with the specified font on a single line.
 * @param font The font to use for computing the string width.
 * @return The width of the resulting string's bounding box. These values may be rounded up to the nearest whole number.
 */
- (CGFloat)widthForFont:(UIFont *)font;

/**
 * Returns the Height of the the string if it were rendered with the specified constraints.
 * @param font      The font to use for computing the sting size.
 * @param withd     The maximum acceptable width for the string. This values is used to calculate where line breaks and wrapping would occur.
 * return The height of the resulting string's bounding box. These values may be rounded up to the nearest whole number.
 */
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

#pragma mark - Regular Expression
///=============================================================================
/// @name Regular Expression
///=============================================================================

/**
 Whether it can match the regular expression.
 
 @param regex   The regular expression.
 @param options The matching options to report.
 @return YES if can match the regex; otherwise, NO.
 */
- (BOOL)matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options;

/**
 Match the regular expression, and executes a given block using each object in the matches.
 
 @param regex   The regular expression.
 @param options The matching options to report.
 @param block   The block to apply to elements in the array of matches.
    The block takes four arguments:
        match: The matching iptions.
        matchRange: Thematching options.
        stop: A reference to a Boolean value. The block can set the value to YEs to stop further processing of the array. The stop this boolean to YES within the Block.
 */
- (void)enumerateRegexMatches:(NSString *)regex options:(NSRegularExpressionOptions)options usingBlock:(void(^)(NSString *match, NSRange matchRange, BOOL *Stop))block;

/**
 Returns a new string containing matching regular expressions replaced with the template string.
 
 @param regex       The regular expression.
 @param options     The matching options to report.
 @param replacement The substitution template used when replacing matching instances.
 @return A string with matching regular expressions replaced by the template string.
 */
- (NSString *)stringbyReplacingRegex:(NSString *)regex options:(NSRegularExpressionOptions)options withString:(NSString *)replacement;

#pragma mark - NSNumber Compatible
///=============================================================================
/// @name NSNumber Compatible
///=============================================================================

//Now you can use Nsstring as a NsNumber
@property (readonly) char charValue;
@property (readonly) unsigned char unsignedCharValue;
@property (readonly) short shortValue;
@property (readonly) unsigned short unsignedShortValue;
@property (readonly) unsigned int unsignedIntValue;
@property (readonly) long longValue;
@property (readonly) unsigned long unsignedLongValue;
@property (readonly) unsigned long long unsignedLongLongValue;
@property (readonly) NSUInteger unsignedIntegerValue;

#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================

/**
 * returns a new UUID string.
 */
+ (NSString *)stringWithUUID;

/**
 * returns a string containing the characters in a given UTF32Char.
 * @param char32 a UTF-32 character.
 * return a new string, or nil if the character is invalid.
 */
+ (nullable NSString *)stringWithUTF32Char:(UTF32Char)char32;
/**
 * Returns a string containing the characters in a given UTF32Char array.
 
 * @param char32 An array of UTF-32 character.
 * @param length The character count in array.
 * @return A new string, or nil if an error occurs.
 */
+ (nullable NSString *)stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length;
/**
 * Enumerates the unicode characters (UTF-32) in the specified range of the string.
 
 * @param range The range within the string to enumerate substrings.
 * @param block The block executed for the enumeration. The block takes four arguments:
        char32: The unicode character.
        range: The range in receiver. If the range.length is 1, the character is in BMP; otherwise (range.length is 2) the character is in none-BMP Plane and stored by a surrogate pair in the receiver.
        stop: A reference to a Boolean value that the block can use to stop the enumeration by setting *stop = YES; it should not touch *stop otherwise.
 */
- (void)enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block;

/**
 * Trim blank characters (space and newline) in head and tail.
 * return the trim string.
 */
- (NSString *)stringByTrim;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank;

/**
 * Return Yes if the target string is contained within the receiver.
 * @param str A string to text the receiver.
 * @discussion Apple has implemented this method in iOS8.
 * ios8以后实现了此方法
 */
- (BOOL)containsString:(NSString *)str;

/**
 * Returns YES if the target CharacterSet is contained within the receiver.
 * @param set  A character set to test the the receiver.
 */
- (BOOL)containsCharacterSet:(NSCharacterSet *)set;

/**
 * Try to parse this string and returns an `NSNumber`.
 * @return Returns an `NSNumber` if parse succeed, or nil if an error occurs.
 */
- (nullable NSNumber *)numberValue;

/**
 * Returns an NSData using utf-8 encoding.
 */
- (nullable NSData *)dataValue;

/**
 * returns NSMakeRange(0,self.length)
 */
- (NSRange)rangeofAll;

/**
 * Returns an NSDictionary/NSArray which is decoded from receiver.
 * Returns nil if an error occurs.
 
 * e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (nullable id)jsonValueDecoded;

/**
 * Create a string from the file in main bundle (similar to [UIImage imageNamed:]).
 
 * @param name The file name (in main bundle).
 
 * @return A new string create from the file in UTF-8 character encoding.
 */
+ (nullable NSString *)stringNamed:(NSString *)name;
/**
 * @param start   The string;
 */
- (BOOL)isStartWithString:(NSString*)start;

/**
 * @param end   The string;
 */
- (BOOL)isEndWithString:(NSString*)end;
@end

NS_ASSUME_NONNULL_END
