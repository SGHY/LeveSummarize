//
//  NSString+IPhoneType.m
//  LEVE
//
//  Created by BigDataAi on 2017/11/15.
//  Copyright © 2017年 dashuju. All rights reserved.
//

#import "NSString+IPhoneType.h"
#import <sys/utsname.h>

@implementation NSString (IPhoneType)

+ (BOOL)isIPhoneX {
    struct utsname systemInfo;
    uname(&systemInfo);//这个有点耗性能
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"] || [platform isEqualToString:@"x86_64"] || [platform isEqualToString:@"i386"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isVideoType {
    if ([self hasSuffix:@".mp4"] || [self hasSuffix:@".mp3"] || [self hasSuffix:@".avi"] || [self hasSuffix:@".wma"] || [self hasSuffix:@".mov"]) {
        return YES;
    }
    return NO;
}

@end
