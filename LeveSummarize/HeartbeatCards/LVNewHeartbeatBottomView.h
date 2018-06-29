//
//  LVNewHeartbeatBottomView.h
//  LEVE
//
//  Created by leve on 2018/5/24.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,LVNewHeartbeatBottomBtnType) {
    LVNewHeartbeatBottomIgnoreBtn,
    LVNewHeartbeatBottomHelloBtn,
    LVNewHeartbeatBottomLikeBtn,
};
typedef NS_ENUM(NSUInteger,LVNewHeartbeatBottomType) {
    LVNewHeartbeatBottomNormal,
    LVNewHeartbeatBottomGreet,//别人向我打招呼
    LVNewHeartbeatBottomGhostMian,//小鬼主页
};
@interface LVNewHeartbeatBottomView : UIView
@property (assign, nonatomic) LVNewHeartbeatBottomType bottomType;
@property(nonatomic, strong) CAGradientLayer *backLayer;//背景半透明遮罩

@property (copy, nonatomic) void (^clickBtnBlock)(LVNewHeartbeatBottomBtnType type,UIButton *btn);
@property (strong, nonatomic) NSString *promptString;

/** 卡片滑动时底部按钮动画*/
- (void)slideBtn:(LVNewHeartbeatBottomBtnType)btnType ratio:(CGFloat)ratio;
@end
