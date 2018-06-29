//
//  HYTagsSuspendingView.m
//  LeveSummarize
//
//  Created by leve on 2018/6/28.
//  Copyright © 2018年 leve. All rights reserved.
//

#import "HYTagsSuspendingView.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "HYRadarView.h"
#import "HYTagModel.h"

@interface HYTagsSuspendingView ()<CLLocationManagerDelegate>
@property (strong, nonatomic) HYRadarView *radarView;
@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) NSMutableArray *currentArr;

@property (nonatomic, assign) CGFloat direction;//真北角
@property (nonatomic, assign) CGFloat zTheta;//zTheta是手机与水平面的夹角
@end

@implementation HYTagsSuspendingView
- (void)dealloc
{
    NSLog(@"dealloc----- %@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.radarView = [[HYRadarView alloc] initWithFrame:CGRectMake(10, 20, 120, 120)];
        [self addSubview:self.radarView];
        
        [self drawFanView];
        
        self.manager = [[CMMotionManager alloc] init];
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.tagArray = [[NSMutableArray alloc] init];
        self.currentArr = [[NSMutableArray alloc] init];
        
        [self loadData];
        [self startGyroPush];
        [self startLocation];
    }
    return self;
}
#pragma mark --添加模拟数据
- (void)loadData
{
    HYTagModel *model0 = [[HYTagModel alloc] initWithText:@"我的家" distance:50.0 azimuth:20.0];
    [self addSubview:model0.tagView];
    [self.tagArray addObject:model0];
    
    HYTagModel *model1 = [[HYTagModel alloc] initWithText:@"讯美广场" distance:20.0 azimuth:50.0];
    [self addSubview:model1.tagView];
    [self.tagArray addObject:model1];
    
    HYTagModel *model2 = [[HYTagModel alloc] initWithText:@"腾讯大夏" distance:30.0 azimuth:100.0];
    [self addSubview:model2.tagView];
    [self.tagArray addObject:model2];
    
    HYTagModel *model3 = [[HYTagModel alloc] initWithText:@"深大地铁站" distance:40.0 azimuth:170.0];
    [self addSubview:model3.tagView];
    [self.tagArray addObject:model3];
    
    HYTagModel *model4 = [[HYTagModel alloc] initWithText:@"科兴科学园A4" distance:40.0 azimuth:240.0];
    [self addSubview:model4.tagView];
    [self.tagArray addObject:model4];
    
    HYTagModel *model5 = [[HYTagModel alloc] initWithText:@"科兴科学园东门" distance:50.0 azimuth:300.0];
    [self addSubview:model5.tagView];
    [self.tagArray addObject:model5];
    
    HYTagModel *model6 = [[HYTagModel alloc] initWithText:@"万基产业园" distance:55 azimuth:270.0];
    [self addSubview:model6.tagView];
    [self.tagArray addObject:model6];
    
    HYTagModel *model7 = [[HYTagModel alloc] initWithText:@"东方科技园" distance:55 azimuth:270.0];
    [self addSubview:model7.tagView];
    [self.tagArray addObject:model7];
}
#pragma mark -- 在雷达上面添加小点点
- (void)addAzimuthViewAtRadarView
{
    for (HYTagModel *model in self.tagArray) {
        [self createAzimuthViewtagModel:model];
    }
    // 判断两个坐标是有没有重和部分，有的话移除其中一个（这里移除了后一个）
    for (int i = 0; i < self.tagArray.count - 1; i++) {
        UIView *view0 = ((HYTagModel *)self.tagArray[i]).azimuthView;
        for (int j = i + 1; j < self.tagArray.count; j++) {
            UIView *view1 = ((HYTagModel *)self.tagArray[j]).azimuthView;
            if (CGRectIntersectsRect(view0.frame, view1.frame)) {
                [((HYTagModel *)self.tagArray[j]).tagView removeFromSuperview];
                [((HYTagModel *)self.tagArray[j]).azimuthView removeFromSuperview];
                [self.tagArray removeObjectAtIndex:j];
            }
        }
    }
}
#pragma mark - 开启陀螺仪
- (void)startGyroPush {
    if (![_manager isDeviceMotionActive] && [_manager isDeviceMotionAvailable]) {
        //设置采样间隔
        _manager.deviceMotionUpdateInterval = 0.001;
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        WeakSelf(weakSelf);
        [_manager startDeviceMotionUpdatesToQueue:queue
                                      withHandler:^(CMDeviceMotion * _Nullable motion,
                                                    NSError * _Nullable error) {
                                          
                                          double gravityX = motion.gravity.x;
                                          double gravityY = motion.gravity.y;
                                          double gravityZ = motion.gravity.z;
                                          //手机水平放    x:0 y:0 z:屏幕朝上-1、屏幕朝下1
                                          //手机竖向垂直放 x:0 y:摄像头朝上-1、摄像头朝下1 z:0
                                          //手机横向垂直放 x:开关键朝上-1、开关键朝下1 y:0 z:0
                                          //NSLog(@"X:%.2f,Y:%.2f,Z:%.2f",gravityX,gravityY,gravityZ);
                                          
                                          //计算真北角
                                          /***
                                          CMQuaternion quat = motion.attitude.quaternion;
                                          double direction = - (atan2(2 * (quat.w * quat.z + quat.x * quat.y), 1 - 2 * (quat.y * quat.y + quat.z * quat.z))) / M_PI * 180.f;
                                          if (direction < 0) {
                                              direction = direction + 360.f;
                                          }
                                          weakSelf.direction = direction;
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              [weakSelf updateRadarView];
                                              [weakSelf updateAllTagViews];
                                          }];
                                           ***/
                                          
                                          if (gravityY<=0 && gravityY>=-1) {
                                              //获取手机的倾斜角度(zTheta是手机与水平面的夹角
                                              CGFloat zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0 + 90;
                                              /**这样算为什么就算出方位角了 为什么还要加90？**/
                                              // atan2(double y,double x) 返回的是原点至点(x,y)的方位角，即与 x 轴的夹角,结果为正表示从 X 轴逆时针旋转的角度，结果为负表示从 X 轴顺时针旋转的角度
                                              //NSLog(@"zTheta = %.2f",_zTheta);
                                              weakSelf.zTheta = zTheta;
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  if (weakSelf.currentArr.count > 0) {
                                                      [weakSelf updataCurrentTagViews];
                                                  }
                                              }];
                                          }
                                      }];
    }
}
#pragma mark --开始定位
- (void)startLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100.0f;
        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    }
}
#pragma mark --画那个黄色的扇形
- (void)drawFanView {
    CGPoint center = CGPointMake(10+60, 20+60);
    float angle_start1 = degreesToRadians(240);
    float angle_end1 = degreesToRadians(300);
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:center];
    [path1 addArcWithCenter:center radius:60 startAngle:angle_start1 endAngle:angle_end1 clockwise:YES];
    CAShapeLayer *shaplayer1 = [CAShapeLayer layer];
    [shaplayer1 setPath:path1.CGPath];
    
    [shaplayer1 setFillColor:[UIColor yellowColor].CGColor];
    [shaplayer1 setZPosition:center.x];
    shaplayer1.opacity = 0.6;
    [self.layer addSublayer:shaplayer1];
}
#pragma mark --创建雷达上面的小点点
- (void)createAzimuthViewtagModel:(HYTagModel *)model{
    CGFloat pointx;
    CGFloat pointy;
    if (model.azimuth > 0 && model.azimuth< 90) {
        CGFloat x = sin(degreesToRadians(model.azimuth))*model.distance;
        CGFloat y = cos(degreesToRadians(model.azimuth))*model.distance;
        pointx = 60+fabs(x);
        pointy = 60-fabs(y);
    }else if (model.azimuth > 90 && model.azimuth <= 180) {
        CGFloat x = sin(degreesToRadians(180-model.azimuth))*model.distance;
        CGFloat y = cos(degreesToRadians(180-model.azimuth))*model.distance;
        pointx = 60+fabs(x);
        pointy = 60+fabs(y);
    }else if (model.azimuth > 180 && model.azimuth <= 270) {
        CGFloat x = sin(degreesToRadians(model.azimuth-180))*model.distance;
        CGFloat y = cos(degreesToRadians(model.azimuth-180))*model.distance;
        pointx = 60-fabs(x);
        pointy = 60+fabs(y);
    }else{
        CGFloat x = sin(degreesToRadians(360-model.azimuth))*model.distance;
        CGFloat y = cos(degreesToRadians(360-model.azimuth))*model.distance;
        pointx = 60-fabs(x);
        pointy = 60-fabs(y);
    }
    
    model.azimuthView.center = CGPointMake(pointx, pointy);
    [self.radarView addSubview:model.azimuthView];
}
#pragma mark -- 更新radarView 影响因素:真北角
- (void)updateRadarView
{
    float headingAngle = -degreesToRadians(_direction);
    self.radarView.transform = CGAffineTransformMakeRotation(headingAngle);
}
#pragma mark -- 更新tagArray 影响因素:真北角 不在视线内的标签要隐藏掉 在视线内的标签要显示出
- (void)updateAllTagViews
{
    for (HYTagModel *model in self.tagArray) {
        [self calculateHiddenOrShowTagView:model];
    }
}
#pragma mark -- 更新currentArr 影响因素:手机与水平面夹角 不在视线内的标签要隐藏掉 在视线内的标签要显示出
- (void)updataCurrentTagViews{
    
    for (HYTagModel *model in self.currentArr) {
        if (_zTheta > 50.0 && _zTheta < 110.0) {
            model.tagView.hidden = NO;
            //纵向视线角度 110-50=60
            CGFloat height = (kScreenHeight+model.width/2.0)/60.0;
            CGFloat y = _zTheta - 50.0;
            CGFloat pointY = y*height;
            CGPoint center = model.tagView.center;
            center.y = pointY-(model.width/2.0)/2.0;
            model.tagView.center = center;
            /**为什么ScreenHeight+model.width/2.0和pointY-(model.width/2.0)/2.0 ？**/
        }else{
            model.tagView.hidden = YES;
            CGPoint center = model.tagView.center;
            model.tagView.center = CGPointMake(center.x, -100);
        }
    }
}
#pragma mark -- 更新单个 影响因素:真北角 不在视线内的标签要隐藏掉 在视线内的标签要显示出
- (void)calculateHiddenOrShowTagView:(HYTagModel *)model {
    if (_direction > 0 && _direction < 30) {
        if (model.azimuth > 330+_direction || model.azimuth < _direction+30) {
            [self showTagView:model];
            [self.currentArr addObject:model];
        }else{
            model.tagView.hidden = YES;
            model.lastDirection = _direction;
            [self.currentArr removeObject:model];
        }
    }else if (_direction >= 30 && _direction < 330) {
        if (model.azimuth > (_direction-30) && model.azimuth < (_direction+30)) {
            [self showTagView:model];
            [self.currentArr addObject:model];
        }else{
            model.tagView.hidden = YES;
            model.lastDirection = _direction;
            [self.currentArr removeObject:model];
        }
    }else{
        if (model.azimuth < _direction-330 || model.azimuth > _direction-30) {
            [self showTagView:model];
            [self.currentArr addObject:model];
            [self.currentArr removeObject:model];
        }else{
            model.tagView.hidden = YES;
            model.lastDirection = _direction;
            [self.currentArr removeObject:model];
        }
    }
}
#pragma mark --从不在视线内的标签移到视线内 还带3d动画
- (void)showTagView:(HYTagModel *)model {
    model.tagView.hidden = NO;
    if (model.azimuth >= 0 && model.azimuth < 30) {
        CGFloat dir = _direction - model.lastDirection;
        if (dir > 0) {
            //从右边出来
            model.lastDirection = -1;
            //横向视线角度60
            CGFloat width = (kScreenWidth+model.width)/60.0;
            CGFloat baseX = 360-fabs(model.azimuth-30);
            CGFloat x;
            if (_direction >= baseX) {
                x = _direction-baseX;
            }else{
                x = (360-baseX)+_direction;
            }
            CGFloat pointX = x*width-(model.width/2.0);
            [self rightToLeftAnimation3D:pointX tagModel:model];
        }else{
            model.lastDirection = 361;
            CGFloat width = (kScreenWidth+model.width)/60.0;
            CGFloat baseX = model.azimuth+30;
            CGFloat x;
            if (_direction > baseX) {
                x = baseX+(360-_direction);
            }else{
                x = baseX-_direction;
            }
            CGFloat pointX = x*width-(model.width/2.0);
            [self leftToRightAnimation3D:pointX tagModel:model];
        }
    }else if (model.azimuth >= 30 && model.azimuth < 330) {
        CGFloat dir = _direction - model.lastDirection;
        if (dir > 0) {
            CGFloat width = (kScreenWidth+model.width)/60.0;
            CGFloat baseX = 30+(model.azimuth-60);
            CGFloat x = _direction-baseX;
            CGFloat pointX = x*width-(model.width/2.0);
            [self rightToLeftAnimation3D:pointX tagModel:model];
        }else{
            CGFloat width = (kScreenWidth+model.width)/60.0;
            CGFloat baseX = 30+model.azimuth;
            CGFloat x = baseX-_direction;
            CGFloat pointX = x*width-(model.width/2.0);
            [self leftToRightAnimation3D:pointX tagModel:model];
        }
    }else{
        CGFloat dir = _direction - model.lastDirection;
        if (dir > 0) {
            model.lastDirection = -1;
            CGFloat width = (kScreenWidth+model.width)/60.0;
            CGFloat baseX = model.azimuth-30;
            CGFloat x;
            if (_direction > baseX) {
                x = _direction-baseX;
            }else{
                x = 360-baseX+_direction;
            }
            CGFloat pointX = x*width-(model.width/2.0);
            [self rightToLeftAnimation3D:pointX tagModel:model];
        }else{
            model.lastDirection = 361;
            CGFloat width = (kScreenWidth+model.width)/60.0;
            CGFloat baseX = 30-fabs(model.azimuth-360);
            CGFloat x;
            if (_direction < baseX) {
                x = baseX-_direction;
            }else{
                x = baseX+360-_direction;
            }
            CGFloat pointX = x*width-(model.width/2.0);
            [self leftToRightAnimation3D:pointX tagModel:model];
        }
    }
}
#pragma mark -- 3D动画 右进左出
- (void)rightToLeftAnimation3D:(CGFloat)pointX tagModel:(HYTagModel *)model {
    CGPoint center = model.tagView.center;
    center.x = kScreenWidth-pointX;
    model.tagView.center = center;
    if (pointX < (model.width/2.0)) {
        CGFloat tx = 60-((60/model.width)*(pointX+(model.width/2.0)));
        CGFloat tz = 30-((30/model.width)*(pointX+(model.width/2.0)));
        CATransform3D transForm1 = CATransform3DIdentity;
        transForm1.m34 = -1.0 / 500.0;
        transForm1 = CATransform3DRotate(transForm1, degreesToRadians(-tz), 0, 0, 1);
        transForm1 = CATransform3DRotate(transForm1, degreesToRadians(-tx), 1, 0, 0);
        model.tagView.layer.transform = transForm1;
    }else if (pointX > kScreenWidth-(model.width/2.0)) {
        CGFloat tx = 60-((60/model.width)*(kScreenWidth-pointX+(model.width/2.0)));
        CGFloat tz = 30-((30/model.width)*(kScreenWidth-pointX+(model.width/2.0)));
        CATransform3D transForm1 = CATransform3DIdentity;
        transForm1.m34 = -1.0 / 500.0;
        transForm1 = CATransform3DRotate(transForm1, degreesToRadians(tz), 0, 0, 1);
        transForm1 = CATransform3DRotate(transForm1, degreesToRadians(tx), 1, 0, 0);
        model.tagView.layer.transform = transForm1;
    }else{
        
    }
}
#pragma mark -- 3D动画 左进右出
- (void)leftToRightAnimation3D:(CGFloat)pointX tagModel:(HYTagModel *)model {
    CGPoint center = model.tagView.center;
    center.x = pointX;
    model.tagView.center = center;
    if (pointX < (model.width/2.0)) {
        CGFloat tx = 60-((60/model.width)*(pointX+(model.width/2.0)));
        CGFloat tz = 30-((30/model.width)*(pointX+(model.width/2.0)));
        CATransform3D transForm1 = CATransform3DIdentity;
        transForm1.m34 = -1.0 / 500.0;
        transForm1 = CATransform3DRotate(transForm1, degreesToRadians(tz), 0, 0, 1);
        transForm1 = CATransform3DRotate(transForm1, degreesToRadians(tx), 1, 0, 0);
        model.tagView.layer.transform = transForm1;
    }else if (pointX > kScreenWidth-(model.width/2.0)) {
        CGFloat tx = 60-((60/model.width)*(kScreenWidth-pointX+(model.width/2.0)));
        CGFloat tz = 30-((30/model.width)*(kScreenWidth-pointX+(model.width/2.0)));
        CATransform3D transForm1 = CATransform3DIdentity;
        transForm1.m34 = -1.0 / 500.0;
        transForm1 = CATransform3DRotate(transForm1, degreesToRadians(-tz), 0, 0, 1);
        transForm1 = CATransform3DRotate(transForm1, degreesToRadians(-tx), 1, 0, 0);
        model.tagView.layer.transform = transForm1;
    }else{
        
    }
}
#pragma mark -- 通过两点的经纬度计算距离
-(float)distanceByMyDot:(CLLocationCoordinate2D)myDot otherDot:(CLLocationCoordinate2D)otherDot {
    double EARTH_RADIUS = 6378137.0;
    
    double radLat1 = (myDot.latitude * M_PI / 180.0);
    double radLat2 = (otherDot.latitude * M_PI / 180.0);
    double a = radLat1 - radLat2;
    double b = (myDot.longitude - otherDot.longitude) * M_PI / 180.0;
    double s = 22 * asin(sqrt(pow(sin(a / 2), 2)
                              + cos(radLat1) * cos(radLat2)
                              * pow(sin(b / 2), 2)));
    s = s * EARTH_RADIUS;
    s = round(s * 10000) / 10000;
    
    return s;
}
#pragma mark -- 通过两点的经纬度计算方位角
- (CGFloat)azimuthByMyDot:(CLLocationCoordinate2D)myDot otherDot:(CLLocationCoordinate2D)otherDot {
    CGFloat fLat = degreesToRadians(myDot.latitude);
    CGFloat fLng = degreesToRadians(myDot.longitude);
    CGFloat tLat = degreesToRadians(otherDot.latitude);
    CGFloat tLng = degreesToRadians(otherDot.longitude);
    
    CGFloat degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    if (degree >= 0) {
        return degree;
    }else{
        return 360+degree;
    }
}
#pragma mark -- 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [_locationManager stopUpdatingLocation];
    static BOOL first = YES;
    if (first) {
        [self addAzimuthViewAtRadarView];
        first = NO;
    }
}
#pragma mark -- 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        NSLog(@"location error: %ld", error.code);
    }
}
#pragma mark -- 手机朝向改变
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(nonnull CLHeading *)newHeading
{
    _direction = newHeading.trueHeading;
    /**为什么要取负值?
     答:因为真北角度是顺时针变大的，而视图旋转角度是逆时针变大的，空间坐标和手机坐标Y轴方向是相反的
     **/
    //    NSLog(@"direction:%.2f      headingAngle:%.2f", _direction,headingAngle);
    float headingAngle = -degreesToRadians(_direction);
    self.radarView.transform = CGAffineTransformMakeRotation(headingAngle);

    for (HYTagModel *model in self.tagArray) {
        [self calculateHiddenOrShowTagView:model];
    }
}
@end
