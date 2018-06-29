//
//  HYMatchSuccessAnimationView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/25.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYMatchSuccessAnimationView.h"
#define CenternHeight kRatioWidth(162)
#define CenternWidth (2*CenternHeight - 10)
#define CenternItemWidth kRatioWidth(50)

@interface HYMatchSuccessAnimationView ()
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) UIButton *leftImageView;
@property (strong, nonatomic) UIButton *rightImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@end
@implementation HYMatchSuccessAnimationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - CenternWidth)/2,(kScreenHeight - CenternHeight)/2 , CenternWidth, CenternHeight)];
        [self addSubview:centerView];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CenternHeight, CenternHeight)];
        leftView.layer.masksToBounds = YES;
        leftView.layer.cornerRadius = CenternHeight/2;
        leftView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [centerView addSubview:leftView];
        self.leftView = leftView;
        
        UIButton *leftImageView = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, CenternHeight-24, CenternHeight-24)];
        leftImageView.layer.masksToBounds = YES;
        leftImageView.layer.cornerRadius = (CenternHeight-24)/2;
        leftImageView.backgroundColor = [UIColor orangeColor];
        [leftView addSubview:leftImageView];
        self.leftImageView = leftImageView;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CenternWidth-CenternHeight, 0, CenternHeight, CenternHeight)];
        rightView.layer.masksToBounds = YES;
        rightView.layer.cornerRadius = CenternHeight/2;
        rightView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [centerView addSubview:rightView];
        self.rightView = rightView;
        
        UIButton *rightImageView = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, CenternHeight - 24, CenternHeight - 24)];
        rightImageView.layer.masksToBounds = YES;
        rightImageView.layer.cornerRadius = (CenternHeight-24)/2;
        rightImageView.backgroundColor = [UIColor orangeColor];
        [rightView addSubview:rightImageView];
        self.rightImageView = rightImageView;
        
        UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CenternWidth-CenternItemWidth)/2, (CenternHeight-CenternItemWidth)/2, CenternItemWidth, CenternItemWidth)];
        centerImageView.image = [UIImage imageNamed:@"ic_zhcg"];
        [centerView addSubview:centerImageView];
        self.centerImageView = centerImageView;
        [self showAnimation];
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
- (void)showAnimation
{
    self.centerImageView.transform = CGAffineTransformMakeScale(0, 0);
    
    CGAffineTransform leftRotation = CGAffineTransformMakeRotation(M_PI_2);
    CGAffineTransform leftTranslation = CGAffineTransformMakeTranslation(-((kScreenWidth - CenternWidth)/2.0 + CenternHeight), 0);
    self.leftView.transform = CGAffineTransformConcat(leftRotation, leftTranslation);
    
    CGAffineTransform rightRotation = CGAffineTransformMakeRotation(-M_PI_2);
    CGAffineTransform rightTranslation = CGAffineTransformMakeTranslation(((kScreenWidth - CenternWidth)/2.0 + CenternHeight), 0);
    self.rightView.transform = CGAffineTransformConcat(rightRotation, rightTranslation);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.leftView.transform = CGAffineTransformIdentity;
        self.rightView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.centerImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }];
}
@end
