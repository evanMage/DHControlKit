//
//  DHScrollView.h
//  headerDemo
//
//  Created by 代新辉 on 2017/12/8.
//  Copyright © 2017年 代新辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHParallaxHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class DHScrollView;

@protocol DHScrollViewDelegate <UIScrollViewDelegate>

@optional

/**
 是否滚动子视图

 @param scrollView the scrollView
 @param subView sub View
 @return YES scroll together, default YES.
 */
- (BOOL)DHScrollView:(DHScrollView *)scrollView shouldScrollWithSubView:(UIScrollView *)subView;

@end

@interface DHScrollView : UIScrollView

@property (nonatomic, weak, nullable) id<DHScrollViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
