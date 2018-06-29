//
//  LVNewHeartbeatMainView.h
//  LEVE
//
//  Created by leve on 2018/5/24.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LVNewGhostInfoModel;

typedef NS_ENUM(NSUInteger,LVNewHeartbeatMainEnterType) {
    LVNewHeartbeatMainEnterNormal,
    LVNewHeartbeatMainEnterScan,//通过扫脸进入
};
@interface LVNewHeartbeatMainView : UIView
@property (copy, nonatomic) void (^closeNewHeartbeatBlock)(LVNewHeartbeatMainView *mainView);
/**cards 有值说明是一进来就有招呼或者匹配成功卡片或者扫脸进来的卡片 scan是否*/
- (instancetype)initWithFrame:(CGRect)frame enterWithCards:(NSArray <LVNewGhostInfoModel *>*)cards enterType:(LVNewHeartbeatMainEnterType)enterType;
@end
