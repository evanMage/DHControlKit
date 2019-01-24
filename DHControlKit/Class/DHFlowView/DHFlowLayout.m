//
//  DHFlowLayout.m
//  DHControlKit
//
//  Created by daixinhui on 2018/12/14.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import "DHFlowLayout.h"

@interface DHFlowLayout ()

@property (nonatomic, strong) DHFlowUtils *flowUtils;

@end

@implementation DHFlowLayout

- (instancetype)initWithFlowUtils:(DHFlowUtils *)flowUtils
{
    self = [super init];
    if (self) {
        self.flowUtils = flowUtils;
        [self defaultSets];
    }
    return self;
}

- (void)defaultSets
{
    self.scrollDirection = (self.flowUtils.scrollDirection == DHFlowScrollDirectionHorizontal)?UICollectionViewScrollDirectionHorizontal:UICollectionViewScrollDirectionVertical;
    self.minimumLineSpacing = self.flowUtils.minimumSpacing;
    self.itemSize = self.flowUtils.itemSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (!self.collectionView || self.flowUtils.scrollingEffect == DHFlowScrollingEffectNormal) {
        return proposedContentOffset;
    }
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.width, self.collectionView.height);
    NSArray *layoutAttributes = [self layoutAttributesForElementsInRect:rect];
    if (!layoutAttributes.count) {
        return proposedContentOffset;
    }
    UICollectionViewLayoutAttributes *candidateAttributes = nil;
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + self.collectionView.width / 2;
    for (UICollectionViewLayoutAttributes *attributes in layoutAttributes) {
        if (attributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        if (!candidateAttributes) {
            candidateAttributes = attributes;
            continue;
        }
        if (ABS(attributes.center.x - proposedContentOffsetCenterX) < ABS(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
            candidateAttributes = attributes;
        }
    }
    CGFloat newOffsetX = candidateAttributes.center.x - self.collectionView.width / 2;
    CGFloat offset = newOffsetX - self.collectionView.contentOffset.x;
    
    if ((velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0)) {
        CGFloat pageWidth = self.itemSize.width + self.minimumLineSpacing;
        newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth;
    }
    return CGPointMake(newOffsetX, proposedContentOffset.y);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    if (!self.collectionView || self.flowUtils.scrollingEffect != DHFlowScrollingEffectTransform) {
        return array;
    }
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGRect visibleRect = CGRectMake(contentOffset.x, contentOffset.y, CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    CGFloat visibleCenterX = CGRectGetMidX(visibleRect);
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGFloat distanceFromCenter = visibleCenterX - attributes.center.x;
        CGFloat absDistanceFromCenter = MIN(ABS(distanceFromCenter), CGRectGetWidth(self.collectionView.bounds));
        CGFloat scale = absDistanceFromCenter * (self.flowUtils.scaleFactor - 1) / CGRectGetWidth(self.collectionView.bounds) + 1;
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1);
    }
    return array;
}

@end
