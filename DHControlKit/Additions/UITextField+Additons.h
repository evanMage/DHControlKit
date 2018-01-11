//
//  UITextField+Additons.h
//  DHFramework
//
//  Created by daixinhui on 16/4/21.
//  Copyright © 2016年 daixinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for 'UITextField'
 */
@interface UITextField (Additons)

/**
 Set all text selected.
 */
- (void)selectAllText;

/**
 Set text in range selected.
 @param range The range of selected text in a document.
 */
- (void)setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END