
//
//  HYPhotoCell.m
//  LeveSummarize
//
//  Created by leve on 2018/6/27.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYPhotoCell.h"
#import "HYImageZoomView.h"

@interface HYPhotoCell ()
@property (strong, nonatomic) HYImageZoomView *zoomView;
@end
@implementation HYPhotoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.zoomView.imageView.image = [UIImage imageNamed:@"beatiful"];
        [self.zoomView showAtView:self.contentView];
    }
    return self;
}
- (HYImageZoomView *)zoomView
{
    if (!_zoomView) {
        _zoomView = [[HYImageZoomView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    }
    return _zoomView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
