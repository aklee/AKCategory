//
//  AKAudioTool.h
//
//  Created by ak on 13-12-24.
//  Copyright (c) 2013年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKAudioTool : NSObject

// 播放声音
+ (void)playSound:(NSString *)filePath;

// 播放系统声音
+ (void)playSystemSound;

// 振动
+ (void)playVibrate;

@end
