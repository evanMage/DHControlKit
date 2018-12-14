//
//  DHFlowView.h
//  DHControlKit
//
//  Created by daixinhui on 2018/12/14.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHFlowUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHFlowView : UIView

@property (nonatomic, strong) DHFlowUtils *flowUtils;

/** 数据、flowUtils更改调用此方法 */
- (void)reloadData;

@end

@protocol DHFlowViewDataSource <NSObject>

@required

- (NSArray *)itemsInFlowView:(DHFlowView *)flowView;

- (UICollectionViewCell *)flowView:(DHFlowView *)flowView viewForRowAtIndex:(NSInteger)index;


@end

@protocol DHFlowViewDelegate <NSObject>

@optional

- (void)flowView:(DHFlowView *)flowView didSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
