//  AKCryption.h
//
//  Created by ak on 15/05/15.
//  Copyright (c) 2015 ak. All rights reserved.
//

#import "AKCryption.h"
#import <openssl/md5.h>
#import <openssl/des.h>
#import <openssl/evp.h>
#import <openssl/bio.h>
#import <CommonCrypto/CommonDigest.h>
#import "Base64.h"
#import "HSRSA.h"

@implementation AKCryption


+ (NSString*)base64Encode:(NSString*)input{
    return [Base64 encodeString:input];
}
+ (NSString*)base64Decode:(NSString*)input{
    return [Base64 decodeString:input];
} 

#pragma mark -
#pragma mark implementation of md5
+ (NSString *)calcMD5:(NSString *)input
{
	NSLog(@"string before md5: [%@]",input);
	unsigned char result[16];//结果临时变量
	MD5((unsigned char*)[[input dataUsingEncoding:NSUTF8StringEncoding] bytes], [input length], result);//计算MD5
	NSMutableString *output = [[NSMutableString alloc] initWithCapacity:1];//结果变量
	int i;
	for (i = 0; i < 16; i++)//循环输出，将结果装换为十六进制字符串
	{
		[output appendFormat:@"%02X", result[i]];
	}
	NSLog(@"string after md5: [%@]",output);
	
	return output;
}

+(NSString*)fileMD5:(NSData*)data
{
    if( !data || ![data length] ) {
		return @"";
	}
    
    unsigned char result[16];    
    CC_MD5([data bytes], [data length], result);
    
    NSString *s = [NSString stringWithFormat:
                   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                   result[0], result[1], result[2], result[3],
                   result[4], result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11],
                   result[12], result[13], result[14], result[15]];
    return s;
}

#pragma mark -
#pragma mark implementation of DES&3DES
+ (NSString *)encryptWithDES:(NSString *)input key:(NSString *)key
{	
	BIO *bio, *mbio, *cbio;//bio
    unsigned char *dst;//cstring结果
    int outlen;//结果长度
//	NSLog(@"endes key: [%@] input:[%@]",key ,input);
    
	//初始化
	mbio = BIO_new( BIO_s_mem( ) );
    cbio = BIO_new( BIO_f_cipher( ) );
	
	//设置密钥和算法
	const unsigned char *k=(const unsigned char *)[key cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_set_cipher( cbio, EVP_des_ecb( ), k , NULL , kEncode );
    bio = BIO_push( cbio , mbio );
	
	//设置输入串和长度
	const unsigned char *inbuf=(const unsigned char *)[input cStringUsingEncoding:NSUTF8StringEncoding];
	int inlen=[input lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    BIO_write( bio , inbuf , inlen );
	
	//计算
    BIO_flush( bio );
	outlen = BIO_get_mem_data( mbio , (unsigned char **)&dst );
    
    
    
    
// 方法1   再进行base64 转换成字符串
 
    NSData * data = [Base64 Base64EncodeWithChars:dst length:outlen];
    NSString*output= [[NSString alloc] initWithData:data   encoding:NSUTF8StringEncoding];
 
    
//或者方法2    转换成16进制
//	NSMutableString *output = [[[NSMutableString alloc] initWithCapacity:16] ];//返回变量
//	int i;
//	for (i = 0; i < outlen; i++)//循环输出，将结果装换为十六进制字符串
//	{
//		[output appendFormat:@"%02X", dst[i]];
//	}
//	NSLog(@"string after endes: [%@]",output);
	

    
	BIO_free_all( bio );//清理
	
    
    

    
	return output;
}

+ (NSString *)decryptWithDES:(NSString *)input key:(NSString *)key
{

 
	BIO *bio, *mbio, *cbio;//bio
    unsigned char *dst;//cstring结果
    int outlen;//结果长度
	
//	NSLog(@"dedes key: [%@] input:[%@]",key ,input);
    
//	方法1
    NSData*  inData=[Base64 decode:input];

//或者	方法2  十六进制字符串转普通串
//	NSMutableData *inData=[[NSMutableData alloc] initWithCapacity:256]; //存放转换后的数据
//	int index;
//	for (index=0; index<[input length]; index+=2) {
//		const char *buff=[[input substringWithRange:NSMakeRange(index, 2)] cStringUsingEncoding:NSASCIIStringEncoding];
//		unsigned char n=((buff[0]>='0'&&buff[0]<='9')?buff[0]-'0':((buff[0]>='a'&&buff[0]<='f')?buff[0]-'a':buff[0]-'A')+10)*16
//        +((buff[1]>='0'&&buff[1]<='9')?buff[1]-'0':((buff[1]>='a'&&buff[1]<='f')?buff[1]-'a':buff[1]-'A')+10);
//		[inData appendBytes:&n length:1];
//	}
	

    
    
	//初始化bio
    mbio = BIO_new( BIO_s_mem( ) );
    cbio = BIO_new( BIO_f_cipher( ) );
	
	//设置密钥和算法
	const unsigned char *k=(const unsigned char *)[key cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_set_cipher( cbio, EVP_des_ecb( ), k , NULL , kDecode );	
    bio = BIO_push( cbio , mbio );
	
	//设置输入串和长度
	int inlen = [inData length];
	unsigned char *inbuf=(unsigned char *)malloc(inlen);
	[inData getBytes:inbuf];
    BIO_write( bio , inbuf , inlen );
	
	//计算
	BIO_flush( bio );
    outlen = BIO_get_mem_data( mbio , (unsigned char **)&dst );
    
    
	NSString *output = [[NSString alloc] initWithBytes:dst length:outlen encoding:NSUTF8StringEncoding];//设置返回结果
	
//	NSLog(@"string after dedes: [%@] %p",output,output);
	
	//清理
	BIO_free_all( bio );
//	[inData release];
	free(inbuf);
	
	return output;
}

+ (NSString *)encryptWithTripleDES:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
{
	BIO *bio, *mbio, *cbio;//bio
    unsigned char *dst;//cstring结果
    int outlen;//结果长度
	
	NSLog(@"en3des:key1[%@] key2[%@] key3[%@] input[%@]",key1,key2,key3,input);
	//用key1加密
	//初始化
	mbio = BIO_new( BIO_s_mem( ) );
    cbio = BIO_new( BIO_f_cipher( ) );
	
	//设置密钥和算法
	const unsigned char *k1=(const unsigned char *)[key1 cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_set_cipher( cbio, EVP_des_ecb( ), k1 , NULL , kEncode );
    bio = BIO_push( cbio , mbio );
	
	//设置输入串和长度
	const unsigned char *inbuf=(const unsigned char *)[input cStringUsingEncoding:NSUTF8StringEncoding];
	int inlen=[input lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    BIO_write( bio , inbuf , inlen );
	
	//计算
    BIO_flush( bio );
	outlen = BIO_get_mem_data( mbio , (unsigned char **)&dst );
	
	unsigned char *buff = (unsigned char *)malloc(outlen);
	memcpy(buff,dst,outlen);
	
	//清理
	BIO_free_all( bio );
	
	
	//用key2解密
	//初始化bio
    mbio = BIO_new( BIO_s_mem( ) );
    cbio = BIO_new( BIO_f_cipher( ) );
	
	//设置密钥和算法
	const unsigned char *k2=(const unsigned char *)[key2 cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_set_cipher( cbio, EVP_des_ecb( ), k2 , NULL , kDecode );	
    bio = BIO_push( cbio , mbio );
	
	//设置输入串和长度
	inlen = outlen;//输入长度等于上次输出长度
    BIO_write( bio , buff , inlen );
	
	//计算
	BIO_flush( bio );
    outlen = BIO_get_mem_data( mbio , (unsigned char **)&dst );
	free(buff);
	buff = (unsigned char *)malloc(outlen);
	memcpy(buff,dst,outlen);
	
	//清理
	BIO_free_all( bio );
	
	
	//用key3加密
	//初始化bio
    mbio = BIO_new( BIO_s_mem( ) );
    cbio = BIO_new( BIO_f_cipher( ) );
	
	//设置密钥和算法
	const unsigned char *k3=(const unsigned char *)[key3 cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_set_cipher( cbio, EVP_des_ecb( ), k3 , NULL , kEncode );	
    bio = BIO_push( cbio , mbio );
	
	//设置输入串和长度
	inlen = outlen;//输入长度等于上次输出长度
    BIO_write( bio , buff , inlen );
	
	//计算
	BIO_flush( bio );
    outlen = BIO_get_mem_data( mbio , (unsigned char **)&dst );
	
	//编码输出
	NSMutableString *output = [[NSMutableString alloc] initWithCapacity:16];//返回变量
	int i;
	for (i = 0; i < outlen; i++)//循环输出，将结果装换为十六进制字符串
	{
		[output appendFormat:@"%02X", dst[i]];
	}
	NSLog(@"string after en3des: [%@]",output);
	
	//清理
	free(buff);
	BIO_free_all( bio );
	
	return output;
}

+ (NSString *)decryptWithTripleDES:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
{
	BIO *bio, *mbio, *cbio;//bio
    unsigned char *dst;//cstring结果
    int outlen;//结果长度
	
	NSLog(@"de3des:key1[%@] key2[%@] key3[%@] input[%@]",key1,key2,key3,input);
	
	//十六进制字符串转普通串
	NSMutableData *inData=[[NSMutableData alloc] initWithCapacity:256]; //存放转换后的数据
	int index;
	for (index=0; index<[input length]; index+=2) {
		const char *buff=[[input substringWithRange:NSMakeRange(index, 2)] cStringUsingEncoding:NSASCIIStringEncoding];
		unsigned char n=((buff[0]>='0'&&buff[0]<='9')?buff[0]-'0':((buff[0]>='a'&&buff[0]<='f')?buff[0]-'a':buff[0]-'A')+10)*16
		+((buff[1]>='0'&&buff[1]<='9')?buff[1]-'0':((buff[1]>='a'&&buff[1]<='f')?buff[1]-'a':buff[1]-'A')+10);
		[inData appendBytes:&n length:1];
	}
	//用key3解密
	//初始化bio
    mbio = BIO_new( BIO_s_mem( ) );
    cbio = BIO_new( BIO_f_cipher( ) );
	
	//设置密钥和算法
	const unsigned char *k3=(const unsigned char *)[key3 cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_set_cipher( cbio, EVP_des_ecb( ), k3 , NULL , kDecode );	
    bio = BIO_push( cbio , mbio );
	
	//设置输入串和长度
	int inlen = [inData length];
	unsigned char *inbuf=(unsigned char *)malloc(inlen);
	[inData getBytes:inbuf];
    BIO_write( bio , inbuf , inlen );
	
	//计算
	BIO_flush( bio );
    outlen = BIO_get_mem_data( mbio , (unsigned char **)&dst );
	unsigned char *buff = (unsigned char *)malloc(outlen);
	memcpy(buff,dst,outlen);
	
	//清理
	BIO_free_all( bio );
	[inData release];
	free(inbuf);
	
	//用key2加密
	//初始化bio
    mbio = BIO_new( BIO_s_mem( ) );
    cbio = BIO_new( BIO_f_cipher( ) );
	
	//设置密钥和算法
	const unsigned char *k2=(const unsigned char *)[key2 cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_set_cipher( cbio, EVP_des_ecb( ), k2 , NULL , kEncode );	
    bio = BIO_push( cbio , mbio );
	
	//设置输入串和长度
	inlen = outlen;//输入长度等于上次输出长度
    BIO_write( bio , buff , inlen );
	
	//计算
	BIO_flush( bio );
    outlen = BIO_get_mem_data( mbio , (unsigned char **)&dst );
	free(buff);
	buff = (unsigned char *)malloc(outlen);
	memcpy(buff,dst,outlen);
	
	//清理
	BIO_free_all( bio );
	
	//用key1解密
	//初始化bio
    mbio = BIO_new( BIO_s_mem( ) );
    cbio = BIO_new( BIO_f_cipher( ) );
	
	//设置密钥和算法
	const unsigned char *k1=(const unsigned char *)[key1 cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_set_cipher( cbio, EVP_des_ecb( ), k1 , NULL , kDecode );	
    bio = BIO_push( cbio , mbio );
	
	//设置输入串和长度
	inlen = outlen;//输入长度等于上次输出长度
    BIO_write( bio , buff , inlen );
	
	//计算
	BIO_flush( bio );
    outlen = BIO_get_mem_data( mbio , (unsigned char **)&dst );
	
	//编码输出
	NSString *output = [[NSString alloc] initWithBytes:dst length:outlen encoding:NSUTF8StringEncoding];//设置返回结果
	
	NSLog(@"string after de3des: [%@]",output);
	//清理
	free(buff);
	BIO_free_all( bio );
	
	
	return @"";
}

#pragma mark - RSA
+ (NSString *)encryptWithRSA:(NSString *)input Modulus:(NSString *)m Exponent:(NSString *)e
{
    
    NSDictionary *dict = @{
                           @"Class":@"HSRSA",
                           @"Modulus":@"hundsun",
                           @"Exponent":@"hundsun"
                           };//[[Configuration configuration] RSADict];
    if (!dict) {
        return input;
    }
    NSString *className = [dict objectForKey:@"Class"];
    Class c = NSClassFromString(className);
    if (!c) {
        return input;
    }
    if([c isSubclassOfClass:[HSRSA class]])
    {
        NSString *M = [dict objectForKey:@"Modulus"];
        NSString *E = [dict objectForKey:@"Exponent"];
        if ([m length]>0) {
            M = m;
        }
        if ([e length]>0) {
            E = e;
        }
        NSString *result = [c RSAEncryptWithData:[input UTF8String] Modulus:[M UTF8String] Exponent:[E UTF8String]];
        NSLog(@"%@",result);
        if([result length]>0)
            return result;
        else
            return input;
    }
    return input;
}


@end
