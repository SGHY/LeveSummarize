//
//  HYTagModel.m
//  LeveSummarize
//
//  Created by leve on 2018/6/28.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYTagModel.h"
#import "NSString+Size.h"

@implementation HYTagModel
- (instancetype)initWithText:(NSString *)text distance:(CGFloat)distance azimuth:(CGFloat)azimuth {
    self = [self init];
    if (self) {
        self.text = text;
        self.distance = distance;
        self.azimuth = azimuth;
        [self createTagView];
    }
    return self;
}
- (void)createTagView {
    self.width = [self.text widthWithFont:[UIFont systemFontOfSize:16] constrainedToHeight:22] + 20;
    if (self.width > 300) {
        self.width = 300;
    }
    HYTagView *tagView = [[HYTagView alloc] initWithFrame:CGRectMake(0, -100, self.width, 40)];
    tagView.label.text = self.text;
    tagView.hidden = YES;
    self.tagView = tagView;
    
    UIView *azimuthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    azimuthView.layer.cornerRadius = 2;
    azimuthView.backgroundColor = [UIColor redColor];
    self.azimuthView = azimuthView;
}
@end
