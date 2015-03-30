//
//  EHDefine.h
//  EHealth
//
//  Created by zhoushaolong on 14-11-14.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#ifndef EHealth_EHDefine_h
#define EHealth_EHDefine_h

#ifndef k_IS_Report_Exception
#define k_IS_Report_Exception   0
#endif

#ifndef k_Server_Test   
#define k_Server_Test   1
#endif
// 设置 Architectures      $(ARCHS_STANDARD)

// 调试模式 用于一些测试代码
#ifndef k_Is_DebugMode
#define k_Is_DebugMode   1
#endif


#pragma mark -
#pragma mark 应用信息
//应用信息
#define APP_ID                          @"789571992"
#define APP_ITUNES_URL                  [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",APP_ID]

#define k_Test_UserID                   @"342601198209087116"

#pragma mark - UI 定义

//主色调
#define kColorMainTint                      RGBA(29, 139, 242, 1)
#define kColorNavigationBar                 RGBA(29, 139, 242, 1)
//#define kColorNavigationBar                 RGBA(33, 116, 239, 1)

//字体
#define kColorTextBlue                      RGB(29, 139, 242)
#define kColorTextGray                      RGB(50,50,50)

//默认图片
#define kImageDoctorDefault [UIImage imageNamed:@"doctor_default.png"]

#pragma mark -
#pragma mark HTTP URL
//http请求地址
#if k_Server_Test
#define kHttpBase                          @"http://121.41.109.117:8200"      // 测试环境服务器
#else
#define kHttpBase                          @"http://api.yuekong.com:8080"        // 正式环境服务器
#endif

//App获取绑定信息
#define k_URL_GetBindData               @"" kHttpBase"/yuekong/device/get_device_by_pdsn"


//Client获取系统可适配的遥控器的类型
#define k_URL_GetCategory               @"" kHttpBase"/yuekong/remote/list_categories"

//Client获取系统可适配的遥控器的品牌
#define k_URL_GetBrand                  @"" kHttpBase"/yuekong/remote/list_brands"

//列出STB编码已覆盖的城市
#define k_URL_GetCity_Covered                  @"" kHttpBase"/yuekong/city/list_covered_cities"

//Client获取系统目前支持的省份
#define k_URL_GetCity_Provinces                   @"" kHttpBase"/yuekong/city/list_provinces"

//根据省份编码前缀列出地级市
#define k_URL_GetCity_Cities                   @"" kHttpBase"/yuekong/city/list_cities"

//获取遥控器索引列表（用于码表下载模式）
#define k_URL_List_remote_indexes                   @"" kHttpBase"/yuekong/remote/list_remote_indexes"


//根据文件名下载代码二进制文件   http://121.41.109.117:8200/rb/ykir_upd6121g_remote_box_164.bin
#define k_URL_RB                   @"" kHttpBase"/rb/"


//创建遥控器实例
#define k_URL_Create_remote_instance                   @"" kHttpBase"/yuekong/remote/create_remote_instance"



//根据移动终端 ID 例举遥控器实例 (侧滑菜单列表)
#define k_URL_List_remote_instances                   @"" kHttpBase"/yuekong/remote/list_remote_instances"


//绑定遥控器
#define k_URL_Bind_remote_instance                   @"" kHttpBase"/yuekong/remote/bind_remote_instance"


//创建遥控器模式
#define k_URL_Create_remote                   @"" kHttpBase"/yuekong/remote/create_remote"


//更新遥控器模式
#define k_URL_Update_remote                   @"" kHttpBase"/yuekong/remote/update_remote"


//根据遥控器实例 ID 列举遥控器模式 (主面板)
#define k_URL_List_remotes                   @"" kHttpBase"/yuekong/remote/list_remotes"


//UE注册
#define k_URL_register_mobile                   @"" kHttpBase"/yuekong/mobile/register_mobile"




#pragma mark -- DataBase
#define k_TABLE_NAME_Hospital   @"HospitalInfo"
#define k_TABLE_NAME_HospitalParams   @"HospitalParams"
#define k_TABLE_NAME_Department   @"Departments"

#define kPrimaryKey_Eh                @"hospitalCode"


#pragma mark - 类型

/* 网络 */
//状态码
typedef enum HttpStatusCode_
{
    //成功
    HttpStatusCodeSuccess = 1,
    
    //失败
    HttpStatusCodeNetworkErr = -99999,
    
    //未成年人
    HttpStatusCodeNoAdult = 1035,
    
    //查询排队超过工作时间
    HttpStatusCodeCheckQueueOutTime = -12346
    
}HttpStatusCode;

#pragma mark - YK Defines
typedef enum YKControlKeys_{
    
    YKKey_Power = 0,
    YKKey_Mute,     //静音
    YKKey_Up,       //上
    YKKey_Down,
    YKKey_Left,
    YKKey_Right,
    YKKey_Middle,
    YKKey_VolumeUp,
    YKKey_VolumeDowm,
    YKKey_Back,
    YKKey_HomePage,
    YKKey_Menu,
    YKKey_Fun1,
    YKKey_Fun2,
    YKKey_Fun3,
}YKControlKeys;

typedef enum HomeAppliancesKey_ {
    HAKey_Null = -1,    // 无
    //    HAKey_Power = YKKey_Power,
    //    HAKey_Mute = YKKey_Mute,
    //    HAKey_Power = YKKey_Up,
    //    HAKey_Power = YKKey_Down,
    //    HAKey_Power = YKKey_Left,
    //    HAKey_Power = YKKey_Power,
    //    HAKey_Power = YKKey_Power,
    //    HAKey_Power = YKKey_Power,
    //    HAKey_Power = YKKey_Power,
    //    HAKey_Power = YKKey_Power,
    //    HAKey_Power = YKKey_Power,
    //    HAKey_Power = YKKey_Power,
}HomeAppliancesKey;

typedef enum HouseholdAppliancesType_{
    HAType_AirConditioner = 1,  // 空调
    HAType_TV,
    HAType_SetTopBox , // 机顶盒//
    HAType_LanBox,          //网络盒子
    
    HAType_Add = -1,
    
}HouseholdAppliancesType;

#pragma mark - Marvell

#define ALPHANUMERIC @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.@-!#$%^*()"
#define ALPHANUMERICWITHSPACE @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.@-!#$%^*() "

#define NETWORK_NAME @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_ "
#define NUMERIC @"-+()0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMBERS @"0123456789"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#define ASCII @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define HEX @"ABCDEFabcdef0123456789"


#define WEBSERVICE_URL @"http://192.168.10.1/sys/"
#define LOCAL_URL @"http://192.168.10.1/sys/"
#define URL_SCAN @"http://192.168.10.1/sys/scan"
#define Marvell_URL @"http://192.168.10.1/"


#pragma mark - Marvell Tip

#define  MARVELL_NETWORK_NAME @"wmdemo"

/* response error message */
#define  MARVELL_DHCP_FAILED @"dhcp_failed"
#define  MARVELL_AUTH_FAILED @"auth_failed"
#define  MARVELL_NW_NOT_FOUND @"network_not_found"

/* error messages */
#define  MARVELL_AUTH_FAILED_MSG @"Authentication failure"
#define  MARVELL_DHCP_FAILED_MSG @"DHCP Failure"
#define  MARVELL_NETWORK_NOT_FOUND_MSG @"Network not found"

/* alert messages handling validations */
#define  MARVELL_NO_NETWORK_IPHONE @"请将手机连接至可用wifi wmdemo-xxxx"
#define  MARVELL_NO_NETWORK_IPOD @"Please connect your iPod to the WiFi network wmdemo-xxxx"
#define  MARVELL_NO_NETWORK_IPAD @"Please connect your iPad to the WiFi network wmdemo-xxxx"
#define  MARVELL_BSSIDNOT_MATCH @"The device has been successfully configured with provided settings. Please check the indicators on the device for the connectivity status"
#define MARVELL_TIMEOUT @"The device has been successfully configured with provided settings. Please check the indicators on the device for the connectivity status"
/* @"Could not confirm if the device is successfully connected to the network" */
#define MARVELL_PROVISIONED @"Device is already provisioned Please connect to another device"
#define MARVELL_RESET @"Reset to provisioning successful"
#define MARVELL_CHOOSE_NETWORK @"Please enter the network name !!!"
#define MARVELL_CHOOSE_PASSOWORD @"Please enter the password !!!"
#define MARVELL_INVALID_SECURITY @"Invalid security! Choose another network"
#define MARVELL_WPA_MINIMUM @"Passphrase should be of minimum 8 characters"
#define MARVELL_RST_To_PROV @"The device is configured with provided settings. However device can’t connect to configured network. Reason:"
#define MARVELL_INCORRECT_DATA @"Incorrect configuration data, please retry the provisioning again"
#define MARVELL_NET_NOTFOUND @"Could not configure network, please check your connection"
#define MARVELL_WPS @"Not a valid device, please check your connection"
#define MARVELL_SUCESS_PROV @"Device is now successfully connected to the network "
#define MARVELL_NETWORK_TIMEOUT @"Could not get list of networks, please check your connection"

#endif
