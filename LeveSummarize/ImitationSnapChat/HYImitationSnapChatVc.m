//
//  HYImitationSnapChatVc.m
//  LeveSummarize
//
//  Created by leve on 2018/6/26.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYImitationSnapChatVc.h"
#import "HYMainLayoutManagerView.h"
#import "HYLeftViewController.h"
#import "HYRightViewController.h"
#import "HYCaptureViewController.h"
#import "HYTopViewController.h"
#import "HYBottomViewController.h"

@interface HYImitationSnapChatVc ()<HYMainLayoutDelegate,HYMainLayoutDatasource>
@end

@implementation HYImitationSnapChatVc

- (void)viewDidLoad {
    [super viewDidLoad];
    HYMainLayoutManagerView *manager = [[HYMainLayoutManagerView alloc] initWithFrame:self.view.bounds];
    manager.delegate = self;
    manager.dataSource = self;
    [manager startLayout];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 30, 60, 30);
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn setTitle:@"退出" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --HYMainLayoutDataSource
- (UIViewController *)mainLayout:(HYMainLayoutManagerView *)mainLayout viewControllerAtLocation:(HYMainLayoutLocation)location
{
    switch (location) {
        case HYMainLayoutLeft:
        {
            HYLeftViewController *leftVc = [[HYLeftViewController alloc] init];
            return leftVc;
        }
            break;
        case HYMainLayoutRight:
        {
            HYRightViewController *rightVc = [[HYRightViewController alloc] init];
            return rightVc;
        }
            break;
        case HYMainLayoutMiddle:
        {
            HYCaptureViewController *captureVc = [[HYCaptureViewController alloc] init];
            return captureVc;
        }
            break;
        case HYMainLayoutTop:
        {
            HYTopViewController *topVc = [[HYTopViewController alloc] init];
            return topVc;
        }
            break;
        case HYMainLayoutBottom:
        {
            HYBottomViewController *bottomVc = [[HYBottomViewController alloc] init];
            return bottomVc;
        }
            break;
        default:
            return nil;
            break;
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
