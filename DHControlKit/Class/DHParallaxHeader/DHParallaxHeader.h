//
//  DHParallaxHeader.h
//  headerDemo
//
//  Created by 代新辉 on 2017/12/8.
//  Copyright © 2017年 代新辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** header mode */
typedef NS_ENUM(NSInteger,DHParallaxHeaderMode) {
    /** 内容可能会被剪切 */
    DHParallaxHeaderModeFill = 0,
    /** 并在标题栏的顶部对齐 */
    DHParallaxHeaderModeTopFill,
    /** 将内容对齐到标题栏的顶部 */
    DHParallaxHeaderModeTop,
    /** 比例不变 */
    DHParallaxHeaderModeCenter,
    /** 内容对齐在页眉边界的底部 */
    DHParallaxHeaderModeBottom
};

IB_DESIGNABLE

@protocol DHParallaxHeaderDelegate;

/** parallax header for UIScrollView */
@interface DHParallaxHeader : NSObject

/** UIScrollView 的内容视图 */
@property (nonatomic, readonly) UIView *contentView;
/** delegate */
@property (nonatomic,weak,nullable) id<DHParallaxHeaderDelegate> delegate;
/** 头部View */
@property (nonatomic,strong,nullable) UIView *view;
/** 头部高度 默认 0 */
@property (nonatomic, assign) IBInspectable CGFloat height;
/** 头部最小高度 默认 0 */
@property (nonatomic, assign) IBInspectable CGFloat minimumHeight;
/** mode */
@property (nonatomic, assign) DHParallaxHeaderMode mode;
/** 头部 进度 */
@property (nonatomic, readonly, assign) CGFloat progress;

@end

@protocol DHParallaxHeaderDelegate <NSObject>

@optional

/**
 Tells the header view that the parallax header did scroll.
 The view typically implements this method to obtain the change in progress from parallaxHeaderView.
 
 @param parallaxHeader The parallax header that scrolls.
 */
- (void)parallaxHeaderDidScroll:(DHParallaxHeader *)parallaxHeader;

@end

@interface UIScrollView (DHParallaxHeader)

/** The parallax header */
@property (nonatomic, strong) DHParallaxHeader *parallaxHeader;

@end

NS_ASSUME_NONNULL_END
