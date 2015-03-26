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
@property(nonatomic, copy)NSString* name;

@end



@interface ykRemoteControlIndex : YKRemoteControlModel

@property(nonatomic, assign) 	int category_id;
@property(nonatomic, copy)NSString* category_name;
@property(nonatomic, copy)NSString* create_time;
// 	是否有效(1: 有效, 0: 无效)，默认为1
@property(nonatomic, copy)NSString* status;

@end




