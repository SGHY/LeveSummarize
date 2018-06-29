//
//  LVNewHeartbeatBackgroundView.m
//  LEVE
//
//  Created by leve on 2018/5/28.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import "LVNewHeartbeatBackgroundView.h"
@interface LVNewHeartbeatBackgroundView ()
@property (strong, nonatomic) UIVisualEffectView *effectView;
@end
@implementation LVNewHeartbeatBackgroundView
- (void)dealloc
{
    NSLog(@"dealloc ------------- %@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.alpha = 0.9;
        effectView.frame = self.bounds;
        [self addSubview:effectView];
        self.effectView = effectView;
        
        CGRect rect = CGRectZero;
        if (kScreenWidth == kiPhone6P_W) {
            rect = CGRectMake(0,  -120, kScreenWidth, kScreenHeight);
        }else if (kScreenWidth == kiPhone6_W){
            rect = CGRectMake(0,  -110, kScreenWidth, kScreenHeight);
        }else if (kScreenWidth == kiPhone5_W){
            rect = CGRectMake(0,  -90, kScreenWidth, kScreenHeight);
        }
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:rect];
        bgImgView.contentMode = UIViewContentModeScaleAspectFit;
        bgImgView.image = [UIImage imageNamed:@"心动卡片背景"];
        [self addSubview:bgImgView];
        self.bgImgView = bgImgView;
    }
    return self;
}
- (void)setBgType:(LVNewHeartbeatBackgroundType)bgType
{
    _bgType = bgType;
    switch (bgType) {
        case LVNewHeartbeatBackgroundNormal:
            self.effectView.hidden = NO;
            CGRect rect = CGRectZero;
            if (kScreenWidth == kiPhone6P_W) {
                rect = CGRectMake(0,  -120, kScreenWidth, kScreenHeight);
            }else if (kScreenWidth == kiPhone6_W){
                rect = CGRectMake(0,  -110, kScreenWidth, kScreenHeight);
            }else if (kScreenWidth == kiPhone5_W){
                rect = CGRectMake(0,  -90, kScreenWidth, kScreenHeight);
            }
            self.bgImgView.frame = rect;
            self.bgImgView.image = [UIImage imageNamed:@"心动卡片背景"];
            self.bgImgView.contentMode = UIViewContentModeScaleAspectFit;
            break;
        case LVNewHeartbeatBackgroundGreet:
            self.effectView.hidden = YES;
            self.bgImgView.frame = self.bounds;
            self.bgImgView.image = [UIImage imageNamed:@"bg_greet"];
            self.bgImgView.contentMode = UIViewContentModeScaleAspectFill;
            break;
        case LVNewHeartbeatBackgroundGreetSuccess:
            self.effectView.hidden = YES;
            self.bgImgView.frame = self.bounds;
            self.bgImgView.image = [UIImage imageNamed:@"bg_zhcg"];
            self.bgImgView.contentMode = UIViewContentModeScaleAspectFill;
            break;
        case LVNewHeartbeatBackgroundMatchSuccess:
            self.effectView.hidden = YES;
            self.bgImgView.frame = self.bounds;
            self.bgImgView.image = [UIImage imageNamed:@"bg_xdcg"];
            self.bgImgView.contentMode = UIViewContentModeScaleAspectFill;
            break;
        default:
            break;
    }
}
@end
