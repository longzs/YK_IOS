//
//  EHUserDefaultManager.h
//  EHealth
//
//  Created by zhoushaolong on 14-12-9.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKDeviceModel.h"

#define k_LastPdsn  @"k_LastPdsn"

#define k_UserSSID  @"k_UserSSID"

#define k_UserWIFIPWD  @"k_UserWIFIPWD"

#define k_YKDevice      @"k_YKDevice_UserDefault"

@interface EHUserDefaultManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(EHUserDefaultManager)

//基座返回的设备id
@property(nonatomic, copy)NSString* lastPdsn;

@property(nonatomic, strong)YKDeviceModel   *currentDevice;


- (BOOL)isFirstLaunch;
- (void)appDidLaunched;

//用户信息
//- (EHUserInfoModel *)lastUserInfo;
//- (void)updateUserInfo:(EHUserInfoModel *)userInfo;
//- (void)removeLastUserInfo;

- (NSString*)LastPdsn;
- (void)updatelastLastPdsn:(NSString*)refrashTime;
- (void)removelastLastPdsn;

- (YKDeviceModel*)getCurrentDevice;
- (void)updateCurrentDevice:(YKDeviceModel*)dv;
- (void)removeCurrentDevice;

-(NSString*)getValueFromDefault:(NSString*)key;
-(void)updateDefaultValue:(NSString*)key
                         Value:(NSString*)valueStr;
-(void)removeDefaultValue:(NSString*)key;

- (NSString*)currentUserSSID;
- (void)updateCurrentUserSSID:(NSString*)dCode;
- (void)removeCurrentUserSSID;

- (NSString*)currentUserWIFIPWD;
- (void)updateCurrentUserWIFIPWD:(NSString*)dCode;
- (void)removeCurrentUserWIFIPWD;

- (void)removeAllUserDefaults;

//版本更新
- (void)checkNewVersionWithWaiting:(BOOL)showLoading;

@end
