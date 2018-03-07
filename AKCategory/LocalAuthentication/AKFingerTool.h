//
//  FingerTool.h 
//
//  Created by ak on 2017/5/29.
//  Copyright © 2017年 ak. All rights reserved.

#import <Foundation/Foundation.h>

@interface AKFingerTool : NSObject

/**
 设备是否支持touchID
 //5s及以上
 //8.0及以上
 //iphone  不支持ipad

 @return 是否
 */
+(bool)isSupportTouchID;

/**
 设备是否启用touchID

 @return 是否
 */
+(bool)enableTouchID;


/**
 验证指纹

 @param callback 回调，result 0失败 1成功 2输入交易密码
 @param title 多选标题（title,"取消"）
 */

/**
 验证指纹

 @param title 标题
 @param fallbackTitle 其他选项标题
 @param complete 完成回调 result：0成功 1其他选项 2取消 3touchID有问题
 */
+(void)check:(NSString*)title fallbackTitle:(NSString*)fallbackTitle complete:(void(^)(int result))complete;
@end
