//
//  HYTagView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/28.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYTagView.h"

@implementation HYTagView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 4;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

@end
