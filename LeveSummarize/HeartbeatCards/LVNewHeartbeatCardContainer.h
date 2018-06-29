//
//  LVNewHeartbeatCardContainer.h
//  LEVE
//
//  Created by leve on 2018/5/25.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LVNewHeartbeatCardContainer;
#import "LVNewHeartbeatCardView.h"

typedef NS_OPTIONS(NSInteger, LVNewHeartbeatCardDirection) {
    LVNewHeartbeatCardDirectionDefault     = 0,
    LVNewHeartbeatCardDirectionLeft        = 1,
    LVNewHeartbeatCardDirectionRight       = 2,
    LVNewHeartbeatCardDirectionUp          = 3,
    LVNewHeartbeatCardDirectionDown        = 4,
};
@protocol LVNewHeartbeatCardContainerDelegate <NSObject>

/**
 *  滑动卡片时调用
 *  @param draggableDirection 滑动的方向
 *  @param widthRatio 滑动的水平偏移量
 *  @param heightRatio 滑动的竖直偏移量
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        draggableDirection:(LVNewHeartbeatCardDirection)draggableDirection
        widthRatio:(CGFloat)widthRatio
        heightRatio:(CGFloat)heightRatio;
/**
 *  滑动结束某张卡片时调用
 *  @param didSlidedIndex 滑动的卡片的下标
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        draggableDirection:(LVNewHeartbeatCardDirection)draggableDirection
        cardView:(LVNewHeartbeatCardView *)cardView
        didSlidedIndex:(NSInteger)didSlidedIndex;
/**
 *  点击卡片触发的
 *  @param didSelectIndex 点击的card的下标
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        cardView:(LVNewHeartbeatCardView *)cardView
        didSelectIndex:(NSInteger)didSelectIndex;

/**
 *  当卡片变动时,获取到当前卡片下标
 *  @param currentIndex 当前card的下标
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        cardView:(LVNewHeartbeatCardView *)cardView
        currentIndex:(NSInteger)currentIndex;
/**
 *  滑动最后一张触发
 */
- (void)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
        finishedDraggableLastCard:(BOOL)finishedDraggableLastCard;

@end

@protocol LVNewHeartbeatCardContainerDatasource <NSObject>
@required
/**
 *  卡片的样式
 *  @param index card的下标
 */
- (LVNewHeartbeatCardView *)cardContainer:(LVNewHeartbeatCardContainer *)cardContainer
                               viewForIndex:(NSInteger)index;
/**
 *  卡片的总张数
 */
- (NSInteger)numberOfIndexs;

@end
@interface LVNewHeartbeatCardContainer : UIView
@property (nonatomic, weak)  id <LVNewHeartbeatCardContainerDelegate>delegate;
@property (nonatomic, weak)  id <LVNewHeartbeatCardContainerDatasource>dataSource;
@property (nonatomic, assign) NSInteger currentIndex;
/** 左右滑动卡片*/
- (void)removeFormDirection:(LVNewHeartbeatCardDirection)direction animate:(BOOL)animate;
/** 重新刷新卡片*/
- (void)reloadDataWithAnimate:(BOOL)animate;
/** 在currentIndex后面插入新数据**/
- (void)insertAtCurrentIndexNext;
@end
