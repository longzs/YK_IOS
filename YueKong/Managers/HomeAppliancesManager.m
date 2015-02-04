//
//  HomeAppliancesManager.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-23.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "HomeAppliancesManager.h"

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

//App获取绑定信息
-(int)GetBindData:(NSMutableDictionary*)postBody
 responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@",k_URL_GetBindData];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    /*手机 APP 向云端发起请求来判断设备是否绑定成功：
     PID：手机设备号 String
     云端返回：
     PDSN：步骤 2 中向云端注册的设备 ID String
     id：设备的内网 ip，用来进行之后的点对点连接
     */
    NSMutableDictionary* dicBody = postBody;
    if (nil == dicBody) {
        dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString* pid = [OpenUDID value];
        NSLog(@"pid = %@", pid);
        dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
    }
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_POST];
    [sent setDelegate_:delegate];
    [sent setCmdCode_:CC_CheckYKBindSuccess];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    [sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

//Client获取系统可适配的遥控器的类型
-(int)GetCategory:(NSMutableDictionary*)postBody
 responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    NSString *requestURL = [NSString stringWithFormat:@"%@",k_URL_GetCategory];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    /*App 等获取平台支持的遥控器的类型，如电视机的、机顶盒的、空调的等
     */
    NSMutableDictionary* dicBody = postBody;
    if (nil == dicBody) {
        dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString* pid = [OpenUDID value];
        dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
        dicBody[@"deviceid"] = RPLACE_EMPTY_STRING(pid);
    }
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_POST];
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
    NSString *requestURL = [NSString stringWithFormat:@"%@",k_URL_GetBrand];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    /*App 等获取平台支持的遥控器的品牌，如TCL、三星、海信等
     */
    NSMutableDictionary* dicBody = postBody;
    if (nil == dicBody) {
        dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString* pid = [OpenUDID value];
        dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
        dicBody[@"deviceid"] = RPLACE_EMPTY_STRING(pid);
        dicBody[@"catid"] = RPLACE_EMPTY_STRING(pid);
    }
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_POST];
    [sent setDelegate_:delegate];
    [sent setCmdCode_:CC_GetBrand];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    [sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}


-(int)GetCity:(NSMutableDictionary*)postBody
responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@",k_URL_GetCity];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    /*手机 APP 向云端发起请求来判断设备是否绑定成功：
     PID：手机设备号 String
     云端返回：
     PDSN：步骤 2 中向云端注册的设备 ID String
     id：设备的内网 ip，用来进行之后的点对点连接
     */
    NSMutableDictionary* dicBody = postBody;
    if (nil == dicBody) {
        dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString* pid = [OpenUDID value];
        NSLog(@"pid = %@", pid);
        dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
    }
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_POST];
    [sent setDelegate_:delegate];
    [sent setCmdCode_:CC_GetCity];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    [sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

-(int)checkIsBindYKSuccess:(NSMutableDictionary*)postBody
          responseDelegate:(id<HTTP_MSG_RESPOND>)delegate{
    
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
