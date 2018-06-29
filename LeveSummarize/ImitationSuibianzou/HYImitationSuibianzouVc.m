//
//  HYImitationSuibianzouVc.m
//  LeveSummarize
//
//  Created by leve on 2018/6/28.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYImitationSuibianzouVc.h"
#import "HYCaptureViewController.h"
#import "HYTagsSuspendingView.h"

@interface HYImitationSuibianzouVc ()

@end

@implementation HYImitationSuibianzouVc
- (void)dealloc
{
    NSLog(@"dealloc----- %@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    HYCaptureViewController *captureVc = [[HYCaptureViewController alloc] init];
    captureVc.view.frame = self.view.bounds;
    [self addChildViewController:captureVc];
    [self.view addSubview:captureVc.view];
    
    HYTagsSuspendingView *tagsView = [[HYTagsSuspendingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tagsView];
    
    [self createReturnBack];
}
- (void)createReturnBack
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth-60, 30, 60, 30);
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn setTitle:@"退出" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
