//
//  Utils.h
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 焦点科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "HMSegmentedControl.h"
#import "MBProgressHUD.h"

@class MBProgressHUD;

/**
 *  工具类，包含了常用的一些方法
 */
@interface Utils : NSObject

#pragma mark - 展示提示信息
/**
 *  创建一个显示在窗口中的提示view
 *
 *  @param title    提示文本信息
 *  @param delegate 回调
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showLoadingViewInWindowWithTitle:(NSString*)title delegate:(id) delegate;
/**
 *  创建一个自动消息的显示在窗口中的提示view
 *
 *  @param title 提示文本信息
 *  @param delay 延时消失时间
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showPromptViewInWindowWithTitle:(NSString*)title afterDelay:(NSTimeInterval)delay;

/**
 *  隐藏等待框
 */
+ (void)hideLoadingView;

/**
 *  显示一个简单的AlertView（只有一个确认按钮）
 *
 *  @param message       显示信息文本
 *  @param alertDelegate alert的回调
 *
 *  @return 正在显示的Alert
 */
+ (UIAlertView *)showSimpleAlert:(NSString *)message delegate:(id)alertDelegate;

+ (void)showSimpleAlert:(NSString *)message;
/**
 *  显示一个toast弹出通知，toast距离底部为150个点
 *
 *  @param mesage 信息文本
 */
+ (void)showToastWithMessage:(NSString *)mesage;
/**
 *  显示一个toast弹出通知
 *
 *  @param mesage 信息文本
 */
+ (void)showCenterToastWithMessage:(NSString *)mesage;
/**
 *  显示一个toast弹出通知
 *
 *  @param mesage 信息文本
 *  @param view   容器View
 */
+ (void)showCenterToastWithMessage:(NSString *)mesage inView:(UIView*)view;
/**
 *  显示一个toast，使其能在键盘之上
 *
 *  @param message 信息文本
 *
 *  @return HUD对象
 */
+ (MBProgressHUD *)showCoverKeyboardHUD:(NSString *)message;

#pragma mark - 导航栏定制
/**
 *  创建一个应用于导航栏左侧的取消按钮
 *
 *  @param target 目标对象
 *  @param action 响应方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)cancelButtonItemWithTarget:(id)target action:(SEL)action;
/**
 *  创建一个应用于导航栏上的按钮
 *
 *  @param title  按钮名称
 *  @param target 目标对象
 *  @param action 响应方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)buttonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
/**
 *  创建一个应用于导航栏上的按钮(iOS7风格)
 *
 *  @param title  按钮名称
 *  @param target 目标对象
 *  @param action 响应方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem*) buttonItemWith7Title:(NSString *)title target:(id)target action:(SEL)action;
/**
 *  创建一个应用于导航栏左侧的按钮
 *
 *  @param imageUrl         正常状态图片名称
 *  @param highlightedImage 高亮状态图片名称
 *  @param target           目标对象
 *  @param action           响应方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)leftbuttonItemWithImage:(NSString *)imageUrl highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;
/**
 *  创建一个应用于导航栏右侧的按钮
 *
 *  @param imageUrl         正常状态图片名称
 *  @param highlightedImage 高亮状态图片名称
 *  @param target           目标对象
 *  @param action           响应方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)rightbuttonItemWithImage:(NSString *)imageUrl highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;

/**
 *  创建一个应用于导航栏左侧的按钮
 *
 *  @param title  标题
 *  @param target 目标对象
 *  @param action 相应方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)leftbuttonItemWithText:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  创建一个应用于导航栏右侧的按钮
 *
 *  @param title  标题
 *  @param target 目标对象
 *  @param action 相应方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)rightbuttonItemWithText:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  返回按钮
 *
 *  @param target 目标对象
 *  @param action 响应方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)backbuttonItemWithTarget:(id)target action:(SEL)action;
/**
 *  创建一个导航栏标题风格的label
 *
 *  @param title 标题名称
 *
 *  @return Label
 */
+ (UILabel *)titleLabelWithTitle:(NSString *)title;

#pragma mark - 系统
/**
 *  获取info.plist定义app的bundleId
 *
 *  @return bundleId
 */
+ (NSString *)bundleIdString;
/**
 *  获取info.plist定义的app版本号
 *
 *  @return 返回版本信息字符串例如1.0.0
 */
+ (NSString *)appVersionString;

/**
 *  跳转到appstore评价页面
 */
+ (void)giveAMarkInAppStore;
/**
 *  应用在Appstore页面
 */
+ (void)showAppPage;

/**
 *  返回版本检测的url
 *
 *  @return url 字符串
 */
+ (NSString *)versionCheckUrlString;

/**
 *  调用接口时传的版本号
 *
 *  @return 调用接口时传的版本号
 */
+ (NSString *)versionStringForRequest;

/**
 *  是否开启接受推送
 *
 *  @return 是否开启接受推送
 */
+ (BOOL)isEnableRecivePushNotification;

/**
 *  请求新版本
 *
 *  @param block 回调
 */
+ (void)sendCheckVersionRequestWithBlock:(void(^)(NSDictionary *infoDic))block;


+(BOOL)judgeCameraAuth;

#pragma mark - UI
/**
 *  根据指定颜色对象创建UIImage
 *
 *  @param color 颜色
 *
 *  @return 图像
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;
/**
 *  将6为rgp十六进制字符串转为UIColor对象
 *
 *  @param stringToConvert 十六进制颜色值（0XFFFFFF或FFFFFF）
 *
 *  @return UIColor对象
 */
+ (UIColor*)colorWithHexString:(NSString *)stringToConvert;

/**
 *  初始化选择器
 *
 *  @param segmentedControl 选择器
 */
+ (void)commonInitSegmentedControl:(HMSegmentedControl *)segmentedControl;

/**
 *  可拉伸的背景
 *
 *  @return UIimage实例
 */
+ (UIImage *)cellBGResizeableImage;

+ (CGSize)fullSizeOfText:(NSString *)text font:(UIFont *)textFont size:(CGSize)size;

#pragma mark - 验证
/**
 *  根据身份证判断其是否为男性
 *
 *  @param idcard 身份证号码
 *
 *  @return YES：男性，NO：女性
 */
+ (BOOL)isMaleFromIdCard:(NSString *)idcard;

//正则式校验
/**
 *  邮箱是否合法
 *
 *  @param value 邮箱字符串
 *
 *  @return YES：合法，NO：不合法
 */
+ (BOOL)isValidEmail:(NSString *)value;

/**
 *  校验是否是一个合法的用户名，根据业务需要修改
 *
 *  @param value 待校验字符串
 *
 *  @return YES：合法，NO：不合法
 */
+ (BOOL)isValidUserName:(NSString *)value;

/**
 *  校验是否是一个合法的密码，根据业务需要修改
 *
 *  @param value 待校验字符串
 *
 *  @return YES：合法，NO：不合法
 */
+ (BOOL)isValidPassword:(NSString *)value;

/**
 *  校验是否是一个合法的手机号
 *
 *  @param value 待校验字符串
 *
 *  @return YES：合法，NO：不合法
 */
+ (BOOL)isValidMobilePhone:(NSString *)value;

/**
 *  校验是否是一个连续（相同/递增）的字符串
 *
 *  @param value 待校验字符串
 *
 *  @return YES：合法，NO：不合法
 */
+ (BOOL)isContinuousString:(NSString *)value;

/**
 *  校验是否是一个合法的身份证号
 *
 *  @param value 待校验字符串
 *
 *  @return YES：合法，NO：不合法
 */
+ (NSString *)isValidIDCard:(NSString *)value;
/**
 *  校验是否是一个合法的英文名
 *
 *  @param value 待校验字符串
 *
 *  @return YES：合法，NO：不合法
 */
+ (BOOL)isValidEnName:(NSString *)value;

/**
 *  校验是否是一个合法中文
 *
 *  @param value 待校验字符串
 *
 *  @return YES：合法，NO：不合法
 */
+ (BOOL)isValidAllCnString:(NSString *)value;

/**
 *  校验是否是一个合法中文名
 *
 *  @param value 待校验字符串
 *
 *  @return YES：合法，NO：不合法
 */
+ (BOOL)isValidCnName:(NSString *)value;

#pragma mark - 字符串操作
/**
 *  清除字符串中的空格、回车、换行符、制表符
 *
 *  @param value 原字符串
 *
 *  @return 过滤后字符串
 */
+ (NSString *)cleanString:(NSString *)value;

/**
 *  拼接医生完整职称
 *
 *  @param doctorTitle    职称
 *  @param departmentName 科室名
 *
 *  @return 完成职称
 */
+ (NSString *)fullTitleStringWithDepartmentName:(NSString *)departmentName doctorTitle:(NSString *)doctorTitle ;

#pragma mark - 时间日期
/**
 *  从身份证中获取出生日期
 *
 *  @param idcard 身份证号码
 *
 *  @return 生日
 */
+ (NSDate *)birthdayFromIdCard:(NSString *)idcard;

/**
 *  通过身份证号判断是否是成年人
 *
 *  @param idCard 身份证号
 *
 *  @return 判断结果
 */
+ (BOOL)isAdultFromIdCard:(NSString *)idCard;

/**
 *  获取对应日期的周几
 *
 *  @param dateString yyyy-MM-dd格式的日期字符串
 *
 *  @return 周几（星期一...）
 */
+ (NSString *)weekStringFromDate:(NSString*)dateString;

/**
 *  获取时分秒
 *
 *  @param dateString yyyy-MM-dd hhmmss格式的日期字符串
 *
 *  @return xx时xx分xx秒
 */
+ (NSString *)hourFormatStringFromDate:(NSString*)dateString;

/**
 *  获取距离天数，十位
 *
 *  @param dateString yyyy-MM-dd格式的日期字符串
 *
 *  @return 距离十位描述（）
 */
+ (NSString *)tenDaysStringFromDate:(NSString*)dateString;

/**
 *  获取距离天数，个位
 *
 *  @param dateString yyyy-MM-dd格式的日期字符串
 *
 *  @return 距离个位描述（）
 */
+ (NSString *)bitDaysStringFromDate:(NSString*)dateString;

/**
 *  获取距离天数，个位
 *
 *  @return yyyy-MM-dd HHmmss格式的日期字符串
 */
+ (NSString *)nowTimeDescriptiong;



/**
 *  调用接口时传的版本号
 *
 *  @param seeTimeFromServer seeTime字段从接口返回的值
 *
 *  @return 统一格式化之后的日期
 */
+ (NSString *)fomartSeeTimeFromServer:(NSString *)seeTimeFromServer;

/**
 *  格式化日期字符串 yyyy-MM-dd格式
 *
 *  @param date 时间
 *
 *  @return 格式化之后的日期
 */
+ (NSString *)fomartForDate:(NSDate *)date;


/**
 *  格式化日期字符串 formatStr 格式
 *
 *  @param datsStr 时间
 *
 *  @return 格式化之后的日期
 */
+ (NSDate *)fomartDateFromString:(NSString *)datsStr
                            format:(NSString*)formatStr;

/**
 *  格式化日期字符串 formatStr 格式
 *
 *  @param datsStr 时间
 *
 *  @return 格式化之后的日期
 */
+ (NSString *)fomartDateStringFromString:(NSString *)datsStr
                          format:(NSString*)formatStr
                        newFormat:(NSString*)newFormat;


/**
 *  计算日期偏差
 *
 *  @param srcDate    日期基准
 *  @param tarDateStr 目标日期字符串
 *  @param formatStr  目标日期格式
 *
 *  @return 
 */
+ (NSInteger)dateNumberFromDate:(NSDate *)srcDate
                        toString:(NSString *)tarDateStr
                          format:(NSString*)formatStr;

#pragma mark - 控制器
+(AppDelegate*)currentAppDelegate;

/**
 *  从main.storyboard中获取viewcontroller
 *
 *  @param storyboardID view controller 在story中的id
 *
 *  @return view controller 实例
 */
+ (UIViewController *)controllerInMainStroyboardWithID:(NSString *)storyboardID;

+ (UIViewController *)controllerStroyboardWithName:(NSString *)storyboardName
                                      storyboardID:(NSString*)storyboardID;

@end
