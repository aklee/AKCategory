//
//  AKAudioTool.m
//
//  Created by ak on 13-12-24.
//  Copyright (c) 2013年 p. All rights reserved.
//

#import "AKAudioTool.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UILocalNotification.h>
#import <UIKit/UIApplication.h>

static void systemAudioCallback(SystemSoundID mySSID, void *clientData) {
    AudioServicesDisposeSystemSoundID(mySSID);
}

@implementation AKAudioTool

+ (void)playSound:(NSString *)filePath {
    if (!filePath)
        return;
    
    NSURL *filePathUrl = [NSURL fileURLWithPath:filePath isDirectory:NO];
    if (filePathUrl) {
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePathUrl, &soundId);
        AudioServicesAddSystemSoundCompletion(soundId, nil, nil, systemAudioCallback, nil);
        AudioServicesPlaySystemSound(soundId);
    }
    
}

+ (void)playSystemSound {
    AudioServicesPlaySystemSound(1006);
}

+ (void)playVibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
