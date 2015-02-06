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

//Client获取系统可适配的遥控器的类型

/*
 from 	Query 	查询开始的ID号，用作分页，无分页时请指定为0
 count 	Query 	每页显示的条目数量，由客户端自定义
 */

-(int)GetCategory:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

//获取系统可适配的遥控器的品牌

/*
 category_id 	Query 	该品牌所述的电器类型(Category) ID
 from 	Query 	查询开始的ID号，用作分页，无分页时请指定为0
 count 	Query 	每页显示的条目数量，由客户端自定义
 */
-(int)GetBrand:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;


/*
 列出(机顶盒)STB编码已覆盖的城市
 
 from 	Query 	City ID起始值，如果从头开始，请赋值为0
 count 	Query 	每页显示城市条目数量，建议为50以上
 
 */
-(int)GetCityCovered:(NSMutableDictionary*)postBody
      responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;


//列出所有省份
-(int)GetCityProvinces:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

/*
 province_prefix 	Query 	省份编码前缀，例如江苏省为“32”
 */
-(int)GetCity:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

//App获取绑定信息
-(int)checkIsBindYKSuccess:(id<HTTP_MSG_RESPOND>)delegate;

-(int)HomeAppliancesKey:(YKControlKeys)ykKey
      HomeApplianceType:(HouseholdAppliancesType)haType;
@end
