//
//  UIViewController+Additions.h
//  SogouTranslator
//
//  Created by daixinhui on 2019/1/15.
//  Copyright © 2019 sogou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Additions)

/**
 return the current viewController

 @return UIViewController
 */
+ (UIViewController *)currentViewController;

@end

NS_ASSUME_NONNULL_END
