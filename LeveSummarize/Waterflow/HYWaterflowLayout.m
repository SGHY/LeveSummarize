
//
//  HYWaterflowLayout.m
//  HYWaterflowDemo
//
//  Created by leve on 2017/10/11.
//  Copyright © 2017年 leve. All rights reserved.
//
#import "HYWaterflowLayout.h"

/** 默认的列数 */
static const NSInteger HYDefaultColumnCount = 3;
/** 每一列之间的间距 */
static const CGFloat HYDefaultColumnMargin = 10;
/** 每一行之间的间距 */
static const CGFloat HYDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets HYDefaultEdgeInsets = {10, 10, 10, 10};


@interface HYWaterflowLayout()
/** 存放所有cell的布局属性 */
@property (strong, nonatomic) NSMutableArray *attrsArray;
/** 存放所有列的当前高度 */
@property (strong, nonatomic) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (assign, nonatomic) CGFloat contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end

@implementation HYWaterflowLayout
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return HYDefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return HYDefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return HYDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return HYDefaultEdgeInsets;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

/**
 自定义UICollectionViewLayout需重写以下几个方法：
 -(void)prepareLayout
 准备方法被自动调用，以保证layout实例的正确。
 
 -(CGSize)collectionViewContentSize
 返回collectionView的内容的尺寸
 
 -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
 1.返回rect中的所有的元素的布局属性
 2.返回的是包含UICollectionViewLayoutAttributes的NSArray
 3.UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes：
 
 -(UICollectionViewLayoutAttributes )layoutAttributesForItemAtIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的cell的布局属性
 
 -(UICollectionViewLayoutAttributes )layoutAttributesForSupplementaryViewOfKind:(NSString )kind atIndexPath:(NSIndexPath *)indexPath
 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
 
 -(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString)decorationViewKind atIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
 
 -(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
 */
/**初始化*/
- (void)prepareLayout
{
    [super prepareLayout];

    self.contentHeight = 0;

    [self.columnHeights removeAllObjects];

    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    [self.attrsArray removeAllObjects];

    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
 
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    
    //找出来最短后 就把下一个cell 添加到低下 瀑布流核心思想
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

@end
