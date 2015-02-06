//
//  HttpMsgDefine.m
//  
//
//  Created by zhoushaolong on 12-2-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HttpMsgDefine.h"

#define kErrorCode      @"Code"
#define kErrorMsg       @"Msg"
#define kResponseEntity       @"entity"
#define kResponseStatus       @"status"

////  for tcp socket define 
//@implementation MsgHeader
//
//- (id) init
//{
//	self = [super init];
//	if (self != nil) {
//
//		bZip_ = NO;
//		bCrt_ = NO;
//	}
//	return self;
//}
//@end
//
//@implementation MsgBuf
//
//@synthesize header_, strBody_;
//
//- (void) dealloc
//{
//	[header_ release];
//	[strBody_ release];
//	[super dealloc];
//}
//@end
/////////// end


@implementation MsgBase

@synthesize strContent_, cmdCode_;
@synthesize bCrt_,bZip_;
@synthesize retryCount = retryCount_;
-(id) init{
	
	if (self = [super init]) {
		
		bCrt_ = NO;
		bZip_ = NO;
        self.retryCount = 0;
	}
	
	return self;
}

- (void) dealloc
{
	[strContent_ release];
	[super dealloc];
}

- (NSString *)description
{
    NSMutableString * returnString = [[[NSMutableString alloc] init] autorelease];
    if ([super description])
    {
        [returnString appendFormat:@"\n%@\n", [super description]];
    }
    [returnString appendFormat:@"cmdCode: %d\n", cmdCode_];
    if (strContent_)
    {
         [returnString appendFormat:@"strContent: %@\n", strContent_];
    }
    else
    {
        [returnString appendFormat:@"strContent: %@\n", @"nil"];
    }
    [returnString appendFormat:@"bZip: %@\n", bZip_?@"YES":@"NO"];
    [returnString appendFormat:@"bCrt: %@\n", bCrt_?@"YES":@"NO"];
    return  returnString;
}
@end

@implementation MsgSent
@synthesize timeout_, method_Http, method_Req, delegate_,msgSessionId, iFailedCode,retryOnConnection;
@synthesize recData_, httpRsp_;
@synthesize dicHeader;
@synthesize postData;
@synthesize userInfo;
@synthesize iReqType;
@synthesize dicRetHeader;
@synthesize responseJsonString;
- (id) init{
	
	self = [super init];
	if (self != nil) {

		self.httpRsp_ = 0;
		timeout_ = HTTP_TIMEOUT;
		//method_ = [[NSString alloc] initWithString:HTTP_METHOD_POST];
		self.method_Http = HTTP_METHOD_POST;
		recData_ = [[NSMutableData alloc] init];
        iReqType = HTTP_REQ_SHORTRUN;
        iFailedCode = 0;
        userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
        retryOnConnection = YES;
	}
	return self;
}

- (void) dealloc
{
	[method_Http release];
	[method_Req release];
	[recData_ release];
    [dicHeader release];
    [postData release];
    [userInfo release];
    [dicRetHeader release];
    [responseJsonString release];
	[super dealloc];
}


- (NSString *)description
{
    NSMutableString * returnString = [[[NSMutableString alloc] init] autorelease];
    if ([super description])
    {
         [returnString appendFormat:@"\%@", [super description]];
    }
    if (delegate_)
    {
        [returnString appendFormat:@"delegate: %@\n", [delegate_ description]];
    }
    else
    {
        [returnString appendFormat:@"delegate: %@\n", @"nil"];
    }
    [returnString appendFormat:@"msgSessionId: %d\n", msgSessionId];
    [returnString appendFormat:@"iFailedCode: %d\n", iFailedCode];
    [returnString appendFormat:@"iReqType: %d\n", iReqType];
    [returnString appendFormat:@"httpRspCode: %d\n", httpRsp_];
    [returnString appendFormat:@"timeout: %ld\n", timeout_];
    
    if (method_Http)
    {
        [returnString appendFormat:@"method_Http: %@\n", method_Http];
    }
    else
    {
        [returnString appendFormat:@"method_Http: %@\n", @"nil"];
    }
    
    if (method_Req)
    {
         [returnString appendFormat:@"method_Req: %@\n", method_Req];
    }
    else
    {
        [returnString appendFormat:@"method_Req: %@\n", method_Req];
    }
    if (dicHeader)
    {
        [returnString appendFormat:@"dicHeader: %@\n", [dicHeader description]];
    }
    else
    {
        [returnString appendFormat:@"dicHeader: %@\n", @"nil"];
    }
    if (dicRetHeader)
    {
        [returnString appendFormat:@"dicRetHeader: %@\n", [dicRetHeader description]];
    }
    else
    {
        [returnString appendFormat:@"dicRetHeader: %@\n", @"nil"];
    }
    if (userInfo)
    {
        [returnString appendFormat:@"userInfo: %@\n", [userInfo description]];
    }
    else
    {
        [returnString appendFormat:@"userInfo: %@\n", @"nil"];
    }
    
    if (postData)
    {
        NSString * tempString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        if ([tempString length])
        {
            [returnString appendFormat:@"postData (String): %@\n", tempString];
        }
        else
        {
            [returnString appendFormat:@"postData (Data): %@\n", [postData description]];
        }
        [tempString release];
    }
    else
    {
       [returnString appendFormat:@"postData : %@\n", @"nil"];
    }
    if (recData_)
    {
        NSString * tempString = [[NSString alloc] initWithData:recData_ encoding:NSUTF8StringEncoding];
        if ([tempString length])
        {
            [returnString appendFormat:@"recData (String): %@\n", tempString];
        }
        else
        {
            [returnString appendFormat:@"recData  (Data): %@\n", [recData_ description]];
        }
        [tempString release];
    }
    else
    {
         [returnString appendFormat:@"recData : %@\n", @"nil"];
    }
    return returnString;
    
}

-(BOOL)isRequestSuccess{
    
    return 200 == self.httpRsp_;
}

-(id)responsdData{
    NSString *responseString = self.responseJsonString;
    NSDictionary *JSONValue = [responseString mutableObjectFromJSONStringWithParseOptions:JKParseOptionValidFlags];
    
    return JSONValue[kResponseEntity];
}

+ (NSString*)mbase64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

@end

@implementation DownLoadSent
@synthesize downloadId,destObj,photoURL,progressDelegate;
@synthesize strDownLoadPath;
- (id) init{
	
	self = [super init];
	if (self != nil) {
        timeout_ = 100;
	}
	return self;
}
- (void) dealloc
{
	[photoURL release];
    [strDownLoadPath release];
	[super dealloc];
}
@end

@implementation upLoadSent

@synthesize valueList;
@synthesize tempFilePath;
@synthesize aryuaddData,aryuaddDataandOther,aryuaddFile, aryuaddFileandOther;

- (id) init{
	if (self = [super init]) {
        valueList = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	return self;
}

- (void) dealloc
{
    [valueList release];
    [aryuaddFile release];
    [aryuaddData release];
    [aryuaddFileandOther release];
    [aryuaddDataandOther release];
	[super dealloc];
}

- (void)uaddFile:(NSString *)filePath withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key
{
    if (nil == aryuaddFile)
    {
        aryuaddFile = [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSMutableArray* aryParams = [[NSMutableArray alloc] initWithObjects:filePath, fileName, contentType, key, nil];
    [aryuaddFile addObject:aryParams];
    [aryParams release];
}

- (void)uaddData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key
{
    if (nil == aryuaddData)
    {
        aryuaddData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSMutableArray* aryParams = [[NSMutableArray alloc] initWithObjects:data, fileName, contentType, key, nil];
    [aryuaddData addObject:aryParams];
    [aryParams release];
}

- (void)uaddFile:(id)filePath
    withFileName:(NSString *)fileName
  andContentType:(NSString *)contentType
        andOther:(NSDictionary*)otherValue
          forKey:(NSString *)key
{
    if (nil == aryuaddFileandOther)
    {
        aryuaddFileandOther = [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSMutableArray* aryParams = [[NSMutableArray alloc] initWithObjects:filePath, fileName, contentType, otherValue, key, nil];
    [aryuaddFileandOther addObject:aryParams];
    [aryParams release];
}

- (void)uaddData:(id)data
    withFileName:(NSString *)fileName
  andContentType:(NSString *)contentType
        andOther:(NSDictionary*)otherValue
          forKey:(NSString *)key
{
    if (nil == aryuaddDataandOther)
    {
        aryuaddDataandOther = [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSMutableArray* aryParams = [[NSMutableArray alloc] initWithObjects:data, fileName, contentType, otherValue, key, nil];
    [aryuaddDataandOther addObject:aryParams];
    [aryParams release];
}

@end

