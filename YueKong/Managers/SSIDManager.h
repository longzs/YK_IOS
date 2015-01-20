//
//  SSIDManager.h
//  YueKong
//
//  Created by zhoushaolong on 15-1-8.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "absManager.h"


/*
 
 1.手机 APP 向设备（基座）发送信息，参数如下：
 ssid：wifi 名称 String
 key：wifi 密码 String
 security:加密方式
 channel:
 ip:内网 IP
 pid：手机设备号 String
 设备返回：
 pdsn
 
 2.设备向云端进行注册，参数如下 ：
 PDSN：设备 ID String
 PID：步骤 1 的手机设备号 String
 ip：设备内网 IP
 
 
 3.手机 APP 向云端发起请求来判断设备是否绑定成功：
 PID：手机设备号 String
 云端返回：
 PDSN：步骤 2 中向云端注册的设备 ID String
 id：设备的内网 ip，用来进行之后的点对点连接
 
 4.app 和设备之间的交互，socket 通信；
 T_BUTTON_ID : 遥控器按键
 设备返回：
 T_BUTTON_ID:
 T_CODE: 该键对应的码值
 
 5.手机 APP 进行遥控器配置，将指令上传给云端，参数定义如下：
 PID：手机设备号 String
 PDSN：设备号 String
 E_TYPE：电器类型 String
 E_BRAND：电器品牌 String
 E_CITY：电器所在城市 String
 E_NAME：电器名称 String
 T_BUTTON_ID：遥控器按键 Int
 T_CODE: 按键对应的码值 byte[]
 云端返回：
 E_ID：电器唯一 ID，可根据 E_TYPE+E_BRAND(或 E_CITY）MD5 加密算出，
 该 E_ID 会作为之后三方交互的重要依据，比如电器预约等功能都要用到
 T_BUTTON_ID[]： 能够识别出来的按键 ID 数组，app 可根据这些 ID 直接点亮
 对应的按键
 学习过程中，第四第五步可重复执行，直至学习结束点击完成
 
 6.APP 向设备通过 socket 告知设备，学习结束
 E_ID ： 电器唯一 ID
 
 7.设备向云端发起请求来下载完整码库，参数定义如下：
 PID：手机设备号 String
 PDSN：设备号 String
 E_ID：电器唯一 ID
 云端返回：
 T_CODE[]：遥控器对应的多有按键的码库 byte[][]
 */

@interface SSIDManager : absManager

DEFINE_SINGLETON_FOR_HEADER(SSIDManager)

//Checks whether wifi is reachable or not
+(BOOL)isWiFiReachable;


- (NSString *)currentWifiSSID;
- (id)fetchSSIDInfo;

@end
