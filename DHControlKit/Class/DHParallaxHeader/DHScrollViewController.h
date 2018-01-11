//
//  DHScrollViewController.h
//  headerDemo
//
//  Created by 代新辉 on 2017/12/8.
//  Copyright © 2017年 代新辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHScrollViewController : UIViewController

@property (nonatomic,readonly) DHScrollView *scrollView;
@property (nonatomic,strong,nullable) UIViewController *headerViewController;
@property (nonatomic,strong,nullable) UIViewController *childViewController;

@end

@interface UIViewController (DHParallaxHeader)

@property (nonatomic,readonly,nullable) DHParallaxHeader *parallaxHeader;

@end

/** headerViewController form storyboard */
@interface DHParallaxHeaderSegue : UIStoryboardSegue

@end

/** childViewController rom storyboard */
@interface DHScrollViewControllerSegue : UIStoryboardSegue

@end


NS_ASSUME_NONNULL_END
