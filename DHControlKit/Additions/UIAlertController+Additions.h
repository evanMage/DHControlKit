//
//  UIAlertController+Additions.h
//  SogouTranslator
//
//  Created by daixinhui on 2019/1/15.
//  Copyright © 2019 sogou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Additions)

/**
 显示 UIAlertController (默认样式UIAlertControllerStyleAlert，最多两个AlertAction)
 
 @param title 标题
 @param message 提示信息
 @param block 回调block (index @[cancelTitle,otherTitles,...])
 @param cancelTitle 取消AlertAction标题
 @param otherTitle 其他AlertAction标题
 */
+ (void)showAlertControllerWithTitle:(nullable NSString *)title
                             message:(nullable NSString *)message
                         cancelTitle:(nullable NSString *)cancelTitle
                         otherTitle:(nullable NSString *)otherTitle
                       callBackBlock:(void (^__nullable)(NSInteger index, UIAlertAction *alertAction))block;

/**
 显示 UIAlertController (默认样式 UIAlertControllerStyleAlert)

 @param title 标题
 @param message 提示信息
 @param block 回调block (index @[cancelTitle,otherTitles,...])
 @param cancelTitle 取消AlertAction标题
 @param otherTitles 其他AlertAction标题数组
 */
+ (void)showAlertControllerWithTitle:(nullable NSString *)title
                             message:(nullable NSString *)message
                         cancelTitle:(nullable NSString *)cancelTitle
                         otherTitles:(nullable NSArray<NSString *> *)otherTitles
                       callBackBlock:(void (^__nullable)(NSInteger index, UIAlertAction *alertAction))block;

/**
 显示 UIAlertController

 @param title 标题
 @param message 提示信息
 @param preferredStyle UIAlertControllerStyle样式
 @param block 回调block (index @[cancelTitle,destructiveTitle,otherTitles,...])
 @param cancelTitle 取消AlertAction标题
 @param destructiveTitle 红色AlertAction标题
 @param otherTitles 其他AlertAction标题数组
 */
+ (void)showAlertControllerWithTitle:(nullable NSString *)title
                             message:(nullable NSString *)message
                      preferredStyle:(UIAlertControllerStyle)preferredStyle
                         cancelTitle:(nullable NSString *)cancelTitle
                    destructiveTitle:(nullable NSString *)destructiveTitle
                         otherTitles:(nullable NSArray<NSString *> *)otherTitles
                       callBackBlock:(void (^__nullable)(NSInteger index, UIAlertAction *alertAction))block;

@end

NS_ASSUME_NONNULL_END
