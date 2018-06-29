//
//  HYImageZoomView.h
//  LeveSummarize
//
//  Created by leve on 2018/6/27.
//  Copyright © 2018年 leve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYImageZoomView : UIView
@property (strong, nonatomic) UIImageView *imageView;

- (void)showAtView:(UIView *)view;
@end
