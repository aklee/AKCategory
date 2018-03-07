//
//  HSRSA.m
//  Breeze
//
//  Created by Gu Jianglai on 13-7-2.
//
//

#import "HSRSA.h"

#import <openssl/pem.h>
#import <openssl/err.h>

@implementation HSRSA

+ (NSString *)RSAEncryptWithData:(const char *)input Modulus:(const char *)m Exponent:(const char *)e
{
    char *p_en;
    int flen,rsa_len;
    
    RSA * rsa_pub = RSA_new();

    
    if (!BN_hex2bn(&rsa_pub->n, m)) {
        return @"";
    }
    
    
    if (!BN_hex2bn(&rsa_pub->e, e)) {
        return @"";
    }
    
    flen = strlen(input);
    rsa_len = RSA_size(rsa_pub);
    p_en = (char *)malloc(rsa_len + 1);
    memset(p_en, 0, rsa_len + 1);

    
    if(RSA_public_encrypt(flen, (unsigned char *)input, (unsigned char *)p_en, rsa_pub, RSA_PKCS1_PADDING)<0)
    {
        return @"";
    }
    
    RSA_free(rsa_pub);
    NSMutableString *result = [NSMutableString string];
    for (int i=0; i<rsa_len; i++) {
        [result appendFormat:@"%02X",(UInt8)p_en[i]];
    }
    free(p_en);
    return result;
}

@end