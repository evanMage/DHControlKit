//
//  DHParallaxHeader.m
//  headerDemo
//
//  Created by 代新辉 on 2017/12/8.
//  Copyright © 2017年 代新辉. All rights reserved.
//

#import "DHParallaxHeader.h"
#import <objc/runtime.h>

@interface DHParallaxView : UIView

@property (nonatomic, weak) DHParallaxHeader *parent;

@end

@implementation DHParallaxView

static void *const kDHParallaxHeaderKVOContext = (void *) & kDHParallaxHeaderKVOContext;

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self.parent forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kDHParallaxHeaderKVOContext];
    }
}

- (void)didMoveToSuperview
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview addObserver:self.parent forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew  context:kDHParallaxHeaderKVOContext];
    }
}

@end

@interface DHParallaxHeader ()
{
    BOOL _isObserving;
}

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation DHParallaxHeader
@synthesize contentView = _contentView;
//MARK: - setter & getter
- (UIView *)contentView
{
    if (!_contentView) {
        DHParallaxView *contentView = [[DHParallaxView alloc] init];
        contentView.parent = self;
        contentView.clipsToBounds = YES;
        _contentView = contentView;
    }
    return _contentView;
}

- (void)setView:(UIView *)view
{
    if (view != _view) {
        _view = view;
        [self updateConstraints];
    }
}

- (void)setMode:(DHParallaxHeaderMode)mode
{
    if (_mode != mode) {
        _mode = mode;
        [self updateConstraints];
    }
}

- (void)setHeight:(CGFloat)height
{
    if (_height != height) {
        
        //Adjust content inset
        [self adjustScrollViewTopInset:self.scrollView.contentInset.top - _height + height];
        
        _height = height;
        [self updateConstraints];
        [self layoutContentView];
    }
}

- (void)setMinimumHeight:(CGFloat)minimumHeight
{
    _minimumHeight = minimumHeight;
    [self layoutContentView];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView != scrollView) {
        _scrollView = scrollView;
        
        //Adjust content inset
        [self adjustScrollViewTopInset:scrollView.contentInset.top + self.height];
        [scrollView addSubview:self.contentView];
        
        //Layout content view
        [self layoutContentView];
        _isObserving = YES;
    }
}

- (void)setProgress:(CGFloat)progress
{
    if(_progress != progress) {
        _progress = progress;
        
        if ([self.delegate respondsToSelector:@selector(parallaxHeaderDidScroll:)]) {
            [self.delegate parallaxHeaderDidScroll:self];
        }
    }
}
//MARK: - Constraints
- (void)updateConstraints {
    if (!self.view) {
        return;
    }
    
    [self.view removeFromSuperview];
    [self.contentView addSubview:self.view];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    switch (self.mode) {
        case DHParallaxHeaderModeFill:
            [self setFillModeConstraints];
            break;
            
        case DHParallaxHeaderModeTopFill:
            [self setTopFillModeConstraints];
            break;
            
        case DHParallaxHeaderModeTop:
            [self setTopModeConstraints];
            break;
            
        case DHParallaxHeaderModeBottom:
            [self setBottomModeConstraints];
            break;
            
        default:
            [self setCenterModeConstraints];
            break;
    }
}

- (void)setCenterModeConstraints
{
    
    NSDictionary *binding = @{@"v" : self.view};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:self.height]];
}

- (void)setFillModeConstraints
{
    NSDictionary *binding = @{@"v" : self.view};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:binding]];
}

- (void)setTopFillModeConstraints
{
    NSDictionary *binding = @{@"v" : self.view};
    NSDictionary *metrics = @{@"highPriority" : @(UILayoutPriorityDefaultHigh),
                              @"height"       : @(self.height)};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v(>=height)]-0.0@highPriority-|" options:0 metrics:metrics views:binding]];
}

- (void)setTopModeConstraints
{
    NSDictionary *binding = @{@"v" : self.view};
    NSDictionary *metrics = @{@"height" : @(self.height)};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v(==height)]" options:0 metrics:metrics views:binding]];
}

- (void)setBottomModeConstraints
{
    NSDictionary *binding = @{@"v" : self.view};
    NSDictionary *metrics = @{@"height" : @(self.height)};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v(==height)]|" options:0 metrics:metrics views:binding]];
}

//MARK: - Private Methods

- (void)layoutContentView
{
    CGFloat minimumHeight = MIN(self.minimumHeight, self.height);
    CGFloat relativeYOffset = self.scrollView.contentOffset.y + self.scrollView.contentInset.top - self.height;
    CGFloat relativeHeight  = -relativeYOffset;
    
    CGRect frame = (CGRect){
        .origin.x       = 0,
        .origin.y       = relativeYOffset,
        .size.width     = self.scrollView.frame.size.width,
        .size.height    = MAX(relativeHeight, minimumHeight)
    };
    
    self.contentView.frame = frame;
    
    CGFloat div = self.height - self.minimumHeight;
    self.progress = (self.contentView.frame.size.height - self.minimumHeight) / (div? : self.height);
}

- (void)adjustScrollViewTopInset:(CGFloat)top
{
    UIEdgeInsets inset = self.scrollView.contentInset;
    
    //Adjust content offset
    CGPoint offset = self.scrollView.contentOffset;
    offset.y += inset.top - top;
    self.scrollView.contentOffset = offset;
    
    //Adjust content inset
    inset.top = top;
    self.scrollView.contentInset = inset;
}

//MARK: - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (context == kDHParallaxHeaderKVOContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
            [self layoutContentView];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end

@implementation UIScrollView (DHParallaxHeader)

- (DHParallaxHeader *)parallaxHeader
{
    DHParallaxHeader *parallaxHeader = objc_getAssociatedObject(self, @selector(parallaxHeader));
    if (!parallaxHeader) {
        parallaxHeader = [DHParallaxHeader new];
        [self setParallaxHeader:parallaxHeader];
    }
    return parallaxHeader;
}

- (void)setParallaxHeader:(DHParallaxHeader *)parallaxHeader
{
    parallaxHeader.scrollView = self;
    objc_setAssociatedObject(self, @selector(parallaxHeader), parallaxHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
