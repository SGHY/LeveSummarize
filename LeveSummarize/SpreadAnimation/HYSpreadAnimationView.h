//
//  HYSpreadAnimationView.h
//  LeveSummarize
//
//  Created by leve on 2018/6/23.
//  Copyright © 2018年 leve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYSpreadAnimationView : UIView
/**
 从某个视图上展开显示
 @param view 父视图
 @param fromRect 开始位置大小
 */
- (void)showAtView:(UIView *)view fromRect:(CGRect)fromRect;
@end
