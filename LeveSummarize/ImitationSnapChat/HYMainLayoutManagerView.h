//
//  HYMainLayoutManagerView.h
//  LeveSummarize
//
//  Created by leve on 2018/6/26.
//  Copyright © 2018年 leve. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HYMainLayoutManagerView;

typedef NS_ENUM(NSInteger,HYScrollingDirection) {
    HYScrollingDirectionVertical,
    HYScrollingDirectionHorizontal,
};
typedef NS_ENUM(NSUInteger,HYMainLayoutLocation) {
    HYMainLayoutLeft,
    HYMainLayoutRight,
    HYMainLayoutMiddle,
    HYMainLayoutTop,
    HYMainLayoutBottom,
};
@protocol HYMainLayoutDelegate<NSObject>
@optional
/** 滚动偏移量*/
- (void)mainLayout:(HYMainLayoutManagerView *)mainLayout layoutOffset:(CGPoint)layoutOffset
        scrollingdirection:(HYScrollingDirection)scrollingdirection;

- (void)mainLayout:(HYMainLayoutManagerView *)mainLayout layoutLocation:(HYMainLayoutLocation)location;
@end
@protocol HYMainLayoutDatasource<NSObject>
@required
- (UIViewController *)mainLayout:(HYMainLayoutManagerView *)mainLayout viewControllerAtLocation:(HYMainLayoutLocation)location;
@end
@interface HYMainLayoutManagerView : UIView
@property (weak, nonatomic) id<HYMainLayoutDelegate> delegate;
@property (weak, nonatomic) id<HYMainLayoutDatasource> dataSource;
@property (assign, nonatomic) HYMainLayoutLocation layoutLocation;

- (void)startLayout;
@end
