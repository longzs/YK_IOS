//
//  YKDeviceModel.h
//  YueKong
//
//  Created by zhoushaolong on 15-2-5.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKModel.h"

@interface YKDeviceModel :YKModel<NSCoding>
@property(nonatomic, copy)NSString* pdsn;
@property(nonatomic, copy)NSString* idNo;
@property(nonatomic, copy)NSString* ip_address;
@property(nonatomic, copy)NSString* name;

@property(nonatomic, copy)NSString* version;
@property(nonatomic, copy)NSString* create_time;
// 	是否有效(1: 有效, 0: 无效)，默认为1
@property(nonatomic, copy)NSString* status;
@end
