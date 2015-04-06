//
//  Utils.m
//
//  Created on 12-6-14.
//  Copyright (c) 2012年 焦点科技. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"
#import "MD5Util.h"
#import "NSString+URLEncoding.h"
#import "RegexKitLite.h"
#import "MBProgressHUD.h"
#import "NSObject+Null.h"
#import "NSDate+TKCategory.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "InfoUIDevice.h"
#import "Reachability.h"
#import "OpenUDID.h"
#import "JSONKit.h"

@implementation Utils

+ (NSString *)bundleIdString
{
    NSString *identifier =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
    return identifier;
}

+ (NSString *)appVersionString
{
    NSString *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return version;
}

+ (UIAlertView *)showSimpleAlert:(NSString *)message delegate:(id)alertDelegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:alertDelegate cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
    return alert;
}

+ (void)showSimpleAlert:(NSString *)message 
{
    [Utils showSimpleAlert:message delegate:nil];
}

+ (void)showToastWithMessage:(NSString *)mesage
{
    if (!mesage || ![mesage isKindOfClass:[NSString class]]) {
        mesage = @"";
    }
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWin = windows[0];
    UIWindow *winodw = mainWin;
    for (NSInteger  i = windows.count-1; i >= 0; i--) {
        UIWindow *win = windows[i];
        if (CGRectEqualToRect(win.bounds, mainWin.bounds) && (win.windowLevel == UIWindowLevelNormal)) {
            winodw = win;
            break;
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:winodw animated:YES];
    hud.yOffset = 150;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = mesage;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:2.];
}

+ (void)showCenterToastWithMessage:(NSString *)mesage
{
    if (!mesage || ![mesage isKindOfClass:[NSString class]]) {
        mesage = @"";
    }
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWin = windows[0];
    UIWindow *winodw = mainWin;
    for (NSInteger  i = windows.count-1; i >= 0; i--) {
        UIWindow *win = windows[i];
        if (CGRectEqualToRect(win.bounds, mainWin.bounds) && (win.windowLevel == UIWindowLevelNormal)) {
            winodw = win;
            break;
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:winodw animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = mesage;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:2.];
}

+ (void)showCenterToastWithMessage:(NSString *)mesage inView:(UIView*)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = mesage;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:2.];
}

+ (MBProgressHUD *)showCoverKeyboardHUD:(NSString *)message
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWin = windows[0];
    for (NSInteger  i = windows.count-1; i >= 0; i--) {
        UIWindow *win = windows[i];
        if ([win isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
            mainWin = win;
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainWin animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

/*
 * 根据字符串类型的16进制的色值返回相应的颜色
 * 传入参数  "0xFF0000"或者 "FFFFFF" 
 * 返回     UIColor
 */
+(UIColor*)colorWithHexString:(NSString *)stringToConvert  
{  
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];  
	
    // String should be 6 or 8 characters  
    if ([cString length] < 6) return nil;  
	
    // strip 0X if it appears  
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
	
    if ([cString length] != 6 &&[cString length] != 8) return nil;  
	
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
	
    // Scan values  
    unsigned int r, g, b,a=255.0;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
	if ([cString length] == 8)  
	{
		range.location = 6; 
		NSString *aString = [cString substringWithRange:range]; 
		[[NSScanner scannerWithString:aString] scanHexInt:&a]; 
	}
	
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:((float) a / 255.0f)];  
} 

+ (void)commonInitSegmentedControl:(HMSegmentedControl *)segmentedControl
{
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorHeight = 2.0f;
    segmentedControl.selectedTextColor = kColorMainTint;
    segmentedControl.selectionIndicatorColor = kColorMainTint;
    segmentedControl.textColor = RGB(102, 102, 102);
    segmentedControl.backgroundColor = RGB(242, 242, 242);
}

+ (UIImage *)cellBGResizeableImage
{
    UIImage *image = [UIImage imageNamed:@"generalCellBg.png"];
    
    UIImage *resizeedImage = [image resizableImageWithCapInsets:(UIEdgeInsetsMake(10, 5, 30, 5)) resizingMode:(UIImageResizingModeTile)];
    
    return resizeedImage;
}

+ (CGSize)fullSizeOfText:(NSString *)text font:(UIFont *)textFont size:(CGSize)size
{
    if (IOS_VERSION_7_LATER) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        return [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:textFont,NSParagraphStyleAttributeName:style} context:nil].size;
        
    }
    else {
        return [text sizeWithFont:textFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    
}

+ (MBProgressHUD *)showLoadingViewInWindowWithTitle:(NSString*)title delegate:(id<MBProgressHUDDelegate>) delegate
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWin = windows[0];
    UIWindow *window = mainWin;
    for (NSInteger  i = windows.count-1; i >= 0; i--) {
        UIWindow *win = windows[i];
        if (CGRectEqualToRect(win.bounds, mainWin.bounds) && win.windowLevel == UIWindowLevelNormal) {
            window = win;
            break;
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    hud.delegate = delegate;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (MBProgressHUD *)showPromptViewInWindowWithTitle:(NSString*)title afterDelay:(NSTimeInterval)delay{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWin = windows[0];
    UIWindow *window = mainWin;
    for (NSInteger  i = windows.count-1; i >= 0; i--) {
        UIWindow *win = windows[i];
        if (CGRectEqualToRect(win.bounds, mainWin.bounds) && win.windowLevel == UIWindowLevelNormal) {
            window = win;
            break;
        }
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hud];
    if (title) {
        hud.labelText = title;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    if (delay > 0) {
        [hud hide:YES afterDelay:delay];
    }
    return hud;
}

+ (void)hideLoadingView
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWin = windows[0];
    UIWindow *window = mainWin;
    for (NSInteger  i = windows.count-1; i >= 0; i--) {
        UIWindow *win = windows[i];
        if (CGRectEqualToRect(win.bounds, mainWin.bounds) && win.windowLevel == UIWindowLevelNormal) {
            window = win;
            break;
        }
    }
    [MBProgressHUD hideHUDForView:window animated:YES];

}

#define MAX_BACK_BUTTON_WIDTH 160.0
//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define kColorWinTint                       [UIColor whiteColor]
#define kColorWinHightlyTint                RGBA(252, 58, 43,0.5)
#define kColorHightlyWhite                  RGBA(255, 255, 255, 0.5)


//+ (UIBarButtonItem*) backButtonItemWithTarget:(id)target action:(SEL)action {
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 51, 44);
//    [button setImage:[UIImage imageNamed:@"nav_back_normal.png"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"nav_back_hight.png"] forState:UIControlStateHighlighted];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside]; 
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
//    return item;
//}

+ (UIBarButtonItem *) cancelButtonItemWithTarget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 51, 44);
    [button setImage:[UIImage imageNamed:@"nav_cancel_normal.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_cancel_hight.png"] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}
+ (UIBarButtonItem*) buttonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIFont *font = [UIFont boldSystemFontOfSize:17.0];
    CGRect frame;
    UIImage *normalBgImg;
    frame = CGRectMake(0, 0, 50, 44);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:normalBgImg forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [button setTitleColor:kColorWinTint forState:UIControlStateNormal];
    [button setTitleColor:kColorHightlyWhite forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem*) buttonItemWith7Title:(NSString *)title target:(id)target action:(SEL)action {
    UIFont *font = [UIFont boldSystemFontOfSize:17.0];
    CGRect frame = CGRectMake(0, 0, 50, 44);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:kColorHightlyWhite forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)leftbuttonItemWithImage:(NSString *)imageUrl  highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
    if (highlightedImage) {
        [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)rightbuttonItemWithImage:(NSString *)imageUrl highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
    if (highlightedImage) {
        [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)leftbuttonItemWithText:(NSString *)title target:(id)target action:(SEL)action
{
    UIFont *font = [UIFont boldSystemFontOfSize:17.0];
    CGRect frame = CGRectMake(0, 0, 50, 44);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:kColorHightlyWhite forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)rightbuttonItemWithText:(NSString *)title target:(id)target action:(SEL)action
{
    UIFont *font = [UIFont boldSystemFontOfSize:17.0];
    CGRect frame = CGRectMake(0, 0, 75, 44);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:kColorHightlyWhite forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)backbuttonItemWithTarget:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 40, 44);
    //[button setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    button.frame = CGRectMake(0, 0, 25, 41);
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")?-40:-20, 0, 0)];
    [button setImage:[UIImage imageNamed:@"btn_nav_back.png"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"nav_back_press"] forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UILabel *)titleLabelWithTitle:(NSString *)title
{
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:17.]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 31)];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:17.];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    return label;
}


+ (NSDate *)birthdayFromIdCard:(NSString *)idcard
{
    NSString *birthday;
    if ([idcard length] == 15) {
        birthday = [NSString stringWithFormat:@"19%@",[idcard substringWithRange:NSMakeRange(6,6)]];
    }else {
        birthday = [idcard substringWithRange:NSMakeRange(6,8)];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    return [formatter dateFromString:birthday];
}

+ (BOOL)isAdultFromIdCard:(NSString *)idCard
{
    NSDate *brithday = [self birthdayFromIdCard:idCard];
    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    components.year = 18;
    NSDate *dayOf18 = [cal dateByAddingUnit:(NSCalendarUnitYear) value:18 toDate:brithday options:(NSCalendarWrapComponents)];
    
    if ([dayOf18 timeIntervalSinceDate:[NSDate date]] <= 0.0f) {
        return YES;
    }
    else {
        return NO;
    }
    
}

+ (BOOL)isMaleFromIdCard:(NSString *)idcard
{
    if ([idcard length] == 15) {
        return [[idcard substringFromIndex:14] intValue]%2 == 1;
    }else {
        return [[idcard substringWithRange:NSMakeRange(16,1)] intValue]%2 == 1;
    }
}

+ (BOOL)isValidEmail:(NSString *)value
{
    if ([value isNullClass]) {
        return NO;
    }
    NSString *regex = @"^([a-zA-Z0-9]+[_|\\_|\\.\\-]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\\_|\\.|\\-]?)*[a-zA-Z0-9]+\\.[a-zA-Z]{2,3}$";
    return [value isMatchedByRegex:regex];
}

+ (BOOL)isValidUserName:(NSString *)value
{
    if ([value isNullClass]) {
        return NO;
    }
    NSString *regex = @"^[a-zA-Z0-9\\/-]+$";
    return [value isMatchedByRegex:regex];
}

+ (BOOL)isValidPassword:(NSString *)value
{
    if ([value isNullClass]) {
        return NO;
    }
    NSString *regex = @"^[a-zA-Z0-9\\/-]+$";
    return [value isMatchedByRegex:regex];
}

+ (BOOL)isValidMobilePhone:(NSString *)value
{
    if ([value isNullClass]) {
        return NO;
    }
    NSString *regex = @"^1\\d{10}$";
    return [value isMatchedByRegex:regex];
}

+ (BOOL)isContinuousString:(NSString *)value
{
    if ([value isNullClass]) {
        return YES;
    }
    unichar begin = [value characterAtIndex:0];
    NSInteger count = [value length];
    NSMutableString *newStr = [[NSMutableString alloc] initWithFormat:@"%c",begin];
    for (int i = 0; i < count-1; i++) {
        [newStr appendFormat:@"%c",++begin];
    }
    if ([value isEqualToString:newStr]) {
        return YES;
    }
    begin = [value characterAtIndex:0];
    newStr = [[NSMutableString alloc] initWithFormat:@"%c",begin];
    for (int i = 0; i < count-1; i++) {
        [newStr appendFormat:@"%c",--begin];
    }
    if ([value isEqualToString:newStr]) {
        return YES;
    }
    begin = [value characterAtIndex:0];
    newStr = [[NSMutableString alloc] initWithFormat:@"%c",begin];
    for (int i = 0; i < count-1; i++) {
        [newStr appendFormat:@"%c",begin];
    }
    if ([value isEqualToString:newStr]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isValidEnName:(NSString *)value
{
    if ([value isNullClass]) {
        return NO;

    }
    NSString *regex = @"^[a-zA-Z \\.]+$";
    return [value isMatchedByRegex:regex];
}

+ (BOOL)isValidAllCnString:(NSString *)value
{
    if ([value isNullClass]) {
        return NO;
        
    }
    NSString *regex = @"^[\u4e00-\u9fff]+$";
    return [value isMatchedByRegex:regex];
}

+ (BOOL)isValidCnName:(NSString *)value
{
    return [Utils isValidAllCnString:value];
}

+ (NSString *)isValidIDCard:(NSString *)value
{
    if ([value isKindOfClass:[NSNull class]] || value.length == 0) {
        return @"身份证号不能为空";
    }
    NSDictionary *area = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"北京",@"11",@"天津",@"12",@"河北",@"13",@"山西",@"14",@"内蒙古",@"15",//华北
                          @"辽宁",@"21",@"吉林",@"22",@"黑龙江",@"23",//东北
                          @"上海",@"31",@"江苏",@"32",@"浙江",@"33",@"安徽",@"34",@"福建",@"35",@"江西",@"36",@"山东",@"37",//华东
                          @"河南",@"41",@"湖北",@"42",@"湖南",@"43",@"广东",@"44",@"广西",@"45",@"海南",@"46",@"重庆",//中南
                          @"50",@"四川",@"51",@"贵州",@"52",@"云南",@"53",@"西藏",@"54",//西南
                          @"陕西",@"61",@"甘肃",@"62",@"青海",@"63",@"宁夏",@"64",@"新疆",@"65",//西北
                          @"台湾",@"71",@"香港",@"81",@"澳门",@"82",@"国外",@"91", nil];
    NSArray *errors = [NSArray arrayWithObjects:@"身份证验证通过!", 
                       @"身份证号码位数不对!", 
                       @"身份证号码出生日期超出范围或含有非法字符!", 
                       @"身份证号码校验错误!", 
                       @"身份证号码在地区处非法!", nil];
    if ([value length] != 15 && [value length] != 18) {
        return [errors objectAtIndex:1];
    }
    
    if (![area objectForKey:[value substringToIndex:2]]) {
        return [errors objectAtIndex:4];
    }
    NSString *ereg = nil;
    if ([value length] == 15) {
        ereg = @"^\\d{15}";
        if (![value isMatchedByRegex:ereg]){
            return [errors objectAtIndex:2];
        }
        NSString *birthday = [NSString stringWithFormat:@"19%@",[value substringWithRange:NSMakeRange(6,6)]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMdd";
        NSDate *date = [formatter dateFromString:birthday];
        if (date) {
            return nil;
        }else {
            return [errors objectAtIndex:2];
        }
    }else if ([value length] == 18) {
        ereg = @"^\\d{17}[0-9xX]{1}$";
        if (![value isMatchedByRegex:ereg]){
            return [errors objectAtIndex:2];
        }
        NSString *birthday = [value substringWithRange:NSMakeRange(6,8)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMdd";
        NSDate *date = [formatter dateFromString:birthday];

        NSMutableArray *idCards = [NSMutableArray array];;
        for (int i = 0; i < 18; i++) {
            [idCards addObject:[value substringWithRange:NSMakeRange(i, 1)]];
        }
        if(date){ 
            NSInteger S = ([[idCards objectAtIndex:0] intValue] + [[idCards objectAtIndex:10] intValue]) * 7 
            + ([[idCards objectAtIndex:1] intValue] + [[idCards objectAtIndex:11] intValue]) * 9 
            + ([[idCards objectAtIndex:2] intValue] + [[idCards objectAtIndex:12] intValue]) * 10 
            + ([[idCards objectAtIndex:3] intValue] + [[idCards objectAtIndex:13] intValue]) * 5 
            + ([[idCards objectAtIndex:4] intValue] + [[idCards objectAtIndex:14] intValue]) * 8 
            + ([[idCards objectAtIndex:5] intValue] + [[idCards objectAtIndex:15] intValue]) * 4 
            + ([[idCards objectAtIndex:6] intValue] + [[idCards objectAtIndex:16] intValue]) * 2 
            + [[idCards objectAtIndex:7] intValue] * 1 
            + [[idCards objectAtIndex:8] intValue] * 6 
            + [[idCards objectAtIndex:9] intValue] * 3 ; 
            NSInteger Y = S % 11; 
            NSString *JYM = @"10X98765432"; 
            NSString *M = [JYM substringWithRange:NSMakeRange(Y,1)]; 
            if([[M uppercaseString] isEqualToString:[[idCards objectAtIndex:17] uppercaseString]])
                return nil; 
            else 
                return [errors objectAtIndex:3]; 
        } 
        else {
            return [errors objectAtIndex:2]; 
        }
    }else {
        return [errors objectAtIndex:1]; 
    }
    
}


+ (void)giveAMarkInAppStore{
    NSString *str = [NSString stringWithFormat: 
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", 
                     APP_ID];  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]; 
}

+ (void)showAppPage{
    //软件首页
    NSString *str2 = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str2]];
}


+ (NSString *)cleanString:(NSString *)value
{
    NSString *reg = @"\\s*|\t|\r|\n";
    value = [value stringByReplacingOccurrencesOfRegex:reg withString:@""];
    return value;
}

+ (NSString *)fullTitleStringWithDepartmentName:(NSString *)departmentName doctorTitle:(NSString *)doctorTitle
{

    if (departmentName.length == 0 && doctorTitle.length == 0) {
        return @"";
    }
    
    NSString *fullTitle = @"【";
    
    if (departmentName.length > 0) {
        fullTitle = [fullTitle stringByAppendingFormat:@"%@",departmentName];
    }
    
    if (doctorTitle.length > 0) {
        
        if (![fullTitle isEqualToString:@"【"]) {
            fullTitle = [fullTitle stringByAppendingString:@" "];
        }
        
        fullTitle = [fullTitle stringByAppendingFormat:@"%@",doctorTitle];
    }
    
    fullTitle = [fullTitle stringByAppendingString:@"】"];
    return fullTitle;
}

+ (NSString *)weekStringFromDate:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateString];
    NSInteger weekDay = [date dateInformation].weekday;
    switch (weekDay) {
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        case 1:
            return @"星期日";
            break;
            
        default:
            break;
    }
    return nil;
}

+ (NSString *)hourFormatStringFromDate:(NSString*)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    NSInteger ht = [date dateInformation].hour;
    NSInteger mt = [date dateInformation].minute;
    NSInteger st = [date dateInformation].second;
    
    NSString *result = [NSString stringWithFormat:@"%ld时%ld分%ld秒更新",(long)ht,(long)mt,(long)st];
    return result;
}

+ (NSString *)tenDaysStringFromDate:(NSString*)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateString];
    
    NSDate * now = [NSDate date];
    NSString *nowStr =  [formatter stringFromDate:now];
    NSDate *nowDate = [formatter dateFromString:nowStr];
    NSTimeInterval timeBetween = [date timeIntervalSinceDate:nowDate];
//
    int days=((int)timeBetween)/(3600*24);
    NSString *tenDay=[[NSString alloc] initWithFormat:@"%d",days/10];
    return tenDay;
    
}


+ (NSString *)bitDaysStringFromDate:(NSString*)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateString];
    
    NSDate * now = [NSDate date];
    NSString *nowStr =  [formatter stringFromDate:now];
    NSDate *nowDate = [formatter dateFromString:nowStr];
    NSTimeInterval timeBetween = [date timeIntervalSinceDate:nowDate];
//
    int days=((int)timeBetween)/(3600*24);
    NSString *bitDay=[[NSString alloc] initWithFormat:@"%d",days%10];
    return bitDay;
    
}

+ (NSString *)nowTimeDescriptiong{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate * now = [NSDate date];
    NSString *nowStr =  [formatter stringFromDate:now];
    return nowStr;
}

+ (NSString *)versionStringForRequest
{
    return [NSString stringWithFormat:@"IOS%@",[Utils appVersionString]];
}

+ (void)sendCheckVersionRequestWithBlock:(void (^)(NSDictionary *))block
{
    
    
}

+ (NSString *)versionCheckUrlString
{
    NSString *urlBaseString = @"http://s.wfeature.com/base/product/checkVersion?productName=%@&platName=%@&channelName=self&version=%@";
    NSString *urlFullString = [NSString stringWithFormat:urlBaseString,@"jkwy",@"ios",VERSION_APP_STRING];
    
    return urlFullString;
    
#if 0
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[InfoUIDevice currentDevice].hardwareDescription forKey:@"deviceName"];
    [param setObject:[UIDevice currentDevice].systemVersion forKey:@"deviceFirmwareVersion"];
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
        [param setObject:@"yes" forKey:@"isownCamera"];
    }
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    
    int width = [UIScreen mainScreen].scale*size_screen.width;
    int height = [UIScreen mainScreen].scale*size_screen.height;
    
    [param setObject:[NSString stringWithFormat:@"%d %d",width,height] forKey:@"deviceShowratio"];
    
    [param setObject:[NSString stringWithFormat:@"%lu M",NSRealMemoryAvailable()/(1024*1024)] forKey:@"deviceTotalMemory"];
    
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    if ([carrier carrierName] && ![@"" isEqualToString:[carrier carrierName]]) {
        [param setObject:[carrier carrierName] forKey:@"belongedBusiness"];
    }
    
    NetworkStatus netStatus = [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus];
    switch (netStatus) {
        case ReachableViaWWAN:
            [param setObject:@"4" forKey:@"netState"];
            break;
        case ReachableViaWiFi:
            [param setObject:@"2" forKey:@"netState"];
            break;
        default:
            break;
    }
    
    [param setObject:@"" forKey:@"productName"];
    [param setObject:@"ios" forKey:@"platformName"];
    [param setObject:@"" forKey:@"productChannel"];
    [param setObject:VERSION_APP_STRING forKey:@"productVersion"];
    [param setObject:[OpenUDID value] forKey:@"userPkId"];
    
    NSString *paramString = nil;
    NSArray *keys = [param allKeys];
    NSMutableString *params = [[NSMutableString alloc] initWithString:@"?"];
    for (NSString *key in keys) {
        [params appendFormat:@"%@=%@&",key,[param objectForKey:key]];
    }
    if ([params length] == 1) {
        paramString = @"";
    }else {
        paramString = [params substringToIndex:[params length]-1];
    }
    
    NSString *urlString = [@"http://scnc.wfeature.com/base/broadcast/registerUserGet" stringByAppendingString:paramString];
    return [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#endif
}

+ (BOOL)isEnableRecivePushNotification
{
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        return [[UIApplication sharedApplication] currentUserNotificationSettings] != UIRemoteNotificationTypeNone;
    }
    else {
        return [[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone;
    }
    
    
}

+ (NSString *)fomartSeeTimeFromServer:(NSString *)seeTimeFromServer
{
    if (seeTimeFromServer.length == 0) {
        return @"";
    }
    
    NSInteger time = [seeTimeFromServer integerValue];
    if (time == 1) {
        return @"上午";
    }else if (time == 2) {
        return @"下午";
    }else if (time == 3) {
        return @"下午";
    }else if (time == 4) {
        return @"夜晚";
    }else if (time == 5) {
        return @"早班";
    }else if (time == 6) {
        return @"全天";
    }else {
        
        if ([seeTimeFromServer isKindOfClass:[NSString class]]
            && seeTimeFromServer.length > 0) {
            return [NSString stringWithFormat:@"%@",seeTimeFromServer];
        }
        
        return @"";
    }
}

+ (NSString *)fomartForDate:(NSDate *)date
{
    if (nil == date) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";

    NSString *nowStr =  [formatter stringFromDate:date];
    return nowStr;
}

+ (NSDate *)fomartDateFromString:(NSString *)datsStr
                            format:(NSString*)formatStr{
    
    if (nil == datsStr
        || nil == formatStr) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatStr;
    NSDate *date = [formatter dateFromString:datsStr];
    
    return date;
}

+ (NSString *)fomartDateStringFromString:(NSString *)datsStr
                                  format:(NSString*)formatStr
                               newFormat:(NSString*)newFormat;{
    if (nil == datsStr
        || nil == formatStr) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatStr;
    NSDate *date = [formatter dateFromString:datsStr];
    
    formatter.dateFormat = newFormat;
    return [formatter stringFromDate:date];
}

+ (NSInteger)dateNumberFromDate:(NSDate *)srcDate toString:(NSString *)tarDateStr format:(NSString *)formatStr
{
    if (nil == srcDate
        || nil == tarDateStr
        || nil == formatStr) {
        return NSNotFound;
    }
    
    
    //取出目标日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatStr;
    NSDate *tarDate = [formatter dateFromString:tarDateStr];
    
    //时间转换为0点
    NSString *zeroFormat = @"yyy-MM-dd";
    formatter.dateFormat = zeroFormat;
    NSString *srcDateZero = [formatter stringFromDate:srcDate];
    NSString *tarDateZero = [formatter stringFromDate:tarDate];
    
    //计算时间差
    NSTimeInterval timeInterval = [[formatter dateFromString:tarDateZero] timeIntervalSinceDate:[formatter dateFromString:srcDateZero]];
    NSInteger result = (NSInteger)timeInterval / 3600 / 24;
    
    return result;
    
}

+(BOOL)judgeCameraAuth{
    
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    NSLog(@"---AVAuthorizationStatus--------%ld",(long)authStatus);
    
    // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
    
    if(authStatus == AVAuthorizationStatusRestricted
       || authStatus == AVAuthorizationStatusAuthorized){
        // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
        NSLog(@"Restricted");
        
        return YES;
    }
    else {
        
        if(authStatus == AVAuthorizationStatusDenied){
            
            // The user has explicitly denied permission for media capture.
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined){
            
            // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
            
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                
                if(granted){//点击允许访问时调用
                    
                    //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                    
                    NSLog(@"Granted access to %@", mediaType);
                }
                
                else {
                    NSLog(@"Not granted access to %@", mediaType);
                }
            }];
        }
        else {
            NSLog(@"Unknown authorization status");
        }
        
    }
    return NO;
}

+(AppDelegate*)currentAppDelegate{
    
    return ((AppDelegate*)([UIApplication sharedApplication].delegate));
}

+ (NSString*)currentUDID;{
    
    return [OpenUDID value];
}

+ (UIViewController *)controllerInMainStroyboardWithID:(NSString *)storyboardID
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    return [storyboard instantiateViewControllerWithIdentifier:storyboardID];
}

+ (UIViewController *)controllerStroyboardWithName:(NSString *)storyboardName
                                        storyboardID:(NSString*)storyboardID
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    return [storyboard instantiateViewControllerWithIdentifier:storyboardID];
}


@end
