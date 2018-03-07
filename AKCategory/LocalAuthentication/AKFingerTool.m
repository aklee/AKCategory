//
//  FingerTool.m
//
//  Created by ak on 2017/5/29.
//  Copyright © 2017年 ak. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AKFingerTool.h"
#import <sys/sysctl.h>
#import <LocalAuthentication/LocalAuthentication.h>
@implementation AKFingerTool
+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+(bool)isSupportTouchID{
    /*
     if ([platform isEqualToString:@"iPhone1,1"])   return @"iPhone1G GSM";
     if ([platform isEqualToString:@"iPhone1,2"])   return @"iPhone3G GSM";
     if ([platform isEqualToString:@"iPhone2,1"])   return @"iPhone3GS GSM";
     if ([platform isEqualToString:@"iPhone3,1"])   return @"iPhone4 GSM";
     if ([platform isEqualToString:@"iPhone3,3"])   return @"iPhone4 CDMA";
     if ([platform isEqualToString:@"iPhone4,1"])   return @"iPhone4S";
     if ([platform isEqualToString:@"iPhone5,1"])   return @"iPhone5";
     if ([platform isEqualToString:@"iPhone5,2"])   return @"iPhone5";
     if ([platform isEqualToString:@"iPhone5,3"])   return @"iPhone 5c (A1456/A1532)";
     if ([platform isEqualToString:@"iPhone5,4"])   return @"iPhone 5c (A1507/A1516/A1526/A1529)";
     if ([platform isEqualToString:@"iPhone6,1"])   return @"iPhone 5s (A1453/A1533)";
     if ([platform isEqualToString:@"iPhone6,2"])   return @"iPhone 5s (A1457/A1518/A1528/A1530)";
     */
    if ([UIDevice currentDevice].systemVersion.floatValue>=8&&
        UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        if([self platform].length > 6 )//simulator -> x86_64
        {
            
            NSString * numberPlatformStr = [[self platform] substringWithRange:NSMakeRange(6, 1)];
            NSInteger numberPlatform = [numberPlatformStr integerValue];
            // 是否是5s以上的设备
            if(numberPlatform > 5)
            {
                return YES;
            }
            else
            {
                return NO;
            }
            
        }
        else
        {
            return NO;
        }
    }
    return NO;
}


+(bool)enableTouchID{
    //检查Touch ID 功能是否可用
    LAContext *context = [LAContext new];
    __block NSString *msg;
    NSError *error;
    BOOL success;
    success = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (success) {
        return YES;
    }
    else
    {
        msg = [NSString stringWithFormat:NSLocalizedString(@"TOUCH_ID_IS_NOT_AVAILABLE", nil)];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone系统设置中开启Touch ID功能，以便使用指纹支付。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    return NO;
}

+(void)check:(NSString*)title fallbackTitle:(NSString*)fallbackTitle complete:(void(^)(int result))complete{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    context.localizedFallbackTitle = fallbackTitle.length>0?fallbackTitle:@"";
    
    /**
     注意两者的区别，
     首先支持的版本不同、
     //LAPolicyDeviceOwnerAuthentication  iOS 9.0 以上
     //kLAPolicyDeviceOwnerAuthenticationWithBiometrics  iOS 8.0以上
     其次输入 密码次数有关
     用kLAPolicyDeviceOwnerAuthenticationWithBiometrics 就好拉
     
     最主要的是，前者  使用“context.localizedFallbackTitle = @"输入登陆密码";”
     上面这个属性的时候，不能按我们设定的要求走，它会直接弹出验证
     
     所以还是用后者，kLAPolicyDeviceOwnerAuthenticationWithBiometrics
     
     */
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:title
                          reply:^(BOOL success, NSError *error)
         {
             if (success)
             {
                 NSLog(@"验证通过");
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (complete) {
                         complete(0);
                     }
                 });
             }
             else
             {
                 switch (error.code)
                 {
                         
                     case LAErrorUserCancel:
                         //认证被用户取消.例如点击了 cancel 按钮.
                         NSLog(@"密码取消");
                         break;
                         
                     case LAErrorAuthenticationFailed:
                         // 此处会自动消失，然后下一次弹出的时候，又需要验证数字
                         // 认证没有成功,因为用户没有成功的提供一个有效的认证资格
                         NSLog(@"连输三次后，密码失败");
                         break;
                         
                     case LAErrorPasscodeNotSet:
                         // 认证不能开始,因为此台设备没有设置密码.
                         NSLog(@"密码没有设置");
                         break;
                         
                     case LAErrorSystemCancel:
                         //认证被系统取消了(例如其他的应用程序到前台了)
                         NSLog(@"系统取消了验证");
                         break;
                         
                     case LAErrorUserFallback:
                         //当输入觉的会有问题的时候输入
                         NSLog(@"请输入密码");
                         break;
                     case LAErrorTouchIDNotAvailable:
//                     case LAErrorBiometryNotAvailable:
                         //认证不能开始,因为 touch id 在此台设备尚是无效的.
                         NSLog(@"touch ID 无效");
                         
                     default:
                         NSLog(@"您不能访问私有内容");
                         break;
                 } 
                 if (error.code==LAErrorUserFallback) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (complete) {
                             complete(1);
                         }
                     });
                     
                 }else{
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (complete) {
                             complete(2);
                         }
                     });
                 }
                 
             }
         }];
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"您的Touch ID 设置 有问题" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                alert.message = @"您还没有进行指纹输入，请指纹设定后打开";
                break;
            case  LAErrorTouchIDNotAvailable:
                alert.message = @"您的设备不支持指纹输入，请切换为数字键盘";
                break;
            case LAErrorPasscodeNotSet:
                alert.message = @"您还没有设置密码输入";
                break;
            default:
                break;
        }
        [alert show];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(3);
            }
        });
    }
}
@end
