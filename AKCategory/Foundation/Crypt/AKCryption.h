
//  AKCryption.h
//
//  Created by ak on 15/05/15.
//  Copyright (c) 2015 ak. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "md5.h"
//#import "des.h"
//#import "evp.h"
//#import "bio.h"

#define kEncode 1
#define kDecode 0

@interface AKCryption : NSObject {
    
}
+ (NSString*)base64Encode:(NSString*)input;
+ (NSString*)base64Decode:(NSString*)input;
//MAKR:对称加密
//32位大写MD5
+ (NSString *)calcMD5:(NSString *)input;
+ (NSString *)fileMD5:(NSData *)input;
+ (NSString *)encryptWithDES:(NSString *)input key:(NSString *)key;
+ (NSString *)decryptWithDES:(NSString *)input key:(NSString *)key;
+ (NSString *)encryptWithTripleDES:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;
+ (NSString *)decryptWithTripleDES:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;

//MAKR:非对称加密
+ (NSString *)encryptWithRSA:(NSString *)input Modulus:(NSString *)m Exponent:(NSString *)e;

@end
