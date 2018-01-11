//
//  DHViewAnimator.m
//  headerDemo
//
//  Created by 代新辉 on 2018/1/8.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHViewAnimator.h"

@implementation DHViewAnimator

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return radians * 180 / M_PI;
}

- (void)rotateView:(UIView *)view forDegree:(float)degree  duration:(NSTimeInterval)duration atOffsetFromCenter:(CGPoint)offset swipeableView:(DHSwipeView *)swipeableView
{
    float rotationRadian = [self degreesToRadians:degree];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        view.center = [swipeableView convertPoint:swipeableView.center fromView:swipeableView.superview];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(offset.x, offset.y);
        transform = CGAffineTransformRotate(transform, rotationRadian);
        transform = CGAffineTransformTranslate(transform, -offset.x, -offset.y);
        view.transform = transform;
    } completion:nil];
}

- (void)animateView:(UIView *)view index:(NSUInteger)index viewArray:(NSArray<UIView *> *)viewArray swipeView:(DHSwipeView *)swipeView
{
    CGFloat degree = 1;
    NSTimeInterval duration = 0.4;
    CGPoint offset = CGPointMake(0, CGRectGetHeight(swipeView.bounds) * 0.3);
    switch (index) {
        case 0:
            [self rotateView:view forDegree:0 duration:duration atOffsetFromCenter:offset swipeableView:swipeView];
            break;
        case 1:
            [self rotateView:view forDegree:degree duration:duration atOffsetFromCenter:offset swipeableView:swipeView];
            break;
        case 2:
            [self rotateView:view forDegree:-degree duration:duration atOffsetFromCenter:offset swipeableView:swipeView];
            break;
        case 3:
            [self rotateView:view forDegree:0 duration:duration atOffsetFromCenter:offset swipeableView:swipeView];
            break;
        default:
            break;
    }
}


@end
