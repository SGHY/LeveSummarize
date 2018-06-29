//
//  HYTagModel.h
//  LeveSummarize
//
//  Created by leve on 2018/6/28.
//  Copyright © 2018年 leve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYTagView.h"

@interface HYTagModel : NSObject
//显示在标签上的文字
@property (nonatomic, copy) NSString *text;
//距离
@property (nonatomic, assign) CGFloat distance;
//方位角
@property (nonatomic, assign) CGFloat azimuth;
//宽度
@property (nonatomic, assign) CGFloat width;

//真北角
@property (nonatomic, assign) CGFloat lastDirection;
//标签
@property (nonatomic, strong) HYTagView *tagView;
//雷达上面的点点
@property (nonatomic, strong) UIView *azimuthView;

- (instancetype)initWithText:(NSString *)text distance:(CGFloat)distance azimuth:(CGFloat)azimuth;
@end
