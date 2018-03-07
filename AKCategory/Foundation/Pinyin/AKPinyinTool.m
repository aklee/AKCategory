//
//  AKPinyinTool.m
//
//  Created by   ak on 13-12-25.
//  Copyright (c) 2013年 ak. All rights reserved.
//

#import "AKPinyinTool.h"
#import "HanZiPinYin.h"

@implementation AKPinyinTool

+ (NSString *)getFirstChar:(NSString *)hanzi{
    NSString *defaultChar = @"~";
    if (hanzi.length <= 0) {
        return defaultChar;
    }
//    NSString *firstLetter = [[hanzi substringToIndex:1] uppercaseString];
    return [HanZiPinYin getFirstLetter:hanzi];
}

+ (NSString *)getPinyinStringForSort:(NSString *)string enablePinyin:(BOOL)enable {
    if (enable) {
        return [HanZiPinYin getOnePinyinCombination:string];
    } else {
        return string;
    }
}

+ (NSArray *)getAllPinyinArray:(NSString *)string {
    return [HanZiPinYin getAllCharactersPinyin:string];
}

+ (NSArray *)getWordsPinyinAndRangesInfo:(NSString *)string {
    return [HanZiPinYin getWordsPinyinAndRangesInfo:string];
}

@end
