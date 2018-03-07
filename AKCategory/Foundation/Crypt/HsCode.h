/******************************************************************
 文件名称: HsCode.h
 系统名称: 手机银行
 模块名称: 客户端
 类 名 称: HsCode
 软件版权: 恒生电子股份有限公司
 功能说明: 
 系统版本: 
 开发人员: si xin
 开发时间: 09-8-13
 审核人员:
 相关文档:
 修改记录: 需求编号 修改日期 修改人员 修改说明
 
 ******************************************************************/


#import <Foundation/Foundation.h>

@interface HsCode : NSObject {
	
}

//加密算法,请保证密钥长度是8,否则后果自负
+ (NSString *)decode3Des:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;
+ (NSString *)encode3Des:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;

+ (NSData *)dataEncode3Des:(NSData *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;

+ (NSData *)dataDecode3Des:(NSData *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;

@end