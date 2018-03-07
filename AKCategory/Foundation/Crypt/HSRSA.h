//
//  HSRSA.h
//
//  Created by ak on 13-7-2.
//
//

#import <Foundation/Foundation.h>

@interface HSRSA : NSObject

+ (NSString *)RSAEncryptWithData:(const char *)input Modulus:(const char *)m Exponent:(const char *)e;

@end
