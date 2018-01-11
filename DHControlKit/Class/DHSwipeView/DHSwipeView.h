//
//  DHSwipeView.h
//  headerDemo
//
//  Created by 代新辉 on 2018/1/8.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DHSwipeViewDirectionState) {
    DHSwipeViewDirectionStateNone = 0,
    DHSwipeViewDirectionStateLeft = (1 << 0),
    DHSwipeViewDirectionStateRight = (1 << 1),
    DHSwipeViewDirectionStateHorizontal = DHSwipeViewDirectionStateLeft | DHSwipeViewDirectionStateRight,
    DHSwipeViewDirectionStateUp = (1 << 2),
    DHSwipeViewDirectionStateDown = (1 << 3),
    DHSwipeViewDirectionStateVertical = DHSwipeViewDirectionStateUp | DHSwipeViewDirectionStateDown,
    DHSwipeViewDirectionStateAll = DHSwipeViewDirectionStateHorizontal | DHSwipeViewDirectionStateVertical,
};

typedef NS_ENUM(NSInteger, DHViewAnimatorState) {
    DHViewAnimatorDefaultState = 0,//一般动画
    DHViewAnimatorDynamicState,//UIDynamicAnimator物理仿真动画
};

@class DHSwipeViewMovement,DHSwipeViewOptions,DHSwipeView;

/** view自定义动画 */
@protocol DHSwipeViewAnimatorProtocol <NSObject>

@required

/**
 定义卡牌效果和动画

 @param view 动画view
 @param index index
 @param viewArray view数组
 @param swipeView swipeView
 */
- (void)animateView:(UIView *)view index:(NSUInteger)index viewArray:(NSArray<UIView *> *)viewArray swipeView:(DHSwipeView *)swipeView;

@end
/** SwipeView 响应方向 */
@protocol DHSwipeViewDirectionProtocol <NSObject>

@required
/**
 响应方向
 
 @param direction DHSwipeViewDirectionState
 @param view 响应view
 @param index index
 @return DHSwipeViewOptions
 */
- (DHSwipeViewOptions *)interpretDirection:(DHSwipeViewDirectionState)direction view:(UIView *)view index:(NSUInteger)index viewArray:(NSArray<UIView *> *)viewArray swipeView:(DHSwipeView *)swipeView;

@end
/** 是否滑动view */
@protocol DHSwipeViewSwipingDeterminatorProtocol <NSObject>

@required
/**
 是否允许切换view
 
 @param view 滑动响应view
 @param swipeView swipeView
 @return YES 切换view NO 不切换View
 */
- (BOOL)shouldSwipeView:(UIView *)view movement:(DHSwipeViewMovement *)movement swipeView:(DHSwipeView *)swipeView;

@end

@protocol DHSwipeViewDelegate <NSObject>

@optional

- (void)DHSwipeView:(DHSwipeView *)swipeView didSwipeView:(UIView *)view inDirection:(DHSwipeViewDirectionState)direction;

- (void)DHSwipeView:(DHSwipeView *)swipeView didCancelSwipe:(UIView *)view;

- (void)DHSwipeView:(DHSwipeView *)swipeView didStartSwipingView:(UIView *)view atLocation:(CGPoint)location;

- (void)DHSwipeView:(DHSwipeView *)swipeView swipingView:(UIView *)view atLocation:(CGPoint)location translation:(CGPoint)translation;

- (void)DHSwipeView:(DHSwipeView *)swipeView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location;

@end

@protocol DHSwipeViewDataSource <NSObject>

@required

- (UIView *)nextViewForSwipeView:(DHSwipeView *)swipeView;

@optional
- (UIView *)previousViewForSwipeView:(DHSwipeView *)swipeView;

@end

/**
 view
 */
@interface DHSwipeView : UIView

/** 显示的卡牌数量 */
@property (nonatomic) NSUInteger numberOfActiveViews;
@property (nonatomic) DHSwipeViewDirectionState allowedDirectionState;
@property (nonatomic) CGFloat minTranslationInPercent;
@property (nonatomic) CGFloat minVelocityInPointPerSecond;
@property (nonatomic, readonly) NSArray<UIView *> *history;
@property (nonatomic) NSUInteger numberOfHistoryItem;
@property (nonatomic) DHViewAnimatorState animatorState;

@property (nonatomic, weak) id<DHSwipeViewDelegate>delegate;
@property (nonatomic, weak) id<DHSwipeViewDataSource>dataSource;
@property (nonatomic, strong) id<DHSwipeViewDirectionProtocol>directionProtocol;
@property (nonatomic, strong) id<DHSwipeViewAnimatorProtocol>animatorProtocol;
@property (nonatomic, strong) id<DHSwipeViewSwipingDeterminatorProtocol>determinatorProtocol;

- (UIView *)topView;

- (NSArray<UIView *> *)activeViews;

- (void)loadViewsIfNeeded;

- (void)rewind;

- (void)discardAllViews;

- (void)swipeTopViewToLeft;

- (void)swipeTopViewToRight;

- (void)swipeTopViewToUp;

- (void)swipeTopViewToDown;

- (void)swipeTopViewInDirection:(DHSwipeViewDirectionState)direction;

- (void)swipeTopViewFromPoint:(CGPoint)point inDirection:(CGVector)directionVector;

@end

/**
 DHSwipeView 响应方向
 */
@interface DHSwipeViewOptions : NSObject

@property (nonatomic) CGPoint location;
@property (nonatomic) CGVector direction;

- (instancetype)initWithLocation:(CGPoint)location direction:(CGVector)direction;

@end

/**
 DHSwipeView 运动状态相关
 */
@interface DHSwipeViewMovement : NSObject

@property (nonatomic) CGPoint location;
@property (nonatomic) CGPoint translation;
@property (nonatomic) CGPoint velocity;

- (instancetype)initWithLocation:(CGPoint)location tranlation:(CGPoint)tranlation velocity:(CGPoint)velocity;

@end

