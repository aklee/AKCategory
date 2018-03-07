//
//  NetworkUtils.m
//  CinCommon
//
//  Created by zhengkanyan on 16/7/19.
//  Copyright © 2016年 p. All rights reserved.
//

#import "NetworkUtils.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <ifaddrs.h>
#import <net/if.h>
#include <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation NetworkUtils
{
    SCNetworkReachabilityRef _reachabilityRef;
}

+ (instancetype)sharedInstance {
    static NetworkUtils *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *host = @"www.cmbchina.com";
        _reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
    }
    return self;
}

- (void)dealloc
{
    if (_reachabilityRef != NULL)
    {
        CFRelease(_reachabilityRef);
    }
}

+ (BOOL)isReachable:(NSString *)url {
    SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    if(reachabilityRef) {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
        {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                return NO;
            }
        }
        CFRelease(reachabilityRef);
    }
    else {
        return NO;
    }
    return YES;
}

+ (BOOL)isWiFiEnabled {
    NSCountedSet * cset = [[NSCountedSet alloc] init];
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}

+ (NSString *)getWifiName {
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

+ (NSString *)deviceWANIPAddress {
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    if(data) {
        NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if(ipDic && [ipDic[@"code"] integerValue] == 0) {
            return ipDic[@"data"][@"ip"];
        }
    }
    return nil;
}

+ (NSMutableArray *)fetchIPAddress:(NSString *)host {
    Boolean result,bResolved;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    NSMutableArray * ipsArr = [[NSMutableArray alloc] init];
    CFStringRef hostNameRef = (__bridge CFStringRef)host;
    
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
    if (result == TRUE) {
        addresses = CFHostGetAddressing(hostRef, &result);
    }
    bResolved = result == TRUE ? true : false;
    
    if(bResolved)
    {
        struct sockaddr_in* remoteAddr;
        for(int i = 0; i < CFArrayGetCount(addresses); i++)
        {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            
            if(remoteAddr != NULL)
            {
                //获取IP地址
                char ip[16];
                strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
                NSString * ipStr = [NSString stringWithCString:ip encoding:NSUTF8StringEncoding];
                [ipsArr addObject:ipStr];
            }
        }
    }
    CFRelease(hostRef);
    return ipsArr;
}

+ (NetWorkType)currentNetworkType {
    SCNetworkReachabilityRef reachabilityRef = [NetworkUtils sharedInstance]->_reachabilityRef;
    if(reachabilityRef) {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
        {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // The target host is not reachable.
                return [NetworkUtils fetchWWANNetworkType];
            }
            
            BOOL isWIFI = NO;
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
                isWIFI = YES;
            }
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed...
                    isWIFI = YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                //... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
                isWIFI = NO;
            }
            
            if(isWIFI) {
                return NetWorkType_Wifi;
            }
        }
        
        return [NetworkUtils fetchWWANNetworkType];
    }
    return NetWorkType_Unknown;
}

+ (NetWorkType)fetchWWANNetworkType {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = info.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]
        || [currentStatus isEqualToString:CTRadioAccessTechnologyEdge]
        || [currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        return NetWorkType_2G;
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]
              || [currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]
              || [currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]
              || [currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]
              || [currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]
              || [currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]
              || [currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
        return NetWorkType_3G;
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
        return NetWorkType_4G;
    }
    else {//其他场景默认为WIFI
        return NetWorkType_Wifi;
    }
}

+ (NSString *)currentNetworkString {
    NetWorkType type = [NetworkUtils currentNetworkType];
    switch (type) {
            
        case NetWorkType_2G:
            return @"NetWork_2G";
            break;
            
        case NetWorkType_3G:
            return @"NetWork_3G";
            break;
            
        case NetWorkType_4G:
            return @"NetWork_4G";
            break;
            
        case NetWorkType_Wifi:
            return @"NetWork_Wifi";
            break;
            
        default:
            return @"NetWork_Unknown";
            break;
    }
}

+ (NSString *)currentNetworkCarrierCodeName {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *carrierType = [NSString stringWithFormat:@"%@%@", carrier.mobileCountryCode ? : @"", carrier.mobileNetworkCode ? : @""];
    return carrierType;
}
     
+ (NSString *)currentNetworkCarrierName {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    return carrier.carrierName;
}

+ (NSInteger)meetingNetRecall {
    NetWorkType type = [NetworkUtils currentNetworkType];
    switch (type) {
        case NetWorkType_2G:
            return 3;
            break;
        case NetWorkType_3G:
            return 2;
            break;
        case NetWorkType_4G:
            return 1;
            break;
        case NetWorkType_Wifi:
            return 4;
            break;
        default:
            return 0;
            break;
    }
}

+ (NSInteger)getCarrierIntForMeeting {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSInteger i = 1;
    if ([carrier.carrierName isEqualToString:@"中国移动"]) {
        i = 1;
    } else if ([carrier.carrierName isEqualToString:@"中国联通"]) {
        i = 2;
    } else if ([carrier.carrierName isEqualToString:@"中国电信"]) {
        i = 3;
    } else {
        i = 0;
    }
    return i;
}

@end
