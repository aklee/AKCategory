//
//  AKUDID.h
//
//  Created by ak on 15/7/6.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKUDID : NSObject
//设备唯一标识，app被删除后下次获取也相同
+ (NSString *)UDID;
+ (NSString *)UDID:(NSString*)key;
@end
