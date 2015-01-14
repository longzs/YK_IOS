//
//  SSIDManager.h
//  YueKong
//
//  Created by zhoushaolong on 15-1-8.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "absManager.h"

@interface SSIDManager : absManager


DEFINE_SINGLETON_FOR_HEADER(SSIDManager)

//Checks whether wifi is reachable or not
+(BOOL)isWiFiReachable;


- (NSString *)currentWifiSSID;
- (id)fetchSSIDInfo;

@end
