//
//  LVNewHeartbeatUserMsgView.m
//  LEVE
//
//  Created by leve on 2018/5/25.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import "LVNewHeartbeatUserMsgView.h"

@interface LVNewHeartbeatUserMsgView ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *greetPromptLabel;
@property (strong, nonatomic) UIView *otherMsgView;
@property (strong, nonatomic) UILabel *sexLabel;
@property (strong, nonatomic) UIImageView *sexImg;
@property (strong, nonatomic) UILabel *ageLabel;
@property (strong, nonatomic) UILabel *constellationLabel;//星座
@property (strong, nonatomic) UILabel *yLabel;//那个黄色的

@end
@implementation LVNewHeartbeatUserMsgView
- (void)dealloc
{
    NSLog(@"dealloc ------------- %@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 40)];
        nameLabel.text = @"超级大帅哥 ~~~";
        nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:28];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *greetPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, CGRectGetWidth(frame), 20)];
        greetPromptLabel.text = @"打个招呼邀请TA激活吧";
        greetPromptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        greetPromptLabel.textColor = [UIColor whiteColor];
        greetPromptLabel.textAlignment = NSTextAlignmentCenter;
        greetPromptLabel.hidden = YES;
        [self addSubview:greetPromptLabel];
        self.greetPromptLabel = greetPromptLabel;
        
        UIView *otherMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, nameLabel.bottom+10, CGRectGetWidth(frame), 20)];
        [self addSubview:otherMsgView];
        self.otherMsgView = otherMsgView;
        
//        UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexLabel.left - 70, 0, 70, 20)];
//        yLabel.layer.cornerRadius = 10;
//        yLabel.layer.masksToBounds = YES;
//        yLabel.text = @"LVC:100.3";
//        yLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//        yLabel.textColor = [UIColor whiteColor];
//        yLabel.backgroundColor = KOrangeColor;
//        yLabel.textAlignment = NSTextAlignmentCenter;
//        [self.otherMsgView addSubview:yLabel];
//        self.yLabel = self.yLabel;
        
        //在最中间
        UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - 44)/2, 0, 44, 20)];
        ageLabel.text = @"25";
        ageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        ageLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        ageLabel.textAlignment = NSTextAlignmentCenter;
        [self.otherMsgView addSubview:ageLabel];
        self.ageLabel = ageLabel;
        
        UIImageView *ageImg = [[UIImageView alloc] initWithFrame:CGRectMake(ageLabel.left-13, 3.5, 13, 13)];
        ageImg.image = [UIImage imageNamed:@"xd_nianling"];
        [self.otherMsgView addSubview:ageImg];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(ageImg.left-15, 5, 1, 10)];
        line1.backgroundColor = kRGBColor(227, 227, 227);
        [self.otherMsgView addSubview:line1];
        
        UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(line1.left - 44, 0, 44, 20)];
        sexLabel.text = @"男";
        sexLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        sexLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        sexLabel.textAlignment = NSTextAlignmentCenter;
        [self.otherMsgView addSubview:sexLabel];
        self.sexLabel = sexLabel;
        
        UIImageView *sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(sexLabel.left-13, 3.5, 13, 13)];
        sexImg.image = [UIImage imageNamed:@"xd_xingbei_nan"];
        [self.otherMsgView addSubview:sexImg];
        self.sexImg = sexImg;
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(ageLabel.right, 5, 1, 10)];
        line2.backgroundColor = kRGBColor(227, 227, 227);
        [self.otherMsgView addSubview:line2];
        
        UIImageView *constellationImg = [[UIImageView alloc] initWithFrame:CGRectMake(line2.right+15, 3.5, 13, 13)];
        constellationImg.image = [UIImage imageNamed:@"xd_xignzuo"];
        [self.otherMsgView addSubview:constellationImg];
        
        UILabel *constellationLabel = [[UILabel alloc] initWithFrame:CGRectMake(constellationImg.right, 0, 68, 20)];
        constellationLabel.text = @"水瓶座";
        constellationLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        constellationLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        constellationLabel.textAlignment = NSTextAlignmentCenter;
        [self.otherMsgView addSubview:constellationLabel];
        self.constellationLabel = constellationLabel;
    }
    return self;
}
@end
