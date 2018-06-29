//
//  LVNewHeartbeatCardView.m
//  LEVE
//
//  Created by leve on 2018/5/25.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import "LVNewHeartbeatCardView.h"
#import "UIView+Rotate.h"

#define LoadRunWidth 50
#define DirectionWidth kRatioWidth(58)

@interface LVNewHeartbeatCardView ()
@property (strong, nonatomic) UIImageView *loadView;
@property (strong, nonatomic) UIView *loadRunView;
@property (strong, nonatomic) UIImageView *cardTypeView;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UIImageView *directionView;
@property (strong, nonatomic) UIPageControl *pageView;
@property (strong, nonatomic) NSTimer *timer;
/** 需要轮番显示的图片数组**/
@property (strong, nonatomic) NSArray *imageSource;
@end
@implementation LVNewHeartbeatCardView
- (void)dealloc
{
    NSLog(@"dealloc ---------- %@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *loadView = [[UIImageView alloc] initWithFrame:self.bounds];
        loadView.image = [UIImage imageNamed:@"xd_registered_upload"];
        [self addSubview:loadView];
        self.loadView = loadView;
        
        UIImageView *cardTypeView = [[UIImageView alloc] initWithFrame:CGRectMake(kRatioWidth(8), kRatioWidth(8), self.bounds.size.width - 2*kRatioWidth(8), self.bounds.size.height - 2*kRatioWidth(8))];
        cardTypeView.image = [UIImage imageNamed:@"xd_registered"];
        [self addSubview:cardTypeView];
        self.cardTypeView = cardTypeView;
        
        UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*kRatioWidth(8), 2*kRatioWidth(8), self.bounds.size.width - 4*kRatioWidth(8), self.bounds.size.width - 4*kRatioWidth(8))];
        contentImageView.layer.masksToBounds = YES;
        contentImageView.layer.cornerRadius = CGRectGetWidth(contentImageView.frame)/2;
        contentImageView.backgroundColor = [UIColor colorWithRed:arc4random() % 256/255.0 green:arc4random() % 256/255.0 blue:arc4random() % 256/255.0 alpha:1];
        [self addSubview:contentImageView];
        self.contentImageView = contentImageView;
        
        UIView *loadRunview = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:loadRunview];
        UIImageView *runView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - LoadRunWidth)/2, -10, LoadRunWidth, LoadRunWidth)];
        runView.image = [UIImage imageNamed:@"ic_xd_sun"];
        [loadRunview addSubview:runView];
        self.loadRunView = loadRunview;
        
        UIImageView *directionView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - DirectionWidth)/2, (self.bounds.size.height - DirectionWidth)/2, DirectionWidth, DirectionWidth)];
        directionView.image = [UIImage imageNamed:@"ic_xd_like_hd"];
        directionView.alpha = 0;
        [self addSubview:directionView];
        self.directionView = directionView;
        
        UIPageControl *pageView = [[UIPageControl alloc] init];
        pageView.hidesForSinglePage = YES;
        CGSize size = [pageView sizeForNumberOfPages:6];
        pageView.frame = CGRectMake((CGRectGetWidth(self.frame)-size.width)/2, CGRectGetHeight(self.frame) - 40 - size.height,size.width , size.height);
        pageView.numberOfPages = 6;
        pageView.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        pageView.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:pageView];
        self.pageView = pageView;
    }
    return self;
}
- (void)setImageSource:(NSArray *)imageSource
{
    _imageSource = imageSource;
    CGSize size = [self.pageView sizeForNumberOfPages:imageSource.count];
    self.pageView.frame = CGRectMake((CGRectGetWidth(self.frame)-size.width)/2, CGRectGetHeight(self.frame) - 40 - size.height,size.width , size.height);
    self.pageView.numberOfPages = imageSource.count;
    self.pageView.currentPage = 0;
}
- (void)playImage
{
    UIColor *color = [UIColor colorWithRed:arc4random() % 256/255.0 green:arc4random() % 256/255.0 blue:arc4random() % 256/255.0 alpha:1];
    self.contentImageView.backgroundColor = color;
    if (self.pageView.currentPage < self.imageSource.count-1) {
        self.pageView.currentPage = self.pageView.currentPage + 1;
    }else{
        self.pageView.currentPage = 0;
    }
    if(self.imageSource.count <= self.pageView.currentPage){
        return;
    }
}
- (void)setCardType:(LVNewHeartbeatCardType)cardType
{
    _cardType = cardType;
    if (cardType == LVNewHeartbeatCardUnregistered) {
        self.loadView.image = [UIImage imageNamed:@"xd_unregistered"];
        [self stopPlayImage];
        self.loadRunView.hidden = YES;
        self.cardTypeView.hidden = YES;
        self.pageView.hidden = YES;
    }else{
        self.loadView.image = [UIImage imageNamed:@"xd_registered_upload"];
        [self startPlayImage];
        self.loadRunView.hidden = NO;
        self.cardTypeView.hidden = NO;
        if (self.imageSource.count == 1) {
            self.pageView.hidden = YES;
        }else{
            self.pageView.hidden = NO;
        }
    }
}
- (void)showDirectionView:(LVNewCardDirection)cardDirection alpha:(CGFloat)alpha
{
    if (cardDirection == LVNewCardDirectionLeft) {
        self.directionView.image = [UIImage imageNamed:@"ic_xd_dislike_hd"];
    }else if(cardDirection == LVNewCardDirectionRight){
        self.directionView.image = [UIImage imageNamed:@"ic_xd_like_hd"];
    }else if(cardDirection == LVNewCardDirectionUp){
        self.directionView.image = [UIImage imageNamed:@"ic_zhcg"];
    }
    self.directionView.alpha = alpha;
}
- (void)hideDirectionView
{
    self.directionView.alpha = 0;
}
- (void)startPlayImage
{
    [self.loadView rotateWithDuration:2 repeatCount:MAXFLOAT];
    [self.loadRunView rotateWithDuration:2 repeatCount:MAXFLOAT];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(playImage) userInfo:nil repeats:YES];
}
- (void)stopPlayImage
{
    [self.loadView stopRotate];
    [self.loadRunView stopRotate];
    [self.timer invalidate];
    self.timer = nil;
}
@end
