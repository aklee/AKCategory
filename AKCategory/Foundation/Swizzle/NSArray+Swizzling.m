//
//  UIView+AK.m
//
//  Created by AK Lee on 14-5-26.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import "JRSwizzle.h"

@implementation NSArray (Swizzling)
 
#pragma Swizzling
+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSLog(@"NSArray-Swizzling");


#if DEBUG
        /*
         这里的NSArray是一种特殊的类，英文叫做Class cluster，中文翻译过来是类簇，在设计模式中，这个叫做工厂类，它在外层提供了很多方法接口，但是这些方法的实现是由具体的内部类来实现的。当使用NSArray生成一个对象时，初始化方法会判断哪个“自己内部的类”最适合生成这个对象，然后这个“工厂”就会生成这个具体的类对象返回给你。这种又外层类提供统一抽象的接口，然后具体实现让隐藏的，具体的内部类来实现，在设计模式中称为“抽象工厂”模式。
         
         也就是说，对于普通的类，我们使用上述方法是没有问题的，然而对于Class cluster这种工厂类，就需要找到它的真身才行。
         */
        /*
        NSLog(@"akak:%@", [NSArray class]);
        NSLog(@"akak:%@", [[NSArray array] class]);
        NSLog(@"akak:%@", [[NSMutableArray array] class]);
         */
        /*
        output:
        2015-11-03 18:57:49.916 JiuCai[37517:1185574] akak:NSArray
        2015-11-03 18:57:49.916 JiuCai[37517:1185574] akak:__NSArray0
        2015-11-03 18:57:49.917 JiuCai[37517:1185574] akak:__NSArrayM
         */
        
#endif
        /*
         借助jr_swizzleMethod
         */
        
//        NSError* err1;NSError*err2; NSError*err3;
        SEL m1= @selector(objectAtIndex:);
        
        SEL m2=@selector(myCustomobjectAtIndex_NSMutableArray:);
       
//        SEL m3=@selector(myCustomobjectAtIndex_NSArray:);
//        
//        SEL m4=@selector(myCustomobjectAtIndex_NSArrayI:);
        
        [[[NSArray array] class] jr_swizzleMethod:m1 withMethod:m2 error:nil];
        
        [[[NSMutableArray array] class] jr_swizzleMethod:m1 withMethod:m2 error:nil];
        
        
         Class  cls =    NSClassFromString(@"__NSArrayI");
        
        [[cls class] jr_swizzleMethod:m1 withMethod:m2 error:nil];
    
//        if (err1||err2||err3) {
//            NSLog(@"%@ %@ %@",err1,err2,err3);
//        }
        
        
        /*
         NSMutableArray ,NSArray
         不可以共用自定义的实现方法 所以需要重复定义destMethod  m1,m2,m3,m4
         */

/*
 
         SEL m1= @selector(objectAtIndex:);
         
         SEL m2=@selector(myCustomobjectAtIndex_NSMutableArray:);
         
         SEL m3=@selector(myCustomobjectAtIndex_NSArray:);
         
         SEL m4=@selector(myCustomobjectAtIndex_NSArrayI:);
 
        Method originMethod2=class_getInstanceMethod([[NSArray array] class], m1);
        Method destMethod2=class_getInstanceMethod([[NSArray array ] class], m3);
        method_exchangeImplementations(originMethod2, destMethod2);
        
        
        
        Method originMethod=class_getInstanceMethod([[NSMutableArray array] class], m1);
        Method destMethod=class_getInstanceMethod([[NSMutableArray array ] class], m2);
        method_exchangeImplementations(originMethod, destMethod);
        
        
    
        if (cls) {
            Method originMethod=class_getInstanceMethod([cls class], m1);
            Method destMethod=class_getInstanceMethod([cls class], m4);
            method_exchangeImplementations(originMethod, destMethod);
        }
  */
        
        
    });
}


//static char kCustomBackButtonKey ;

-(id)myCustomobjectAtIndex_NSMutableArray:(NSUInteger)index{
    @autoreleasepool {
        
    
    //    防止数组越界 crush！
    if (self.count>index) {
        
        return [self myCustomobjectAtIndex_NSMutableArray:index];
    }
   
    return nil;
         }
}
//
//-(id)myCustomobjectAtIndex_NSArray:(NSUInteger)index{
//    
//    //    防止数组越界 crush！
//    if (self.count>index) {
//        
//        return [self myCustomobjectAtIndex_NSArray:index];
//    }
//    
//    return nil;
//}
//
//-(id)myCustomobjectAtIndex_NSArrayI:(NSUInteger)index{
//    
//    //    防止数组越界 crush！
//    if (self.count>index) {
//        
//        return [self myCustomobjectAtIndex_NSArrayI:index];
//    }
//    
//    return nil;
//}
//
//
//-(void)dealloc{
////    objc_removeAssociatedObjects(self);
//}

 @end
