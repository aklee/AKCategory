//
//  NetworkUtils.h
//  网络工具类
//
//  Created by zhengkanyan on 16/7/19.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 网络类型
 */
typedef NS_ENUM(NSInteger, NetWorkType) {
    NetWorkType_Unknown,
    NetWorkType_Wifi,
    NetWorkType_2G,
    NetWorkType_3G,
    NetWorkType_4G
};

/**
 网络运营商
 */
typedef NS_ENUM(NSInteger, CarrierType) {
    Unknown,
    ChinaMobile,
    ChinaUnicom,
    ChinaTelecom
};

@interface NetworkUtils : NSObject

// 检查地址连接性
+ (BOOL)isReachable:(NSString *)url;

//检查DNS解析结果
+ (NSMutableArray *)fetchIPAddress:(NSString *)host;

// 检查WIFI是否开启
+ (BOOL)isWiFiEnabled;

// 获取已连接Wi-Fi的名称
+ (NSString *)getWifiName;

// 获取外网IP地址
+ (NSString *)deviceWANIPAddress;

/// 当前网络类型
+ (NetWorkType)currentNetworkType;

/// 当前网络类型字符串
+ (NSString *)currentNetworkString;

/// 当前网络运营商Code名称
+ (NSString *)currentNetworkCarrierCodeName;

/// 当前网络运营商名称
+ (NSString *)currentNetworkCarrierName;

@end
