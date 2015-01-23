//
//  absManager.h
//  EHealth
//
//  Created by zhoushaolong on 14-11-20.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//


//  业务处理管理基类
#import <Foundation/Foundation.h>
#import "HttpMsgCtrl.h"
//#import "EHHttpManager.h"


//  按照目前服务器交互 返回的数据格式为 jsonResponse
typedef void (^processCallBack)(id responseData);

// error 中是网络错误的信息
typedef void (^requestError)(NSError* error);

//  业务处理失败或成功的回调
typedef void (^processSuccess)(NSString *message);
typedef void (^processFailed)(NSString *message);
typedef void (^processFailedWithCode)(HttpStatusCode errCode, NSString *message);

@protocol OperationProcessDelegate <NSObject>
@optional

@end


@interface absManager : NSObject

@property(nonatomic, assign)id<OperationProcessDelegate> delegateProcess;

/**
 *  将回调整合
 *
 *  @param successBlock   成功的回调
 *  @param failureBlock   失败的回调
 *  @param addtionalBlock 在成功中的特殊处理
 *
 *  @return 回调
 */
//- (EHCallBack)callBackWithSuccess:(processSuccess)successBlock
//                          failure:(processFailed)failureBlock
//         additionalProcessSuccess:(EHCallBack)addtionalBlock;


@end

