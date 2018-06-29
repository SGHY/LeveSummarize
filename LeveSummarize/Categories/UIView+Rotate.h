//
//  UIView+Rotate.h
//  卡片切换
//
//  Created by 上官惠阳 on 2017/2/25.
//  Copyright © 2017年 上官惠阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (Rotate)
- (void)rotateWithDuration:(CGFloat)aDuration repeatCount:(CGFloat)aRepeatCount;
- (void)stopRotate;
@end
