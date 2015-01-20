//
//  EHUserDefaultManager.m
//  EHealth
//
//  Created by zhoushaolong on 14-12-9.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import "EHUserDefaultManager.h"
#import "JSONKit.h"

#define     kHasLaunched                @"kHasLaunched"

#define kTagAlertForce 1001
#define kTagAlertNotForce 1002

@interface EHUserDefaultManager()
<UIAlertViewDelegate>
{
    NSUserDefaults *userDefailts;
}
@property (nonatomic ,copy) NSString *appStoreUrl;
@property (nonatomic, copy) NSString *appNewVersion;
@property (nonatomic, copy) NSString *appNewDesc;
@end

@implementation EHUserDefaultManager

DEFINE_SINGLETON_FOR_CLASS(EHUserDefaultManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        userDefailts  = [NSUserDefaults standardUserDefaults];
        
        _lastPdsn = [userDefailts objectForKey:k_LastPdsn];
    }
    return self;
}

#pragma mark - Public Method
- (BOOL)isFirstLaunch{
    return ![userDefailts boolForKey:kHasLaunched];
}

- (void)appDidLaunched{
    [userDefailts setBool:YES forKey:kHasLaunched];
    //[userDefailts setObject:[Utils appVersionString] forKey:IOS_VERSION_STRING];
    [userDefailts synchronize];
}

- (NSString*)LastPdsn{
    self.lastPdsn = [userDefailts objectForKey:k_LastPdsn];
    return _lastPdsn;
}

- (void)updatelastLastPdsn:(NSString*)refrashTime{
    
    self.lastPdsn = refrashTime;
    
    [userDefailts setObject:(nil == self.lastPdsn)?@"":self.lastPdsn forKey:k_LastPdsn];
    [userDefailts synchronize];
}

- (void)removelastLastPdsn{
    [userDefailts removeObjectForKey:k_LastPdsn];
    [userDefailts synchronize];
}

//- (NSString*)currentUserSSID{
//    
//}
//
//- (void)updateCurrentUserSSID:(NSString*)dCode;
//- (void)removeCurrentUserSSID;
//
//- (NSString*)currentUserWIFIPWD;
//- (void)updateCurrentUserWIFIPWD:(NSString*)dCode;
//- (void)removeCurrentUserWIFIPWD;

//- (void)removeLastUserInfo
//{
//    [userDefailts removeObjectForKey:k_LastUserInfo];
//    [userDefailts synchronize];
//}
//
//- (NSString*)lastHostialInfoRefresh{
//    NSString *lastData = [userDefailts objectForKey:k_LastRefreshTime_HospitalInfo];
//    //self.lastUsedCard = [NSKeyedUnarchiver unarchiveObjectWithData:lastUsedCardData];
//    
//    return lastData;
//}
//
//- (void)updatelastHostialInfoRefresh:(NSString*)refrashTime{
//    //NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:card];
//    if (0 == refrashTime.length) {
//        return;
//    }
//    [userDefailts setObject:refrashTime forKey:k_LastRefreshTime_HospitalInfo];
//    [userDefailts synchronize];
//}
//
//- (void)removelastHostialInfoRefresh{
//    
//    [userDefailts removeObjectForKey:k_LastRefreshTime_HospitalInfo];
//    [userDefailts synchronize];
//}

- (void)removeAllUserDefaults{
    //[userDefailts removeObjectForKey:kLastUsedCard];
    [userDefailts removeObjectForKey:kHasLaunched];
    [userDefailts synchronize];
}

#pragma mark --Version Check
- (void)checkNewVersionWithWaiting:(BOOL)showLoading
{
    MBProgressHUD *hud = nil;
    
    if (showLoading) {
        hud = [Utils showLoadingViewInWindowWithTitle:nil delegate:nil];
    }
    
    weakSelf(wSelf);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL * url = [NSURL URLWithString:[Utils versionCheckUrlString]];
        NSError * error;
        NSString * dataString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *infoDic = nil;
            
            if (dataString != nil) {
                infoDic = [[dataString objectFromJSONString] firstObject];
            }
            
            if (infoDic && [infoDic isKindOfClass:[NSDictionary class]]) {
                
                DLog(@"dic:%@",infoDic);
                
                if (showLoading) {
                    [hud hide:YES];
                }
                
                if (infoDic) {
                    //保存升级地址
                    if (infoDic[@"upgradeUrl"] && [infoDic[@"upgradeUrl"] isKindOfClass:[NSString class]]) {
                        wSelf.appStoreUrl = infoDic[@"upgradeUrl"];
                    }
                    
                    //保存提示文字
                    if (infoDic[@"remarksUpdate"] && [infoDic[@"remarksUpdate"] isKindOfClass:[NSString class]]) {
                        wSelf.appNewDesc = infoDic[@"remarksUpdate"];
                    }
                    
                    //保存新版本号
                    if (infoDic[@"versionInfo"] && [infoDic[@"versionInfo"] isKindOfClass:[NSString class]]) {
                        wSelf.appNewVersion = infoDic[@"versionInfo"];
                    }
                    
                    //强制更新
                    if (infoDic[@"maxType"] && [infoDic[@"maxType"] intValue] == 1) {
                        [wSelf showVersionCheckAlertWithForce:YES];
                    }
                    
                    //非强制更新
                    else if (infoDic[@"maxType"] && [infoDic[@"maxType"] intValue] == 2) {
                        [wSelf showVersionCheckAlertWithForce:NO];
                    }
                    
                    //已经是最新版本
                    else if (infoDic[@"updateOrNot"] && [infoDic[@"updateOrNot"] boolValue] == false) {
                        if (showLoading) {
                            [Utils showToastWithMessage:@"已经是最新版本"];
                        }
                    }

                    else {
                        [Utils showToastWithMessage:@"检查新版本失败，请稍候再试"];
                    }
                }
                
                else {
                    [Utils showToastWithMessage:@"检查新版本失败，请稍候再试"];
                }
                
            }
            
            else {
                [Utils showToastWithMessage:@"检查新版本失败，请稍候再试"];
            }

            
        });
    });
    

}

- (void)showVersionCheckAlertWithForce:(BOOL)forceUpgrade
{

    NSString *message = @"发现新版本";
    if (self.appNewVersion) {
        message = [message stringByAppendingFormat:@":%@",self.appNewVersion];
    }
    
    if (self.appNewDesc) {
        message = [message stringByAppendingFormat:@"\n%@",self.appNewDesc];
    }
    
    if (forceUpgrade) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = kTagAlertForce;
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = kTagAlertNotForce;
        [alert show];
    }
    
}

- (void)goAppStore
{
    NSString *urlString = self.appStoreUrl ? self.appStoreUrl : @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=789571992";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kTagAlertForce) {
        [self goAppStore];
    }
    
    else if (alertView.tag == kTagAlertNotForce) {
        if (buttonIndex == 1) {
            [self goAppStore];
        }
    }
    
}
@end
