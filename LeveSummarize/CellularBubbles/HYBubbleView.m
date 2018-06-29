//
//  HYBubbleView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/25.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYBubbleView.h"

@implementation HYBubbleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.layer.cornerRadius = self.width/2;
    }
    return self;
}
@end
