//
//  HYWaterflowLayout.h
//  HYWaterflowDemo
//
//  Created by leve on 2017/10/11.
//  Copyright © 2017年 leve. All rights reserved.
//
#import <UIKit/UIKit.h>

@class HYWaterflowLayout;

@protocol HYWaterflowLayoutDelegate <NSObject>
@required
/**获取cell的高度*/
- (CGFloat)waterflowLayout:(HYWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/**列数*/
- (CGFloat)columnCountInWaterflowLayout:(HYWaterflowLayout *)waterflowLayout;
/**每列间隙*/
- (CGFloat)columnMarginInWaterflowLayout:(HYWaterflowLayout *)waterflowLayout;
/**每行间隙*/
- (CGFloat)rowMarginInWaterflowLayout:(HYWaterflowLayout *)waterflowLayout;
/**collectionView的边缘间距*/
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(HYWaterflowLayout *)waterflowLayout;
@end

@interface HYWaterflowLayout : UICollectionViewLayout
@property (nonatomic, weak) id<HYWaterflowLayoutDelegate> delegate;
@end
