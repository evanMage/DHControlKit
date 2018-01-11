//
//  DHCustomSlideView.m
//  DHSlideViewDemo
//
//  Created by daixinhui on 15/10/15.
//  Copyright © 2015年 daixinhui. All rights reserved.
//

#import "DHCustomSlideView.h"

#define kDefaultTabbarBottomSpacing 0

@interface DHCustomSlideView ()<DHSlideTabbarDelegate, DHSlideViewDelegate, DHSlideViewDataSource>

@property (nonatomic, strong) DHSlideView *slideView;

@end

@implementation DHCustomSlideView

- (void)commonInit{
    self.tabbarBottomSpacing = kDefaultTabbarBottomSpacing;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)setup{
    _tabbarView.delegate = self;
    _tabbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_tabbarView];
    [_slideView removeFromSuperview];
    _slideView = [[DHSlideView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_tabbarView.frame) + _tabbarBottomSpacing, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(_tabbarView.frame) - _tabbarBottomSpacing)];
    _slideView.delegate = self;
    _slideView.dataSource = self;
    _slideView.baseViewController = _baseViewController;
    [self addSubview:_slideView];
//    [_slideView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.right.equalTo(self);
//        make.top.equalTo(self).offset(CGRectGetHeight(_tabbarView.frame) + _tabbarBottomSpacing);
//        make.bottom.equalTo(self);
//    }];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutBarAndSlide];
}

- (void)layoutBarAndSlide{
    _tabbarView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _tabbarView.frame.size.height);
//    _slideView.frame = CGRectMake(0, CGRectGetHeight(_tabbarView.frame) + _tabbarBottomSpacing, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(_tabbarView.frame) - _tabbarBottomSpacing);
}

- (void)setBaseViewController:(UIViewController *)baseViewController{
    _slideView.baseViewController = baseViewController;
    _baseViewController = baseViewController;
}

- (void)readloadCustomView
{
    [self layoutBarAndSlide];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [_slideView setSelecteIndex:selectedIndex];
    [_tabbarView setSelectedIndex:selectedIndex];
}

- (void)DHSlideTabbar:(id)slideTabbar selectAtIndex:(NSInteger)index
{
    [_slideView setSelecteIndex:index];
}

- (NSInteger)numberOfControllersInDHSlideView:(DHSlideView *)slideView
{
    return [_delegate numberOfTabsInDHCustomSlideView:self];
}

- (UIViewController *)DHSlideView:(DHSlideView *)slideView viewControllerAtIndex:(NSInteger)index
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)index];
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    } else{
        UIViewController *viewController = [_delegate DHCustomSlideView:self controllerAtIndex:index];
        [self.cache setObject:viewController forKey:key];
        return viewController;
    }
}

- (void)DHSlideView:(DHSlideView *)slideView fromIndex:(NSInteger)oldIndex toIndex:(NSInteger)toIndex percent:(float)percent
{
    [_tabbarView switchFromIndex:oldIndex toIndex:toIndex percent:percent];
}

- (void)DHSlideView:(DHSlideView *)slideView didSelectIndex:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(DHCustomSlideView:didSelectedAtIndex:)]) {
        [_delegate DHCustomSlideView:self didSelectedAtIndex:index];
    }
    [_tabbarView setSelectedIndex:index];
}

- (void)DHSlideView:(DHSlideView *)slideView cancelIndex:(NSInteger)index
{
    [_tabbarView setSelectedIndex:index];
}


@end
