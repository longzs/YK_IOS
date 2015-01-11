//
//  EHUserDefaultManager.h
//  EHealth
//
//  Created by zhoushaolong on 14-12-9.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHUserDefaultManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(EHUserDefaultManager)

//上次选择的医院/科室id，在首页中显示
@property(nonatomic, copy)NSString* lastHCode;
@property(nonatomic, copy)NSString* lastDCode;

- (BOOL)isFirstLaunch;
- (void)appDidLaunched;

//用户信息
//- (EHUserInfoModel *)lastUserInfo;
//- (void)updateUserInfo:(EHUserInfoModel *)userInfo;
//- (void)removeLastUserInfo;

- (NSString*)lastHostialInfoRefresh;
- (void)updatelastHostialInfoRefresh:(NSString*)refrashTime;
- (void)removelastHostialInfoRefresh;

- (NSString*)lastDepartID;
- (void)updateLastDepartID:(NSString*)dCode;
- (void)removeLastDepartID;

- (NSString*)lastHospitalCode;
- (void)updateHospitalCode:(NSString*)hCode;
- (void)removeHospitalCode;

- (void)removeAllUserDefaults;

//版本更新
- (void)checkNewVersionWithWaiting:(BOOL)showLoading;

@end
