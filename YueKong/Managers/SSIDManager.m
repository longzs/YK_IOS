//
//  SSIDManager.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-8.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "SSIDManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"

@implementation SSIDManager

DEFINE_SINGLETON_FOR_CLASS(SSIDManager)

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

- (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"ifs:%@",ifs);
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"dici：%@",[info  allKeys]);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}

//Checks whether wifi is reachable or not
+(BOOL)isWiFiReachable
{
    Reachability *wifiReach = [Reachability reachabilityForLocalWiFi];
    NetworkStatus netStatus2 = [wifiReach currentReachabilityStatus];
    if(netStatus2 == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    return YES;
}

@end
