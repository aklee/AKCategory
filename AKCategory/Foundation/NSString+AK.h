//
//  NSString+AK.h
//
//  Created by ak  on 15/7/29.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//  常用字符串正则比较

#import <Foundation/Foundation.h>

@interface NSString (AK)
+ (NSString *)urlEncodeWithEncoding:(NSStringEncoding)encoding string:(NSString *)string ;

//MARK:Regex
- (BOOL)isEmail;

- (BOOL)isMobileNumber;

//字符串内只包括1-9纯数字
- (BOOL)isNumber;

//字符串内只包括0-9纯数字
- (BOOL)isNumberInclude0;

//是否6位数字交易密码
- (BOOL)isTradePwd;
 

- (BOOL)isPersonalID;

//0到18位长度 并且仅包括 数字 或 x 或 X
- (BOOL)isPersonalIDWithX;

//密码强度匹配:6-16位 数字和字符组合
- (BOOL)isLoginPwd;

//精确到小数点2位
- (BOOL)isDecimal;
@end
