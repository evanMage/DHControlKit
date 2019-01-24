//
//  DHFlowViewCell.m
//  DHControlKit
//
//  Created by daixinhui on 2018/12/17.
//  Copyright © 2018 代新辉. All rights reserved.
//

#import "DHFlowViewCell.h"

@implementation DHFlowViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = [UIColor colorRandom].CGColor;
    self.layer.borderWidth = 1;
}

@end
