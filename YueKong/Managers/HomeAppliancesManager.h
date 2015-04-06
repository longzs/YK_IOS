//
//  HomeAppliancesManager.h
//  YueKong
//
//  Created by zhoushaolong on 15-1-23.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "absManager.h"
#import "NetControl.h"
#import "YKRemoteControlModel.h"

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



#pragma mark - Remote
/*
 获取遥控器索引列表（用于码表下载模式）
 
 category_id 	Query 	该品牌所述的电器类型(Category) ID
 brand_id 	Query 	该品牌所述的电器品牌(Brand) ID
 city_code 	Query 	城市国标码
 from 	Query 	查询开始的ID号，用作分页，无分页时请指定为0
 count 	Query 	每页显示的条目数量，由客户端自定义
 
 */
-(int)List_remote_indexes:(NSMutableDictionary*)postBody
    responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

/*
 根据文件名下载代码二进制文件
 
 */
-(int)DownloadRemoteBinFile:(NSMutableDictionary*)postBody
         responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;


/*
 创建遥控器实例
 
 remote_instance 	Form 	遥控器实例(remote_instance)的Application/JSON对象
 
 */
-(int)Create_remote_instance:(NSMutableDictionary*)postBody
         responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

/*
 根据移动终端 ID 例举遥控器实例 (侧滑菜单列表)
 
 mobile_id 	Query 	移动终端唯一 ID
 
 */
-(int)List_remote_instances:(NSMutableDictionary*)postBody
            responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

/*
 绑定遥控器
 
 device_pdsn 	Query 	底座设备的SN
 mobile_instance_id 	Query 	遥控器实例ID
 
 */
-(int)Bind_remote_instances:(NSMutableDictionary*)postBody
           responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

/*
 创建遥控器模式
 
 remote 	Form 	遥控器模式(remote)的Application/JSON对象
 
 */
-(int)Create_remote:(NSMutableDictionary*)postBody
           responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

/*
 更新遥控器模式
 
 remote_id 	Query 	要更新的遥控器的ID
 remote 	Form 	新遥控器的 Appliation/JSON 对象
 
 */
-(int)Update_remote:(NSMutableDictionary*)postBody
   responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

/*
 根据遥控器实例 ID 列举遥控器模式 (主面板)
 
 remote_instance_id 	Query 	遥控器实例 ID
 from 	Query 	Remote ID起始值，如果从头开始，请赋值为0
 count 	Query 	每页显示遥控器模式条目数量，建议为8 (总共支持8种模式，无翻页)
 
 */
-(int)List_remotes:(NSMutableDictionary*)postBody
   responseDelegate:(id<HTTP_MSG_RESPOND>)delegate;

@end
