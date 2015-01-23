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
#define k_Server_Test   0
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
#define kColorTextGray                      RGB(153, 153, 153)

//默认图片
#define kImageDoctorDefault [UIImage imageNamed:@"doctor_default.png"]

#pragma mark -
#pragma mark HTTP URL
//http请求地址
#if k_Server_Test
#define kHttpBase                          @"http://121.40.149.20/yuekong/core/app/"      // 测试环境服务器
#else
#define kHttpBase                          @"http://121.40.149.20/yuekong/core/app/"        // 正式环境服务器
#endif

//App获取绑定信息
#define k_URL_GetBindData               @"" kHttpBase"api/getBindData.php"


//Client获取系统可适配的遥控器的类型
#define k_URL_GetCategory               @"" kHttpBase"api/getCategory.php"

//Client获取系统可适配的遥控器的品牌
#define k_URL_GetBrand                  @"" kHttpBase"api/getBrand.php"

//Client获取系统目前支持的地区
#define k_URL_GetCity                   @"" kHttpBase"api/getCity.php"



//注册
#define k_URL_userRegister                   @"userRegister"

//重置密码
#define k_URL_passwordReset                   @"passwordReset"

//修改密码
#define k_URL_modifyPassword                   @"modifyPassword"

//登陆
#define k_URL_userLogin                     @"userLogin"

//系统参数初始化
#define k_URL_initSystem                    @"initSystem"

//医院信息查询
#define k_URL_getHospitalInfo                   @"searchHospitalInfo"

//医院参数初始化(可与2.1.8合并)
#define k_URL_initHospitalParam                   @"initHospitalParam"

//验证卡号是否可用
#define k_URL_checkCtznCardRegister                   @"checkCtznCardRegister"

//修改手机号码
#define k_URL_modifyPhoneNum                   @"modifyPhoneNum"

//查询常用就诊人信息
#define k_URL_searchCommonlyUsers                  @"searchCommonlyUsers"

//修改/增加/删除常用就诊人信息
#define k_URL_modifyCommonlyUser                  @"modifyCommonlyUser"

//医院、医生信息查询
#define k_URL_searchHospitalAndDoctors                  @"searchHospitalAndDoctors"

//获取用户百度推送Id
#define k_URL_getUserBaiduPushId                  @"getUserBaiduPushId"

//获取用户推送信息
#define k_URL_getUserPushMsg                  @"getUserPushMsg"

#pragma mark -- 预约挂号
//查询科室排班（医生出诊情况）
#define k_URL_searchSchedue                  @"searchSchedue"

//查询就诊卡号
#define k_URL_searchCardNo                  @"searchCardNo"

//预约下单
#define k_URL_preRegisterConfirm                  @"preRegisterConfirm"

//预约取消
#define k_URL_preRegisterCancel                  @"preRegisterCancel"

#pragma mark -- 就诊查询

//实时排队叫号查询(登录)
#define k_URL_searchQueuingInfo                  @"searchQueuingInfo"

//实时排队叫号查询(未登录)
#define k_URL_searchDeptQueuingInfo             @"searchDeptQueuingInfo"

//查询用户今日就诊排班列表（包括预约和挂号）
#define k_URL_searchCurrentRegisterInfo                  @"searchCurrentRegisterInfo"

//查询用户预约列表
#define k_URL_searchPreRegisterInfo                  @"searchPreRegisterInfo"

//查询用户就诊历史挂号单列表
#define k_URL_searchHistoryRegisterInfo                  @"searchHistoryRegisterInfo"

//查询用户预约/挂号记录列表
#define k_URL_searchUserRegisterInfo                  @"searchUserRegisterInfo"

#pragma mark -- 医检报告

//根据条码查询医检报告
#define k_URL_searchReportByBarCode                  @"searchReportByBarCode"

//查询用户医检报告列表
#define k_URL_searchHistoryReport                  @"searchHistoryReport"

#pragma mark -- 缴费支付
//查询用户挂号单缴费详情
#define k_URL_searchPrenosInfo                  @"searchPrenosInfo"

//挂号下单-请求支付
#define k_URL_registerRequestPay                  @"registerRequestPay"

//挂号下单-结果查询
#define k_URL_registerResultQuery                  @"registerResultQuery"

//划价单缴费-请求支付
#define k_URL_prenosRequestPay                  @"prenosRequestPay"

//划价单缴费-结果查询
#define k_URL_prenosResultQuery                  @"prenosResultQuery"


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
#define  MARVELL_NO_NETWORK_IPHONE @"Please connect your iPhone to the WiFi network wmdemo-xxxx"
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
