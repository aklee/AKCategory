//
//  HSRSA.m
//  Breeze
//
//  Created by Gu Jianglai on 13-7-2.
//
//

#import "DGBRSA.h"


@implementation DGBRSA

+ (NSString *)RSAEncryptWithData:(const char *)input Modulus:(const char *)m Exponent:(const char *)e
{
    NSString *s = [NSString stringWithFormat:@"101234567890%02zd%s",strlen(input),input];
    return [super RSAEncryptWithData:[s UTF8String] Modulus:m Exponent:e];
}

@end