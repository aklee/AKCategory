//
//  AKPinyinTool.h
//
//  Created by ak on 13-12-25.
//  Copyright (c) 2013年 ak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKPinyinTool : NSObject
/**
 获取首字符

 @param NSString  首字母拼音 eg：陈(C) apple(A)  其他(~)
 @return 大写英文字符
 */
+ (NSString *)getFirstChar:(NSString *)string;
+ (NSString *)getPinyinStringForSort:(NSString *)string enablePinyin:(BOOL)enable;
+ (NSArray *)getAllPinyinArray:(NSString *)string;
+ (NSArray *)getWordsPinyinAndRangesInfo:(NSString *)string;

@end
