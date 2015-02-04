//
//  HttpMsgCtrl.m
//  
//
//  Created by zhoushaolong on 12-2-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HttpMsgCtrl.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import <queue>
#import <map>

using std::map;
using std::queue;

typedef queue<MsgSent*> sendQueue;
typedef map<int, MsgSent*>  mapSend;
typedef map<int, MsgSent*>::iterator	iter_Send;
typedef map<int, MsgSent*>::value_type  value_Send;

#define GETWORKQUEUE(workQueue, operationCount) 	\
workQueue = [[ASINetworkQueue alloc] init];\
[workQueue reset];\
[workQueue setDelegate:self];\
[workQueue setRequestDidFinishSelector:@selector(OperationFinished:)];\
[workQueue setRequestDidFailSelector:@selector(OperationFailed:)];\
[workQueue_ setMaxConcurrentOperationCount:operationCount];\
[workQueue_ setShouldCancelAllRequestsOnFailure:NO];

#define k_async 0

static sendQueue g_sendqueue;
static mapSend g_mapSend;

@interface HttpMsgCtrl()

-(void)OperationRspResult:(ASIHTTPRequest *)request MsgSent:(iter_Send)iter_Sent;

-(void)OperationFinished:(ASIHTTPRequest *)request;

-(void)OperationFailed:(ASIHTTPRequest *)request;

-(NSString*)GetURL:(NSString*)reqMethod;
-(NSString*)GetImgURL:(NSString*)imgName;

-(int)SendDownLoadReq:(DownLoadSent*)SendMsg;

-(int)SendShortReq:(MsgSent*)SendMsg;

-(int)SendUpLoadReq:(MsgSent*)SendMsg;

-(ASIHTTPRequest*)createRequestByMsg:(MsgSent*)SendMsg;

-(int)getTagCode:(int)cmdCode;

-(int)getCmdcode:(int)tagCode;

-(void)setAuthorization:(ASIHTTPRequest*)req header:(NSMutableDictionary*)dicHeader;

-(void)addUpLoadReqData:(ASIFormDataRequest*)_Req :(upLoadSent*)SendMsg;

-(void)insertSendMsg:(MsgSent*)SendMsg withTag:(int)msgTag;

-(void)dispatchResponse;

@end


static HttpMsgCtrl* msgCtrl = nil;

@implementation HttpMsgCtrl
@synthesize workQueue_, lock_, workQueueDownLoad_, workQueueUpLoad_;
@synthesize aryRequest_;
+(id) hiddenAlloc
{
	return [super alloc];
}

+(HttpMsgCtrl*)GetInstance{
	if (nil == msgCtrl) {
		msgCtrl = [[[self class] hiddenAlloc] init];
	}
	
	return msgCtrl;
}

+ (id) alloc
{
	NSLog(@"please use GetInstance");
	
	return [[self GetInstance] retain];
}

+ (id)new
{
	return [self alloc];
}


- (id)copyWithZone:(NSZone *)zone
{
	[self retain];
	return self;
}

- (id) init{
	
	if (self = [super init]) {
        
        GETWORKQUEUE(workQueue_, 5);
        GETWORKQUEUE(workQueueDownLoad_, 1);
        GETWORKQUEUE(workQueueUpLoad_, 1);
		lock_ = [[NSLock alloc] init];
		lastMsgSessionId = 0;
        aryRequest_ = [[NSMutableArray alloc] initWithCapacity:0];
#if k_async
        [NSThread detachNewThreadSelector:@selector(dispatchResponse) toTarget:self withObject:nil];
#endif
    }
	return self;
}


-(HttpMsgCtrl*)initWithDelegate:(id)RspDelegate{
	if (self = [super init]) {
		workQueue_ = [[ASINetworkQueue alloc] init];
		[workQueue_ reset];
		[workQueue_ setDelegate:RspDelegate];
		[workQueue_ setRequestDidFinishSelector:@selector(OperationFinished:)];
		[workQueue_ setRequestDidFailSelector:@selector(OperationFailed:)];
		[workQueue_ setMaxConcurrentOperationCount:2];
		workQueueDownLoad_ = [[ASINetworkQueue alloc] init];
		[workQueueDownLoad_ reset];
		[workQueueDownLoad_ setDelegate:RspDelegate];
		[workQueueDownLoad_ setRequestDidFinishSelector:@selector(OperationFinished:)];
		[workQueueDownLoad_ setRequestDidFailSelector:@selector(OperationFailed:)];
		
		lock_ = [[NSLock alloc] init];
	}
	
	return self;
}

-(void) dealloc{
	
	[workQueue_ release];
	[workQueueDownLoad_ release];
    [workQueueUpLoad_ release];
	[lock_ release];
    [aryRequest_ release];
	[super dealloc];
}

-(int)SendHttpMsg:(MsgSent*)SendMsg{
	
    int msgTag = -1;
	if (nil == SendMsg) {
		
		return msgTag;
	}
    //NSLog(@"req = %@", SendMsg.method_Req);NSLog(@"sendMsg id = %d " , SendMsg.cmdCode_) ;
	switch (SendMsg.iReqType) {
        case HTTP_REQ_SHORTRUN:
        {
            msgTag = [self SendShortReq:SendMsg];
            break;
        }
        case HTTP_REQ_DOWNLOAD:
        {
            msgTag = [self SendDownLoadReq:(DownLoadSent*)SendMsg];
            break;
        }
        case HTTP_REQ_UPLOAD:
        {
            msgTag = [self SendUpLoadReq:(upLoadSent*)SendMsg];
            break;
        }
        default:
            break;
    }
	return msgTag;
}

-(int)SendSingRequest:(MsgSent*)SendMsg
{
    int msgTag = -1;
	if (nil == SendMsg) {
		
		return msgTag;
	}
    //////
    ASIBasicBlock  block = ^{
        
        if ([aryRequest_ count] > 0)
        {
            [aryRequest_ removeObjectAtIndex:0];
        }
        
        if ([aryRequest_ count] > 0)
        {
            ASIHTTPRequest * request = [aryRequest_ objectAtIndex:0];
            //[self insertSendMsg:SendMsg withTag:request.tag];
            [workQueue_ addOperation:request];
            [request release];
        }
    };
    
    ASIHTTPRequest* request  = [self createRequestByMsg:SendMsg];
    [request setCompletionBlock:block] ;
    [request setFailedBlock:block];
    [aryRequest_ addObject:request];
    //[request release];
    
    msgTag = (int)request.tag;
    [self insertSendMsg:SendMsg withTag:msgTag];
    if (1 == [aryRequest_ count])
    {
        //NSLog(@"begin+++++++++++");
        
        [workQueue_ addOperation:request];
        [request release];
    }
    return msgTag;
}

-(ASIHTTPRequest*)createRequestByMsg:(MsgSent*)SendMsg
{
    int msgTag = [self getTagCode:SendMsg.cmdCode_];
	SendMsg.msgSessionId = msgTag;
	NSString *urlStr = SendMsg.method_Req;
    if (nil == urlStr) {
        if ([SendMsg isKindOfClass:[DownLoadSent class]]) {
            urlStr = [(DownLoadSent*)SendMsg photoURL];
        }
    }
	ASIFormDataRequest* _Req = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
	[_Req setTag:msgTag];
	[_Req setRequestMethod:SendMsg.method_Http];
	_Req.timeOutSeconds = SendMsg.timeout_;
	[_Req setRequestHeaders:SendMsg.dicHeader];
    [_Req appendPostData:SendMsg.postData];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [_Req setShouldContinueWhenAppEntersBackground:YES];
#endif
//#if HTTP_SUPPORT_TLS
//    [_Req setValidatesSecureCertificate:YES];
//#else
//    [_Req setValidatesSecureCertificate:NO];
//#endif
//    k_HTTP_COMPRESS(_Req);
    [self setAuthorization:_Req header:nil];
    
    switch (SendMsg.iReqType) {
        case HTTP_REQ_SHORTRUN:
        {
            break;
        }
        case HTTP_REQ_DOWNLOAD:
        {
            _Req.shouldResetDownloadProgress = NO;
            NSString* DownLoadPath = [(DownLoadSent*)SendMsg strDownLoadPath];
            if (nil != DownLoadPath && 0 < [DownLoadPath length]) {
                [_Req setDownloadDestinationPath:DownLoadPath];
            }
            break;
        }
        case HTTP_REQ_UPLOAD:
        {
            [self addUpLoadReqData:_Req :(upLoadSent*)SendMsg];
            break;
        }
        default:
            break;
    }
    return _Req;
}

-(int)SendShortReq:(MsgSent*)SendMsg
{
    ASIHTTPRequest* _Req  = [self createRequestByMsg:SendMsg];
    int msgTag = (int)_Req.tag;
	[self insertSendMsg:SendMsg withTag:msgTag];
	
	[workQueue_ addOperation:_Req];
	[_Req release];
	[workQueue_ go];
    
    return msgTag;
}

-(int)SendUpLoadReq:(upLoadSent*)SendMsg
{
    ASIHTTPRequest* _Req  = [self createRequestByMsg:SendMsg];
	
    int msgTag = (int)_Req.tag;
	[self insertSendMsg:SendMsg withTag:msgTag];
	
	[workQueueUpLoad_ addOperation:_Req];
	[_Req release];
	[workQueueUpLoad_ go];
    
    return msgTag;
}

-(int)SendDownLoadReq:(DownLoadSent*)SendMsg{
	
	ASIHTTPRequest* _Req  = [self createRequestByMsg:SendMsg];
	
    int msgTag = (int)_Req.tag;
    [self insertSendMsg:SendMsg withTag:msgTag];
	
	[workQueueDownLoad_ addOperation:_Req];
	[_Req release];
	[workQueueDownLoad_ go];
	
	return msgTag;
}

-(void)insertSendMsg:(MsgSent*)SendMsg withTag:(int)msgTag
{
    
#if 1
    NSLog(@"---requestData---\n redID = 0x%x , %@", SendMsg.cmdCode_, SendMsg.method_Req);//
#endif
    
    [lock_ lock];
	[SendMsg retain];
	g_mapSend.insert(value_Send(msgTag, SendMsg));
	[lock_ unlock];
}

-(int)getTagCode:(int)cmdCode{
	static unsigned short int curCode= 0x0001;
	int returnCode = (curCode & 0x0000ffff);
	returnCode |=  cmdCode << 16 & 0xffff0000; 
	[lock_ lock];
	    curCode++;
		if (0xffff == curCode) {
			curCode = 0x0001;
		}
	
	[lock_ unlock];
	lastMsgSessionId = returnCode;
	return returnCode;
}

-(int)getCmdcode:(int)tagCode{
	int returnCode = tagCode >>16 & 0x0000ffff;
	return returnCode;
}

-(void)setAuthorization:(ASIHTTPRequest*)req header:(NSMutableDictionary*)dicHeader
{
    if ([req.requestHeaders objectForKey:@"Authorization"]) {
        [req setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
    }
}

-(void)addUpLoadReqData:(ASIFormDataRequest*)_Req :(upLoadSent*)SendMsg
{
    NSArray* aryKeys = [SendMsg.valueList allKeys];
    for (id keyPost in aryKeys) {
        id valuePost = [SendMsg.valueList objectForKey:keyPost];
        [_Req addPostValue:valuePost forKey:keyPost];
    }
    NSMutableArray* aryTemps = SendMsg.aryuaddData;
    for (NSMutableArray* aryTemp in aryTemps) {
        if (aryTemp &&
            4 <= [aryTemp count]) {
            [_Req addData:[aryTemp objectAtIndex:0] withFileName:[aryTemp objectAtIndex:1]
           andContentType:[aryTemp objectAtIndex:2] forKey:[aryTemp objectAtIndex:3]];
        }
    }
    
    aryTemps = SendMsg.aryuaddFile;
    for (NSMutableArray* aryTemp in aryTemps) {
        if (aryTemp &&
            4 <= [aryTemp count]) {
            [_Req addFile:[aryTemp objectAtIndex:0] withFileName:[aryTemp objectAtIndex:1]
           andContentType:[aryTemp objectAtIndex:2] forKey:[aryTemp objectAtIndex:3]];
        }
    }
    aryTemps = SendMsg.aryuaddFileandOther;
    for (NSMutableArray* aryTemp in aryTemps) {
        if (aryTemp &&
            5 <= [aryTemp count]) {
            [_Req addFile:[aryTemp objectAtIndex:0] withFileName:[aryTemp objectAtIndex:1]
           andContentType:[aryTemp objectAtIndex:2] andOther:[aryTemp objectAtIndex:3]
                   forKey:[aryTemp objectAtIndex:4]];
        }}
    
    aryTemps = SendMsg.aryuaddDataandOther;
    for (NSMutableArray* aryTemp in aryTemps) {
        if (aryTemp &&
            5 <= [aryTemp count]) {
            [_Req addData:[aryTemp objectAtIndex:0] withFileName:[aryTemp objectAtIndex:1]
           andContentType:[aryTemp objectAtIndex:2] andOther:[aryTemp objectAtIndex:3]
                   forKey:[aryTemp objectAtIndex:4]];
        }
    }
}
#pragma mark--
#pragma threadProcess
-(void)dispatchResponse
{
    while (1) {
        //sleep(0.05);
        if (!g_sendqueue.empty())
        {
            MsgSent* response = g_sendqueue.front();
            [response.delegate_ ReciveHttpMsg:response];
            [response release];
            
            [lock_ lock];
            g_sendqueue.pop();
            [lock_ unlock];
        }
    }
}
// If a delegate implements one of these, it will be asked to supply credentials when none are available
// The delegate can then either restart the request ([request retryUsingSuppliedCredentials]) once credentials have been set
// or cancel it ([request cancelAuthentication])
//- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request;
//- (void)proxyAuthenticationNeededForRequest:(ASIHTTPRequest *)request;

#pragma mark private method

-(void)OperationRspResult:(ASIHTTPRequest *)request MsgSent:(iter_Send)iter_Sent{
	
	NSData* tempData = [request responseData];
    [iter_Sent->second setDicRetHeader:request.responseHeaders];
#if 1
	NSLog(@"---responseData---\n redID = 0x%x , %s", iter_Sent->second.cmdCode_, (char*)[tempData bytes]);//
#endif
	
	iter_Sent->second.httpRsp_ = [request responseStatusCode] ;
	
	if (nil == tempData) {
		if (0 == [iter_Sent->second.method_Req compare:@"downloadPhoto"]) {
			return;
		}
	}
	else {
		char tch = 0 ;
		[iter_Sent->second.recData_ setData:tempData];
		[iter_Sent->second.recData_ appendBytes: &tch length:1];
        
        NSString *responseString = [[NSString alloc] initWithData:iter_Sent->second.recData_ encoding:NSUTF8StringEncoding];
        iter_Sent->second.responseJsonString = responseString;
	}
	return;
}

-(void)OperationFinished:(ASIHTTPRequest *)request{
	
	//NSLog(@"---RequestDidFinish---\n redID = %d\n", request.);
	[lock_ lock];
	iter_Send iter = g_mapSend.find((int)request.tag);
	[lock_ unlock];
	
	//  如果有结束完的请求
	if (g_mapSend.end() != iter) {
		
		//////  test for invocation   
//		NSInvocation * invocation = [[NSInvocation alloc] init];
//		[invocation setTarget:self];
//		[invocation setSelector:@selector(OperationRspResult:)];
//		[invocation setArgument:request atIndex:2];
//		[invocation setArgument:&iter atIndex:3];
//		[self performSelectorOnMainThread:@selector(OperationRspResult:) withObject:invocation waitUntilDone:YES];
//		[invocation release];
		///// end    2012-02-10
		
		//取内容与请求
		[self OperationRspResult:request MsgSent:iter];

		if (iter->second.delegate_  
			&& [iter->second.delegate_ respondsToSelector:@selector(ReciveHttpMsg:)]) {
#if k_async
            [lock_ lock];
            g_sendqueue.push(iter->second);
            [lock_ unlock];
#else
            [iter->second.delegate_ ReciveHttpMsg:iter->second];
#endif
		}
#if !k_async
		[iter->second release];
#endif
		// 释放&&去掉
		[lock_ lock];
		g_mapSend.erase(iter);
		[lock_ unlock];
		
	}
	
	return;
}

-(void)OperationFailed:(ASIHTTPRequest *)request{
	
	NSInteger codeid = [[request error] code];
	[lock_ lock];
	iter_Send iter = g_mapSend.find((int)request.tag);
	[lock_ unlock];
	
	//  如果有结束完的请求
	if (g_mapSend.end() != iter) {
        NSLog(@"---RequestDidFailed---\n redID = 0x%x, errorID = %d, errorMsg = %@", iter->second.cmdCode_, (int)codeid, [[request error] domain]);
		[iter->second setDicRetHeader:request.responseHeaders];
        
        /// 当faile 时 response code 和 error code 一致
		iter->second.httpRsp_ = (int)codeid;//[request responseStatusCode];
        iter->second.iFailedCode = (int)codeid;
        //取内容与请求
        
        if (iter->second.delegate_
			&& [iter->second.delegate_ respondsToSelector:@selector(ReciveHttpMsg:)]) {
			
			[iter->second.delegate_ ReciveHttpMsg:iter->second];
		}
		
		[iter->second release];
		// 释放&&去掉
		[lock_ lock];
		g_mapSend.erase(iter);
		[lock_ unlock];
	}
}

-(NSString*)GetURL:(NSString*)reqMethod{
    
    return @"";
}

-(NSString*)GetImgURL:(NSString*)imgName{

	return @"";
}

#define kCancelRequestByID(asiQueue, reqID) for (int i = 0; i < [[asiQueue operations] count]; i++) {\
ASIHTTPRequest *Req = [[asiQueue operations] objectAtIndex:i];\
if (reqID == Req.tag) {\
    [Req cancel];\
    bCancel = YES;\
    break;\
}\
}

-(void)cancelRequestFromQueuqByID:(int)reqID
{
    BOOL bCancel = NO;
    kCancelRequestByID(workQueue_, reqID);
    if (!bCancel)
    {
        kCancelRequestByID(workQueueDownLoad_, reqID);
    }
    if (!bCancel) {
        kCancelRequestByID(workQueueUpLoad_, reqID);
    }
}

  
-(void)CancelRequestByID:(int)ReqId{
    
    [self cancelRequestFromQueuqByID:ReqId];
    // 从队列中 cancel 掉请求后会有回调通知上层来处理回调 这里不去掉回调  2013-1-4
//	iter_Send iter = g_mapSend.find(ReqId);
//    if (g_mapSend.end() != iter)
//    {
//        [iter->second release];
//        [lock_ lock];
//        g_mapSend.erase(iter);
//        [lock_ unlock];
//    }
}

-(void)cancelAllRequest
{
    // 从队列中 cancel 掉请求后会有回调通知上层来处理回调 这里不去掉回调  2013-1-4
//    for (iter_Send iter = g_mapSend.begin(); iter != g_mapSend.end(); ++iter) {
//        [iter->second release];
//    }
//    [lock_ lock];
//    g_mapSend.clear();
//    [lock_ unlock];
    [aryRequest_ removeAllObjects];
    [workQueue_ cancelAllOperations];
    [workQueueDownLoad_ cancelAllOperations];
    [workQueueUpLoad_ cancelAllOperations];
}
@end
