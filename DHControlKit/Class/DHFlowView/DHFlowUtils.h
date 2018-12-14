//
//  DHFlowUtils.h
//  DHControlKit
//
//  Created by daixinhui on 2018/12/14.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DHFlowScrollDirection) {
    DHFlowScrollDirectionVertical,
    DHFlowScrollDirectionHorizontal
};

typedef NS_ENUM(NSInteger, DHFlowScrollingEffect) {
    DHFlowScrollingEffectNormal,
    DHFlowScrollingEffectCard,
    DHFlowScrollingEffectTransform
};

typedef NS_ENUM(NSInteger, DHFlowScrollWay) {
    DHFlowScrollWayNormal,
    DHFlowScrollWayAuto,
};

NS_ASSUME_NONNULL_BEGIN

@interface DHFlowUtils : NSObject

@property (nonatomic) CGFloat minimumSpacing;//Default 10.0f
@property (nonatomic) CGSize itemSize;
@property (nonatomic) DHFlowScrollDirection scrollDirection;//Default DHFlowScrollDirectionHorizontal
@property (nonatomic) DHFlowScrollingEffect scrollingEffect;//Default DHFlowScrollingEffectTransform
@property (nonatomic) DHFlowScrollWay scrollWay;//Default DHFlowScrollWayNormal
@property (nonatomic) NSTimeInterval timeInterval;//Default 3.0s

@end

NS_ASSUME_NONNULL_END
