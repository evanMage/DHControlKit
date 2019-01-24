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

@protocol DHFlowViewDelegate, DHFlowViewDataSource;

@interface DHFlowView : UIView

@property (nonatomic, strong) DHFlowUtils *flowUtils;

@property (nonatomic, weak) id<DHFlowViewDelegate>delegate;
@property (nonatomic, weak) id<DHFlowViewDataSource>dataSource;

/** 加载UI （flowUtils更改调用此方法） */
- (void)setupUI;

/** 刷新数据 */
- (void)reloadData;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable NSString *)nibName forCellWithReuseIdentifier:(NSString *)identifier;

@end

@protocol DHFlowViewDataSource <NSObject>

@required

- (NSArray *)itemsInFlowView:(DHFlowView *)flowView;

- (UICollectionViewCell *)flowView:(DHFlowView *)flowView collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;


@end

@protocol DHFlowViewDelegate <NSObject>

@optional

- (void)flowView:(DHFlowView *)flowView didSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
