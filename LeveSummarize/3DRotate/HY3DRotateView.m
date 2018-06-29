//
//  HY3DRotateView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/26.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HY3DRotateView.h"

#define SCROLLVIEWTAG 123320

typedef NS_ENUM(NSUInteger, HYDirection)
{
    HYDirectionNone,
    HYDirectionLeft,//往左滑
    HYDirectionRight,//往右滑
};
typedef NS_ENUM(NSUInteger, HYRotateMode)
{
    HYRotateModeNormal,
    HYRotateMode3D,
};

@interface HY3DRotateView ()<UIScrollViewDelegate>
@property (nonatomic, assign) HYDirection direction;//滑动方向
@property (nonatomic, assign) HYRotateMode rotateMode;//旋转样式

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *currImageView;//当前显示视图
@property (nonatomic, strong) UIImageView *otherImageView;//将要显示视图

@property (nonatomic, strong) NSArray *imageArray;//图片数组

@property (nonatomic, assign) NSInteger currIndex;//当前显示图片下标
@property (nonatomic, assign) NSInteger nextIndex;//将要显示图片下标
@end
@implementation HY3DRotateView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rotateMode = HYRotateMode3D;
        NSMutableArray *imageArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_%d",i + 1]];
            [imageArr addObject:image];
        }
        self.imageArray = imageArr;
        [self addSubview:self.scrollView];
        [self setScrollViewContentSize];
        
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
- (UIImageView *)currImageView
{
    if (!_currImageView) {
        _currImageView = [[UIImageView alloc]init];
        _currImageView.backgroundColor = [UIColor yellowColor];
        _currImageView.layer.masksToBounds = YES;
        _currImageView.clipsToBounds = YES;
        _currImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
        _currImageView.bounds = self.bounds;
    }
    return _currImageView;
}
- (UIImageView *)otherImageView
{
    if (!_otherImageView) {
        _otherImageView = [[UIImageView alloc]init];
        _otherImageView.backgroundColor = [UIColor redColor];
        _otherImageView.layer.masksToBounds = YES;
        _otherImageView.clipsToBounds = YES;
        _otherImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
        _otherImageView.bounds = self.bounds;
    }
    return _otherImageView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.tag = SCROLLVIEWTAG;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.frame = self.bounds;
        _scrollView.layer.masksToBounds = NO;
        self.currImageView.userInteractionEnabled = YES;
        [_scrollView addSubview:self.currImageView];
        [_scrollView addSubview:self.otherImageView];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    if (!imageArray.count) return;
    self.currImageView.image = self.imageArray.firstObject;
}
#pragma mark 设置scrollView的contentSize
- (void)setScrollViewContentSize
{
    if (self.imageArray.count > 1) {
        self.scrollView.contentSize = CGSizeMake(self.width * 3, 0);
        self.scrollView.contentOffset = CGPointMake(self.width, 0);
        self.currImageView.frame = CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
    } else {
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentOffset = CGPointZero;
        self.currImageView.frame = CGRectMake(0, 0, self.scrollView.width, self.scrollView.height);
    }
}
#pragma mark --改变要显示的图片
- (void)changeImageView
{
    self.currImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.currImageView.layer.transform = CATransform3DIdentity;
    
    self.currImageView.image = self.otherImageView.image;
    self.scrollView.contentOffset = CGPointMake(self.width, 0);
    self.currIndex = self.nextIndex;
}
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.direction = offsetX > self.width ? HYDirectionLeft : offsetX < self.width ? HYDirectionRight : HYDirectionNone;
    if (self.direction == HYDirectionRight) {
        self.otherImageView.center = CGPointMake(self.currImageView.centerX - self.width, self.currImageView.centerY);
        
        if (self.rotateMode == HYRotateMode3D) {
            CGFloat angle =  (offsetX/self.width)*-M_PI_2;
            [self makeTransformAtView:self.otherImageView anchorPoint:CGPointMake(1, 0.5) rotatAngle:angle translatio:self.width/2];
            
            CGFloat angle2 =  (1 - offsetX/self.width) * M_PI_2;
            [self makeTransformAtView:self.currImageView anchorPoint:CGPointMake(0, 0.5) rotatAngle:angle2 translatio:-self.width/2];
        }
        self.nextIndex = self.currIndex - 1;
        if (self.nextIndex < 0) {
            self.nextIndex = self.imageArray.count - 1;
        }
        if (self.scrollView.contentOffset.x <= 0) {
            [self changeImageView];
        }
    }else if (self.direction == HYDirectionLeft){
        self.otherImageView.center = CGPointMake(self.currImageView.centerX + self.width, self.currImageView.centerY);
        if (self.rotateMode == HYRotateMode3D) {
            CGFloat angle =  (2 - offsetX/
                              self.width)*M_PI_2;
            [self makeTransformAtView:self.otherImageView anchorPoint:CGPointMake(0, 0.5) rotatAngle:angle translatio:-self.width/2];
            
            CGFloat angle2 =  (offsetX/self.width -1) *-M_PI_2;
            [self makeTransformAtView:self.currImageView anchorPoint:CGPointMake(1, 0.5) rotatAngle:angle2 translatio:self.width/2];
        }
        self.nextIndex = self.currIndex + 1;
        if (self.nextIndex > self.imageArray.count -1) {
            self.nextIndex = 1;
        }
        if (self.scrollView.contentOffset.x >= self.width * 2) {
            [self changeImageView];
        }
    }
    self.otherImageView.image = self.imageArray[self.nextIndex];
}
#pragma mark -- 添加旋转动画
- (void)makeTransformAtView:(UIView *)view anchorPoint:(CGPoint)anchorPoint rotatAngle:(CGFloat)rotatAngle translatio:(CGFloat)translatio
{
    CATransform3D identity = CATransform3DIdentity;
    identity.m34 = -1.0 / 1000.0;
    
    view.layer.anchorPoint = anchorPoint;
    CATransform3D rotateTransform2 = CATransform3DRotate(identity, rotatAngle, 0, 1, 0);
    CATransform3D translateTransform2 = CATransform3DMakeTranslation(translatio, 0.0, 0.0);
    view.layer.transform = CATransform3DConcat(rotateTransform2, translateTransform2);
}
@end
