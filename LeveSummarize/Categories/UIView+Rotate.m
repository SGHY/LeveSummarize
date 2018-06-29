//
//  UIView+Rotate.m
//  卡片切换
//
//  Created by 上官惠阳 on 2017/2/25.
//  Copyright © 2017年 上官惠阳. All rights reserved.
//  旋转

#import "UIView+Rotate.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Rotate)
//aDuration控制旋转的速度,转一圈需要aDuration这么久
- (void)rotateWithDuration:(CGFloat)aDuration repeatCount:(CGFloat)aRepeatCount{

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = aDuration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = aRepeatCount;

    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)stopRotate{
    [self.layer removeAllAnimations];
}
@end
