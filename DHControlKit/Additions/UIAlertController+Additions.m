//
//  UIAlertController+Additions.m
//  SogouTranslator
//
//  Created by daixinhui on 2019/1/15.
//  Copyright © 2019 sogou. All rights reserved.
//

#import "UIAlertController+Additions.h"

@implementation UIAlertController (Additions)

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle callBackBlock:(void (^)(NSInteger, UIAlertAction * _Nonnull))block
{
    [self showAlertControllerWithTitle:title message:message cancelTitle:cancelTitle otherTitles:@[otherTitle] callBackBlock:block];
}

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray<NSString *> *)otherTitles callBackBlock:(void (^)(NSInteger, UIAlertAction * _Nonnull))block
{
    [self showAlertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert cancelTitle:cancelTitle destructiveTitle:nil otherTitles:otherTitles callBackBlock:block];
}

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSArray<NSString *> *)otherTitles callBackBlock:(void (^)(NSInteger, UIAlertAction * _Nonnull))block
{
    NSInteger index = 0;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (cancelTitle.length) {
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(index, action);
            }
        }];
        index++;
        [alertController addAction:cancelAlert];
    }
    if (destructiveTitle.length) {
        UIAlertAction *destructiveAlert = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(index, action);
            }
        }];
        index++;
        [alertController addAction:destructiveAlert];
    }
    for (NSString *subTitle in otherTitles) {
        UIAlertAction *otherAlert = [UIAlertAction actionWithTitle:subTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(index, action);
            }
        }];
        index++;
        [alertController addAction:otherAlert];
    }
    UIViewController *viewController = [UIViewController currentViewController];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
