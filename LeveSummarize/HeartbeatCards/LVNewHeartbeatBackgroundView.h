//
//  LVNewHeartbeatBackgroundView.h
//  LEVE
//
//  Created by leve on 2018/5/28.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LVNewHeartbeatBackgroundType) {
    LVNewHeartbeatBackgroundNormal,
    LVNewHeartbeatBackgroundGreet,
    LVNewHeartbeatBackgroundGreetSuccess,
    LVNewHeartbeatBackgroundMatchSuccess,
};
@interface LVNewHeartbeatBackgroundView : UIView
@property (assign, nonatomic) LVNewHeartbeatBackgroundType bgType;
@property (strong, nonatomic) UIImageView *bgImgView;
@end
