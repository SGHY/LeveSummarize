//
//  HYRootViewController.m
//  LeveSummarize
//
//  Created by leve on 2018/6/22.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYRootViewController.h"
#import "LVNewHeartbeatMainView.h"
#import "HYSpreadAnimationView.h"
#import "HYMatchSuccessAnimationView.h"
#import "HYCellularBubblesView.h"
#import "HY3DRotateView.h"
#import "HYImitationSnapChatVc.h"
#import "HYPhotoZoomViewController.h"
#import "HYWaterflowViewController.h"
#import "HYImitationSuibianzouVc.h"

@interface HYRootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation HYRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"LEVE总结";
    [self.view addSubview:self.tableView];
    
    [self loadDataSource];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)loadDataSource
{
    self.dataSource = [[NSMutableArray alloc] init];
    [self.dataSource addObject:@"心动卡片"];
    [self.dataSource addObject:@"展开动效"];
    [self.dataSource addObject:@"匹配成功动效"];
    [self.dataSource addObject:@"蜂窝气泡展示"];
    [self.dataSource addObject:@"立体翻转"];
    [self.dataSource addObject:@"仿snapchat主框架"];
    [self.dataSource addObject:@"图片双指放大缩小可拖动"];
    [self.dataSource addObject:@"瀑布流"];
    [self.dataSource addObject:@"防随便走空间标识悬浮"];
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LVNewHeartbeatMainView *heartBeatView = [[LVNewHeartbeatMainView alloc] initWithFrame:self.view.bounds enterWithCards:nil enterType:LVNewHeartbeatMainEnterNormal];
        [self.navigationController.view addSubview:heartBeatView];
    }
    if (indexPath.row == 1) {
        HYSpreadAnimationView *spreadView = [[HYSpreadAnimationView alloc] initWithFrame:self.navigationController.view.bounds];
        [spreadView showAtView:self.navigationController.view fromRect:CGRectMake(100, 100, 100, 100)];
    }
    if (indexPath.row == 2) {
        HYMatchSuccessAnimationView *matchView = [[HYMatchSuccessAnimationView alloc] initWithFrame:self.navigationController.view.bounds];
        [self.navigationController.view addSubview:matchView];
    }
    if (indexPath.row == 3) {
        HYCellularBubblesView *cellularView = [[HYCellularBubblesView alloc] initWithFrame:self.navigationController.view.bounds];
        [self.navigationController.view addSubview:cellularView];
    }
    if (indexPath.row == 4) {
        HY3DRotateView *rotateView = [[HY3DRotateView alloc] initWithFrame:self.navigationController.view.bounds];
        [self.navigationController.view addSubview:rotateView];
    }
    if (indexPath.row == 5) {
        HYImitationSnapChatVc *snapVc = [[HYImitationSnapChatVc alloc] init];
        [self presentViewController:snapVc animated:YES completion:nil];
    }
    if (indexPath.row == 6) {
        HYPhotoZoomViewController *photoVc = [[HYPhotoZoomViewController alloc] init];
        [self presentViewController:photoVc animated:YES completion:nil];
    }
    if (indexPath.row == 7) {
        HYWaterflowViewController *waterflowVc = [[HYWaterflowViewController alloc] init];
        [self presentViewController:waterflowVc animated:YES completion:nil];
    }
    if (indexPath.row == 8) {
        HYImitationSuibianzouVc *suibainzouVc = [[HYImitationSuibianzouVc alloc] init];
        [self presentViewController:suibainzouVc animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
