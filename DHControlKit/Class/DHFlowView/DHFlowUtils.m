//
//  DHFlowUtils.m
//  DHControlKit
//
//  Created by daixinhui on 2018/12/14.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import "DHFlowUtils.h"

@implementation DHFlowUtils

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultSets];
    }
    return self;
}

- (void)defaultSets
{
    self.scaleFactor = 0.9;
    self.scrollDirection = DHFlowScrollDirectionHorizontal;
    self.scrollingEffect = DHFlowScrollingEffectTransform;
    self.scrollWay = DHFlowScrollWayNormal;
    self.timeInterval = 3.0f;
}

@end
