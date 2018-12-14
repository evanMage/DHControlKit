//
//  DHFlowView.m
//  DHControlKit
//
//  Created by daixinhui on 2018/12/14.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import "DHFlowView.h"

@interface DHFlowView ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

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
}

//MARK: - publick methods

- (void)reloadData
{
    
}

@end
