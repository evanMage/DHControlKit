//
//  TTTAttributedLabel+AddLink.m
//  DHAttributedLabelDemo
//
//  Created by daixinhui on 2018/2/28.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "TTTAttributedLabelAddLink.h"

static NSString *default_regular = @"[a-zA-Z-']+";

#define DEFAULT_SELECT_CORLOR       [UIColor colorWithRed:((0x56b882 & 0xFF0000) >> 16)/255.0 green:((0x56b882 & 0xFF00) >> 8)/255.0 blue:(0x56b882 & 0xFF)/255.0 alpha:1]

@implementation TTTAttributedLabel (AddLink)

- (void)addLinksWithDelegate:(id<TTTAttributedLabelDelegate>)delegate
{
    
    [self addLinksWithDelegate:delegate regularExpression:default_regular activeAttributes:@{kTTTBackgroundFillColorAttributeName:(__bridge id)DEFAULT_SELECT_CORLOR.CGColor,NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)addLinksWithDelegate:(id<TTTAttributedLabelDelegate>)delegate regularExpression:(NSString *)regular
{
    [self addLinksWithDelegate:delegate regularExpression:regular activeAttributes:@{kTTTBackgroundFillColorAttributeName:(__bridge id)DEFAULT_SELECT_CORLOR.CGColor,NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)addLinksWithDelegate:(id<TTTAttributedLabelDelegate>)delegate activeAttributes:(NSDictionary *)activeAttributes
{
    [self addLinksWithDelegate:delegate regularExpression:default_regular activeAttributes:activeAttributes];
}

- (void)addLinksWithDelegate:(id<TTTAttributedLabelDelegate>)delegate regularExpression:(NSString *)regular activeAttributes:(NSDictionary *)activeAttributes
{
    UIColor *fillColor = [activeAttributes objectForKey:NSBackgroundColorAttributeName];
    if (fillColor) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        UIColor *strokeColor = [activeAttributes objectForKey:NSForegroundColorAttributeName];
        [dict setValue:(__bridge id)[fillColor CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
        [dict setObject:strokeColor forKey:NSForegroundColorAttributeName];
        [self setDelegate:delegate regularExpression:regular activeAttributes:dict];
    }else{
        [self setDelegate:delegate regularExpression:regular activeAttributes:activeAttributes];
    }
}
// 添加点击事件
- (void)setDelegate:(id<TTTAttributedLabelDelegate>)delegate regularExpression:(NSString *)regular activeAttributes:(NSDictionary *)activeAttributes
{
    if (!delegate) {
        return;
    }
    self.userInteractionEnabled = YES;
    NSString *string = self.text;
    if (self.attributedText) {
        string = [self.attributedText string];
    }
    if (!string || string.length <= 0) {
        return;
    }
    self.linkAttributes = nil;
    self.inactiveLinkAttributes = nil;
    self.activeLinkAttributes = activeAttributes;
    [self resetLinks];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *array = [regularExpression matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        for (NSTextCheckingResult *retult in array) {
            NSString *word = [string substringWithRange:retult.range];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (delegate) {
                    self.delegate = delegate;
                    if (word && word.length > 0) {
                        [self addLinkToURL:[NSURL URLWithString:[word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] withRange:retult.range];
                    } else{
                        NSAssert(!word || word.length <=0, @"截取的word为nil，或是长度为0");
                    }
                    
                }
            });
        }
    });
}

@end
