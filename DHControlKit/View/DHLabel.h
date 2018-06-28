//
//  DHLabel.h
//  DHControlKit
//
//  Created by daixinhui on 2018/5/2.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHLabel : UIView

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSAttributedString *attributedText;
/** 字体大小 默认 17.0f */
@property (nonatomic, assign) CGFloat fontSize;
/** 字体颜色  默认 黑色 */
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) NSInteger numberOfLines;

@end

NS_ASSUME_NONNULL_END
