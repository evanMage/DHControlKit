//
//  DHViewManager.m
//  headerDemo
//
//  Created by 代新辉 on 2018/1/8.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHViewManager.h"
#import "DHSwipeView.h"
#import "DHSwipeUtils.h"

static const CGFloat kAnchorViewWidth = 1000;

typedef NS_ENUM(NSInteger, DHViewMoveSlopeState) {
    DHViewMoveSlopeTopState = 1,
    DHViewMoveSlopeBottomState = -1,
};

@interface DHViewManager ()

@property (assign, nonatomic) DHViewMoveSlopeState moveSlopeState;
@property (nonatomic, assign) CGPoint viewCenter;
@property (nonatomic, assign) CGRect defaultFrame;

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *miscContainerView;
@property (weak, nonatomic) DHSwipeView *swipeView;
@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) UIView *anchorView;

@property (strong, nonatomic) UISnapBehavior *snapBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *viewToAnchorViewAttachmentBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *anchorViewToPointAttachmentBehavior;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;

@end

@implementation DHViewManager

- (instancetype)initWithView:(UIView *)view containerView:(UIView *)containerView index:(NSUInteger)index miscContainerView:(UIView *)miscContainerView animator:(UIDynamicAnimator *)animator swipeView:(DHSwipeView *)swipeView
{
    self = [super init];
    if (self) {
        self.view = view;
        self.containerView = containerView;
        self.miscContainerView = miscContainerView;
        self.animator = animator;
        self.swipeView = swipeView;
        self.viewCenter = swipeView.center;
        self.defaultFrame = swipeView.bounds;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        
        [view addGestureRecognizer: pan];
        _anchorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAnchorViewWidth, kAnchorViewWidth)];
        _anchorView.hidden = NO;
        [miscContainerView addSubview:_anchorView];
        [containerView insertSubview:view atIndex:index];
    }
    return self;
}

- (void)dealloc {
    for (UIGestureRecognizer *aGestureRecognizer in _view.gestureRecognizers) {
        if ([aGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            [_view removeGestureRecognizer:aGestureRecognizer];
        }
    }
    if (_snapBehavior) {
        [_animator removeBehavior:_snapBehavior];
    }
    if (_viewToAnchorViewAttachmentBehavior) {
        [_animator removeBehavior:_viewToAnchorViewAttachmentBehavior];
    }
    if (_anchorViewToPointAttachmentBehavior) {
        [_animator removeBehavior:_anchorViewToPointAttachmentBehavior];
    }
    if (_pushBehavior) {
        [_animator removeBehavior:_pushBehavior];
    }
    [_anchorView removeFromSuperview];
    [_view removeFromSuperview];
}

#pragma mark - Action

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (!_swipeView) {
        return;
    }
    CGPoint translation = [recognizer translationInView:_containerView];
    CGPoint location = [recognizer locationInView:_containerView];
    CGPoint velocity = [recognizer velocityInView:_containerView];
    DHSwipeViewMovement *movement = [[DHSwipeViewMovement alloc] initWithLocation:location tranlation:translation velocity:velocity];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (_swipeView.animatorState == DHViewAnimatorDefaultState) {
            CGPoint touchPoint = [recognizer locationInView:_swipeView];
            if (touchPoint.y + CGRectGetMinY(_swipeView.frame) <= _viewCenter.y) {
                _moveSlopeState = DHViewMoveSlopeTopState;
            } else {
                _moveSlopeState = DHViewMoveSlopeBottomState;
            }
        }else{
            [self setStateMoving:location];
            [self didStartSwipingView:_view movement:movement];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (_swipeView.animatorState == DHViewAnimatorDefaultState) {
            CGPoint point = [recognizer translationInView:_swipeView];
            CGPoint movedPoint = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y + point.y);
            recognizer.view.center = movedPoint;
//            NSLog(@"----%@-----%@ ------ %@ --- %@",NSStringFromCGPoint(recognizer.view.center),NSStringFromCGPoint(_viewCenter),NSStringFromCGPoint(point),NSStringFromCGPoint(movedPoint));
            [recognizer.view setTransform: CGAffineTransformMakeRotation((recognizer.view.center.x - _viewCenter.x) / _viewCenter.x * (_moveSlopeState * (M_PI / 20)))];
            [recognizer setTranslation:CGPointZero inView:_swipeView];
            
        }else{
            [self setStateMoving:location];
            [self swipingView:_view movement:movement];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (_swipeView.animatorState == DHViewAnimatorDefaultState) {
            float ratio_w = (recognizer.view.center.x - _viewCenter.x) / _viewCenter.x;
            float ratio_h = (recognizer.view.center.y + CGRectGetMinY(_swipeView.frame) - _viewCenter.y) / _viewCenter.y;
            
            DHSwipeViewDirectionState direction = DHSwipeViewDirectionStateNone;
            if (fabs(ratio_h) > fabs(ratio_w)) {
                if (ratio_h < - self.swipeView.minTranslationInPercent && (self.swipeView.allowedDirectionState & DHSwipeViewDirectionStateUp)) {
                    // up
                    direction = DHSwipeViewDirectionStateUp;
                }
                
                if (ratio_h > self.swipeView.minTranslationInPercent && (self.swipeView.allowedDirectionState & DHSwipeViewDirectionStateDown)) {
                    // down
                    direction = DHSwipeViewDirectionStateDown;
                }
                
            } else {
                
                if (ratio_w > self.swipeView.minTranslationInPercent && (self.swipeView.allowedDirectionState & DHSwipeViewDirectionStateRight)) {
                    // right
                    direction = DHSwipeViewDirectionStateRight;
                }
                
                if (ratio_w < - self.swipeView.minTranslationInPercent && (self.swipeView.allowedDirectionState & DHSwipeViewDirectionStateLeft)) {
                    // left
                    direction = DHSwipeViewDirectionStateLeft;
                }
            }
            if (direction == DHSwipeViewDirectionStateNone) {
                self.view.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:0.45 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
                  self.view.frame = self.defaultFrame;
                } completion:nil];
            } else {
                [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
                     if (direction == DHSwipeViewDirectionStateLeft) {
                         self.view.center = CGPointMake(-1 * (self.view.frame.size.width), self.view.center.y);
                     }else if (direction == DHSwipeViewDirectionStateRight) {
                         self.view.center = CGPointMake((self.view.frame.size.width * 2), self.view.center.y);
                     }else if (direction == DHSwipeViewDirectionStateDown) {
                        self.view.center = CGPointMake(self.view.center.x, (self.view.frame.size.height * 2));
                     }else{
                        self.view.center = CGPointMake( self.view.center.x, -1 * ((self.view.frame.size.height) * 2));
                     }
                } completion:^(BOOL finished) {
                    CGVector directionVector = CGVectorFromCGPoint(CGPointMultiply(CGPointNormalized(translation), MAX(CGPointMagnitude(velocity), _swipeView.minVelocityInPointPerSecond)));
                    [_swipeView swipeTopViewFromPoint:location inDirection:directionVector];
                }];
            }
        }else{
            if (_state != DHViewManagerStateMoving) {
                return;
            }
            if ([_swipeView.determinatorProtocol shouldSwipeView:_view movement:movement swipeView:_swipeView]) {
                CGVector directionVector = CGVectorFromCGPoint(CGPointMultiply(CGPointNormalized(translation), MAX(CGPointMagnitude(velocity), _swipeView.minVelocityInPointPerSecond)));
                [_swipeView swipeTopViewFromPoint:location inDirection:directionVector];
            } else {
                [self setStateSnappingAtContainerViewCenter];
                [self didCancelSwipingView:_view movement:movement];
            }
            
            [self didEndSwipingView:_view movement:movement];
        }
    }
}

- (void)setStateSnapping:(CGPoint)point {
    if (_state == DHViewManagerStateMoving) {
        [self detachView];
        [self snapView:point];
    }
    if (_state == DHViewManagerStateSwiping) {
        [self unpushView];
        [self detachView];
        [self snapView:point];
    }
    _state = DHViewManagerStateSnapping;
}

- (void)setStateMoving:(CGPoint)point {
    if (_state == DHViewManagerStateSnapping) {
        [self unsnapView];
        [self attachView:point];
    }
    if (_state == DHViewManagerStateMoving) {
        [self moveView:point];
    }
    _state = DHViewManagerStateMoving;
}

- (void)setStateSwiping:(CGPoint)point direction:(CGVector)directionVector {
    if (_state == DHViewManagerStateSnapping) {
        [self unsnapView];
        [self attachView:point];
        [self pushViewFromPoint:point inDirection:directionVector];
    }
    if (_state == DHViewManagerStateMoving) {
        [self pushViewFromPoint:point inDirection:directionVector];
    }
    _state = DHViewManagerStateSwiping;
}

- (void)setStateSnappingDefault {
    [self setStateSnapping:[_view convertPoint:_view.center fromView:_view.superview]];
}

- (void)setStateSnappingAtContainerViewCenter {
    if (!_swipeView) {
        [self setStateSnappingDefault];
        return;
    }
    [self setStateSnapping:[_containerView convertPoint:_swipeView.center fromView:_swipeView.superview]];
}

#pragma mark - UIDynamicAnimationHelpers

- (void)snapView:(CGPoint)point {
    _snapBehavior = [[UISnapBehavior alloc] initWithItem:_view snapToPoint:point];
    _snapBehavior.damping = 0.30f; /* Medium oscillation */
    [self addBehavior:_snapBehavior];
}

- (void)unsnapView {
    [self removeBehavior:_snapBehavior];
}

- (void)attachView:(CGPoint)point {
    _anchorView.center = point;
    _anchorView.backgroundColor = [UIColor blueColor];
    _anchorView.hidden = YES;
    
    // attach aView to anchorView
    CGPoint p = _view.center;
    _viewToAnchorViewAttachmentBehavior =  [[UIAttachmentBehavior alloc] initWithItem:_view offsetFromCenter:UIOffsetMake(-(p.x - point.x), -(p.y - point.y)) attachedToItem:_anchorView offsetFromCenter:UIOffsetZero];
    _viewToAnchorViewAttachmentBehavior.length = 0;
    
    // attach anchorView to point
    _anchorViewToPointAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:_anchorView offsetFromCenter:UIOffsetZero attachedToAnchor:point];
    _anchorViewToPointAttachmentBehavior.damping = 100;
    _anchorViewToPointAttachmentBehavior.length = 0;
    
    [self addBehavior:_viewToAnchorViewAttachmentBehavior];
    [self addBehavior:_anchorViewToPointAttachmentBehavior];
}

- (void)moveView:(CGPoint)point {
    if (!_viewToAnchorViewAttachmentBehavior || !_anchorViewToPointAttachmentBehavior) {
        return;
    }
    _anchorViewToPointAttachmentBehavior.anchorPoint = point;
}

- (void)detachView {
    if (!_viewToAnchorViewAttachmentBehavior || !_anchorViewToPointAttachmentBehavior) {
        return;
    }
    [self removeBehavior:_viewToAnchorViewAttachmentBehavior];
    [self removeBehavior:_anchorViewToPointAttachmentBehavior];
}

- (void)pushViewFromPoint:(CGPoint)point inDirection:(CGVector)direction {
    if (!_viewToAnchorViewAttachmentBehavior || !_anchorViewToPointAttachmentBehavior) {
        return;
    }
    [self removeBehavior:_anchorViewToPointAttachmentBehavior];
    
    _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_anchorView] mode:UIPushBehaviorModeInstantaneous];
    _pushBehavior.pushDirection = direction;
    [_pushBehavior setMagnitude:1000];
    [self addBehavior:_pushBehavior];
}

- (void)unpushView {
    if (!_pushBehavior) {
        return;
    }
    [self removeBehavior:_pushBehavior];
}

- (void)addBehavior:(UIDynamicBehavior *)behavior {
    [_animator addBehavior:behavior];
}

- (void)removeBehavior:(UIDynamicBehavior *)behavior {
    [_animator removeBehavior:behavior];
}

#pragma mark - delegate

- (void)didStartSwipingView:(UIView *)view movement:(DHSwipeViewMovement *)movement {
    if ([self.swipeView.delegate respondsToSelector:@selector(DHSwipeView:didStartSwipingView:atLocation:)]) {
        [self.swipeView.delegate DHSwipeView:self.swipeView didStartSwipingView:view atLocation:movement.location];
    }
}

- (void)swipingView:(UIView *)view movement:(DHSwipeViewMovement *)movement {
    if ([self.swipeView.delegate respondsToSelector:@selector(DHSwipeView:swipingView:atLocation:translation:)]) {
        [self.swipeView.delegate DHSwipeView:self.swipeView swipingView:view atLocation:movement.location translation:movement.translation];
    }
}

- (void)didCancelSwipingView:(UIView *)view movement:(DHSwipeViewMovement *)movement {
    if ([self.swipeView.delegate respondsToSelector:@selector(DHSwipeView:didCancelSwipe:)]) {
        [self.swipeView.delegate DHSwipeView:self.swipeView didCancelSwipe:view];
    }
}

- (void)didEndSwipingView:(UIView *)view movement:(DHSwipeViewMovement *)movement {
    if ([self.swipeView.delegate respondsToSelector:@selector(DHSwipeView:didEndSwipingView:atLocation:)]) {
        [self.swipeView.delegate DHSwipeView:self.swipeView didEndSwipingView:view atLocation:movement.location];
    }
}
@end

//////////////////////////////////////////////////////////////////////////

@implementation DHTimer

- (void)scheduleActionRepeatedly:(void (^)(void))startActionBlock interval:(NSTimeInterval)interval endCondition:(BOOL (^)(void))endConditionBlock
{
    if (self.timer != nil || interval <= 0) {
        return;
    }
    self.startActionBlock = startActionBlock;
    self.endConditionBlock = endConditionBlock;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
}

- (void)startTimer
{
    if (!self.startActionBlock || !self.endConditionBlock || self.endConditionBlock()) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }else{
        self.startActionBlock();
    }
}

@end
