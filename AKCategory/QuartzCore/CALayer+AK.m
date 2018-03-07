//
//  CALayer+AK.m
//
//  Copyright (c) 2015年 ak. All rights reserved.
//

#import "CALayer+AK.h"

@implementation CALayer (AK)


/*
 *  摇动
 */
-(void)shake{
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    CGFloat s = 16;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    kfa.duration = .1f;
    
    //重复
    kfa.repeatCount =2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}

@end
