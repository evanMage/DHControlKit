//
//  UIViewController+Additions.m
//  SogouTranslator
//
//  Created by daixinhui on 2019/1/15.
//  Copyright © 2019 sogou. All rights reserved.
//

#import "UIViewController+Additions.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIViewController (Additions)

+ (UIViewController *)currentViewController
{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    return [self topViewController:rootViewController];
}

+ (UIViewController *)topViewController:(UIViewController *)viewController
{
    if (viewController.presentedViewController) {
        return [self topViewController:viewController.presentedViewController];
    } else if ([viewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        return [self topViewController:nav.topViewController];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)viewController;
        return [self topViewController:tab.selectedViewController];
    } else {
        return viewController;
    }
    return nil;
}

@end
