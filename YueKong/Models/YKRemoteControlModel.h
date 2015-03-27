//
//  YKRemoteControlModel.h
//  YueKong
//
//  Created by zhoushaolong on 15/3/26.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "YKModel.h"

@interface YKRemoteControlModel : YKModel

@property(nonatomic, assign)int idNo;       //数据库自增列，也可以用于标识唯一Operator对象
// 	是否有效(1: 有效, 0: 无效)，默认为1
@property(nonatomic, assign)int status;

@end



@interface ykRemoteControlIndex : YKRemoteControlModel

@property(nonatomic, assign) 	int category_id;

@property(nonatomic, copy)NSString* category_name;

@property(nonatomic, assign) 	int brand_id;

@property(nonatomic, copy)NSString* brand_name;

@property(nonatomic, copy)NSString* city_code;

@property(nonatomic, copy)NSString* city_name;

@property(nonatomic, assign)int operator_id;

@property(nonatomic, copy)NSString* operator_name;

// 	红外码协议文件
@property(nonatomic, copy)NSString* protocol;

//  红外代码文件
@property(nonatomic, copy)NSString* remote;

//  红外码表映射
@property(nonatomic, copy)NSString* remote_map;

@end


//  遥控器(硬件)实例 (RemoteInstance)
@interface ykRemoteControlINstance : YKRemoteControlModel

@property(nonatomic, copy)NSString* name;

// 	遥控器自身的唯一标识
@property(nonatomic, copy)NSString* rsn;


@property(nonatomic, copy)NSString* device_pdsn;

@property(nonatomic, copy)NSString* device_ip;

// 是否绑定底座
@property(nonatomic, assign)int is_bound;

// 设置该遥控器的移动终端唯一标识
// IOS/Android上统一为获取手机硬件的唯一ID编码并进行32字节MD5散列生成
@property(nonatomic, copy)NSString* mobile_id;

// 	用户唯一ID(如果使用了用户登录)
@property(nonatomic, copy)NSString* user_open_id;

//  红外代码文件
@property(nonatomic, copy)NSString* user_name;

//  遥控器硬件的MAC地址
@property(nonatomic, copy)NSString* mac_address;

@end


//  遥控器模式 (Remote)

@interface YKRemoteMode : YKRemoteControlModel

//  Device的唯一序号（可选字段，为空表示当前APP没有和Device绑定）
@property(nonatomic, copy)NSString* device_pdsn;

// 	遥控器自身的唯一标识
@property(nonatomic, copy)NSString* rsn;

@property(nonatomic, assign) 	int category_id;

@property(nonatomic, copy)NSString* category_name;

@property(nonatomic, assign) 	int brand_id;

@property(nonatomic, copy)NSString* brand_name;

@property(nonatomic, copy)NSString* city_code;

// 该遥控器对应的索引对象ID （可选字段，为空表示该模式是通过学习方式得到，否则为下载码表方式得到）
@property(nonatomic, assign)int remote_index_id;

// 该遥控器对应的索引对象名称，对应remote_index中的protocol + remote_map字符串拼接 （可选字段，为空表示该模式是通过学习方式得到，否则为下载码表方式得到）
@property(nonatomic, copy)NSString* remote_index_name;

// 该遥控器模式的获得方式 （0：下载码表方式，1：自学习方式）
@property(nonatomic, assign)int create_type;

// 所有15键的键名和对应红外编码字符串（APP透传）
@property(nonatomic, copy)NSString* key_code;

// 遥控器实例ID
@property(nonatomic, assign)int remote_instance_id;

// 遥控器实例的MAC地址
@property(nonatomic, copy)NSString* mac_address;

@end




