//
//  HYSpreadAnimationView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/23.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYSpreadAnimationView.h"

@interface HYSpreadAnimationView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGRect fromRect;
@property (assign, nonatomic) CGPoint transPoint;
@end
@implementation HYSpreadAnimationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnTap)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"pic1"];
    }
    return _imageView;
}
- (void)showAtView:(UIView *)view fromRect:(CGRect)fromRect
{
    [view addSubview:self];
    self.fromRect = fromRect;
    
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithOvalInRect:fromRect];
    
    CGFloat radius = sqrtf(pow(self.frame.size.width, 2)+pow(self.frame.size.height, 2))/2;
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    self.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)startCycle.CGPath;
    maskLayerAnimation.toValue = (__bridge id _Nullable)endCycle.CGPath;
    maskLayerAnimation.duration = 0.3;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.layer.mask = nil;
    });
}
- (void)returnTap
{
    CGFloat radius = sqrtf(pow(self.frame.size.width, 2)+pow(self.frame.size.height, 2))/2;
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithOvalInRect:self.fromRect];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    self.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)startCycle.CGPath;
    maskLayerAnimation.toValue = (__bridge id _Nullable)endCycle.CGPath;
    maskLayerAnimation.duration = 0.3;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.layer.mask = nil;
        [self removeFromSuperview];
    });
}
- (void)panGes:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    NSLog(@"point = %@",NSStringFromCGPoint(point));
    /**
     *手指下滑开始切圈，开始圆的半径为屏幕尺寸的一半
     *切圈半径减小先快后慢，先是半径减小下滑距离的6倍，后2倍
     *当减到半径为80的时候不再减小
     *当半径小于屏蔽宽度的一半时，该视图可以随手指拖动，视图一旦拖动即使半径小于屏幕宽度的一半仍然可以拖动
     *当半径大于屏幕宽度的一半时拖动缓慢，感觉有点边缘吸附的效果
     *当改视图的中心点超出屏幕那么停止拖动
     *手指上滑到一开始手指的位置之上，开始还原到半径为屏幕尺寸的一半
     *手指松开，当圆半径小于屏幕宽度的一半时缩回刚进该视图的位置，否者还原
     */
    CGFloat radius = sqrtf(pow(self.width, 2)+pow(self.height, 2))/2;
    CGFloat multiple = 2;
    if (point.y < 15) {
        multiple = 6;
    }
    CGFloat r = radius - point.y*multiple;
    if (r < 80) {
        r = 80;
    }
    if (point.y >= 0) {
        if (r < self.width/2 || !CGPointEqualToPoint(self.imageView.center, self.center)) {
            CGPoint po = CGPointMake(point.x - self.transPoint.x, point.y - self.transPoint.y);
            if(r > self.width/2){
                self.imageView.center = CGPointMake(self.imageView.center.x+po.x/3, self.imageView.center.y+po.y/3);
            }else{
                self.imageView.center = CGPointMake(self.imageView.center.x+po.x, self.imageView.center.y+po.y);
            }
            
            if (self.imageView.center.x > self.width) {
                self.imageView.center = CGPointMake(self.width, self.imageView.center.y);
            }else if (self.imageView.center.x < 0){
                self.imageView.center = CGPointMake(0, self.imageView.center.y);
            }
            if (self.imageView.center.y > self.height) {
                self.imageView.center = CGPointMake(self.imageView.center.x, self.height);
            }
        }
        self.transPoint = point;
        
        if (pan.state == UIGestureRecognizerStateEnded) {
            if (r < self.width/2) {
                //消失缩小动画
                [self.layer.mask removeFromSuperlayer];
                self.bounds = CGRectMake(0.f, 0.f, 2*r, 2*r);
                self.center = self.imageView.center;
                self.imageView.frame = self.bounds;
                self.layer.cornerRadius = r;
                self.layer.masksToBounds = YES;
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.alpha = 0.25;
                    self.frame = self.fromRect;
                    self.layer.cornerRadius = self.fromRect.size.width/2;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }else{
                //还原
                self.transPoint = CGPointMake(0.f, 0.f);
                self.imageView.frame = self.bounds;
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
                maskLayer.path = path.CGPath;
                self.layer.mask = maskLayer;
            }
        }else{
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.imageView.center radius:r startAngle:0 endAngle:M_PI*2 clockwise:YES];
            maskLayer.path = path.CGPath;
            self.layer.mask = maskLayer;
        }
    }else{
        //还原
        self.transPoint = CGPointMake(0.f, 0.f);
        self.imageView.frame = self.bounds;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}
#pragma mark 计算两点距离
- (CGFloat)distanceFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGFloat x = fabs(fromPoint.x - toPoint.x);
    CGFloat y = fabs(fromPoint.y - toPoint.y);
    return sqrtf(pow(x, 2) + pow(y, 2));
}
@end
