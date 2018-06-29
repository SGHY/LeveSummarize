//
//  HYPhotoZoomViewController.m
//  LeveSummarize
//
//  Created by leve on 2018/6/27.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYPhotoZoomViewController.h"
#import "HYPhotoCell.h"

@interface HYPhotoZoomViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (strong , nonatomic) UITableView *tableView;
@end

@implementation HYPhotoZoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
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
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    if (!cell) {
        cell = [[HYPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        cell.backgroundColor = [UIColor orangeColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
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
