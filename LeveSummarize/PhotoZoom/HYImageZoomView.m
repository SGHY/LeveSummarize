//
//  HYImageZoomView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/27.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYImageZoomView.h"
#define MaxZoomScale 3.0
#define MinZoomScale 1.0

@interface HYImageZoomView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIView *atView;
@property (assign, nonatomic) CGRect originalRect;
@property (strong, nonatomic) UIScrollView *scrollView;
@end
@implementation HYImageZoomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        self.originalRect = self.frame;
    }
    return self;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.userInteractionEnabled = YES;
        _imageView = imgView;
    }
    return _imageView;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.contentSize = self.bounds.size;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.maximumZoomScale = MaxZoomScale;
        scrollView.minimumZoomScale = MinZoomScale;
        scrollView.multipleTouchEnabled = YES;
        scrollView.bouncesZoom = NO;//不能缩到ZoomScale比MinZoomScale小,也不能放大到比MaxZoomScale大
        scrollView.layer.masksToBounds = NO;
        scrollView.delegate = self;
        _scrollView = scrollView;
    }
    return _scrollView;
}
- (void)showAtView:(UIView *)view
{
    [view addSubview:self];
    self.atView = view;
}
#pragma mark - scrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.frame = [UIScreen mainScreen].bounds;
    CGRect frame = [self.scrollView convertRect:self.scrollView.bounds toView:[UIApplication sharedApplication].keyWindow];
    self.scrollView.frame = frame;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.scrollView];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scale == 1) {
        self.frame = self.originalRect;
        self.scrollView.frame = self.bounds;
        [self.atView addSubview:self];
        [self addSubview:self.scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.scrollView setZoomScale:1.0f animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.frame = self.originalRect;
        self.scrollView.frame = self.bounds;
        [self.atView addSubview:self];
        [self addSubview:self.scrollView];
    });
}

@end
