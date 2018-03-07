//
//  UIScrollView+AK.m
//  FinancialApp
//
//  Created by ak on 2017/7/5.
//  Copyright © 2017年 ak. All rights reserved.
//

#import "UIScrollView+AK.h"

@implementation UICollectionView(AK)

-(NSInteger)currentIndex{
    if(self.bounds.size.width==0)return 0;
    NSInteger itemCount=[self numberOfItemsInSection:0];
    if (itemCount!=0) {
        return (int)(roundf(self.contentOffset.x/self.bounds.size.width))%itemCount;
    }
    return 0;
}

@end
