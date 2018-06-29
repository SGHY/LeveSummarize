//
//  HYRadarView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/28.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYRadarView.h"
@implementation HYRadarView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //画那个圆盘
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:frame.size.width/2.0];
        
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillColor = [UIColor blackColor].CGColor;
        fillLayer.opacity = 0.6;
        [self.layer addSublayer:fillLayer];
        
        //画那三个白色的圈
        NSInteger radius = self.frame.size.width/6.0;
        NSInteger increment = self.frame.size.width/6.0;
        for (int i = 0; i < 3; i++) {
            
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                                      radius:radius
                                                                  startAngle:degreesToRadians(0)
                                                                    endAngle:degreesToRadians(360)
                                                                   clockwise:YES];
            
            CAShapeLayer *shapLayer = [CAShapeLayer layer];
            shapLayer.lineWidth = 0.5;
            shapLayer.strokeColor = [UIColor whiteColor].CGColor;
            shapLayer.fillColor = [UIColor clearColor].CGColor;
            shapLayer.path = bezierPath.CGPath;
            [self.layer addSublayer:shapLayer];
            
            radius += increment;
        }
        
        //画那根绿线
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        CGPoint point0 = CGPointMake(self.frame.size.width/2.0, 0);
        CGPoint point1 = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        [bezierPath moveToPoint:point0];
        [bezierPath addLineToPoint:point1];
        [bezierPath closePath];
        
        CAShapeLayer *shapLayer = [CAShapeLayer layer];
        shapLayer.lineWidth = 1;
        shapLayer.strokeColor = [UIColor greenColor].CGColor;
        shapLayer.fillColor = [UIColor clearColor].CGColor;
        shapLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapLayer];
    }
    return self;
}
@end
