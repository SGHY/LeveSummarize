//
//  HYMainLayoutManagerView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/26.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYMainLayoutManagerView.h"

@interface HYMainLayoutManagerView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *horizontalScrollView;
@property (strong, nonatomic) UIScrollView *verticalScrollView;
@property (strong, nonatomic) UIScrollView *currentScrollView;
@property(nonatomic, strong) UIView *overlayView;

@property (strong, nonatomic) UIViewController *leftVc;
@property (strong, nonatomic) UIViewController *rightVc;
@property (strong, nonatomic) UIViewController *middleVc;
@property (strong, nonatomic) UIViewController *topVc;
@property (strong, nonatomic) UIViewController *bottomVc;

@property (strong, nonatomic) UIViewController *middleMianVc;

@property(nonatomic, assign) NSInteger currentHPage;
@property(nonatomic, assign) NSInteger currentVPage;
@end
@implementation HYMainLayoutManagerView
- (void)dealloc
{
    NSLog(@"dealloc----- %@",NSStringFromClass([self class]));
}
- (void)startLayout
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(mainLayout:viewControllerAtLocation:)]) {
        self.leftVc = [self.dataSource mainLayout:self viewControllerAtLocation:HYMainLayoutLeft];
        self.rightVc = [self.dataSource mainLayout:self viewControllerAtLocation:HYMainLayoutRight];
        self.middleVc = [self.dataSource mainLayout:self viewControllerAtLocation:HYMainLayoutMiddle];
        self.topVc = [self.dataSource mainLayout:self viewControllerAtLocation:HYMainLayoutTop];
        self.bottomVc = [self.dataSource mainLayout:self viewControllerAtLocation:HYMainLayoutBottom];
    }
    if (self.delegate) {
        UIView *view;
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            view = ((UIViewController *)self.delegate).view;
            [view addSubview:self];
        }else{
            //#warning delegate必须是UIViewController类型
            return;
        }
        if (!self.middleVc) {
            //#warning middleVc必须存在
            return;
        }
        [self addSubview:self.overlayView];
        [self addSubview:self.horizontalScrollView];
        
        if (self.topVc || self.bottomVc) {
            self.middleMianVc = [[UIViewController alloc] init];
            [self.middleMianVc.view addSubview:self.verticalScrollView];
            if (self.topVc) {
                self.topVc.view.frame = CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                [self.middleMianVc addChildViewController:self.topVc];
                [self.verticalScrollView addSubview:self.topVc.view];
            }
            
            self.middleVc.view.frame = CGRectMake(0.f, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [self.middleMianVc addChildViewController:self.middleVc];
            [self.verticalScrollView addSubview:self.middleVc.view];
            
            if (self.bottomVc) {
                self.bottomVc.view.frame = CGRectMake(0.f, [UIScreen mainScreen].bounds.size.height * 2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                [self.middleMianVc addChildViewController:self.bottomVc];
                [self.verticalScrollView addSubview:self.bottomVc.view];
            }
            //设置_verticalScrollView的contentSize和contentOffset
            if (!self.topVc && self.bottomVc) {
                _verticalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2);
                _verticalScrollView.contentOffset = CGPointMake(0.f, 0.f);
            }else if (!self.bottomVc && self.topVc){
                _verticalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2);
                _verticalScrollView.contentOffset = CGPointMake(0.f, [UIScreen mainScreen].bounds.size.height);
            }else if (self.topVc && self.bottomVc){
                _verticalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 3);
                _verticalScrollView.contentOffset = CGPointMake(0.f, [UIScreen mainScreen].bounds.size.height);
            }
        }
        if (self.leftVc || self.rightVc) {
            if (self.leftVc) {
                self.leftVc.view.frame = CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                [(UIViewController *)self.delegate addChildViewController:self.leftVc];
                [self.horizontalScrollView addSubview:self.leftVc.view];
            }
            if (self.middleMianVc) {
                self.middleMianVc.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                [(UIViewController *)self.delegate addChildViewController:self.middleMianVc];
                [self.horizontalScrollView addSubview:self.middleMianVc.view];
            }else{
                self.middleVc.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                [(UIViewController *)self.delegate addChildViewController:self.middleVc];
                [self.horizontalScrollView addSubview:self.middleVc.view];
            }
            
            if (self.rightVc) {
                self.rightVc.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 2, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                [(UIViewController *)self.delegate addChildViewController:self.rightVc];
                [self.horizontalScrollView addSubview:self.rightVc.view];
            }
            
            //设置_horizontalScrollView的contentSize和contentOffset
            if (!self.leftVc && self.rightVc) {
                _horizontalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2, [UIScreen mainScreen].bounds.size.height);
                _horizontalScrollView.contentOffset = CGPointMake(0.f, 0.f);
            }else if (!self.leftVc && self.rightVc){
                _horizontalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2, [UIScreen mainScreen].bounds.size.height);
                _horizontalScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0.0f);
            }else if (self.leftVc && self.rightVc){
                _horizontalScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*3, [UIScreen mainScreen].bounds.size.height);
                _horizontalScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0.0f);
            }
        }
    }else{
        //#warning delegate必须存在
        return;
    }
    self.currentHPage = 1;
    self.currentVPage = 1;
}
- (void)setLayoutLocation:(HYMainLayoutLocation)layoutLocation
{
    switch (layoutLocation) {
        case HYMainLayoutLeft:
        {
            if (self.leftVc) {
                if (self.currentVPage != 1) return;
                [self.horizontalScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
            break;
        case HYMainLayoutRight:
        {
            if (self.rightVc) {
                if (self.currentVPage != 1) return;
                [self.horizontalScrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*2, 0) animated:YES];
            }
        }
            break;
        case HYMainLayoutMiddle:
        {
            if (self.middleVc) {
                if (self.currentVPage != 1) return;
                [self.horizontalScrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:YES];
            }
        }
            break;
        case HYMainLayoutTop:
        {
            if (self.topVc) {
                if (self.currentHPage != 1) return;
                [self.verticalScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
            break;
        case HYMainLayoutBottom:
        {
            if (self.bottomVc) {
                if (self.currentHPage != 1) return;
                [self.verticalScrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.height*2, 0) animated:YES];
            }
        }
            break;
        default:
            break;
    }
    _layoutLocation = layoutLocation;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainLayout:layoutLocation:)]) {
        [self.delegate mainLayout:self layoutLocation:_layoutLocation];
    }
}
#pragma mark -- Property
- (UIScrollView *)horizontalScrollView {
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _horizontalScrollView.exclusiveTouch = YES;
        _horizontalScrollView.delegate = self;
        _horizontalScrollView.showsVerticalScrollIndicator = NO;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.directionalLockEnabled = YES;
        _horizontalScrollView.bounces = NO;
        //适配 iOS11，避免滚动视图顶部出现20的空白以及push或者pop的时候页面有一个上移或者下移的异常动画的问题
        if (@available(iOS 11.0, *)) {
            [_horizontalScrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }
    return _horizontalScrollView;
}
- (UIScrollView *)verticalScrollView {
    if (!_verticalScrollView) {
        _verticalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _verticalScrollView.exclusiveTouch = YES;
        _verticalScrollView.delegate = self;
        _verticalScrollView.showsVerticalScrollIndicator = NO;
        _verticalScrollView.showsHorizontalScrollIndicator = NO;
        _verticalScrollView.pagingEnabled = YES;
        _verticalScrollView.directionalLockEnabled = YES;
        _verticalScrollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            [_verticalScrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }
    return _verticalScrollView;
}
- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _overlayView.alpha = 0;
    }
    return _overlayView;
}
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView) {
        self.currentHPage = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        CGFloat scrollProgress = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
        scrollProgress = (self.currentHPage == 0) ? (1 - scrollProgress) : (scrollProgress - 1);
        if (self.currentScrollView == self.verticalScrollView) {
            return;
        }
        [self animateOverlayView:scrollProgress scrollingDirection:HYScrollingDirectionHorizontal];

    } else if (scrollView == self.verticalScrollView) {
        self.currentVPage = (NSInteger)(scrollView.contentOffset.y / [UIScreen mainScreen].bounds.size.height);
        CGFloat scrollProgress = scrollView.contentOffset.y / [UIScreen mainScreen].bounds.size.height;
        scrollProgress = (self.currentVPage == 0) ? (1 - scrollProgress) : (scrollProgress - 1);
        if (self.currentScrollView == self.horizontalScrollView) {
            return;
        }
        [self animateOverlayView:scrollProgress scrollingDirection:HYScrollingDirectionVertical];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainLayout:layoutOffset:scrollingdirection:)]) {
        [self.delegate mainLayout:self layoutOffset:scrollView.contentOffset scrollingdirection:(scrollView == self.horizontalScrollView)?HYScrollingDirectionHorizontal:HYScrollingDirectionVertical];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView || scrollView == self.verticalScrollView) {
        self.currentScrollView = scrollView;
        self.middleVc.view.frame = CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self insertSubview:self.middleVc.view aboveSubview:self.overlayView];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainLayout:layoutOffset:scrollingdirection:)]) {
        [self.delegate mainLayout:self layoutOffset:scrollView.contentOffset scrollingdirection:(scrollView == self.horizontalScrollView)?HYScrollingDirectionHorizontal:HYScrollingDirectionVertical];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainLayout:layoutOffset:scrollingdirection:)]) {
        [self.delegate mainLayout:self layoutOffset:scrollView.contentOffset scrollingdirection:(scrollView == self.horizontalScrollView)?HYScrollingDirectionHorizontal:HYScrollingDirectionVertical];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.verticalScrollView) {
        self.horizontalScrollView.scrollEnabled = (self.currentVPage == 1);
        if (self.currentVPage == 1 && self.currentScrollView == scrollView) {
            self.middleVc.view.frame = CGRectMake(0.f, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [self.verticalScrollView addSubview:self.middleVc.view];
        }
        if (self.currentVPage == 0) {
            _layoutLocation = HYMainLayoutTop;
        }else if (self.currentVPage == 1) {
            _layoutLocation = HYMainLayoutMiddle;
        }else if (self.currentVPage == 2){
            _layoutLocation = HYMainLayoutBottom;
        }
    } else if (scrollView == self.horizontalScrollView) {
        if (self.currentHPage == 1 && self.currentScrollView == scrollView) {
            self.middleVc.view.frame = CGRectMake(0.f, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [self.verticalScrollView addSubview:self.middleVc.view];
        }
        if (self.currentHPage == 0) {
            _layoutLocation = HYMainLayoutLeft;
        }else if (self.currentHPage == 1) {
            _layoutLocation = HYMainLayoutMiddle;
        }else if (self.currentHPage == 2){
            _layoutLocation = HYMainLayoutRight;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainLayout:layoutLocation:)]) {
        [self.delegate mainLayout:self layoutLocation:_layoutLocation];
    }
}
#pragma mark -- 背景改变
- (void)animateOverlayView:(CGFloat)scrollProgress scrollingDirection:(HYScrollingDirection)scrollingDirection{
    if (!self.overlayView.backgroundColor) {
        self.overlayView.backgroundColor = [self colorForNextSpaceScrollingDirection:scrollingDirection];
    }
    self.overlayView.alpha = scrollProgress;
    self.middleVc.view.alpha = 1 - scrollProgress;
    if (scrollProgress < 0.1) {
        self.overlayView.backgroundColor = nil;
    }
}

#pragma mark -- 获取需要的颜色
- (UIColor *)colorForNextSpaceScrollingDirection:(HYScrollingDirection)scrollingDirection {
    if (scrollingDirection == HYScrollingDirectionHorizontal) {
        if (self.currentHPage == 0) {
            return [UIColor colorWithRed:255/255.f green:183/255.f blue:166/255.f alpha:1];
        }
        return [UIColor colorWithRed:249/255.f green:217/255.f blue:140/255.f alpha:1];
    } else {
        if (self.currentVPage == 0) {
            return [UIColor colorWithRed:161/255.f green:214/255.f blue:89/255.f alpha:1];
        }
        return [UIColor colorWithRed:90/255.f green:200/255.f blue:250/255.f alpha:1];
    }
}
@end
