//
//  LVNewHeartbeatMainView.m
//  LEVE
//
//  Created by leve on 2018/5/24.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import "LVNewHeartbeatMainView.h"
#import "LVNewHeartbeatNavView.h"
#import "LVNewHeartbeatBottomView.h"
#import "LVNewHeartbeatUserMsgView.h"
#import "LVNewHeartbeatCardView.h"
#import "LVNewHeartbeatCardContainer.h"
#import "LVNewHeartbeatBackgroundView.h"

#define TopNavHeight 44
#define BottomHeight kRatioHeight(132)

#define ScreenWidth kRatioWidth(184)
#define ScreenHeight kRatioWidth(50)

#define CardWidth kRatioWidth(316)

@interface LVNewHeartbeatMainView ()<LVNewHeartbeatCardContainerDelegate,LVNewHeartbeatCardContainerDatasource>
@property(nonatomic, strong) UIView *greetBackView;//点击招呼后一闪而过的动画效果
@property(nonatomic, strong) UIView *maskRoundView;//用于动画蒙层
@property (strong, nonatomic) LVNewHeartbeatNavView *nav;
@property (strong, nonatomic) LVNewHeartbeatBottomView *bottomView;
@property (strong, nonatomic) LVNewHeartbeatUserMsgView *userMsgView;
@property (strong, nonatomic) LVNewHeartbeatCardContainer *cardContainer;
@property (strong, nonatomic) LVNewHeartbeatBackgroundView *bgView;
@property (strong, nonatomic) NSMutableArray *cardSource;
@property (strong, nonatomic) NSMutableArray *inserCache;
@property (assign, nonatomic) LVNewHeartbeatMainEnterType enterType;
@end
@implementation LVNewHeartbeatMainView
- (void)dealloc
{
    NSLog(@"dealloc ------------- %@",NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame enterWithCards:(NSArray <LVNewGhostInfoModel *>*)cards enterType:(LVNewHeartbeatMainEnterType)enterType
{
    self = [super initWithFrame:frame];
    if (self) {
        //控制背景
        LVNewHeartbeatBackgroundView *bgView = [[LVNewHeartbeatBackgroundView alloc] initWithFrame:self.bounds];
        bgView.bgType = LVNewHeartbeatBackgroundNormal;
        [self addSubview:bgView];
        self.bgView = bgView;
        
        WeakSelf(weakSelf);
        //自定义导航栏
        LVNewHeartbeatNavView *nav = [[LVNewHeartbeatNavView alloc] initWithFrame:CGRectMake(0,[NSString isIPhoneX]?44:20, kScreenWidth, TopNavHeight)];
        nav.clickBtnBlock = ^(LVNewHeartbeatNavBtnType type, UIButton *btn) {
            if (type == LVNewHeartbeatNavBackBtn) {
                [weakSelf removeFromSuperview];
                if (weakSelf.closeNewHeartbeatBlock) {
                    weakSelf.closeNewHeartbeatBlock(weakSelf);
                    return ;
                }
            }
            if (type == LVNewHeartbeatNavScreenBtn) {
                
            }
            if (type == LVNewHeartbeatNavRecordBtn) {
                
            }
        };
        [self addSubview:nav];
        self.nav = nav;
        
        //当前卡片用户信息
        LVNewHeartbeatUserMsgView *userMsgView = [[LVNewHeartbeatUserMsgView alloc] initWithFrame:CGRectMake(0, [NSString isIPhoneX]?kRatioHeight(85)+20:kRatioHeight(85), kScreenWidth, 60)];
        [self addSubview:userMsgView];
        self.userMsgView = userMsgView;
        
        //底部按钮
        LVNewHeartbeatBottomView *bottomView = [[LVNewHeartbeatBottomView alloc] initWithFrame:CGRectMake(0,kScreenHeight - BottomHeight , kScreenWidth, BottomHeight)];
        bottomView.clickBtnBlock = ^(LVNewHeartbeatBottomBtnType type, UIButton *btn) {
            [weakSelf clickBottomView:type];
        };
        bottomView.bottomType = LVNewHeartbeatBottomNormal;
        [self addSubview:bottomView];
        self.bottomView = bottomView;
        
        [self addSubview:self.greetBackView];
        //心动卡片
        LVNewHeartbeatCardContainer *cardContainer = [[LVNewHeartbeatCardContainer alloc] initWithFrame:CGRectMake((kScreenWidth - CardWidth)/2, (kScreenHeight - CardWidth)/2, CardWidth, CardWidth)];
        [self addSubview:cardContainer];
        cardContainer.delegate = self;
        cardContainer.dataSource = self;
        self.cardContainer = cardContainer;
        
        self.cardSource = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
        [self.cardContainer reloadDataWithAnimate:YES];
    }
    return self;
}
#pragma mark - 点击打招呼，圆圈放大动画
-(void)greetAnimation
{
    self.greetBackView.alpha = 1.0;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskRoundView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.greetBackView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.maskRoundView.transform = CGAffineTransformMakeScale(0, 0);
        }];
    }];
}
- (void)showGreetAnimation
{
    UIView *greetAnimationView = [[UIView alloc] initWithFrame:self.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"bg_greet"];
    [greetAnimationView addSubview:imageView];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.backgroundColor = [UIColor blackColor];
    effectView.alpha = 0.4;
    effectView.frame = self.bounds;
    [greetAnimationView addSubview:effectView];
    [self.bgView addSubview:greetAnimationView];

    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(CGRectGetMidX(self.bottomView.frame)-25, CGRectGetMidY(self.bottomView.frame)-25, 50, 50)];
    CGFloat radius = sqrtf(pow(self.width, 2)+pow(self.height, 2));
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    greetAnimationView.layer.mask = maskLayer;

    CABasicAnimation *maskAni = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAni.duration = 0.5;
    maskAni.fromValue = (__bridge id _Nullable)startPath.CGPath;
    maskAni.toValue = (__bridge id _Nullable)endPath.CGPath;
    maskAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:maskAni forKey:@"path"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [greetAnimationView removeFromSuperview];
        [effectView removeFromSuperview];
    });
}
#pragma mark -- 点击底部按钮
- (void)clickBottomView:(LVNewHeartbeatBottomBtnType)type
{
    //点击无感
    if (type == LVNewHeartbeatBottomIgnoreBtn) {
        [self.cardContainer removeFormDirection:LVNewHeartbeatCardDirectionLeft animate:YES];
    }
    
    //点击招呼
    if (type == LVNewHeartbeatBottomHelloBtn) {
        [self.cardContainer removeFormDirection:LVNewHeartbeatCardDirectionUp animate:YES];
//        [self greetAnimation];
        [self showGreetAnimation];
    }
    
    //点击喜欢
    if (type == LVNewHeartbeatBottomLikeBtn) {
        [self.cardContainer removeFormDirection:LVNewHeartbeatCardDirectionRight animate:YES];
    }
}
#pragma mark --LVNewHeartbeatCardContainerDatasource
- (NSInteger)numberOfIndexs
{
    return self.cardSource.count;
}
- (LVNewHeartbeatCardView *)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer viewForIndex:(NSInteger)index
{
    LVNewHeartbeatCardView *cardView = [[LVNewHeartbeatCardView alloc] initWithFrame:cardContainer.bounds];
    return cardView;
}
#pragma mark --LVNewHeartbeatCardContainerDelegate
/**
 *  滑动卡片时调用
 *  @param draggableDirection 滑动的方向
 *  @param widthRatio 滑动的水平偏移量
 *  @param heightRatio 滑动的竖直偏移量
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        draggableDirection:(LVNewHeartbeatCardDirection)draggableDirection
        widthRatio:(CGFloat)widthRatio
        heightRatio:(CGFloat)heightRatio
{
    if (draggableDirection == LVNewHeartbeatCardDirectionLeft) {
        [self.bottomView slideBtn:LVNewHeartbeatBottomIgnoreBtn ratio:fabs(widthRatio*10)];
    }else if (draggableDirection == LVNewHeartbeatCardDirectionRight){
        [self.bottomView slideBtn:LVNewHeartbeatBottomLikeBtn ratio:fabs(widthRatio*10)];
    }
}
/**
 *  滑动结束某张卡片时调用
 *  @param didSlidedIndex 滑动的卡片的下标
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        draggableDirection:(LVNewHeartbeatCardDirection)draggableDirection
        cardView:(LVNewHeartbeatCardView *)cardView
        didSlidedIndex:(NSInteger)didSlidedIndex
{
}
/**
 *  点击卡片触发的
 *  @param didSelectIndex 点击的card的下标
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        cardView:(LVNewHeartbeatCardView *)cardView
        didSelectIndex:(NSInteger)didSelectIndex
{
   
}

/**
 *  当卡片变动时,获取到当前卡片下标
 *  @param currentIndex 当前card的下标
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        cardView:(LVNewHeartbeatCardView *)cardView
        currentIndex:(NSInteger)currentIndex
{
    if (cardView) {
        [cardView startPlayImage];
    }
}
/**
 *  滑动最后一张触发
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        finishedDraggableLastCard:(BOOL)finishedDraggableLastCard
{
    
}
-(UIView *)greetBackView
{
    if (!_greetBackView) {
        _greetBackView = [[UIView alloc] initWithFrame:self.bounds];
        
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_greet"]];
        backImageView.frame = _greetBackView.bounds;
        [_greetBackView addSubview:backImageView];
        
        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0 - CGRectGetMidY(self.bottomView.frame), 0, CGRectGetMidY(self.bottomView.frame) * 2, CGRectGetMidY(self.bottomView.frame) * 2)];
        roundView.clipsToBounds = YES;
        roundView.layer.cornerRadius = CGRectGetMidY(self.bottomView.frame);
        roundView.transform = CGAffineTransformMakeScale(0, 0);
        roundView.backgroundColor = [UIColor blackColor];
        backImageView.maskView = roundView;
        self.maskRoundView = roundView;
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        effectView.frame = _greetBackView.bounds;
        [_greetBackView addSubview:effectView];
        
        _greetBackView.alpha = 0.0;
    }
    return _greetBackView;
    
}

@end
