//
//  LVNewHeartbeatNavView.m
//  LEVE
//
//  Created by leve on 2018/5/24.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import "LVNewHeartbeatNavView.h"

#define ItemWidth 40
@interface LVNewHeartbeatNavView ()
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *screenBtn;//筛选按钮
@property (strong, nonatomic) UIButton *recordBtn;//记录按钮
@end

@implementation LVNewHeartbeatNavView
- (void)dealloc
{
    NSLog(@"dealloc ------------- %@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(frame) - ItemWidth)/2, ItemWidth, ItemWidth)];
        self.backBtn.exclusiveTouch = YES;
        [self.backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];
        
        self.screenBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 25 - 2*ItemWidth, (CGRectGetHeight(frame) - ItemWidth)/2, ItemWidth, ItemWidth)];
        self.screenBtn.exclusiveTouch = YES;
        [self.screenBtn setImage:[UIImage imageNamed:@"ic_xd_filtrate"] forState:UIControlStateNormal];
        [self.screenBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.screenBtn];
        
        self.recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 15 - ItemWidth, (CGRectGetHeight(frame) - ItemWidth)/2, ItemWidth, ItemWidth)];
        self.recordBtn.exclusiveTouch = YES;
        [self.recordBtn setImage:[UIImage imageNamed:@"ic_history"] forState:UIControlStateNormal];
        [self.recordBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.recordBtn];
    }
    return self;
}
- (void)clickAction:(UIButton *)btn
{
    if (self.clickBtnBlock) {
        if (btn == self.backBtn) {
            self.clickBtnBlock(LVNewHeartbeatNavBackBtn,self.backBtn);
        }else if (btn == self.recordBtn){
            self.clickBtnBlock(LVNewHeartbeatNavRecordBtn, self.recordBtn);
        }else if (btn == self.screenBtn){
            self.clickBtnBlock(LVNewHeartbeatNavScreenBtn, self.screenBtn);
        }
    }
}
- (void)hidden:(BOOL)isHidden heartbeatNavBtn:(LVNewHeartbeatNavBtnType)btnType
{
    switch (btnType) {
        case LVNewHeartbeatNavBackBtn:
            self.backBtn.hidden = isHidden;
            break;
        case LVNewHeartbeatNavScreenBtn:
            self.screenBtn.hidden = isHidden;
            break;
        case LVNewHeartbeatNavRecordBtn:
            self.recordBtn.hidden = isHidden;
            break;
        default:
            break;
    }
}
@end
