//
//  HYWaterflowCell.m
//  LeveSummarize
//
//  Created by leve on 2018/6/27.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYWaterflowCell.h"

@implementation HYWaterflowCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}
@end
