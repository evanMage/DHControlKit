//
//  DHSegmentationViewController.m
//  DHControlKit
//
//  Created by 代新辉 on 2018/1/11.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHSegmentationViewController.h"
#import "DHSlideViewViewController.h"
#import "DHSegmentHeaderViewController.h"

@interface DHSegmentationViewController ()

@property (nonatomic, strong) DHSlideViewViewController *slideVC;
@property (nonatomic, strong) DHSegmentHeaderViewController *headerVC;

@end

@implementation DHSegmentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - private methods
- (void)setupUI
{
    self.scrollView.parallaxHeader.height = 300;
    self.scrollView.parallaxHeader.minimumHeight = 100;
    self.scrollView.parallaxHeader.mode = DHParallaxHeaderModeBottom;
    self.childViewController = self.slideVC;
    self.headerViewController = self.headerVC;
}

#pragma mark - setter & getter

- (DHSlideViewViewController *)slideVC
{
    if (!_slideVC) {
        _slideVC = [[DHSlideViewViewController alloc] init];
    }
    return _slideVC;
}

- (DHSegmentHeaderViewController *)headerVC
{
    if (!_headerVC) {
        _headerVC = [[DHSegmentHeaderViewController alloc] init];
    }
    return _headerVC;
}

@end
