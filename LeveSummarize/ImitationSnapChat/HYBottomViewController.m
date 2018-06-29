//
//  HYBottomViewController.m
//  HY520SnapDemo
//
//  Created by BigDataAi on 2018/4/10.
//  Copyright © 2018年 BigDataAi. All rights reserved.
//

#import "HYBottomViewController.h"

@interface HYBottomViewController ()

@end

@implementation HYBottomViewController

- (void)dealloc {
    NSLog(@"dealloc_____%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width - 100.f, 330.f)];
    whiteView.center = self.view.center;
    whiteView.backgroundColor = [UIColor orangeColor];
    whiteView.layer.cornerRadius = 20.f;
    [self.view addSubview:whiteView];
    
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
