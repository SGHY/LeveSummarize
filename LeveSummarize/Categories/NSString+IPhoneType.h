//
//  NSString+IPhoneType.h
//  LEVE
//
//  Created by BigDataAi on 2017/11/15.
//  Copyright © 2017年 dashuju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IPhoneType)

+ (BOOL)isIPhoneX;
/**
 * 判断是否是视频
 */
- (BOOL)isVideoType;

@end
