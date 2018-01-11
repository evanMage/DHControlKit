//
//  DHSwipeUtils.h
//  headerDemo
//
//  Created by 代新辉 on 2018/1/8.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHSwipeView.h"
CGVector CGVectorFromCGPoint(CGPoint point);

CGFloat CGPointMagnitude(CGPoint point);

CGPoint CGPointNormalized(CGPoint point);

CGPoint CGPointMultiply(CGPoint point, CGFloat factor);

DHSwipeViewDirectionState DHSwipeViewDirectionFromVector(CGVector directionVector);

DHSwipeViewDirectionState DHSwipeViewDirectionFromPoint(CGPoint point);

@interface DHSwipeUtils : NSObject

@end
