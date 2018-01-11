//
//  UIScrollView+Additions.m
//  DHFramework
//
//  Created by daixinhui on 16/4/21.
//  Copyright © 2016年 daixinhui. All rights reserved.
//

#import "UIScrollView+Additions.h"
#import "UIView+Additions.h"

@implementation UIScrollView (Additions)

- (void)scrollToTop
{
    [self scrollToTopAnimated:YES];
}

- (void)scrollToBottom
{
    [self scrollToBottomAnimated:YES];
}

- (void)scrollToLeft
{
    [self scrollToLeftAnimated:YES];
}

- (void)scrollToRight
{
    [self scrollToRightAnimated:YES];
}

- (void)scrollToTopAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToLeftAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToRightAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
