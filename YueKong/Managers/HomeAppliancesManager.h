//
//  HomeAppliancesManager.h
//  YueKong
//
//  Created by zhoushaolong on 15-1-23.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "absManager.h"
#import "NetControl.h"

@interface HomeAppliancesManager : absManager

DEFINE_SINGLETON_FOR_HEADER(HomeAppliancesManager)

-(void)testHttp;

//App获取绑定信息
-(int)GetBindData:(NSMutableDictionary*)postBody
 responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

//Client获取系统可适配的遥控器的类型
-(int)GetCategory:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

//获取系统可适配的遥控器的品牌
-(int)GetBrand:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;


-(int)GetCity:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;


-(int)HomeAppliancesKey:(YKControlKeys)ykKey
      HomeApplianceType:(HouseholdAppliancesType)haType;
@end
