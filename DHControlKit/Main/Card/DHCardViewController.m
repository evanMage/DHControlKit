//
//  DHCardViewController.m
//  DHControlKit
//
//  Created by 代新辉 on 2018/1/11.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHCardViewController.h"
#import "DHCardView.h"
#import "DHSwipeView.h"

@interface DHCardViewController ()<DHSwipeViewDelegate,DHSwipeViewDataSource,DHSwipeViewAnimatorProtocol>

@property (strong, nonatomic) DHSwipeView *swipeView;
@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic) NSUInteger colorIndex;

@end

@implementation DHCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupData];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter & getter

- (DHSwipeView *)swipeView
{
    if (!_swipeView) {
        _swipeView = [[DHSwipeView alloc] init];
        [self.view addSubview:_swipeView];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_swipeView]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_swipeView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-250-[_swipeView]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_swipeView)]];
    }
    return _swipeView;
}

- (NSMutableArray *)colorsArray
{
    if (!_colorsArray) {
        _colorsArray = [[NSMutableArray alloc] init];
    }
    return _colorsArray;
}

#pragma mark - Private Methods

- (void)setupUI
{
    self.swipeView.allowedDirectionState = DHSwipeViewDirectionStateHorizontal;
    self.swipeView.translatesAutoresizingMaskIntoConstraints = NO;
    self.swipeView.numberOfActiveViews = 3;
//    self.swipeView.animatorState = DHViewAnimatorDynamicState;
    self.swipeView.delegate = self;
    self.swipeView.dataSource = self;
    self.swipeView.animatorProtocol = self;
}

- (void)setupData
{
    self.colorIndex = 0;
    [self.colorsArray removeAllObjects];
    [self.colorsArray addObject:[UIColor orangeColor]];
    [self.colorsArray addObject:[UIColor yellowColor]];
    [self.colorsArray addObject:[UIColor blueColor]];
    [self.colorsArray addObject:[UIColor purpleColor]];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.swipeView loadViewsIfNeeded];
}

//MARK: - DHSwipeViewDelegate

- (void)DHSwipeView:(DHSwipeView *)swipeView didCancelSwipe:(UIView *)view
{
    
}

- (void)DHSwipeView:(DHSwipeView *)swipeView didSwipeView:(UIView *)view inDirection:(DHSwipeViewDirectionState)direction
{
    
}

- (void)DHSwipeView:(DHSwipeView *)swipeView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location
{
    
}

- (void)DHSwipeView:(DHSwipeView *)swipeView didStartSwipingView:(UIView *)view atLocation:(CGPoint)location
{
    
}

- (void)DHSwipeView:(DHSwipeView *)swipeView swipingView:(UIView *)view atLocation:(CGPoint)location translation:(CGPoint)translation
{
    
}

//MARK: - DHSwipeViewDataSource
- (UIView *)nextViewForSwipeView:(DHSwipeView *)swipeView
{
    if (self.colorIndex >= self.colorsArray.count) {
        self.colorIndex = 0;
    }
    DHCardView *cardView = [[DHCardView alloc] initWithFrame:swipeView.bounds];
    cardView.backgroundColor = self.colorsArray[self.colorIndex];
//        cardView.backgroundColor = [UIColor whiteColor];
    cardView.tag = self.colorIndex;
    self.colorIndex ++;
    return cardView;
}

//MARK: - DHSwipeViewAnimatorProtocol

- (void)animateView:(UIView *)view index:(NSUInteger)index viewArray:(NSArray<UIView *> *)viewArray swipeView:(DHSwipeView *)swipeView
{
    CGRect frame = swipeView.bounds;
    if (index == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            view.transform = CGAffineTransformIdentity;
            view.frame = frame;
        } completion:nil];
        
    }
    if (index == 1) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            view.transform = CGAffineTransformIdentity;
            view.frame = CGRectMake(frame.origin.x, frame.origin.y + 12, frame.size.width, frame.size.height);
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.97f,0.97f);
        } completion:nil];
    }
    if (index == 2) {
        view.transform = CGAffineTransformIdentity;
        view.frame = CGRectMake(frame.origin.x, frame.origin.y + (12 * 2), frame.size.width, frame.size.height);
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.94f,0.94f);
    }
}
@end
