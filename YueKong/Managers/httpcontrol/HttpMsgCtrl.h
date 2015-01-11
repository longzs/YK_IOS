//
//  HttpMsgCtrl.h
//  
//
//  Created by zhoushaolong on 12-2-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpMsgDefine.h"
#import "ASIHTTPRequestDelegate.h"

@class ASINetworkQueue;

@interface HttpMsgCtrl : NSObject <ASIHTTPRequestDelegate>{
	
@private
	NSLock*			 lock_;
	ASINetworkQueue* workQueue_;
	ASINetworkQueue* workQueueDownLoad_;
    ASINetworkQueue* workQueueUpLoad_;
	int              lastMsgSessionId;
    NSMutableArray*  aryRequest_;
}

@property(nonatomic, readonly)ASINetworkQueue* workQueue_;
@property(nonatomic, readonly)ASINetworkQueue* workQueueDownLoad_;
@property(nonatomic, readonly)ASINetworkQueue* workQueueUpLoad_;
@property(nonatomic, readonly)NSLock*			 lock_;
@property(nonatomic, readonly)NSMutableArray*  aryRequest_;
// 获取实例方法
+(HttpMsgCtrl*)GetInstance;

// 返回reqID
-(int)SendHttpMsg:(MsgSent*)SendMsg;

//按顺序执行的请求 目前用户发送
-(int)SendSingRequest:(MsgSent*)SendMsg;

-(void)CancelRequestByID:(int)ReqId;
-(void)cancelAllRequest;
@end
