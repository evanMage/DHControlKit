//
//  DHFlowViewController.m
//  DHControlKit
//
//  Created by daixinhui on 2018/12/17.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import "DHFlowViewController.h"
#import "DHFLowView.h"
#import "DHFlowViewCell.h"

@interface DHFlowViewController ()<DHFlowViewDelegate, DHFlowViewDataSource>

@property (nonatomic, strong) DHFlowView *flowView;

@end

@implementation DHFlowViewController

#pragma mark - life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

#pragma mark - lazy methods

- (DHFlowView *)flowView
{
    if (!_flowView) {
        _flowView = [[DHFlowView alloc] init];
    }
    return _flowView;
}

#pragma mark - private methods

- (void)setupUI
{
    [self.view addSubview:self.flowView];
    [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    DHFlowUtils *flowUtils = [[DHFlowUtils alloc] init];
    flowUtils.itemSize = CGSizeMake(KEY_WINDOW_WIDTH - 100, KEY_WINDOW_HEIGHT - 400);
    flowUtils.scrollingEffect = DHFlowScrollingEffectNormal;
    flowUtils.contentInset = UIEdgeInsetsMake(0, 50, 0, 50);
    flowUtils.minimumSpacing = 0;
    self.flowView.flowUtils = flowUtils;
    self.flowView.delegate = self;
    self.flowView.dataSource = self;
    [self.flowView setupUI];
    [self.flowView registerNib:DHFlowViewCell.className forCellWithReuseIdentifier:@"flowCell"];
    [self.flowView reloadData];
}

#pragma mark - DHFlowViewDelegate & DHFlowViewDataSource

- (NSArray *)itemsInFlowView:(DHFlowView *)flowView
{
    return @[@"1",@"1",@"1",@"1"];
}

- (UICollectionViewCell *)flowView:(DHFlowView *)flowView collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    DHFlowViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"flowCell" forIndexPath:indexPath];
    return cell;
}

- (void)flowView:(DHFlowView *)flowView didSelectItemAtIndex:(NSInteger)index
{
    DXHDINFO(@"------------------------%ld",index);
}

@end
