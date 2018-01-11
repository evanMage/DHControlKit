//
//  DHScrollView.m
//  headerDemo
//
//  Created by 代新辉 on 2017/12/8.
//  Copyright © 2017年 代新辉. All rights reserved.
//

#import "DHScrollView.h"

@interface DHScrollViewDelegateForwarder : NSObject <DHScrollViewDelegate>

@property (nonatomic, weak) id<DHScrollViewDelegate>delegate;

@end;

@interface DHScrollView ()
{
    BOOL _isObserving;
    BOOL _lock;
}

@property (nonatomic, strong) NSMutableArray<UIScrollView *> *observedViews;
@property (nonatomic, strong) DHScrollViewDelegateForwarder *forwarder;

@end

@implementation DHScrollView

static void *const KDHScrollViewKVOContext = (void *) & KDHScrollViewKVOContext;
//MARK: - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    super.delegate = self.forwarder;
    self.showsVerticalScrollIndicator = NO;
    self.directionalLockEnabled = YES;
    self.bounces = NO;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.panGestureRecognizer.cancelsTouchesInView = YES;
    
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:KDHScrollViewKVOContext];
    _isObserving = YES;
}

//MARK: - setter & getter
- (DHScrollViewDelegateForwarder *)forwarder
{
    if (!_forwarder) {
        _forwarder = [[DHScrollViewDelegateForwarder alloc] init];
    }
    return _forwarder;
}

- (NSMutableArray<UIScrollView *> *)observedViews
{
    if (!_observedViews) {
        _observedViews = [[NSMutableArray alloc] init];
    }
    return _observedViews;
}

- (id<DHScrollViewDelegate>)delegate
{
    return self.forwarder.delegate;
}

- (void)setDelegate:(id<DHScrollViewDelegate>)delegate
{
    self.forwarder.delegate = delegate;
// Scroll view delegate caches whether the delegate responds to some of the delegate methods, so we need to force it to re-evaluate if the delegate responds to them
    super.delegate = nil;
    super.delegate = self.forwarder;
}

//MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer.view == self) {
        return NO;
    }
    // Ignore other gesture than pan
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    // Lock horizontal pan gesture.
    CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self];
    if (fabs(velocity.x) > fabs(velocity.y)) {
        return NO;
    }
    // Consider scroll view pan only
    if (![otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    UIScrollView *scrollView = (id)otherGestureRecognizer.view;
    // Tricky case: UITableViewWrapperView
    if ([scrollView.superview isKindOfClass:[UITableView class]]) {
        return NO;
    }
    BOOL shouldScroll = YES;
    if ([self.delegate respondsToSelector:@selector(DHScrollView:shouldScrollWithSubView:)]) {
        shouldScroll = [self.delegate DHScrollView:self shouldScrollWithSubView:scrollView];
    }
    if (shouldScroll) {
        [self addObservedView:scrollView];
    }
    return shouldScroll;
}
//MARK: - KVO
- (void)addObserverToView:(UIScrollView *)scrollView
{
    _lock = (scrollView.contentOffset.y > -scrollView.contentInset.top);
    [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:KDHScrollViewKVOContext];
}

- (void)removeObserverFromView:(UIScrollView *)scrollView
{
    @try {
        [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:KDHScrollViewKVOContext];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
// 处理滑动，见证奇迹
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == KDHScrollViewKVOContext && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        CGPoint new = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint old = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGFloat diff = old.y - new.y;
        
        if (diff == 0.0 || !_isObserving) {
            return;
        }
        if (object == self) {
            //Adjust self scroll offset when scroll down
            if (diff > 0 && _lock) {
                [self scrollView:self setContentOffset:old];
            } else if (self.contentOffset.y < -self.contentInset.top && !self.bounces) {
                [self scrollView:self setContentOffset:CGPointMake(self.contentOffset.x, -self.contentInset.top)];
            } else if (self.contentOffset.y > -self.parallaxHeader.minimumHeight) {
                [self scrollView:self setContentOffset:CGPointMake(self.contentOffset.x, -self.parallaxHeader.minimumHeight)];
            }
        } else {
            //Adjust the observed scrollview's content offset
            UIScrollView *scrollView = object;
            _lock = (scrollView.contentOffset.y > -scrollView.contentInset.top);
            
            //Manage scroll up
            if (self.contentOffset.y < -self.parallaxHeader.minimumHeight && _lock && diff < 0) {
                [self scrollView:scrollView setContentOffset:old];
            }
            
            //Disable bouncing when scroll down
            if (!_lock && ((self.contentOffset.y > -self.contentInset.top) || self.bounces)) {
                [self scrollView:scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top)];
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//MARK: - Private Methods
- (void)addObservedView:(UIScrollView *)scrollView
{
    if (![self.observedViews containsObject:scrollView]) {
        [self.observedViews addObject:scrollView];
        [self addObserverToView:scrollView];
    }
}
- (void)removeObservedViews
{
    for (UIScrollView *scrollView in self.observedViews) {
        [self removeObserverFromView:scrollView];
    }
    [self.observedViews removeAllObjects];
}

- (void)scrollView:(UIScrollView *)scrollView setContentOffset:(CGPoint)offset
{
    _isObserving = NO;
    scrollView.contentOffset = offset;
    _isObserving = YES;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:KDHScrollViewKVOContext];
    [self removeObservedViews];
}

//MARK: - UIScorllViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _lock = NO;
    [self removeObservedViews];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        _lock = NO;
        [self removeObservedViews];
    }
}

@end

@implementation DHScrollViewDelegateForwarder

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [self.delegate respondsToSelector:aSelector] || [super respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invokeWithTarget:self.delegate];
}
//MARK: - UIScorllViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [(DHScrollView *)scrollView scrollViewDidEndDecelerating:scrollView];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [(DHScrollView *)scrollView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

@end
