//
//  ViewController.m
//  Demo
//
//  Created by gcy on 2018/3/6.
//  Copyright © 2018年 aklee. All rights reserved.
//

#import "ViewController.h"
#import <AKCategory/AKCategory.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self test];
}
-(void)test{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
#pragma clang diagnostic ignored "-Wunreachable-code"

    NSLog(@"%@",[AKUDID UDID]);//AF46C3FF-C7DD-46F2-9411-29A0D6CDBF51
    return;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ReceiveMessage" ofType:@"m4r"];
    [AKAudioTool playSound:path];
    return;
    [AKAudioTool playSystemSound];
    return;
    [AKAudioTool playVibrate];
    return;
    NSLog(@"%@,%@",[AKFingerTool isSupportTouchID]?@"isSupportTouchID":@"no SupportTouchID",[AKFingerTool enableTouchID]?@"enable":@"disable");
    if([AKFingerTool isSupportTouchID]&&[AKFingerTool enableTouchID]){
        [AKFingerTool check:@"认证指纹啦" fallbackTitle:nil complete:^(int result) {
            NSLog(@"%@",@(result));
        }];
    }
    return;
    //UIDevice+AK
    NSAssert([@"1.0 (1)" isEqualToString:[UIDevice getAppVersion]], @"获取APP版本错误");
    
    UIColor *red=[UIColor redColor];
    NSLog(@"%@ %@",[red sharpString],[red rgbaString]);//#FF0000 rgba(255,0,0,1.000000)
    UIColor *yellow=[UIColor yellowColor];
    UIColor *mixColor=[yellow mix:red];
    UIColor *redL=[red lighten];
    UIColor *redD=[red darken];
    NSLog(@"alpha:%@",@([red alpha]));
#pragma clang diagnostic pop
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
