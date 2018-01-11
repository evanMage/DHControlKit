//
//  ViewController.m
//  DHControlKit
//
//  Created by 代新辉 on 2018/1/11.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "ViewController.h"
#import "DHCardViewController.h"
#import "DHSlideViewViewController.h"
#import "DHSegmentationViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK: - Private Methods
- (void)setupData
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = @[@"Slide tab",@"ScrollView Parallax Header",@"Card Swipe"];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            DHSlideViewViewController *slideViewViewController = [[DHSlideViewViewController alloc] init];
            [self.navigationController pushViewController:slideViewViewController animated:YES];
        }
            break;
        case 1:{
            DHSegmentationViewController *segmentationViewController = [[DHSegmentationViewController alloc] init];
            [self.navigationController pushViewController:segmentationViewController animated:YES];
        }
            break;
        case 2:{
            DHCardViewController *cardViewController = [[DHCardViewController alloc] init];
            [self.navigationController pushViewController:cardViewController animated:YES];

        }
            break;
            
        default:
            break;
    }
}

@end
