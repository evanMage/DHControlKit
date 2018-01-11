//
//  DHScrollTabbarView.h
//  DHSlideViewDemo
//
//  Created by daixinhui on 15/10/14.
//  Copyright © 2015年 daixinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHSlideTabbarProtocol.h"

#define kTrackViewHeight 1.5f 

@interface DHScrollTabbarItem : NSObject
@property(nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) BOOL countOfMessage;

+ (DHScrollTabbarItem *)itemWithTitle:(NSString *)title attributedString:(NSAttributedString *)attributedString width:(CGFloat)width;

@end

@interface DHScrollTabbarView : UIView<DHSlideTabbarProtocol>

@property (nonatomic, strong) UIView *backgroundView;
/** tab item 字体默认颜色 */
@property (nonatomic, strong) UIColor *tabItemNormalColor;
/** tab item 字体选中颜色 */
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
/** tab item 字体大小 */
@property (nonatomic, assign) CGFloat tabItemNormalFontSize;
/** tab item 粗体 */
@property (nonatomic, assign) BOOL tabItemBold;
/** 底层线颜色 默认clearColor */
@property (nonatomic, strong) UIColor *lineColor;
/** 滑动线条颜色 */
@property (nonatomic, strong) UIColor *trackColor;
/** item 数组 */
@property (nonatomic, strong) NSArray *tabbarItems;
/** 滑动线条宽度是否跟文字长度相同 否则跟显示文字的区域宽度相同 */
@property (nonatomic, assign) BOOL trackViewWidthEqualToTextLength;
/** 滑动线条圆角 */
@property (nonatomic, assign) CGFloat trackViewCornerRadius;
/**
 *DHSlideTabbarProtocol
 */
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, readonly) NSInteger tabbarCount;
@property(nonatomic, getter=isDivideEqually) BOOL divideEqually;
@property(nonatomic, weak) id<DHSlideTabbarDelegate> delegate;

- (void)switchFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex percent:(float)percent;

@end
