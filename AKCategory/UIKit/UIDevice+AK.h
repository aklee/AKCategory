//
//  UIDevice+ak.h
//
//  Created by ak on 14-9-24.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Info)

+ (NSDictionary *)systemInfoDict;


/**
 get current APP version depends on info.plist

 @return eg:1.0 (1.0.0)
 */
+ (NSString *)getAppVersion;
@end
