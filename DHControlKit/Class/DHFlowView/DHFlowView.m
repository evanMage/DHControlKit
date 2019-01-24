//
//  DHFlowView.m
//  DHControlKit
//
//  Created by daixinhui on 2018/12/14.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import "DHFlowView.h"
#import "DHFlowLayout.h"

@interface DHFlowView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DHFlowLayout *flowLayout;

@end

@implementation DHFlowView

//MARK: - instancetype

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defauleSets];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self defauleSets];
}

//MARK: - lazy methods

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

//MARK: - private methods

- (void)defauleSets
{
    self.backgroundColor = [UIColor clearColor];
    self.flowUtils = [[DHFlowUtils alloc] init];
}

- (UICollectionView *)createCollectionView
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    collectionView.backgroundColor = UIColor.clearColor;
    if (self.flowUtils.scrollingEffect == DHFlowScrollingEffectNormal) {
        collectionView.pagingEnabled = YES;
    }else{
        collectionView.contentInset = self.flowUtils.contentInset;
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    DXHDINFO(@"-----------------%@",NSStringFromUIEdgeInsets(collectionView.contentInset));
    return collectionView;
}

//MARK: - publick methods

- (void)setupUI
{
    self.collectionView = nil;
    [self.collectionView removeFromSuperview];
    self.flowLayout = [[DHFlowLayout alloc] initWithFlowUtils:self.flowUtils];
    UICollectionView *collectionView = [self createCollectionView];
    [self addSubview:collectionView];
    NSDictionary *viewBingings = NSDictionaryOfVariableBindings(collectionView);
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-space-[collectionView]-space-|"
                                                                 options:kNilOptions
                                                                 metrics:@{@"space":self.flowUtils.scrollingEffect == DHFlowScrollingEffectNormal?@(self.flowUtils.contentInset.left):@(0)}
                                                                   views:viewBingings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[collectionView]-space-|"
                                                                 options:kNilOptions
                                                                 metrics:@{@"space":self.flowUtils.scrollingEffect == DHFlowScrollingEffectNormal?@(self.flowUtils.contentInset.top):@(0)}
                                                                   views:viewBingings]];
    self.collectionView = collectionView;
}

- (void)registerNib:(NSString *)nibName forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemsInFlowView:)]) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[self.dataSource itemsInFlowView:self]];
        return self.dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(flowView:collectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSource flowView:self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowView:didSelectItemAtIndex:)]) {
        [self.delegate flowView:self didSelectItemAtIndex:indexPath.item];
    }
}

@end
