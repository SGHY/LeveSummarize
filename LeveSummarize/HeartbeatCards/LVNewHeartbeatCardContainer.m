//
//  LVNewHeartbeatCardContainer.m
//  LEVE
//
//  Created by leve on 2018/5/25.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import "LVNewHeartbeatCardContainer.h"

#define kVisibleCount 2
#define kBoundaryRatio 0.6f
@interface LVNewHeartbeatCardContainer ()
//计算以及加载到了第几个卡片
@property (nonatomic) NSInteger loadedIndex;
//结束时重置
@property (nonatomic) BOOL finishedReset;
//是否正在移动 可以用方向替代, 暂时用着
@property (nonatomic) BOOL moving;
//当前卡片中心点
@property (nonatomic) CGPoint cardCenter;
//当前显示的卡片数组
@property (nonatomic) NSMutableArray *currentCards;
//滑动方向
@property (nonatomic, assign) LVNewHeartbeatCardDirection direction;
@end

@implementation LVNewHeartbeatCardContainer
- (void)dealloc
{
    NSLog(@"dealloc ------------- %@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultConfig];
    }
    return self;
}
#pragma mark --默认初始化一些数据
- (void)defaultConfig {
    self.currentCards = [NSMutableArray array];
    self.finishedReset = NO;
    self.direction = LVNewHeartbeatCardDirectionDefault;
    self.loadedIndex = 0;
    self.moving = NO;
    self.currentIndex = 0;
}
#pragma mark --加载可见卡片
- (void)installNextItem {
    // 最多只显示2个
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfIndexs)] && [self.dataSource respondsToSelector:@selector(cardContainer:viewForIndex:)]) {
        
        NSInteger indexs = [self.dataSource numberOfIndexs];
        NSInteger preloadViewCount = indexs <= kVisibleCount ? indexs : kVisibleCount;
        // 在此需添加当前Card是否移动的状态A
        // 如果A为YES, 则执行当且仅当一次installNextItem, 用条件限制
        if (self.loadedIndex < indexs) {
            for (long int i = self.currentCards.count; i <  (self.moving ? preloadViewCount + 1: preloadViewCount); i++) {
                LVNewHeartbeatCardView *cardView = [self.dataSource cardContainer:self viewForIndex:self.loadedIndex];
                if (self.cardCenter.x == 0) {
                    self.cardCenter = cardView.center;
                }
                // TAG
                cardView.tag = self.loadedIndex;
                
                [self addSubview:cardView];
                [self sendSubviewToBack:cardView]; // addSubview后添加sendSubviewToBack, 使Card的显示顺序倒置
                
                //  -----------------
                //  每次都会改变的
                //  -----------------
                
                // 添加新元素
                [self.currentCards addObject:cardView];
                
                // 添加清扫手势
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
                [cardView addGestureRecognizer:pan];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
                [cardView addGestureRecognizer:tap];
                
                // 总数indexs, 计算以及加载到了第几个index
                self.loadedIndex += 1;
                
                NSLog(@"loaded %ld card", (long)self.loadedIndex);
            }
        }
    } else {
    }
}
#pragma mark --重置可见卡片 带动画
- (void)resetVisibleCards {
    
    WeakSelf(weakSelf);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         [weakSelf originalLayout];
                     } completion:^(BOOL finished) {
                         weakSelf.finishedReset = YES;
                     }];
    
}
#pragma mark --还原卡片位置
- (void)originalLayout {
    
    //  ---------------------------------------------------------
    //  self.delegate所触发方法, 委托对象用来改变一些UI的缩放、透明度等...
    //  此处用于还原
    //  ---------------------------------------------------------
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:draggableDirection:widthRatio:heightRatio:)]) {
        [self.delegate cardContainer:self draggableDirection:self.direction widthRatio:0 heightRatio:0];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:finishedDraggableLastCard:)]) {
        if (self.currentCards.count == 0) {
            [self.delegate cardContainer:self finishedDraggableLastCard:YES];
        }
    }
    
    for (int i = 0; i < self.currentCards.count; i++) {
        
        LVNewHeartbeatCardView *cardView = [self.currentCards objectAtIndex:i];
        cardView.transform = CGAffineTransformIdentity;
        
        switch (i) {
            case 0:
            {
                cardView.alpha = 1;
                cardView.center = self.cardCenter;
                [cardView hideDirectionView];
            }
                break;
            case 1:
            {
                cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
                cardView.alpha = 0.8;
                cardView.center = self.cardCenter;
                [cardView hideDirectionView];
            }
                break;
            default:
                break;
        }
        
        cardView.originalTransform = cardView.transform;
    }
}
#pragma mark --点击卡片
- (void)tapGestureHandle:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:cardView:didSelectIndex:)]) {
        [self.delegate cardContainer:self cardView:(LVNewHeartbeatCardView *)tap.view didSelectIndex:tap.view.tag];
    }
}
#pragma mark --拖动卡片
- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture {
    
    if (!self.finishedReset) { return; }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // Coding...
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        LVNewHeartbeatCardView *cardView = (LVNewHeartbeatCardView *)gesture.view;
        if (cardView != [self.currentCards firstObject]) {
            return;
        }
        CGPoint point = [gesture translationInView:self]; // translation: 平移 获取相对坐标原点的坐标
        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        cardView.center = movedPoint;
        cardView.transform = CGAffineTransformRotate(cardView.originalTransform, (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x * (M_PI_4 / 12));
        [gesture setTranslation:CGPointZero inView:self]; // 设置坐标原点位上次的坐标
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:draggableDirection:widthRatio:heightRatio:)]) {
            //  做比例, 总长度(0 ~ self.cardCenter.x), 已知滑动的长度 (gesture.view.center.x - self.cardCenter.x)
            //  ratio用来判断是否显示图片中的"Like"或"DisLike"状态, 用开发者限定多少比例显示或设置透明度
            CGFloat widthRatio = (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x;
            CGFloat heightRatio = (gesture.view.center.y - self.cardCenter.y) / self.cardCenter.y;
            
            // Moving
            [self judgeMovingState: widthRatio];
            
            //  ----------------------------------------
            //  左右的判断方法为: 只要 ratio_w > 0 就是Right
            //  ----------------------------------------
            
            if (widthRatio > 0) {
                self.direction = LVNewHeartbeatCardDirectionRight;
            } if (widthRatio < 0) {
                self.direction = LVNewHeartbeatCardDirectionLeft;
            } else if (widthRatio == 0) {
                self.direction = LVNewHeartbeatCardDirectionDefault;
            }
            [self.delegate cardContainer:self draggableDirection:self.direction widthRatio:widthRatio heightRatio:heightRatio];
            
            [cardView showDirectionView:(LVNewCardDirection)self.direction alpha:fabs(widthRatio)];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled) {
        
        //  --------------------
        //  随着滑动的方向消失或还原
        //  --------------------
        
        float widthRatio = (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x;
        float moveWidth  = (gesture.view.center.x  - self.cardCenter.x);
        float moveHeight = (gesture.view.center.y - self.cardCenter.y);
        
        [self finishedPanGesture:gesture.view direction:self.direction scale:(moveWidth / moveHeight) disappear:fabs(widthRatio) > kBoundaryRatio];
    }
}
#pragma mark --判断卡片移动状态来变动卡片大小
- (void)judgeMovingState:(CGFloat)scale {
    if (!self.moving) {
        self.moving = YES;
        [self installNextItem];
    } else {
        [self movingVisibleCards:scale];
    }
}
#pragma mark --卡片拖动时，可见卡片的移动动画
// scale: MAX: kBoundaryRatio
- (void)movingVisibleCards:(CGFloat)scale {
    
    scale = fabs(scale) >= kBoundaryRatio ? kBoundaryRatio : fabs(scale);
    CGFloat sPoor = 0.2; // 相邻两个CardScale差值 透明度的差值
    CGFloat tPoor = sPoor / (kBoundaryRatio / scale); // transform x值
    
    for (int i = 1; i < self.currentCards.count; i++) {
        
        LVNewHeartbeatCardView *cardView = [self.currentCards objectAtIndex:i];
        
        switch (i) {
            case 1:
            {
                CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + 0.8, tPoor + 0.8);// 改变tran
                cardView.transform = scaleTransform;
                cardView.alpha = 0.8 + tPoor;
            }
                break;
            case 2:
            {
                CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + 0.6, tPoor + 0.6);
                cardView.transform = scaleTransform;
                cardView.alpha = 0.6 + tPoor;
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark --结束拖动
- (void)finishedPanGesture:(UIView *)cardView direction:(LVNewHeartbeatCardDirection)direction scale:(CGFloat)scale disappear:(BOOL)disappear {
    
    //  ---------------
    //  还原Original坐标
    //  移除最底层Card
    //  ---------------
    
    __weak LVNewHeartbeatCardView *weakCardView = (LVNewHeartbeatCardView *)cardView;
    WeakSelf(weakSelf);
    if (!disappear) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfIndexs)]) {
            if (self.moving && self.loadedIndex < [self.dataSource numberOfIndexs]) {
                LVNewHeartbeatCardView *lastView = [self.currentCards lastObject];
                self.loadedIndex = lastView.tag;
                [lastView stopPlayImage];
                [lastView removeFromSuperview];
                [self.currentCards removeObject:lastView];
            }
            self.moving = NO;
            [self resetVisibleCards];
        }
    } else {
        
        // --------------------------------
        // 移除屏幕后
        // 1.删除移除屏幕的cardView
        // 2.重新布局剩下的cardViews
        // --------------------------------
        
        NSInteger flag = direction == LVNewHeartbeatCardDirectionLeft ? -1 : 2;
        [UIView animateWithDuration:0.5f
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             weakCardView.center = CGPointMake(kScreenWidth * flag, kScreenWidth * flag / scale + weakSelf.cardCenter.y);
                         } completion:^(BOOL finished) {
                             [weakCardView stopPlayImage];
                             [weakCardView removeFromSuperview];
                         }];
        [self.currentCards removeObject:cardView];
        self.moving = NO;
        [self resetVisibleCards];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:draggableDirection:cardView:didSlidedIndex:)]){
            [self.delegate cardContainer:self draggableDirection:self.direction cardView:(LVNewHeartbeatCardView *)cardView didSlidedIndex:cardView.tag];
        }
        NSInteger startIndex = cardView.tag+2 > [self.dataSource numberOfIndexs]? 1 : cardView.tag + 2;
        self.currentIndex = startIndex - 1;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(cardContainer: cardView:currentIndex:)]){
            [self.delegate cardContainer:self cardView:[self.currentCards firstObject]  currentIndex:self.currentIndex];
        }
    }
}
#pragma mark --左右移除卡片
- (void)removeFormDirection:(LVNewHeartbeatCardDirection)direction animate:(BOOL)animate
{
    if (animate) {
        if (self.moving) {
            return;
        } else {
            CGPoint cardCenter = CGPointZero;
            CGFloat flag = 0;
            
            switch (direction) {
                case LVNewHeartbeatCardDirectionLeft:
                    cardCenter = CGPointMake(-kScreenWidth / 2, self.cardCenter.y);
                    flag = -1;
                    self.direction = LVNewHeartbeatCardDirectionLeft;
                    break;
                case LVNewHeartbeatCardDirectionRight:
                    cardCenter = CGPointMake(kScreenWidth * 1.5, self.cardCenter.y);
                    flag = 1;
                    self.direction = LVNewHeartbeatCardDirectionRight;
                    break;
                case LVNewHeartbeatCardDirectionUp:
                    cardCenter = CGPointMake(kScreenWidth * 0.5, -kScreenHeight/2);
                    flag = 0;
                    self.direction = LVNewHeartbeatCardDirectionUp;
                    break;
                case LVNewHeartbeatCardDirectionDown:
                    cardCenter = CGPointMake(kScreenWidth * 0.5, kScreenHeight*1.5);
                    flag = 0;
                    self.direction = LVNewHeartbeatCardDirectionUp;
                    break;
                default:
                    break;
            }
            
            UIView *cardView = [self.currentCards firstObject];
            
            __weak LVNewHeartbeatCardView *weakCardView = (LVNewHeartbeatCardView *)cardView;
            WeakSelf(weakSelf);
            [UIView animateWithDuration:0.35 animations:^{
                
                CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, flag * 20, 0);
                weakCardView.transform = CGAffineTransformRotate(translate, flag * M_PI_4 / 4);
                weakCardView.center = cardCenter;
                
                [weakCardView showDirectionView:(LVNewCardDirection)direction alpha:1];
            } completion:^(BOOL finished) {
                [weakCardView stopPlayImage];
                [weakCardView removeFromSuperview];
                [weakSelf.currentCards removeObject:weakCardView];
                
                [weakSelf installNextItem];
                [weakSelf resetVisibleCards];
                
                if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cardContainer:draggableDirection:cardView:didSlidedIndex:)]){
                    [weakSelf.delegate cardContainer:weakSelf draggableDirection:weakSelf.direction cardView:(LVNewHeartbeatCardView *)weakCardView didSlidedIndex:weakCardView.tag];
                }
                NSInteger startIndex = weakCardView.tag+2 > [weakSelf.dataSource numberOfIndexs]? 1 : weakCardView.tag + 2;
                weakSelf.currentIndex = startIndex - 1;
    
                if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cardContainer:cardView:currentIndex:)]){
                    [weakSelf.delegate cardContainer:weakSelf cardView:[weakSelf.currentCards firstObject] currentIndex:weakSelf.currentIndex];
                }
            }];
        }
    }else{
        LVNewHeartbeatCardView *cardView = [self.currentCards firstObject];
        [cardView stopPlayImage];
        [cardView removeFromSuperview];
        [self.currentCards removeObject:cardView];
        
        [self installNextItem];
        [self resetVisibleCards];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:draggableDirection:cardView:didSlidedIndex:)]){
            [self.delegate cardContainer:self draggableDirection:self.direction cardView:(LVNewHeartbeatCardView *)cardView didSlidedIndex:cardView.tag];
        }
        
        NSInteger startIndex = cardView.tag+2 > [self.dataSource numberOfIndexs]? 1 : cardView.tag + 2;
        self.currentIndex = startIndex - 1;
    }
}
#pragma mark --刷新ka'pian
- (void)reloadDataWithAnimate:(BOOL)animate
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self defaultConfig];
    [self installNextItem];
    if (animate) {
        [self resetVisibleCards];
    }else{
        [self originalLayout];
        self.finishedReset = YES;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(cardContainer:cardView:currentIndex:)]){
        [self.delegate cardContainer:self cardView:[self.currentCards firstObject] currentIndex:self.currentIndex];
    }
}
#pragma mark -- 在xurrentIndex位置后面插入新数据
- (void)insertAtCurrentIndexNext
{
    [self installNextItem];
}
@end
