//
//  HomeAppliancesManager.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-23.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "HomeAppliancesManager.h"

#define kNeedPid        0

@implementation HomeAppliancesManager

DEFINE_SINGLETON_FOR_CLASS(HomeAppliancesManager)

-(void)testHttp{
    NSString *requestURL = @"http://192.168.1.200:8081/yuekong/hello/test_post";//@"http://192.168.1.200:8081/yuekong/hello/test?name=xxx";
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
   
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_POST];
    [sent setDelegate_:nil];
    [sent setCmdCode_:CC_CheckYKBindSuccess];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    //[sent setPostData:[dicBody JSONData]];
    [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

//Client获取系统可适配的遥控器的类型
-(int)GetCategory:(NSMutableDictionary*)postBody
 responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    NSString *requestURL = [NSString stringWithFormat:@"%@?from=0&count=100",k_URL_GetCategory];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    /*App 等获取平台支持的遥控器的类型，如电视机的、机顶盒的、空调的等
     */
    NSMutableDictionary* dicBody = postBody;
    
#if kNeedPid
    if (nil == dicBody) {
        dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString* pid = [OpenUDID value];
        dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
        dicBody[@"deviceid"] = RPLACE_EMPTY_STRING(pid);
    }
#endif
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_GET];
    [sent setDelegate_:delegate];
    [sent setCmdCode_:CC_GetCategory];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    [sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

//获取系统可适配的遥控器的品牌
-(int)GetBrand:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@?category_id=%@&from=0&count=20",k_URL_GetBrand, postBody[@"category_id"]];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    /*App 等获取平台支持的遥控器的品牌，如TCL、三星、海信等
     */
    NSMutableDictionary* dicBody = postBody;
#if kNeedPid
    if (nil == dicBody) {
        dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString* pid = [OpenUDID value];
        dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
        dicBody[@"deviceid"] = RPLACE_EMPTY_STRING(pid);
        dicBody[@"catid"] = RPLACE_EMPTY_STRING(pid);
    }
#endif
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_GET];
    [sent setDelegate_:delegate];
    [sent setCmdCode_:CC_GetBrand];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    //[sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

/*
 列出(机顶盒)STB编码已覆盖的城市
 
 from 	Query 	City ID起始值，如果从头开始，请赋值为0
 count 	Query 	每页显示城市条目数量，建议为50以上
 
 */
-(int)GetCityCovered:(NSMutableDictionary*)postBody
    responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@?from=0&count=70",k_URL_GetCity_Covered];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
#if kNeedPid
    NSMutableDictionary* dicBody = postBody;
    if (nil == dicBody) {
        dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString* pid = [OpenUDID value];
        NSLog(@"pid = %@", pid);
        dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
    }
#endif
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_GET];
    [sent setDelegate_:delegate];
    [sent setCmdCode_:CC_GetCitesCovered];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    //[sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}


-(int)GetCityProvinces:(NSMutableDictionary*)postBody
      responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@",k_URL_GetCity_Provinces];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
#if kNeedPid
    NSMutableDictionary* dicBody = postBody;
    if (nil == dicBody) {
        dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString* pid = [OpenUDID value];
        NSLog(@"pid = %@", pid);
        dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
    }
#endif
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_GET];
    [sent setDelegate_:delegate];
    [sent setCmdCode_:CC_GetCityProvinces];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    //[sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

-(int)GetCity:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@?province_prefix=%@",k_URL_GetCity_Cities, postBody[@"province_prefix"]];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    NSMutableDictionary* dicBody = postBody;
    #if kNeedPid
    if (nil == dicBody) {
        dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString* pid = [OpenUDID value];
        NSLog(@"pid = %@", pid);
        dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
    }
#endif
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_GET];
    [sent setDelegate_:delegate];
    [sent setCmdCode_:CC_GetCitesByProvinces];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setDicHeader:header];
    //[sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

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
         responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    
    return 0;
}

/*
 根据文件名下载代码二进制文件
 
 */
-(int)DownloadRemoteBinFile:(NSMutableDictionary*)postBody
           responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    
    return 0;
}
/*
 创建遥控器实例
 
 remote_instance 	Form 	遥控器实例(remote_instance)的Application/JSON对象
 
 */
-(int)Create_remote_instance:(NSMutableDictionary*)postBody
            responseDelegate:(id<HTTP_MSG_RESPOND>)delegate
{
    
    return 0;
}

/*
 根据移动终端 ID 例举遥控器实例 (侧滑菜单列表)
 
 mobile_id 	Query 	移动终端唯一 ID
 
 */
-(int)List_remote_instances:(NSMutableDictionary*)postBody
           responseDelegate:(id<HTTP_MSG_RESPOND>)delegate
{
    
    return 0;
}

/*
 绑定遥控器
 
 device_pdsn 	Query 	底座设备的SN
 mobile_instance_id 	Query 	遥控器实例ID
 
 */
-(int)Bind_remote_instances:(NSMutableDictionary*)postBody
           responseDelegate:(id<HTTP_MSG_RESPOND>)delegate
{
    
    return 0;
}

/*
 创建遥控器模式
 
 remote 	Form 	遥控器模式(remote)的Application/JSON对象
 
 */
-(int)Create_remote:(NSMutableDictionary*)postBody
   responseDelegate:(id<HTTP_MSG_RESPOND>)delegate
{
    
    return 0;
}

/*
 更新遥控器模式
 
 remote_id 	Query 	要更新的遥控器的ID
 remote 	Form 	新遥控器的 Appliation/JSON 对象
 
 */
-(int)Update_remote:(NSMutableDictionary*)postBody
   responseDelegate:(id<HTTP_MSG_RESPOND>)delegate
{
    
    return 0;
}

/*
 根据遥控器实例 ID 列举遥控器模式 (主面板)
 
 remote_instance_id 	Query 	遥控器实例 ID
 from 	Query 	Remote ID起始值，如果从头开始，请赋值为0
 count 	Query 	每页显示遥控器模式条目数量，建议为8 (总共支持8种模式，无翻页)
 
 */
-(int)List_remotes:(NSMutableDictionary*)postBody
  responseDelegate:(id<HTTP_MSG_RESPOND>)delegate
{
    
    return 0;
}


#pragma mark - other
-(int)checkIsBindYKSuccess:(id<HTTP_MSG_RESPOND>)delegate{
    
    NSString* pdsn = @"P000000000000001";//[[EHUserDefaultManager sharedInstance] LastPdsn];
    NSString *requestURL = [NSString stringWithFormat:@"%@?pdsn=%@",k_URL_GetBindData,pdsn];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
//    NSMutableDictionary* dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString* pid = [OpenUDID value];
//    //NSLog(@"pid = %@", pid);
//    dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_GET];
    [sent setDelegate_:delegate];
    [sent setCmdCode_:CC_CheckYKBindSuccess];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:20];
    [sent setDicHeader:header];
    //[sent setPostData:[dicBody JSONData]];
    
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

-(int)HomeAppliancesKey:(YKControlKeys)ykKey
      HomeApplianceType:(HouseholdAppliancesType)haType{
    
    int i = ykKey;
    switch (ykKey) {
        case YKKey_Power:
        {
        }
            break;
        case YKKey_Mute:
        {
            if (HAType_AirConditioner == haType
                || HAType_LanBox == haType) {
                i = HAKey_Null;
            }
        }
            break;
        case YKKey_Up:
        {
            if (HAType_AirConditioner == haType) {
            }
        }
            break;
        case YKKey_Down:
        {
            if (HAType_AirConditioner == haType) {
            }
        }
            break;
        case YKKey_Left:
        {
            if (HAType_AirConditioner == haType) {
                i = HAKey_Null;
            }
        }
            break;
        case YKKey_Right:
        {
            if (HAType_AirConditioner == haType) {
                i = HAKey_Null;
            }
        }
            break;
        case YKKey_Middle:
        {
            if (HAType_AirConditioner == haType) {
                i = HAKey_Null;
            }
        }
            break;
        case YKKey_VolumeUp:
        {
            if (HAType_AirConditioner == haType) {
                //i = HAKey_Null;
            }
        }
            break;
        case YKKey_VolumeDowm:
        {
            if (HAType_AirConditioner == haType) {
                //i = HAKey_Null;
            }
        }
            break;
        case YKKey_Back:
        {
            if (HAType_AirConditioner == haType) {
                //i = HAKey_Null;
            }
        }
            break;
        case YKKey_HomePage:
        {
            if (HAType_AirConditioner == haType) {
                //i = HAKey_Null;
            }
        }
            break;
        case YKKey_Menu:
        {
            if (HAType_AirConditioner == haType) {
                //i = HAKey_Null;
            }
        }
            break;
        case YKKey_Fun1:
        {
            if (HAType_AirConditioner == haType) {
                
            }
            else{
                i = HAKey_Null;
            }
        }
            break;
        case YKKey_Fun2:
        {
            if (HAType_AirConditioner == haType) {
                
            }
            else{
                i = HAKey_Null;
            }
        }
            break;
        case YKKey_Fun3:
        {
            if (HAType_AirConditioner == haType) {
                
            }
            else{
                i = HAKey_Null;
            }
        }
            break;
        default:
            break;
    }
    return i;
}
@end
