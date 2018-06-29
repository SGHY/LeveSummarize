//
//  LVNewHeartbeatCardView.h
//  LEVE
//
//  Created by leve on 2018/5/25.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LVNewHeartbeatCardType) {
    LVNewHeartbeatCardRegistered,
    LVNewHeartbeatCardUnregistered,
};
typedef NS_ENUM(NSUInteger, LVNewCardDirection) {
    LVNewCardDirectionDefault     = 0,
    LVNewCardDirectionLeft        = 1,
    LVNewCardDirectionRight       = 2,
    LVNewCardDirectionUp          = 3,
};
@interface LVNewHeartbeatCardView : UIView
@property (assign, nonatomic) LVNewHeartbeatCardType cardType;
@property (assign, nonatomic) CGAffineTransform originalTransform;
- (void)showDirectionView:(LVNewCardDirection)cardDirection alpha:(CGFloat)alpha;
- (void)hideDirectionView;

- (void)startPlayImage;
- (void)stopPlayImage;
@end
