//
//  DHCardView.m
//  DHControlKit
//
//  Created by 代新辉 on 2018/1/11.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHCardView.h"

@implementation DHCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.layer.cornerRadius = 10;
    //    self.layer.borderColor = [UIColor blueColor].CGColor;
    //    self.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    
    //shadow
    //    self.layer.shadowColor = [UIColor blackColor].CGColor;
    //    self.layer.shadowOpacity = 1;
    //    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    //    self.layer.shadowRadius = 4.0;
    //    self.layer.shouldRasterize = YES;
    //    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)tap:(UIGestureRecognizer *)recognizer
{
    DXHDINFO(@"--------%zd",recognizer.view.tag);
}

@end
