//
//  TTTAttributedLabel+AddLink.h
//  DHAttributedLabelDemo
//
//  Created by daixinhui on 2018/2/28.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "TTTAttributedLabel.h"

@interface TTTAttributedLabel (AddLink)

/** 添加单词点击
 * 只添加英文单词
 */
- (void)addLinksWithDelegate:(id<TTTAttributedLabelDelegate>)delegate;

/** 条件添加
 *  regular 正则
 */
- (void)addLinksWithDelegate:(id<TTTAttributedLabelDelegate>)delegate regularExpression:(NSString *)regular;

/**
 点击态配置
 @param delegate delegate
 @param activeAttributes attributed string dict
 */
- (void)addLinksWithDelegate:(id<TTTAttributedLabelDelegate>)delegate activeAttributes:(NSDictionary *)activeAttributes;

/**
 条件添加 & 点击态配置
 @param delegate delegate
 @param regular 正则
 @param activeAttributes attributed string dict 
 */
- (void)addLinksWithDelegate:(id<TTTAttributedLabelDelegate>)delegate regularExpression:(NSString *)regular activeAttributes:(NSDictionary *)activeAttributes;

@end
