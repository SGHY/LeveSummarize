//
//  UIView+Frame.h
//  HYNeiHan
//
//  Created by 上官惠阳 on 16/9/25.
//  Copyright © 2016年 上官惠阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
/**
 *  起点x坐标
 */
@property (nonatomic, assign) CGFloat x;
/**
 *  起点y坐标
 */
@property (nonatomic, assign) CGFloat y;
/**
 *  中心点x坐标
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 *  中心点y坐标
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 *  宽度
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  高度
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  顶部
 */
@property (nonatomic, assign) CGFloat top;
/**
 *  底部
 */
@property (nonatomic, assign) CGFloat bottom;
/**
 *  左边
 */
@property (nonatomic, assign) CGFloat left;
/**
 *  右边
 */
@property (nonatomic, assign) CGFloat right;
/**
 *  size
 */
@property (nonatomic, assign) CGSize size;
/**
 *  起点坐标
 */
@property (nonatomic, assign) CGPoint origin;
/**
 *  适配iphoneX 头部
 */
@property (nonatomic, assign) CGFloat originIPhoneX;
/**
 *  适配iphoneX 底部
 */
@property (nonatomic, assign) CGFloat originIPhoneXBottom;
@end
