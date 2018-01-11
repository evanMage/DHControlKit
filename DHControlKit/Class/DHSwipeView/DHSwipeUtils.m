//
//  DHSwipeUtils.m
//  headerDemo
//
//  Created by 代新辉 on 2018/1/8.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHSwipeUtils.h"

CGVector CGVectorFromCGPoint(CGPoint point) { return CGVectorMake(point.x, point.y); }

CGFloat CGPointMagnitude(CGPoint point) { return sqrtf(powf(point.x, 2) + powf(point.y, 2)); }

CGPoint CGPointNormalized(CGPoint point) {
    CGFloat magnitude = CGPointMagnitude(point);
    return CGPointMake(point.x / magnitude, point.y / magnitude);
}

CGPoint CGPointMultiply(CGPoint point, CGFloat factor) {
    return CGPointMake(point.x * factor, point.y * factor);
}

DHSwipeViewDirectionState DHSwipeViewDirectionFromVector(CGVector directionVector) {
    DHSwipeViewDirectionState direction = DHSwipeViewDirectionStateNone;
    if (ABS(directionVector.dx) > ABS(directionVector.dy)) {
        if (directionVector.dx > 0) {
            direction = DHSwipeViewDirectionStateRight;
        } else {
            direction = DHSwipeViewDirectionStateLeft;
        }
    } else {
        if (directionVector.dy > 0) {
            direction = DHSwipeViewDirectionStateDown;
        } else {
            direction = DHSwipeViewDirectionStateUp;
        }
    }
    
    return direction;
}

DHSwipeViewDirectionState DHSwipeViewDirectionFromPoint(CGPoint point) {
    return DHSwipeViewDirectionFromVector(CGVectorFromCGPoint(point));
}

@implementation DHSwipeUtils

@end
