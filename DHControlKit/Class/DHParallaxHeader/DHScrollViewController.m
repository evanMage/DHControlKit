//
//  DHScrollViewController.m
//  headerDemo
//
//  Created by 代新辉 on 2017/12/8.
//  Copyright © 2017年 代新辉. All rights reserved.
//

#import "DHScrollViewController.h"
#import <objc/runtime.h>

IB_DESIGNABLE
@interface DHScrollViewController ()

@property (nonatomic,weak) UIView *headerView;
@property (nonatomic) IBInspectable CGFloat headerHeight;
@property (nonatomic) IBInspectable CGFloat headerMinimumHeight;

@end

static void *const KDHScrollViewControllerKVOContext = (void *) & KDHScrollViewControllerKVOContext;

@implementation DHScrollViewController

@synthesize scrollView = _scrollView;

- (void)loadView
{
    self.view = self.scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.parallaxHeader.view = self.headerView;
    self.scrollView.parallaxHeader.height = self.headerHeight;
    self.scrollView.parallaxHeader.minimumHeight = self.headerMinimumHeight;
    
    //Hack to perform segues on load
    @try {
        NSArray *templates = [self valueForKey:@"storyboardSegueTemplates"];
        for (id template in templates) {
            NSString *segueClasseName = [template valueForKey:@"_segueClassName"];
            if ([segueClasseName isEqualToString:NSStringFromClass(DHScrollViewControllerSegue.class)] ||
                [segueClasseName isEqualToString:NSStringFromClass(DHParallaxHeaderSegue.class)]) {
                NSString *identifier = [template valueForKey:@"identifier"];
                [self performSegueWithIdentifier:identifier sender:self];
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-----------%@",NSStringFromCGRect(self.scrollView.frame));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"-----------%@",NSStringFromCGRect(self.scrollView.frame));
    CGRect frame = self.scrollView.frame;
    frame.size.height -= 34;
    self.scrollView.frame = frame;
    NSLog(@"-----------%@",NSStringFromCGRect(self.scrollView.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.scrollView.frame.size;
    [self layoutChildViewController];
}

- (void)layoutChildViewController
{
    CGRect frame = self.scrollView.frame;
    frame.origin = CGPointZero;
    frame.size.height -= self.scrollView.parallaxHeader.minimumHeight;
    self.childViewController.view.frame = frame;
}

#pragma mark Properties

- (DHScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[DHScrollView alloc] init];
        [_scrollView.parallaxHeader addObserver:self forKeyPath:NSStringFromSelector(@selector(minimumHeight)) options:NSKeyValueObservingOptionNew context:KDHScrollViewControllerKVOContext];
    }
    return _scrollView;
}

- (void)setHeaderViewController:(UIViewController *)headerViewController
{
    if (_headerViewController.parentViewController == self) {
        [_headerViewController willMoveToParentViewController:nil];
        [_headerViewController.view removeFromSuperview];
        [_headerViewController removeFromParentViewController];
        [_headerViewController didMoveToParentViewController:nil];
    }
    
    if (headerViewController) {
        [headerViewController willMoveToParentViewController:self];
        [self addChildViewController:headerViewController];
        
        //Set parallaxHeader view
        objc_setAssociatedObject(headerViewController, @selector(parallaxHeader), self.scrollView.parallaxHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.scrollView.parallaxHeader.view = headerViewController.view;
        [headerViewController didMoveToParentViewController:self];
    }
    _headerViewController = headerViewController;
}

- (void)setChildViewController:(UIViewController<DHScrollViewDelegate> *)childViewController
{
    if (_childViewController.parentViewController == self) {
        [_childViewController willMoveToParentViewController:nil];
        [_childViewController.view removeFromSuperview];
        [_childViewController removeFromParentViewController];
        [_childViewController didMoveToParentViewController:nil];
    }
    
    if (childViewController) {
        [childViewController willMoveToParentViewController:self];
        [self addChildViewController:childViewController];
        
        //Set UIViewController's parallaxHeader property
        objc_setAssociatedObject(childViewController, @selector(parallaxHeader), self.scrollView.parallaxHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self.scrollView addSubview:childViewController.view];
        [childViewController didMoveToParentViewController:self];
    }
    _childViewController = childViewController;
}

//MARK: - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == KDHScrollViewControllerKVOContext) {
        if (self.childViewController && [keyPath isEqualToString:NSStringFromSelector(@selector(minimumHeight))]) {
            [self layoutChildViewController];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.scrollView.parallaxHeader removeObserver:self forKeyPath:NSStringFromSelector(@selector(minimumHeight))];
}

@end
//MARK: - UIViewController category
@implementation UIViewController (DHParallaxHeader)

- (DHParallaxHeader *)parallaxHeader
{
    DHParallaxHeader *parallaxHeader = objc_getAssociatedObject(self, @selector(parallaxHeader));
    if (!parallaxHeader && self.parentViewController) {
        return self.parentViewController.parallaxHeader;
    }
    return parallaxHeader;
}

@end

#pragma mark MXParallaxHeaderSegue class

@implementation DHParallaxHeaderSegue

- (void)perform {
    if ([self.sourceViewController isKindOfClass:[DHScrollViewController class]]) {
        DHScrollViewController *svc = self.sourceViewController;
        svc.headerViewController = self.destinationViewController;
    }
}

@end

//MARK: - DHScrollViewControllerSegue class

@implementation DHScrollViewControllerSegue

- (void)perform {
    if ([self.sourceViewController isKindOfClass:[DHScrollViewController class]]) {
        DHScrollViewController *svc = self.sourceViewController;
        svc.childViewController = self.destinationViewController;
    }
}
@end
