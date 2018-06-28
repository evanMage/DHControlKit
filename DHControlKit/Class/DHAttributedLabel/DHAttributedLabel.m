//
//  DHAttributedLabel.m
//  DHControlKit
//
//  Created by daixinhui on 2018/4/25.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHAttributedLabel.h"

@implementation DHAttributedLabel

@dynamic text;
@synthesize attributedText = _attributedText;

//MARK: - instancetype
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureDefaults];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureDefaults];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureDefaults];
}

//MARK: - draw
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

//MARK: - private methods
/** 配置默认属性 */
- (void)configureDefaults
{
    
}

//MARK: - public methods

@end
