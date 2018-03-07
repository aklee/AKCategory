//
//  UIKitMock.m
//  AKCategoryTests
//
//  Created by gcy on 2018/3/6.
//  Copyright © 2018年 aklee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BaseTestCase.h"
#import <AKCategory/AKCategory.h>
@interface UIKitMock : BaseTestCase

@end

@implementation UIKitMock

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
//MARK:
- (void)testUIView{
}

- (void)testDeviceInfo{
    NSLog(@"%@",[UIDevice getAppVersion]);
}

-(void)testImage{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    CGSize size = CGSizeMake(100, 50);
    UIColor *c = [UIColor blueColor];
    UIColor *red = [UIColor redColor];
    UIImage *img = [UIImage imageWithRectSize:size fillColor:c];
    UIImage *img2 = [UIImage imageWithEllipseSize:size fillColor:c];
    UIImage *img3 = [UIImage imageWithEllipseSize:size strokeColor:red fillColor:c];
    UIImage *img4 = [UIImage imageWithStarSize:10 strokeColor:red fillColor:c];
    
//    UIImage *img5 = [img imageWithTintColor:c];
//    UIImage *img6 = [img imageWithGradientTintColor:c];
 
#pragma clang diagnostic pop
    
}
-(void)testEncryt{
    NSString *md5=[AKCryption calcMD5:@"123456"];//32位大写
    XCTAssertTrue([@"E10ADC3949BA59ABBE56E057F20F883E" isEqualToString:md5]);
    
    NSString*str=@"123456123456123456123456";
    NSString*base64=[AKCryption base64Encode:@"123456"];
    NSString*baseDecode=[AKCryption base64Decode:base64];
    XCTAssertTrue([str isEqualToString:baseDecode]);
    
    NSString*des=[AKCryption encryptWithDES:str key:@"aklee"];
    NSString*desDecode=[AKCryption decryptWithDES:des key:@"aklee"];
    XCTAssertTrue([str isEqualToString:desDecode]);
    
    
    NSString *the3des=[AKCryption encryptWithTripleDES:str key1:@"k1" key2:@"k2" key3:@"k3"];
    NSString *the3desDecode=[AKCryption decryptWithTripleDES:the3des key1:@"k1" key2:@"k2" key3:@"k3"];
    XCTAssertTrue([str isEqualToString:the3desDecode]);
    
    
}
-(void)testPinyinTool{
    NSString *s=[AKPinyinTool getFirstChar:@"a斯蒂芬"];
    XCTAssertTrue([@"A" isEqualToString:s]);
    s=[AKPinyinTool getFirstChar:@"斯蒂芬"];
    XCTAssertTrue([@"S" isEqualToString:s]);
    s=[AKPinyinTool getFirstChar:@"_+a斯蒂芬"];
    XCTAssertTrue([@"~" isEqualToString:s]);
}


-(void)testUDID{
    NSLog(@"%@",[AKUDID UDID]);
}


-(void)testNSData{
//    NSString *str=@"aklee";//太短的字符串 gzippedData长度比原始data更大
    NSString *str=@"akleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeakleeaklee";
    NSData *orginal=[str dataUsingEncoding:4];
    XCTAssert([orginal isGzippedData]==NO);
    NSData *gzipData=[orginal gzippedData];
    XCTAssert([gzipData isGzippedData]==YES);
    XCTAssert(orginal.length > gzipData.length);
    NSString*str2=[[NSString alloc] initWithData:[gzipData gunzippedData] encoding:4];
    XCTAssert([str2 isEqualToString:str]);
}

-(void)testNSURL{
    NSString *str=@"http://image.baidu.com/search/index?tn=baiduimage&ps=1&ct=201326592&lm=-1&cl=2&nc=1&ie=utf-8&word=asdf";
    NSDictionary*dic=[[NSURL URLWithString:str] queryParams];
    XCTAssert(dic.allKeys.count==8);
    NSLog(@"%@",dic);
}
-(void)testNSString{
    
    NSString *str = [NSString urlEncodeWithEncoding:4 string:@"http://www.bubuko.com/infodetail-650915.html"];
    XCTAssert([@"http%3A%2F%2Fwww.bubuko.com%2Finfodetail-650915.html" isEqualToString:str],@"url编码错误");
    
    XCTAssert([@"123123@qq.com" isEmail],@"mail判断错误");
    
    XCTAssert([@"123123" isNumber],@"isNumber判断错误");
    
    XCTAssert([@"000111" isNumber]==NO,@"isNumber判断错误");
    
    
    
    XCTAssert([@"1231230" isNumberInclude0],@"isNumberInclude0判断错误");
    
    XCTAssert([@"123456" isTradePwd],@"isTradePwd判断错误");
    
    XCTAssert([@"12345" isTradePwd]==NO,@"isTradePwd判断错误");
    
    
    
    XCTAssert([@"33032219901027001" isPersonalID]==NO,@"身份证判断错误");
    XCTAssert([@"330322199010270011" isPersonalID],@"身份证判断错误");
    XCTAssert([@"33032219901027001X" isPersonalIDWithX],@"身份证判断错误");
    XCTAssert([@"33032219901027001x" isPersonalIDWithX],@"身份证判断错误");
    
    
    //6-16位 数字和字符组合
    XCTAssert([@"123456a" isLoginPwd],@"isLoginPwd判断错误");
    
    XCTAssert([@"aa" isDecimal]==NO,@"isDecimal判断错误");
    XCTAssert([@"11" isDecimal],@"isDecimal判断错误");
    XCTAssert([@"123.123" isDecimal]==NO,@"isDecimal判断错误");
    XCTAssert([@"123.13" isDecimal],@"isDecimal判断错误");
    
}



- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
