//
//  HttpMsgDefine.h
//  
//
//  Created by zhoushaolong on 12-2-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgConstant.h"

#ifndef LOG_TEST
#define LOG_TEST	1
#endif


#define HTTP_TIMEOUT			8  // 默认超时时间10妙
#define HTTP_METHOD_POST		@"POST"
#define HTTP_METHOD_GET			@"GET"
#define HTTP_METHOD_PUT         @"PUT"
#define HTTP_METHOD_DELETE      @"DELETE"

enum HTTP_REQ_TYPE {
    HTTP_REQ_SHORTRUN = 0,
    HTTP_REQ_DOWNLOAD,
    HTTP_REQ_UPLOAD,
    HTTP_REQ_UNKONW
};

typedef enum HttpErr{
    E_HTTPERR_ASIConnectionFailureErrorType = 1,
    E_HTTPERR_ASIRequestTimedOutErrorType = 2,
    E_HTTPERR_ASIAuthenticationErrorType = 3,
    E_HTTPERR_ASIRequestCancelledErrorType = 4,
    E_HTTPERR_ASIUnableToCreateRequestErrorType = 5,
    E_HTTPERR_ASIInternalErrorWhileBuildingRequestType  = 6,
    E_HTTPERR_ASIInternalErrorWhileApplyingCredentialsType  = 7,
	E_HTTPERR_ASIFileManagementError = 8,
	E_HTTPERR_ASITooMuchRedirectionErrorType = 9,
	E_HTTPERR_ASIUnhandledExceptionError = 10,
	E_HTTPERR_ASICompressionError = 11
}E_HTTPERR;

////  for tcp socket define 
//@interface MsgHeader : NSObject
//{
//	NSInteger lenth_;
//	NSInteger version_;
//	E_SENDERTYPE sendertype_;
//	E_MSGTYPE	  msgType_;
//	E_MSGCLASS   msgClass_;
//	E_CMDCODE    cmdCode_;
//	BOOL bZip_;		// 压缩
//	BOOL bCrt_;		// 加密
//	NSUInteger sno_;
//	NSUInteger sessionid_;
//}
//
//@end
//
//@interface MsgBuf : NSObject
//{
//	MsgHeader*		header_;
//	NSString*       strBody_;
//}
//
//@property(nonatomic, retain)MsgHeader*		header_;
//@property(nonatomic, copy)NSString*			strBody_;
//
//@end
///////// end

#pragma mark http_define
@interface MsgBase : NSObject
{
	BOOL bZip_;		// 压缩
	BOOL bCrt_;		// 加密	
	
	E_CMDCODE	cmdCode_;           // 接口的命令码
	NSString*	strContent_;		// 发送的请求字符串
    NSInteger   retryCount_;
}

@property(nonatomic, copy)NSString* strContent_;
@property(nonatomic, assign)E_CMDCODE	cmdCode_;
@property(nonatomic,assign)BOOL bZip_;		// 压缩
@property(nonatomic,assign)BOOL bCrt_;		// 压缩
@property(nonatomic,assign)NSInteger retryCount;
@end

@protocol HTTP_MSG_RESPOND;

@interface MsgSent : MsgBase
{
	NSInteger timeout_;         // 超时时间 现在默认是 绝对超时
	NSString* method_Http;		// 选择请求模式
	NSString* method_Req;		// 选择请求方法
	
	id<HTTP_MSG_RESPOND> delegate_;
	
	int             httpRsp_;           // http 返回码(eg:200),在faile时也等同于asi error code
	NSMutableData*	recData_;			// 返回的请求内容
	int             msgSessionId;       // 每次调用返回的 请求id，用于cancel 请求时使用
    
    NSMutableDictionary*  dicHeader;    // 请求的 http header
    NSDictionary*  dicRetHeader;        // http响应后的 header
    NSData*               postData;     // 请求的 body data
    NSMutableDictionary*  userInfo;     // 附加的用户信息
    
    int             iReqType;           // 是短任务，还是下载，或者上传
    
    int             iFailedCode;        // asi 失败后返回的errorcode;
    BOOL retryOnConnection;
}

@property(assign)NSInteger				timeout_;
@property(nonatomic, copy)NSString*     method_Http;
@property(nonatomic, copy)NSString*     method_Req;
@property(assign)id<HTTP_MSG_RESPOND>   delegate_;
@property(nonatomic, strong)NSMutableData*	recData_;			// 返回的请求内容
@property(nonatomic, assign)int             httpRsp_;
@property(nonatomic, assign)int             msgSessionId; //消息序列号
@property(nonatomic, strong)NSMutableDictionary*    dicHeader;
@property(nonatomic, strong)NSDictionary*           dicRetHeader;
@property(nonatomic, strong)NSData*               postData;
@property(nonatomic, strong)NSMutableDictionary*  userInfo;
@property(nonatomic, assign)int             iReqType;
@property(nonatomic, assign)int             iFailedCode;
@property (nonatomic, assign)BOOL           retryOnConnection;

@property (nonatomic, strong)NSString*           responseJsonString;

+ (NSString*)mbase64forData:(NSData*)theData;

-(BOOL)isRequestSuccess;
-(id)responsdData;
@end

#pragma mark delegate_
@protocol HTTP_MSG_RESPOND<NSObject>

@required
-(int)ReciveHttpMsg:(MsgSent*)ReciveMsg;

@optional
-(void)ReciveDidFailed:(MsgSent*)ReciveMsg;

@end

@protocol ASIProgressDelegate;

@interface DownLoadSent : MsgSent
{
	int      downloadId;
	id       destObj;
	NSString *photoURL;
	id <ASIProgressDelegate> progressDelegate;
    NSString* strDownLoadPath;
}
@property int downloadId;
@property(nonatomic,assign) id destObj;
@property (nonatomic, retain) NSString *photoURL;
@property (nonatomic,assign) id progressDelegate; 
@property (nonatomic, retain) NSString *strDownLoadPath;
@end

@protocol ASIProgressDelegate;
@interface upLoadSent : MsgSent
{
    NSMutableDictionary *valueList;
    
    NSMutableArray* aryuaddFile;
    NSMutableArray* aryuaddData;
    
    NSMutableArray* aryuaddFileandOther;
    NSMutableArray* aryuaddDataandOther;
    NSString * tempFilePath;
}
@property (nonatomic, retain) NSMutableDictionary *valueList;
@property (nonatomic, readonly) NSMutableArray* aryuaddFile;
@property (nonatomic, readonly) NSMutableArray* aryuaddData;
@property (nonatomic, readonly) NSMutableArray* aryuaddFileandOther;
@property (nonatomic, readonly) NSMutableArray* aryuaddDataandOther;
@property (nonatomic, copy) NSString *tempFilePath;

- (void)uaddFile:(NSString *)filePath withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;

- (void)uaddData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;

- (void)uaddFile:(id)filePath
   withFileName:(NSString *)fileName
 andContentType:(NSString *)contentType
       andOther:(NSDictionary*)otherValue
         forKey:(NSString *)key;

- (void)uaddData:(id)data
   withFileName:(NSString *)fileName
 andContentType:(NSString *)contentType
       andOther:(NSDictionary*)otherValue
         forKey:(NSString *)key;

@end

