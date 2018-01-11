//
//  DHSwipeView.m
//  headerDemo
//
//  Created by 代新辉 on 2018/1/8.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHSwipeView.h"
#import "DHSwipeViewProtocol.h"
#import "DHSwipeUtils.h"
#import "DHViewManager.h"
#import "DHViewAnimator.h"

@interface DHSwipeView ()

@property (nonatomic) NSMutableArray<UIView *> *mutableHistoryArray;

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIView *miscContainerView;

@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) NSMutableDictionary<NSValue *, DHViewManager *> *viewManagerDictionary;

@property (strong, nonatomic) DHTimer *timer;

@end

@implementation DHSwipeView
#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - private methods
- (void)setup
{
    self.numberOfActiveViews = 4;
    self.minTranslationInPercent = 0.3;
    self.minVelocityInPointPerSecond = 500;
    self.allowedDirectionState = DHSwipeViewDirectionStateAll;
    self.animatorState = DHViewAnimatorDefaultState;
    
    self.mutableHistoryArray = [NSMutableArray array];
    self.numberOfHistoryItem = 10;
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.containerView];
    
    self.miscContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.miscContainerView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    self.viewManagerDictionary = [NSMutableDictionary dictionary];
    
    self.timer = [[DHTimer alloc] init];
    
    self.animatorProtocol = [[DHViewAnimator alloc] init];
    self.determinatorProtocol = [[DHSwipeViewDefaultDeterminator alloc] init];
    self.directionProtocol = [[DHSwipeViewDefaultDirection alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerView.frame = self.bounds;
}

- (NSArray<UIView *> *)history {
    return [_mutableHistoryArray mutableCopy];
}

- (UIView *)topView {
    return [self activeViews].firstObject;
}

- (NSArray<UIView *> *)activeViews {
    NSPredicate *notSwipingViews =
    [NSPredicate predicateWithBlock:^BOOL(UIView *view, NSDictionary *bindings) {
        DHViewManager *manager = [self managerForView:view];
        if (!manager) {
            return false;
        }
        return manager.state != DHViewManagerStateSwiping;
    }];
    return [[[[self allViews] filteredArrayUsingPredicate:notSwipingViews] reverseObjectEnumerator] allObjects];
}

- (void)loadViewsIfNeeded {
    for (NSInteger i = [self activeViews].count; i < self.numberOfActiveViews; i++) {
        UIView *nextView = [self nextView];
        if (nextView) {
            [self insert:nextView atIndex:0];
        }
    }
    [self updateViews];
}

- (void)rewind {
    UIView *viewToBeRewinded;
    
    if (_mutableHistoryArray.lastObject) {
        viewToBeRewinded = _mutableHistoryArray.lastObject;
        [_mutableHistoryArray removeLastObject];
    } else {
        viewToBeRewinded = [self previousView];
    }
    
    if (!viewToBeRewinded) {
        return;
    }
    
    [self insert:viewToBeRewinded atIndex:[self allViews].count];
    [self updateViews];
}

- (void)discardAllViews {
    for (UIView *view in [self allViews]) {
        [self remove:view];
    }
}

- (void)swipeTopViewToLeft {
    [self swipeTopViewInDirection:DHSwipeViewDirectionStateLeft];
}

- (void)swipeTopViewToRight {
    [self swipeTopViewInDirection:DHSwipeViewDirectionStateRight];
}

- (void)swipeTopViewToUp {
    [self swipeTopViewInDirection:DHSwipeViewDirectionStateUp];
}

- (void)swipeTopViewToDown {
    [self swipeTopViewInDirection:DHSwipeViewDirectionStateDown];
}

- (void)swipeTopViewInDirection:(DHSwipeViewDirectionState)direction {
    UIView *topView = [self topView];
    if (!topView) {
        return;
    }
    
    DHSwipeViewOptions *swipeOptions = [_directionProtocol interpretDirection:direction view:topView index:0 viewArray:[self activeViews] swipeView:self];
    [self swipeTopViewFromPoint:swipeOptions.location inDirection:swipeOptions.direction];
}

- (void)swipeTopViewFromPoint:(CGPoint)point inDirection:(CGVector)directionVector {
    UIView *topView = [self topView];
    if (!topView) {
        return;
    }
    DHViewManager *topViewManager = [self managerForView:topView];
    if (!topViewManager) {
        return;
    }
    [self swipeView:topView location:point directionVector:directionVector];
}

#pragma mark - Private APIs

- (NSArray<UIView *> *)allViews {
    return self.containerView.subviews;
}

- (NSArray<UIView *> *)inactiveViews {
    NSArray<UIView *> *activeViews = [self activeViews];
    return [[[[self allViews] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *view, NSDictionary *bindings) {
        return ![activeViews containsObject:view];
    }]] reverseObjectEnumerator] allObjects];
}

- (void)insert:(UIView *_Nonnull)view atIndex:(NSUInteger)index {
    if ([[self allViews] containsObject:view]) {
        DHViewManager *viewManager = [self managerForView:view];
        if (!viewManager) {
            return;
        }
        [viewManager setStateSnappingAtContainerViewCenter];
        return;
    }
    
    DHViewManager *viewManager = [[DHViewManager alloc] initWithView:view containerView:self.containerView index:index miscContainerView:self.miscContainerView animator:self.animator swipeView:self];
    [self setManagerForView:view viewManager:viewManager];
}

- (void)remove:(UIView *)view {
    if (![[self allViews] containsObject:view]) {
        return;
    }
    
    [self removeManagerForView:view];
}

- (void)updateViews {
    NSArray<UIView *> *activeViews = [self activeViews];
    NSArray<UIView *> *inactiveViews = [self inactiveViews];
    
    for (UIView *view in inactiveViews) {
        view.userInteractionEnabled = false;
    }
    
    UIView *topView = [self topView];
    if (!topView) {
        return;
    }
    for (UIGestureRecognizer *recognizer in topView.gestureRecognizers) {
        if (recognizer.state != UIGestureRecognizerStatePossible) {
            return;
        }
    }
    
    for (NSUInteger i = 0; i < activeViews.count; i++) {
        UIView *view = activeViews[i];
        view.userInteractionEnabled = true;
        BOOL shouldBeHidden = i >= self.numberOfActiveViews;
        view.hidden = shouldBeHidden;
        if (shouldBeHidden) {
            continue;
        }
        [self.animatorProtocol animateView:view index:i viewArray:activeViews swipeView:self];
    }
}

- (void)swipeView:(UIView *)view location:(CGPoint)location directionVector:(CGVector)directionVector {
    
    [[self managerForView:view] setStateSwiping:location direction:directionVector];
    
    DHSwipeViewDirectionState direction = DHSwipeViewDirectionFromVector(directionVector);
    
    NSPredicate *outOfBoundViews = [NSPredicate predicateWithBlock:^BOOL(UIView *view, NSDictionary *bindings) {
        return !CGRectIntersectsRect([_containerView convertRect:view.frame toView:nil], [UIScreen mainScreen].bounds);
    }];
    [self scheduleToBeRemoved:view withPredicate:outOfBoundViews];
    
    if (_delegate && [_delegate respondsToSelector:@selector(DHSwipeView:didSwipeView:inDirection:)]) {
        [_delegate DHSwipeView:self didSwipeView:view inDirection:direction];
    }
    [self loadViewsIfNeeded];
}

- (void)scheduleToBeRemoved:(UIView *)view withPredicate:(NSPredicate *)predicate {
    if (![[self allViews] containsObject:view]) {
        return;
    }
    
    [_mutableHistoryArray addObject:view];
    if (_mutableHistoryArray.count > _numberOfHistoryItem) {
        [_mutableHistoryArray removeObjectAtIndex:0];
    }
    
    [_timer scheduleActionRepeatedly:^{
        NSArray *matchedViews = [[self inactiveViews] filteredArrayUsingPredicate:predicate];
        for (UIView *view in matchedViews) {
            [self remove:view];
        }
    } interval:0.3 endCondition:^BOOL {
        return [self activeViews].count == [self allViews].count;
    }];
}

#pragma mark - ()

- (UIView *)nextView {
    if ([self.dataSource respondsToSelector:@selector(nextViewForSwipeView:)]) {
        return [self.dataSource nextViewForSwipeView:self];
    }
    return nil;
}

- (UIView *)previousView {
    if ([self.dataSource respondsToSelector:@selector(previousViewForSwipeView:)]) {
        return [self.dataSource previousViewForSwipeView:self];
    }
    return nil;
}

- (DHViewManager *)managerForView:(UIView *)view {
    return [_viewManagerDictionary objectForKey:[NSValue valueWithNonretainedObject:view]];
}

- (void)setManagerForView:(UIView *)view viewManager:(DHViewManager *)viewManager {
    _viewManagerDictionary[[NSValue valueWithNonretainedObject:view]] = viewManager;
}

- (void)removeManagerForView:(UIView *)view {
    [_viewManagerDictionary removeObjectForKey:[NSValue valueWithNonretainedObject:view]];
}

@end


//////////////////////////////////////////////////////////////////////////

@implementation DHSwipeViewOptions

- (instancetype)initWithLocation:(CGPoint)location direction:(CGVector)direction {
    self = [super init];
    if (self) {
        self.location = location;
        self.direction = direction;
    }
    return self;
}

@end

//////////////////////////////////////////////////////////////////////////

@implementation DHSwipeViewMovement

- (instancetype)initWithLocation:(CGPoint)location tranlation:(CGPoint)tranlation velocity:(CGPoint)velocity {
    self = [super init];
    if (self) {
        self.location = location;
        self.translation = tranlation;
        self.velocity = velocity;
    }
    return self;
}

@end
