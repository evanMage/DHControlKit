//
//  DHClickWordViewController.m
//  DHControlKit
//
//  Created by 代新辉 on 2018/2/28.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHClickWordViewController.h"
#import <TTTAttributedLabel.h>

@interface DHClickWordViewController ()<TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *testAttributedLabel;

@end

@implementation DHClickWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.testAttributedLabel.delegate = self;
    NSString *string = @"Promises are often like the butterfly, which disappear after beautiful hover!";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorRandom] range:[string rangeofAll]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:[string rangeofAll]];
    self.testAttributedLabel.attributedText = attrStr;
    [self.testAttributedLabel addLinkToURL:[NSURL URLWithString:@"Promises"] withRange:NSMakeRange(0, 8)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    DXHDINFO(@"-------------- %@",url.absoluteString);
}

@end
