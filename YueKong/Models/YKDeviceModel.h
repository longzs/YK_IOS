//
//  YKDeviceModel.h
//  YueKong
//
//  Created by zhoushaolong on 15-2-5.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKModel.h"

#define kOtherCityName    @"kOtherCityName"

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

// 遥控器类型
@interface YKRemoteControlCategory : YKModel
@property(nonatomic, copy)NSString* idNo;
@property(nonatomic, copy)NSString* name;
@property(nonatomic, copy)NSString* create_time;
// 	是否有效(1: 有效, 0: 无效)，默认为1
@property(nonatomic, copy)NSString* status;
@end

// 遥控器品牌 (Brand)
@interface YKRemoteControlBrand : YKModel
@property(nonatomic, copy)NSString* idNo;
@property(nonatomic, copy)NSString* name;
@property(nonatomic, copy)NSString* category_id;
@property(nonatomic, copy)NSString* category_name;
@property(nonatomic, copy)NSString* create_time;
// 	是否有效(1: 有效, 0: 无效)，默认为1
@property(nonatomic, copy)NSString* status;
@end



// 城市 (City)
@interface YKCityModel : YKModel
@property(nonatomic, copy)NSString* idNo;
@property(nonatomic, copy)NSString* name;
@property(nonatomic, copy)NSString* code;
@property(nonatomic, copy)NSString* longitude;
@property(nonatomic, copy)NSString* latitide;
@end


// 广电运营商 (Operator)
@interface YKOperatorModel : YKModel
@property(nonatomic, copy)NSString* idNo;
@property(nonatomic, copy)NSString* operator_id;
@property(nonatomic, copy)NSString* operator_name;
@property(nonatomic, copy)NSString* city_code;
@property(nonatomic, copy)NSString* city_name;
// 	是否有效(1: 有效, 0: 无效)，默认为1
@property(nonatomic, copy)NSString* status;
@end


// 移动终端UE
@interface YKMobileModel : YKModel
@property(nonatomic, copy)NSString* idNo;
@property(nonatomic, copy)NSString* pdsn;
@property(nonatomic, copy)NSString* pid;
@property(nonatomic, copy)NSString* ssid;
@property(nonatomic, copy)NSString* sskey;
@property(nonatomic, copy)NSString* ip_address;
@property(nonatomic, copy)NSString* mobile_number;

@property(nonatomic, copy)NSString* app_version;
@property(nonatomic, copy)NSString* device_version;
@property(nonatomic, copy)NSString* create_time;
// 	是否有效(1: 有效, 0: 无效)，默认为1
@property(nonatomic, copy)NSString* status;
@end

// 家电预约
@interface YKMApplicaonSchedueModel : YKModel
@property(nonatomic, copy)NSString* idNo;
@property(nonatomic, copy)NSString* name;
@property(nonatomic, copy)NSString* start_time;
@property(nonatomic, copy)NSString* end_time;
@end
