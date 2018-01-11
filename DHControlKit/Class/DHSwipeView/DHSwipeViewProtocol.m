//
//  DHSwipeViewProtocol.m
//  headerDemo
//
//  Created by 代新辉 on 2018/1/9.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHSwipeViewProtocol.h"
#import "DHSwipeUtils.h"

//////////////////////////////////////////////////////////////////////////

@implementation DHSwipeViewDefaultDeterminator

- (BOOL)shouldSwipeView:(UIView *)view movement:(DHSwipeViewMovement *)movement swipeView:(DHSwipeView *)swipeView
{
//    return YES;
    CGPoint translation = movement.translation;
    CGPoint velocity = movement.velocity;
    CGRect bounds = swipeView.bounds;
    CGFloat minTranslationInPercent = swipeView.minTranslationInPercent;
    CGFloat minVelocityInPointPerSecond = swipeView.minVelocityInPointPerSecond;
    CGFloat allowedDirection = swipeView.allowedDirectionState;
    
//    BOOL swipe = [self isDirectionAllowed:translation allowedDirection:allowedDirection] && [self isTranslation:translation inTheSameDirectionWithVelocity:velocity] && ([self isTranslationLargeEnough:translation minTranslationInPercent:minTranslationInPercent bounds:bounds] || [self isVelocityLargeEnough:velocity minVelocityInPointPerSecond:minVelocityInPointPerSecond]);
    //不考虑加速度
    BOOL swipe = [self isDirectionAllowed:translation allowedDirection:allowedDirection] && ([self isTranslationLargeEnough:translation minTranslationInPercent:minTranslationInPercent bounds:bounds] || [self isVelocityLargeEnough:velocity minVelocityInPointPerSecond:minVelocityInPointPerSecond]);

    return swipe;
}

- (BOOL)isTranslation:(CGPoint)p1 inTheSameDirectionWithVelocity:(CGPoint)p2 {
    return signNum(p1.x) == signNum(p2.x) && signNum(p1.y) == signNum(p2.y);
}

- (BOOL)isDirectionAllowed:(CGPoint)translation allowedDirection:(DHSwipeViewDirectionState)allowedDirection {
    return (DHSwipeViewDirectionFromPoint(translation) & allowedDirection) != DHSwipeViewDirectionStateNone;
}

- (BOOL)isTranslationLargeEnough:(CGPoint)translation  minTranslationInPercent:(CGFloat)minTranslationInPercent bounds:(CGRect)bounds {
    return ABS(translation.x) > minTranslationInPercent * bounds.size.width ||
    ABS(translation.y) > minTranslationInPercent * bounds.size.height;
}

- (BOOL)isVelocityLargeEnough:(CGPoint)velocity minVelocityInPointPerSecond:(CGFloat)minVelocityInPointPerSecond {
    return CGPointMagnitude(velocity) > minVelocityInPointPerSecond;
}

int signNum(CGFloat n) {
    return (n < 0) ? -1 : (n > 0) ? +1 : 0;
    
}

@end

//////////////////////////////////////////////////////////////////////////

@implementation DHSwipeViewDefaultDirection

- (DHSwipeViewOptions *)interpretDirection:(DHSwipeViewDirectionState)direction view:(UIView *)view index:(NSUInteger)index viewArray:(NSArray<UIView *> *)viewArray swipeView:(DHSwipeView *)swipeView
{
    CGFloat programaticSwipeVelocity = 1000;
    CGPoint location = CGPointMake(view.center.x, view.center.y * 0.7);
    CGVector directionVector;
    switch (direction) {
        case DHSwipeViewDirectionStateLeft:
            directionVector = CGVectorMake(-programaticSwipeVelocity, 0);
            break;
        case DHSwipeViewDirectionStateRight:
            directionVector = CGVectorMake(programaticSwipeVelocity, 0);
            break;
        case DHSwipeViewDirectionStateUp:
            directionVector = CGVectorMake(0, -programaticSwipeVelocity);
            break;
        case DHSwipeViewDirectionStateDown:
            directionVector = CGVectorMake(0, programaticSwipeVelocity);
            break;
        default:
            directionVector = CGVectorMake(0, 0);
            break;
    }
    DHSwipeViewOptions *swipeViewOptions =  [[DHSwipeViewOptions alloc] initWithLocation:location direction:directionVector];
    return swipeViewOptions;
}

@end
