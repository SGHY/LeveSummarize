//
//  HYCaptureViewController.m
//  HYMetadataFaceDemo
//
//  Created by BigDataAi on 2017/12/15.
//  Copyright © 2017年 BigDataAi. All rights reserved.
//

#import "HYCaptureViewController.h"

#define NeedImageTime 1

@interface HYCaptureViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

/**
 *  AVFoundation捕捉类的中心枢纽,用于捕捉视频和音频，协调视频和音频的输入和输出流
 */
@property (nonatomic,strong) AVCaptureSession *captureSession;
/**
 *  输入  使用AVCaptureDeviceInput让设备添加到session中,AVCaptureDeviceInput负责管理设备端口(视频输入和音频输入) 也就说麦克风,摄像头都是它管理
 */
@property (nonatomic,strong) AVCaptureDeviceInput *videoDeviceInput;
/**
 *  可以对视频流进行实时处理    AVCaptureMovieFileOutput不可以
 */
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoDataOutput;
/**
 *  CALayer 的子类，自动显示相机产生的实时图像
 */
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic,strong) UIView *preview;
/**
 *  设置YES不允许自动旋转  需要考虑设备旋转  默认NO
 */
@property (nonatomic,assign) BOOL useDeviceOrientation;


@end

@implementation HYCaptureViewController

- (void)dealloc {
    NSLog(@"dealloc_____%@",[self class]);
    [self stopCaptureSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    NSError *error;
    [self setupSession:&error];
    if (!error) {
        [self.view addSubview:self.preview];
        [self setupCaptureVideoPreviewLayer];
    } else {
        NSLog(@"error：%@",error);
    }
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(20.f, 35.f, 35.f, 35.f);
//    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
//    [button setTitle:@"返回" forState:UIControlStateNormal];
//    button.hidden = YES;
//    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraTap:)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
}

#pragma mark -- 双击切换摄像头
- (void)cameraTap:(UITapGestureRecognizer *)tap {
    [self switchCameras];
}

#pragma mark -- 能否切换摄像头
- (BOOL)canSwitchCameras {
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1;
}

#pragma mark -- 切换摄像头方法
- (BOOL)switchCameras {
    if (![self canSwitchCameras]) {
        return NO;
    }
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        [self.captureSession beginConfiguration];
        [self.captureSession removeInput:self.videoDeviceInput];
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.videoDeviceInput = videoInput;
        } else {
            [self.captureSession addInput:self.videoDeviceInput];
        }
        [self.captureSession commitConfiguration];
    } else {
        NSLog(@"error: %@",error);
        return NO;
    }
    return YES;
}

#pragma mark -- inactiveCamera 获取活跃设备
- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *device = nil;
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1) {
        if (self.videoDeviceInput.device.position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    } else {
        NSLog(@"获取活跃设备失败");
    }
    return device;
}

#pragma mark -- cameraWithPosition 切换摄像头之后重新捕捉设备
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark -- 配置captureSession
- (void)setupSession:(NSError **)error {
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (videoInput) {
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.videoDeviceInput = videoInput;
        }
    } else {
        NSLog(@"添加视频输入失败");
    }
    
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey: (id)kCVPixelBufferPixelFormatTypeKey];
    [self.videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
    } else {
        NSLog(@"添加视频输出失败");
    }
    
    [self.captureSession startRunning];
}

#pragma mark -- AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

#pragma mark -- 初始化preview
- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height)];
        _preview.backgroundColor = [UIColor clearColor];
    }
    return _preview;
}

#pragma mark -- 初始化captureVideoPreviewLayer CALayer 的子类，自动显示相机产生的实时图像
- (void)setupCaptureVideoPreviewLayer {
    CGRect bounds = self.preview.layer.bounds;
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureVideoPreviewLayer.bounds = bounds;
    self.captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    [self.preview.layer addSublayer:self.captureVideoPreviewLayer];
    self.captureVideoPreviewLayer.connection.videoOrientation = [self orientationForConnection];
    if (![self.captureVideoPreviewLayer.connection isEnabled]) {
        [self.captureVideoPreviewLayer.connection setEnabled:YES];
    }
}

#pragma mark -- orientationForConnection 设备取向
- (AVCaptureVideoOrientation)orientationForConnection {
    AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
    if (self.useDeviceOrientation) {
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationLandscapeLeft:
                // yes to the right, this is not bug!
                videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            case UIDeviceOrientationLandscapeRight:
                videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            default:
                videoOrientation = AVCaptureVideoOrientationPortrait;
                break;
        }
    } else {
        switch ([[UIApplication sharedApplication] statusBarOrientation]) {
            case UIInterfaceOrientationLandscapeLeft:
                videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            case UIInterfaceOrientationLandscapeRight:
                videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            default:
                videoOrientation = AVCaptureVideoOrientationPortrait;
                break;
        }
    }
    return videoOrientation;
}

#pragma mark -- 返回按钮点击事件
- (void)buttonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -- 停止捕捉
- (void)stopCaptureSession {
    if (self.captureSession.isRunning) {
        [self.captureSession stopRunning];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
