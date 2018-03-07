//
//  GZIP.h
//
//  Version 1.1.1
//
//  Created by Nick Lockwood on 03/06/2012.
//  Copyright (C) 2012 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/GZIP
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import <Foundation/Foundation.h>


@interface NSData (GZIP)

- (nullable NSData *)gzippedDataWithCompressionLevel:(float)level;
- (nullable NSData *)gzippedData;
- (nullable NSData *)gunzippedData;
- (BOOL)isGzippedData;
// Return hex string of NSData.
- (nullable NSString *)hexademicalString;


/**
 * 数组转换成十六进制字符串
 */
- (nullable NSString*)hexString;

//十六进制字符串转换成NSData      Hex String->NSData
+ (nullable NSData *)dataFromHexStr:(nullable NSString *)str;

// 十六进制转换为普通字符串的
+ (nullable NSString *)stringFromHexString:(nullable NSString *)hexString;

//普通字符串转换为十六进制的
+ (nullable NSString *)hexStringFromString:(nullable NSString *)string;








@end
