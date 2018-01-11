//
//  DHScrollTabbarView.m
//  DHSlideViewDemo
//
//  Created by daixinhui on 15/10/14.
//  Copyright © 2015年 daixinhui. All rights reserved.
//

#import "DHScrollTabbarView.h"
#import "DHColorChangeUtils.h"

#define kLabelTagBase 1000
#define kViewTagBase 2000

@implementation DHScrollTabbarItem

+ (DHScrollTabbarItem *)itemWithTitle:(NSString *)title attributedString:(NSAttributedString *)attributedString width:(CGFloat)width
{
    DHScrollTabbarItem *item = [[DHScrollTabbarItem alloc] init];
    item.title = title;
    item.attributedString = attributedString;
    item.width = width;
    return item;
}

@end

@interface DHScrollTabbarView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *trackView;
@property (nonatomic, strong) UIView *lineView;
@property(nonatomic, assign) CGFloat trackViewHeight;//滑动线条高度

@end

@implementation DHScrollTabbarView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}

- (void)commonInit
{
    _selectedIndex = -1;
    _trackViewHeight = kTrackViewHeight;
    _trackViewWidthEqualToTextLength = NO;
    self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 1.0/[UIScreen mainScreen].scale, CGRectGetWidth(self.bounds), 1.0/[UIScreen mainScreen].scale);
    self.lineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lineView];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.bounds) - kTrackViewHeight,70, _trackViewHeight)];
    [_scrollView addSubview:_trackView];
}
#pragma mark - set methods
- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        [self insertSubview:backgroundView atIndex:0];
        _backgroundView = backgroundView;
    }
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.lineView.backgroundColor = _lineColor;
}

- (void)setTabItemNormalColor:(UIColor *)tabItemNormalColor
{
    _tabItemNormalColor = tabItemNormalColor;
    
    for (int i = 0; i < [self tabbarCount]; i ++) {
        if (i == _selectedIndex) {
            continue;
        }
        UILabel *label = (UILabel *)[_scrollView viewWithTag:kLabelTagBase + i];
        label.textColor = tabItemNormalColor;
    }
    
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackColor = trackColor;
    _trackView.backgroundColor = trackColor;
}

- (void)setTrackViewCornerRadius:(CGFloat)trackViewCornerRadius
{
    _trackViewCornerRadius = trackViewCornerRadius;
    _trackView.layer.cornerRadius = trackViewCornerRadius;
}

- (void)setTrackViewWidthEqualToTextLength:(BOOL)trackViewWidthEqualToTextLength
{
    _trackViewWidthEqualToTextLength = trackViewWidthEqualToTextLength;
    [self layoutSubviews];
}

- (void)setTabbarItems:(NSArray *)tabbarItems
{
    for (int index = 0; index < tabbarItems.count; index++) {
        UIView *view = [_scrollView viewWithTag:kViewTagBase + index];
        [view removeFromSuperview];
    }
    _scrollView.frame = self.bounds;
    if (_tabbarItems != tabbarItems) {
        _tabbarItems = tabbarItems;
        float height = CGRectGetHeight(self.bounds);
        float x = 0.0f;
        NSInteger i = 0;
        for (DHScrollTabbarItem *item in tabbarItems) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, item.width, height)];
            backView.backgroundColor = [UIColor clearColor];
            backView.tag = kViewTagBase + i;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, item.width, height)];
            UIFont *font = self.tabItemBold?[UIFont boldSystemFontOfSize:self.tabItemNormalFontSize]:[UIFont systemFontOfSize:self.tabItemNormalFontSize];
            if (item.attributedString.length >0) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:item.attributedString];
                [attributedString addAttribute:NSForegroundColorAttributeName value:_tabItemNormalColor range:NSMakeRange(0, attributedString.length)];
                [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length - 1)];
                [attributedString addAttribute:NSFontAttributeName value:self.tabItemBold?[UIFont boldSystemFontOfSize:_tabItemNormalFontSize - 5]:[UIFont systemFontOfSize:_tabItemNormalFontSize - 5] range:NSMakeRange(attributedString.length - 1,1)];
                label.attributedText = attributedString;
            }else{
                label.text = item.title;
                label.font = font;
                label.textColor = _tabItemNormalColor;
            }
            label.textAlignment = NSTextAlignmentCenter;
            if (self.isDivideEqually) {
                [label sizeToFit];
            }
            label.tag = kLabelTagBase + i;
            label.frame = CGRectMake((item.width - CGRectGetWidth(label.bounds))/2.0f, (height - CGRectGetHeight(label.bounds))/2.0f, CGRectGetWidth(label.bounds), CGRectGetHeight(label.bounds));
            [backView addSubview:label];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [backView addGestureRecognizer:tap];
            [_scrollView addSubview:backView];
            x += item.width;
            i++;
        }
        _scrollView.contentSize = CGSizeMake(x, height);
    }
    self.selectedIndex = _selectedIndex;
}

- (void)configItem:(DHScrollTabbarItem *)item  backgroundView:(UIView *)backView label:(UILabel *)label index:(NSUInteger) index{
    float height = CGRectGetHeight(self.bounds);
    float width = item.width;
    float x = index * width;
    backView.frame = CGRectMake(x, 0, width, height);

    label.frame = CGRectMake(label.frame.origin.x, (height - CGRectGetHeight(label.bounds))/2.0f,
                             width, CGRectGetHeight(backView.bounds));
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _backgroundView.frame = self.bounds;
    _scrollView.frame = self.bounds;
    for (NSUInteger i = 0; i < self.tabbarItems.count; i++) {
        UIView *backView = [_scrollView viewWithTag:kViewTagBase + i] ;
        UILabel *label = [backView viewWithTag:kLabelTagBase + i];
        [self configItem:self.tabbarItems[i] backgroundView:backView label:label index:i];
        if (i == self.selectedIndex) {
            //                float width = CGRectGetWidth(self.bounds) / MAX(1, self.tabbarItems.count);
            CGRect trackRect = [_scrollView convertRect:label.bounds fromView:label];
            
            if(self.trackViewWidthEqualToTextLength) {
                NSString *titleString = label.text;
                UIFont *font = self.tabItemBold?[UIFont boldSystemFontOfSize:self.tabItemNormalFontSize]:[UIFont systemFontOfSize:self.tabItemNormalFontSize];
                CGSize size = [titleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(label.frame)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
                _trackView.frame = CGRectMake(trackRect.origin.x+(CGRectGetWidth(trackRect)-size.width)/2.0, _trackView.frame.origin.y, size.width, CGRectGetHeight(_trackView.bounds));
                
            } else {
                _trackView.frame = CGRectMake(trackRect.origin.x, _trackView.frame.origin.y,
                                              CGRectGetWidth(trackRect), CGRectGetHeight(_trackView.bounds));
            }
            
        }
    }
}



- (NSInteger)tabbarCount
{
    return _tabbarItems.count;
}

- (void)switchFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex percent:(float)percent
{
    UILabel *fromLabel = (UILabel *)[_scrollView viewWithTag:kLabelTagBase + fromIndex];
    fromLabel.textColor = [DHColorChangeUtils getColorOfPercent:percent betweenColor:_tabItemNormalColor andColor:_tabItemSelectedColor];
    
    UILabel *toLabel = nil;
    if (toIndex >= 0 && toIndex < [self tabbarCount]) {
        toLabel = (UILabel *)[_scrollView viewWithTag:kLabelTagBase + toIndex];
        toLabel.textColor = [DHColorChangeUtils getColorOfPercent:percent betweenColor:_tabItemSelectedColor andColor:_tabItemNormalColor];
    }
    // 计算track view位置和宽度
    CGRect fromRect = [_scrollView convertRect:fromLabel.bounds fromView:fromLabel];
    CGFloat fromWidth = fromLabel.frame.size.width;
    CGFloat fromX = fromRect.origin.x;
    CGFloat toX;
    CGFloat toWidth;
    if (toLabel) {
        CGRect toRect = [_scrollView convertRect:toLabel.bounds fromView:toLabel];
        toWidth = toRect.size.width;
        toX = toRect.origin.x;
    }
    else{
        toWidth = fromWidth;
        if (toIndex > fromIndex) {
            toX = fromX + fromWidth;
        } else{
            toX = fromX - fromWidth;
        }
    }
//    CGFloat width = toWidth * percent + fromWidth * (1 - percent);
//    CGFloat x = fromX + (toX - fromX) * percent;
    //如果跟着手势走松手的时候有点不自然
//    _trackView.frame = CGRectMake(x, _trackView.frame.origin.y, width, CGRectGetHeight(_trackView.bounds));
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex >= 0) {
        UILabel *fromLabel = (UILabel *)[_scrollView viewWithTag:kLabelTagBase + _selectedIndex];
        fromLabel.textColor = _tabItemNormalColor;
    }
    if (selectedIndex >= 0 && selectedIndex < [self tabbarCount]) {
        UILabel *toLabel = (UILabel *)[_scrollView viewWithTag:kLabelTagBase + selectedIndex];
        toLabel.textColor = _tabItemSelectedColor;
        
        UIView *selectView = [_scrollView viewWithTag:kViewTagBase + selectedIndex];
        CGRect selectViewFrom = selectView.frame;
        selectViewFrom = CGRectMake(self.isDivideEqually ? 0 : CGRectGetMidX(selectViewFrom) - _scrollView.bounds.size.width/2.0f,
                                    selectViewFrom.origin.y,
                                    _scrollView.bounds.size.width, selectViewFrom.size.height);
        [_scrollView scrollRectToVisible:selectViewFrom animated:YES];
        
        CGRect trackRect = [_scrollView convertRect:toLabel.bounds fromView:toLabel];
        
        
        if(self.trackViewWidthEqualToTextLength) {
            NSString *titleString = toLabel.text;
            UIFont *font = self.tabItemBold?[UIFont boldSystemFontOfSize:self.tabItemNormalFontSize]:[UIFont systemFontOfSize:self.tabItemNormalFontSize];
            CGSize size = [titleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(toLabel.frame)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
            [UIView animateWithDuration:0.3 animations:^{
                _trackView.frame = CGRectMake(trackRect.origin.x+(CGRectGetWidth(trackRect)-size.width)/2.0, _trackView.frame.origin.y, size.width, CGRectGetHeight(_trackView.bounds));
                
            }];
            
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                _trackView.frame = CGRectMake(trackRect.origin.x, _trackView.frame.origin.y, trackRect.size.width, CGRectGetHeight(_trackView.bounds));
            }];
        }
    }
    _selectedIndex = selectedIndex;
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    self.selectedIndex = recognizer.view.tag - kViewTagBase;
    if (_delegate && [_delegate respondsToSelector:@selector(DHSlideTabbar:selectAtIndex:)]) {
        [_delegate DHSlideTabbar:self selectAtIndex:_selectedIndex];
    }
}

@end
