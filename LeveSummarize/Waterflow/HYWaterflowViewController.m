//
//  HYWaterflowViewController.m
//  LeveSummarize
//
//  Created by leve on 2018/6/27.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYWaterflowViewController.h"
#import "HYWaterflowLayout.h"
#import "HYWaterflowCell.h"

@interface HYWaterflowViewController ()<HYWaterflowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) HYWaterflowLayout *momentLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HYWaterflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    
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
#pragma mark -- views
- (HYWaterflowLayout *)momentLayout
{
    if (!_momentLayout) {
        HYWaterflowLayout *layout = [[HYWaterflowLayout alloc] init];
        layout.delegate = self;
        _momentLayout = layout;
    }
    return _momentLayout;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight) collectionViewLayout:self.momentLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [collectionView registerClass:[HYWaterflowCell class] forCellWithReuseIdentifier:@"HYWaterflowCell"];
        _collectionView = collectionView;
    }
    return _collectionView;
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYWaterflowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HYWaterflowCell" forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark - <HYWaterflowLayoutDelegate>
//返回每个cell的高度
- (CGFloat)waterflowLayout:(HYWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    return 100 +arc4random()%101;
}
//每行的最小距离
- (CGFloat)rowMarginInWaterflowLayout:(HYWaterflowLayout *)waterflowLayout
{
    return 5.f;
}
//每列的最小距离
- (CGFloat)columnMarginInWaterflowLayout:(HYWaterflowLayout *)waterflowLayout
{
    return 5.f;
}
//有多少列
- (CGFloat)columnCountInWaterflowLayout:(HYWaterflowLayout *)waterflowLayout
{
    return 2;
}
//内边距
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(HYWaterflowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
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
