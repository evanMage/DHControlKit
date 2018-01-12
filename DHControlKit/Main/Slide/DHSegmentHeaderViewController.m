//
//  DHSegmentHeaderViewController.m
//  DHControlKit
//
//  Created by 代新辉 on 2018/1/11.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHSegmentHeaderViewController.h"

@interface DHSegmentHeaderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

@implementation DHSegmentHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *str = @"一寸土，一年木，一花一木一贪图，一寸土，一年木，一花一木一贪图";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} range:[str rangeofAll]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingHead;
    [attrStr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:[str rangeofAll]];
    self.textfield.attributedText = attrStr;
    self.textfield.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
