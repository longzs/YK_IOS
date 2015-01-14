//
//  NetWorkDetails.h
//  YueKong
//
//  Created by zhoushaolong on 15-1-14.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkDetails : NSObject
@property (nonatomic, strong)NSString *ssid;
@property (nonatomic, strong)NSString *bssid;
@property (nonatomic, assign)int security;
@property (nonatomic, assign)int channel;
@property (nonatomic, assign)int rssi;
@property (nonatomic, assign)int nf;
@end
