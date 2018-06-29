//
//  HYBubbleView.h
//  LeveSummarize
//
//  Created by leve on 2018/6/25.
//  Copyright © 2018年 leve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYBubbleView : UIView
@property (nonatomic,assign) NSInteger index;           //标记编号
@property (nonatomic,assign) NSInteger circleNumber;    //处在第几圈
@property(nonatomic, assign) CGFloat distanceToCenter;    //与屏幕中心点的距离
@end
