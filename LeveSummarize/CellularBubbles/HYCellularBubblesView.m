//
//  HYCellularBubblesView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/25.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYCellularBubblesView.h"
#import "HYBubbleView.h"

#define BubbleItemWidth 100
#define Radian(x) (M_PI/180*x)
#define ContentWidth 2000

@interface HYCellularBubblesView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *backView;
@end
@implementation HYCellularBubblesView
{
    NSMutableArray *_bubbles;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self setUpBubbles];
        
        [self createReturnBack];
    }
    return self;
}
- (void)createReturnBack
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth-60, 30, 60, 30);
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn setTitle:@"退出" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
- (void)backAction
{
    [self removeFromSuperview];
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.bounds;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(ContentWidth, ContentWidth);
    }
    return _scrollView;
}
- (void)setUpBubbles
{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ContentWidth, ContentWidth)];
    [self.scrollView addSubview:self.backView];
    [self.scrollView setContentOffset:CGPointMake(self.backView.center.x - self.width/2.0, self.backView.center.y - self.height/2.0) animated:YES];
    [self addSubview:self.scrollView];
    
    _bubbles = [[NSMutableArray alloc] init];
    
    //思想：显示当前圈气泡的时候，会以上一圈的气泡的每一个气泡作为参照物，然后分别排查六个方向是否以显示气泡
    CGPoint centerBubblePoint;//参照物中心点
    NSInteger dirIndex = 1;//用来控制显示方向
    NSInteger circleNumber = 1;//第几圈
    NSInteger centerIndex = 0;//参照物所在下标
    NSMutableArray *arr = [[NSMutableArray alloc] init];//存放当前圈的bubble数组
    //1 6 12 18 24 内到外圈上bubble的个数
    for (int i = 0; i < 15; i ++) {
        if(arr.count > 6*(circleNumber-1)) {
            [arr removeAllObjects];
            circleNumber++;
            //取出上一圈的第一个作为参照物
            centerIndex = 6*(circleNumber-2);
            HYBubbleView *centerBubble = (HYBubbleView *)[_bubbles objectAtIndex:centerIndex];
            centerBubblePoint = centerBubble.center;
        }
        CGPoint point = CGPointZero;
        if (circleNumber > 1) {
            if (dirIndex == 1) {
                //正上方
                point = CGPointMake(centerBubblePoint.x, centerBubblePoint.y - BubbleItemWidth);
            }
            if (dirIndex == 2) {
                //斜左上方
                point = CGPointMake(centerBubblePoint.x-sin(Radian(60))*BubbleItemWidth, centerBubblePoint.y - cos(Radian(60))*BubbleItemWidth);
            }
            if (dirIndex == 3) {
                //斜右上方
                point = CGPointMake(centerBubblePoint.x + sin(Radian(60))*BubbleItemWidth, centerBubblePoint.y - cos(Radian(60))*BubbleItemWidth);
            }
            if (dirIndex == 4) {
                //斜左下方
                point = CGPointMake(centerBubblePoint.x - sin(Radian(60))*BubbleItemWidth, centerBubblePoint.y + cos(Radian(60))*BubbleItemWidth);
            }
            if (dirIndex == 5) {
                //斜右下方
                point = CGPointMake(centerBubblePoint.x + sin(Radian(60))*BubbleItemWidth, centerBubblePoint.y + cos(Radian(60))*BubbleItemWidth);
            }
            if (dirIndex == 6) {
                //正下方
                point = CGPointMake(centerBubblePoint.x, centerBubblePoint.y + BubbleItemWidth);
            }
            if (dirIndex == 6) {
                dirIndex = 1;
                centerIndex ++;
                HYBubbleView *centerBubble = (HYBubbleView *)[_bubbles objectAtIndex:centerIndex];
                centerBubblePoint = centerBubble.center;
            }else{
                dirIndex ++;
            }
            if ([self containsBubblePoint:point]) {
                //此处已显示气泡 跳过
                i --;
                continue;
            }
        }
        HYBubbleView *bubble = [[HYBubbleView alloc] initWithFrame:CGRectMake(0, 0,BubbleItemWidth , BubbleItemWidth)];
        bubble.index = i;
        bubble.circleNumber = circleNumber;
        [self.backView addSubview:bubble];
        [_bubbles addObject:bubble];
        
        if (i == 0) {
            bubble.center = CGPointMake(ContentWidth/2, ContentWidth/2);
            [arr addObject:bubble];
            continue;
        }else{
            if (arr.count < 6*(circleNumber-1)) {
                [arr addObject:bubble];
            }
        }
        bubble.center = point;
    }
}
#pragma mark -- 判断bubblePoint的地方是否已经显示气泡了
- (BOOL)containsBubblePoint:(CGPoint)bubblePoint
{
    for (HYBubbleView *b in _bubbles) {
        if (CGRectContainsPoint(b.frame, bubblePoint)) {
            return YES;
        }
    }
    return NO;
}
#pragma mark -- 计算两点之间的距离
- (float)distancePointA:(CGPoint)p1 pointB:(CGPoint)p2 {
    return sqrtf(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /**
     * 距离中心点距离为d，半径比例为scale
     * 1)、d = 0时气泡半径为BubbleItemWidth 半径减少0 scale=BubbleItemWidth/BubbleItemWidth =1
     * 2)、d >= BubbleItemWidth 时气泡半径为BubbleItemWidth*0.7 半径减少BubbleItemWidth*0.3 scale=0.7*BubbleItemWidth/BubbleItemWidth= 0.7
     * 3)、那么d >= 0 && d <= BubbleItemWidth 时气泡半径为
     * BubbleItemWidth -(0.3*BubbleItemWidth/BubbleItemWidth)*d = BubbleItemWidth - 0.3*d scale=(BubbleItemWidth - 0.3*d)/BubbleItemWidth = 1-0.3*d/BubbleItemWidth
     **/
    for (HYBubbleView *bubble in _bubbles) {
        CGPoint viewPoint = [self.scrollView convertPoint:bubble.center toView:self];
        CGPoint viewCenter = self.center;
        CGFloat d = [self distancePointA:viewPoint pointB:viewCenter];
        bubble.distanceToCenter = d;
        CGFloat scale;
        if (d > BubbleItemWidth) {
            scale = 0.7;
        }else{
            scale = 1-0.3*d/BubbleItemWidth;
        }
        bubble.transform = CGAffineTransformMakeScale(scale, scale);
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //得到降序排序数组
    NSArray *arr = [_bubbles sortedArrayUsingComparator:^NSComparisonResult(HYBubbleView *obj1, HYBubbleView *obj2) {
        return obj1.distanceToCenter < obj2.distanceToCenter;
    }];
    HYBubbleView *view = arr.lastObject;
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointMake(view.center.x - self.width/2, view.center.y - self.height/2) animated:YES];
    });
}
@end
