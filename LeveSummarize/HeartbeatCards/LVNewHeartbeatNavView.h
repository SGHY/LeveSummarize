//
//  LVNewHeartbeatNavView.h
//  LEVE
//
//  Created by leve on 2018/5/24.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,LVNewHeartbeatNavBtnType) {
    LVNewHeartbeatNavBackBtn,
    LVNewHeartbeatNavScreenBtn,
    LVNewHeartbeatNavRecordBtn,
};
@interface LVNewHeartbeatNavView : UIView
@property (copy, nonatomic) void (^clickBtnBlock)(LVNewHeartbeatNavBtnType type,UIButton *btn);
- (void)hidden:(BOOL)isHidden heartbeatNavBtn:(LVNewHeartbeatNavBtnType)btnType;
@end
