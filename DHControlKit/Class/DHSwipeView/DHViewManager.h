//
//  DHViewManager.h
//  headerDemo
//
//  Created by 代新辉 on 2018/1/8.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DHViewManagerState) {
    DHViewManagerStateSnapping = 0,
    DHViewManagerStateMoving = 1,
    DHViewManagerStateSwiping = 2,
};

@class DHSwipeView;

/** View 管理 */
@interface DHViewManager : NSObject

@property (nonatomic, readonly) DHViewManagerState state;

@property (nonatomic) CGPoint point;

@property (nonatomic) CGVector direction;

- (instancetype)initWithView:(UIView *)view containerView:(UIView *)containerView index:(NSUInteger)index miscContainerView:(UIView *)miscContainerView animator:(UIDynamicAnimator *)animator  swipeView:(DHSwipeView *)swipeView;

- (void)setStateSnapping:(CGPoint)point;

- (void)setStateMoving:(CGPoint)point;

- (void)setStateSwiping:(CGPoint)point direction:(CGVector)directionVector;

- (void)setStateSnappingDefault;

- (void)setStateSnappingAtContainerViewCenter;

@end

/** 计时器 */
@interface DHTimer : NSObject

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) void (^startActionBlock)(void);
@property (nonatomic, copy) BOOL (^endConditionBlock)(void);

/**
 定时器

 @param startActionBlock 开始block
 @param interval 时间
 @param endConditionBlock 结束block
 */
- (void)scheduleActionRepeatedly:(void (^)(void))startActionBlock interval:(NSTimeInterval)interval endCondition:(BOOL (^)(void))endConditionBlock;

@end;

