//
//  DHSlideViewViewController.m
//  DHControlKit
//
//  Created by 代新辉 on 2018/1/11.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHSlideViewViewController.h"
#import "DHCache.h"
#import "DHCustomSlideView.h"
#import "DHScrollTabbarView.h"
#import "DHContentViewController.h"

@interface DHSlideViewViewController ()<DHCustomSlideViewDelegate>

@property (weak, nonatomic) IBOutlet DHCustomSlideView *customSlideView;

@property (nonatomic, strong) DHScrollTabbarView *scrollTabbarView;
@property (nonatomic, strong) DHCache *cache;

@end

@implementation DHSlideViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addCustomSlideView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods
- (void)addCustomSlideView
{
    self.cache = [[DHCache alloc] initWithCount:6];
    [self.scrollTabbarView removeFromSuperview];
    NSArray *array = [self itemTitleData];
    //    self.scrollTabbarView = [[DHScrollTabbarView alloc] initWithFrame:CGRectMake(0, 0, KEY_WINDOW_WIDTH, array.count <= 1 && self.dictModel.isHasOxford?0:48)];
    self.scrollTabbarView = [[DHScrollTabbarView alloc] initWithFrame:CGRectMake(0, 0, KEY_WINDOW_WIDTH, 50)];
    self.scrollTabbarView.tabItemNormalColor = [UIColor blackColor];
    self.scrollTabbarView.tabItemSelectedColor = [UIColor redColor];
    self.scrollTabbarView.tabItemNormalFontSize = 14.0f;
    self.scrollTabbarView.tabItemBold = YES;
    self.scrollTabbarView.trackColor = [UIColor redColor];
    self.scrollTabbarView.trackViewWidthEqualToTextLength = YES;
    self.scrollTabbarView.lineColor = [UIColor purpleColor];
    
    self.scrollTabbarView.tabbarItems = array;
    self.customSlideView.delegate = self;
    self.customSlideView.tabbarView = self.scrollTabbarView;
    self.customSlideView.cache = self.cache;
    self.customSlideView.tabbarBottomSpacing = 0;
    self.customSlideView.baseViewController = self;
    [self.customSlideView setup];
    self.customSlideView.selectedIndex = 0;
}

- (NSArray *)itemTitleData
{
    NSMutableArray *itemArray = [NSMutableArray array];
    DHScrollTabbarItem *item = nil;
    item = [DHScrollTabbarItem itemWithTitle:@"娱乐" attributedString:nil width:80];
    [itemArray addObject:item];
    item = [DHScrollTabbarItem itemWithTitle:@"阅读" attributedString:nil width:80];
    [itemArray addObject:item];
    item = [DHScrollTabbarItem itemWithTitle:@"小说" attributedString:nil width:80];
    [itemArray addObject:item];
    item = [DHScrollTabbarItem itemWithTitle:@"国际报道" attributedString:nil width:80];
    [itemArray addObject:item];
    return itemArray;
}
- (NSInteger)numberOfTabsInDHCustomSlideView:(DHCustomSlideView *)customSlideView
{
    return [[self itemTitleData] count];
}

- (UIViewController *)DHCustomSlideView:(DHCustomSlideView *)customSlideView controllerAtIndex:(NSInteger)index
{
    DHContentViewController *viewController = [[DHContentViewController alloc] init];
    return viewController;
}


@end
