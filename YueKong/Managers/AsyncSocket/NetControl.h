//
//  NetControl.h
//  Router3G
//
//  Created by zhousl on 14-6-17.
//  Copyright (c) 2014年 zsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "netMsgDefine.h"
#import "mPacket.h"


#define k_Tcp_Port  7000
#define k_TimeOut_Tcp       5
#define k_Length_Header     11

#define k_YKCMD_app_tick @"000"

#define k_YKCMD_app_get_pdsn @"001"

#define k_YKCMD_app_get_reboot @"002"

#define k_YKCMD_app_study_irda @"003"

@class GCDAsyncSocket;


@protocol netControlDelegate <NSObject>
@optional
-(void)verify3gRoute:(NSNumber*)isSucc;

-(void)check3gIsOpen:(NSNumber*)isOpen;

-(void)openOrClose3gSuccess;

-(void)getAdImages;

-(void)refresh3GDatas:(ROUTERSTATE)rr;

-(void)clear3gDatasSuccess;

-(void)versionUpdate:(NSString*)url mode:(NSInteger)uMode;

@end

@interface NetControl : NSObject

@property(nonatomic, strong, readonly)GCDAsyncSocket* tcpCtrl;
@property(nonatomic, assign)id<netControlDelegate> delegate_;

@property(nonatomic, strong)NSString* adpicver;
@property(nonatomic, strong)NSString* mainad_url;
@property(nonatomic, strong)NSString* support_url;
@property(nonatomic, strong)NSMutableArray* aryAdPicURLS;

@property(nonatomic, assign)BOOL b3gOpen;
@property(nonatomic)BOOL   isConnect;
@property(nonatomic)BOOL   isVerifySuccess;

@property(nonatomic, strong)NSString*   strIP;

+(NetControl*)shareInstance;

-(void)getBaseInfo;

-(int)sendVerify3g;
-(int)sendPacket:(mPacket*)mp;

-(void)sendCheck3gIsOpen;
-(void)sendOpen3g:(BOOL)isOpen;

-(int)send3gPacket:(short)action Param:(char)param length:(short)len;

/*
 
 {"000", app_tick},
	{"001", app_get_pdsn},
	{"002", app_get_reboot},
	{"003", app_study_irda},
 
 003,key=1,category=1,brand=1,city=-1
 
 result=success, match=10 （match=1时学习成功， =0时 提示完全学习）
 */

-(int)sendYKDeviceCmd:(NSString*)cmd param:(NSString*)params;
-(void)ConnectToYKDevice;
-(void)closeTcp;
@end

