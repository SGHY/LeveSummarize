//
//  LVNewHeartbeatBottomView.m
//  LEVE
//
//  Created by leve on 2018/5/24.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import "LVNewHeartbeatBottomView.h"

#define SizeItemWidth kRatioWidth(58)
#define MiddleItemWidth kRatioWidth(80)
#define MarginWidth kRatioWidth(50)

@interface LVNewHeartbeatBottomView ()
@property (strong, nonatomic) UIButton *ignoreBtn;
@property (strong, nonatomic) UIButton *helloBtn;
@property (strong, nonatomic) UIButton *likeBtn;
@property (strong, nonatomic) UILabel *promptLabel;
@end

@implementation LVNewHeartbeatBottomView
- (void)dealloc
{
    NSLog(@"dealloc ------------- %@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 20)];
        self.promptLabel.textAlignment = NSTextAlignmentCenter;
        self.promptLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        self.promptLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.promptLabel];
        
        self.ignoreBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - MiddleItemWidth)/2 - SizeItemWidth - MarginWidth, (CGRectGetHeight(frame) - SizeItemWidth)/2, SizeItemWidth, SizeItemWidth)];
        self.ignoreBtn.exclusiveTouch = YES;
        [self.ignoreBtn setBackgroundImage:[UIImage imageNamed:@"ic_xd_dislike"] forState:UIControlStateNormal];
        [self.ignoreBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.ignoreBtn];
        
        self.helloBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - MiddleItemWidth)/2, (CGRectGetHeight(frame) - MiddleItemWidth)/2, MiddleItemWidth, MiddleItemWidth)];
        self.helloBtn.exclusiveTouch = YES;
        [self.helloBtn setBackgroundImage:[UIImage imageNamed:@"ic_xd_greet"] forState:UIControlStateNormal];
        [self.helloBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.helloBtn];
        
        self.likeBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - MiddleItemWidth)/2 + MiddleItemWidth + MarginWidth, (CGRectGetHeight(frame) - SizeItemWidth)/2, SizeItemWidth, SizeItemWidth)];
        self.likeBtn.exclusiveTouch = YES;
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"ic_xd_like"] forState:UIControlStateNormal];
        [self.likeBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.likeBtn];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)kRGBAColor(0, 0, 0, 0.7).CGColor, (__bridge id)kRGBAColor(0, 0, 0, 0).CGColor];
        gradientLayer.locations = @[@0.0, @1.0];
        gradientLayer.startPoint = CGPointMake(0.5, 1.0);
        gradientLayer.endPoint = CGPointMake(0.5, 0.0);
        gradientLayer.frame = self.bounds;
        [self.layer addSublayer:gradientLayer];
        [self.layer insertSublayer:gradientLayer atIndex:0];
        self.backLayer = gradientLayer;
        self.backLayer.opacity = 0.0;
    }
    return self;
}
- (void)clickAction:(UIButton *)btn
{
    if (self.clickBtnBlock) {
        if (btn == self.ignoreBtn) {
            self.clickBtnBlock(LVNewHeartbeatBottomIgnoreBtn,self.ignoreBtn);
        }else if (btn == self.helloBtn){
            self.clickBtnBlock(LVNewHeartbeatBottomHelloBtn, self.helloBtn);
        }else if (btn == self.likeBtn){
            self.clickBtnBlock(LVNewHeartbeatBottomLikeBtn, self.likeBtn);
        }
    }
}
- (void)setBottomType:(LVNewHeartbeatBottomType)bottomType
{
    if (bottomType == _bottomType) {
        return;
    }
    switch (bottomType) {
        case LVNewHeartbeatBottomNormal:
        {
            CGFloat duration = 0.3;
            if (_bottomType == LVNewHeartbeatBottomGhostMian) {
                duration = 0.8;
            }
            [UIView animateWithDuration:duration animations:^{
                self.ignoreBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - MiddleItemWidth)/2 - SizeItemWidth - MarginWidth, (CGRectGetHeight(self.frame) - SizeItemWidth)/2, SizeItemWidth, SizeItemWidth);
                
                self.helloBtn.hidden = NO;
                
                self.helloBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - MiddleItemWidth)/2, (CGRectGetHeight(self.frame) - MiddleItemWidth)/2, MiddleItemWidth, MiddleItemWidth);
                
                self.likeBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - MiddleItemWidth)/2 + MiddleItemWidth + MarginWidth, (CGRectGetHeight(self.frame) - SizeItemWidth)/2, SizeItemWidth, SizeItemWidth);
            }];
        }
            break;
        case LVNewHeartbeatBottomGreet:
        {
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat middleItem = -kRatioWidth(20);
                self.ignoreBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - middleItem)/2 - SizeItemWidth - MarginWidth, (CGRectGetHeight(self.frame) - SizeItemWidth)/2, SizeItemWidth, SizeItemWidth);
                
                self.helloBtn.hidden = YES;
                
                self.likeBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - middleItem)/2 + middleItem + MarginWidth, (CGRectGetHeight(self.frame) - SizeItemWidth)/2, SizeItemWidth, SizeItemWidth);
            }];
        }
            break;
        case LVNewHeartbeatBottomGhostMian:
        {
            [UIView animateWithDuration:0.8 animations:^{
                self.ignoreBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - SizeItemWidth)/2 - SizeItemWidth - MarginWidth, (CGRectGetHeight(self.frame) - SizeItemWidth)/2, SizeItemWidth, SizeItemWidth);
                
                self.helloBtn.hidden = NO;
                
                self.helloBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - SizeItemWidth)/2, (CGRectGetHeight(self.frame) - SizeItemWidth)/2, SizeItemWidth, SizeItemWidth);
                
                self.likeBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - SizeItemWidth)/2 + SizeItemWidth + MarginWidth, (CGRectGetHeight(self.frame) - SizeItemWidth)/2, SizeItemWidth, SizeItemWidth);
            }];
        }
            break;
        default:
            break;
    }
    _bottomType = bottomType;
}
- (void)setPromptString:(NSString *)promptString
{
    _promptString = promptString;
    self.promptLabel.text = promptString;
}
- (void)slideBtn:(LVNewHeartbeatBottomBtnType)btnType ratio:(CGFloat)ratio
{
    if(btnType == LVNewHeartbeatBottomIgnoreBtn){
        self.ignoreBtn.width = SizeItemWidth+ratio;
        self.ignoreBtn.height = SizeItemWidth+ratio;
    }else if (btnType == LVNewHeartbeatBottomLikeBtn){
        self.likeBtn.width = SizeItemWidth+ratio;
        self.likeBtn.height = SizeItemWidth+ratio;
    }else if (btnType == LVNewHeartbeatBottomGreet){
        self.helloBtn.width = SizeItemWidth+ratio;
        self.helloBtn.height = SizeItemWidth+ratio;
    }
}
@end
