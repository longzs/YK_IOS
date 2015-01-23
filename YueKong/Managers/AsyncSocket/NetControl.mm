//
//  NetControl.m
//  Router3G
//
//  Created by zhousl on 14-6-17.
//  Copyright (c) 2014年 zsl. All rights reserved.
//

#import "NetControl.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import "GCDAsyncSocket.h"
#import "ASIHTTPRequest.h"



#define k_Tag_Read_Header    0
#define k_Tag_Read_Body      1

@interface NetControl()<GCDAsyncSocketDelegate>
{
    dispatch_queue_t tcpQueue_;
}
@property(nonatomic, getter = serialNumber)Byte   cSerial_;
@property(nonatomic, strong)NSTimer* timerGetState;
@end

@implementation NetControl
@synthesize tcpCtrl;
@synthesize cSerial_;
@synthesize strIP;
@synthesize isConnect,isVerifySuccess;
@synthesize delegate_;
@synthesize adpicver,aryAdPicURLS,mainad_url,support_url;
@synthesize timerGetState;
@synthesize b3gOpen;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

static NetControl* g_ins = nil;
+(NetControl*)shareInstance;
{
    if (nil == g_ins) {
        @synchronized(self){
            g_ins = [[NetControl alloc] init];
        }
    }
    return g_ins;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        tcpQueue_ = dispatch_queue_create("asyncTcp", nil);
        tcpCtrl = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:tcpQueue_];
    }
    return self;
}

-(void)getBaseInfo{
    
}

-(void)ConnectTo3gRouter{
    // 10.10.10.254 [self localWiFiIPAddress];
    if (!isConnect)
    {
        if (self.strIP.length) {
            NSError* er = nil;
            [tcpCtrl connectToHost:self.strIP onPort:k_Tcp_Port
                       withTimeout:k_TimeOut_Tcp error:&er];
            if (er) {
                NSLog(@"connect fail --- %@", er.description);
            }
        }
    }
}

-(void)closeTcp{
    
    isConnect = NO;
    [tcpCtrl disconnect];
}

-(Byte)serialNumber
{
    __block Byte tag = 0;
    dispatch_block_t block = ^{  // char 会在达到最大值后自动归零 不用在另行判断
        tag = cSerial_++;
    };
    if ([NSThread isMainThread]) {
        block();
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
    return tag;
}

- (NSString *) localWiFiIPAddress
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                    NSLog(@"ip = %@", address);
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


-(void)createTimerFor3gState
{
    [NSThread detachNewThreadSelector:@selector(addTimerGet3GState) toTarget:self withObject:nil];
}

-(void)addTimerGet3GState{
    // 开始查询状态
    if (nil == timerGetState) {
        self.timerGetState = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(sendCheck3gData) userInfo:nil repeats:YES];
        [timerGetState fire];
        [[NSRunLoop currentRunLoop] addTimer:timerGetState forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

-(void)stop3gStateTimer
{
    if (nil != timerGetState) {
        if ([timerGetState isValid]) {
            [timerGetState invalidate];
        }
        
        self.timerGetState = nil;
    }
}

-(NSData*)createPacket:(mPacket*)msg
{
    if (nil == msg) {
        return nil;
    }
    //NSString* strBody = msg.body;
#if 1
    NSLog(@"sendMsg-- cmd = %x, Param = %x\n",msg.cmdID, msg.stateOper);
#endif
    
    NSData* bodyData = msg.sendData;
    unsigned short uSize = [bodyData length];
    msg.bTag = [self serialNumber];
    msg.uLength = uSize;
    
    TCPPACKET* pPacket = (TCPPACKET*)malloc(uSize+11);
    memset(pPacket, 0, uSize);
    pPacket->hn = 0xA5;
    pPacket->version = 0;
    pPacket->usLength = msg.uLength;//htons(msg.uLength);
    pPacket->cCmdID = msg.cmdID;
    pPacket->param= msg.stateOper;
    pPacket->cSerialNumber = msg.bTag;
    
    if (0 < uSize) {
        memcpy(pPacket->pBody, bodyData.bytes, uSize);
    }
    NSData* sendData = [[NSData alloc] initWithBytes:pPacket length:uSize+11];
    free(pPacket);
    
    return sendData;
}

-(mPacket*)getPacketByData:(NSData*)data{
    if (nil == data) {
        return nil;
    }
    pTcpPacket pPacket = (pTcpPacket)[data bytes];
    if (nil == pPacket) {
        NSLog(@"-----ret data error----");
        return nil;
    }
    mPacket* mp = [[mPacket alloc] init];
    mp.cmdID = pPacket->cCmdID;
    mp.stateOper = pPacket->param;
    mp.uLength = pPacket->usLength;//ntohs(pPacket->usLength);
    mp.bTag = pPacket->cSerialNumber;
    mp.body = @"";
    if (0 < mp.uLength) {
        NSData* bodyData = [NSData dataWithBytes:pPacket->pBody length:mp.uLength];
        mp.responseData = bodyData;
    }
    return mp;
}

-(int)sendPacket:(mPacket*)mp{
    
    int iRet = 0;
    
    NSData* data  = [self createPacket:mp];
    [tcpCtrl writeData:data withTimeout:5 tag:mp.cmdID];
    return iRet;
}

-(void)sendHeartBeat{
    return;
    if (isConnect) {
        mPacket* mp = [[mPacket alloc] init];
        mp.cmdID = CC_heartBeat;
        mp.stateOper = 0x01;
        [[NetControl shareInstance] sendPacket:mp];
    }
    
    [self performSelector:@selector(sendHeartBeat) withObject:nil afterDelay:5];
}

-(int)sendVerify3g{
    if (isConnect) {
        mPacket* mp = [[mPacket alloc] init];
        mp.cmdID = CC_Verify;
        mp.stateOper = 0x01;
        [self sendPacket:mp];
    }
    return 0;
}
-(void)sendCheck3gIsOpen{}


-(void)sendOpen3g:(BOOL)isOpen
{
    //说明:Param:0x00表示设置状态为不转发,0x01:表示设置转发打开.
    char param = self.b3gOpen ? 0x00 : 0x01;
    [[NetControl shareInstance] send3gPacket:0x0041 Param:param length:0];
}

-(void)sendCheck3gData{
    [self send3gPacket:CC_CheckState Param:0 length:0];
}

-(int)send3gPacket:(short)action Param:(char)param length:(short)len{
    int r = 0;
    if (isConnect) {
        mPacket* mp = [[mPacket alloc] init];
        mp.cmdID = action;
        mp.stateOper = param;
        mp.uLength = len;
        r = [self sendPacket:mp];
    }
    return r;
}

-(void)processByResponse:(mPacket*)mp{
    
    if (nil == mp) {
        return;
    }
    NSLog(@"processByResponse cmd = %x, Param = %x", mp.cmdID, mp.stateOper);
    switch (mp.cmdID) {
        case CC_Verify_Response1:{
            // aes 加密
            NSData* resData = mp.responseData;
            if (64 == resData.length)
            {
                const char* lpcData = (const char*)[resData bytes];
                //aes_context ctx;
                Byte bb[64];
                mPacket* sendMp = [[mPacket alloc] init];
                sendMp.cmdID = CC_Verify_Response2;
                sendMp.stateOper = 0x03;
                sendMp.uLength = 64;
                sendMp.sendData = [NSData dataWithBytes:bb length:64];
                [[NetControl shareInstance] sendPacket:sendMp];
            }
        }
            break;
        case CC_Verify_Response3:{
            if (0x011 == mp.stateOper) {
                isVerifySuccess = NO;
            }
            else if (0x10 == mp.stateOper){
                // success
                isVerifySuccess = YES;
            }
            // 验证失败 弹 提示  延时重新验证
            dispatch_block_t block = ^{
                if (!isVerifySuccess) {
                    // 5秒后重新验证
                    [self performSelector:@selector(sendVerify3g) withObject:nil afterDelay:5];
                }
                else{
                    // 验证通过就开始查询设备数据
                    [self createTimerFor3gState];
                    // 查询开关
                    [self send3gPacket:0x0031 Param:0 length:0];
                }
                if ([delegate_ respondsToSelector:@selector(verify3gRoute:)]) {
                    [delegate_ verify3gRoute:[NSNumber numberWithBool:isVerifySuccess]];
                }
            };
            if ([NSThread isMainThread]) {
                block();
            }
            else{
                dispatch_async(dispatch_get_main_queue(), block);
            }
        }
            break;default:
            break;
    }
}

#pragma mark -- tcpDelegate
/**
 * Called when a socket accepts a connection.
 * Another socket is automatically spawned to handle it.
 *
 * You must retain the newSocket if you wish to handle the connection.
 * Otherwise the newSocket instance will be released and the spawned connection will be closed.
 *
 * By default the new socket will have the same delegate and delegateQueue.
 * You may, of course, change this at any time.
 **/
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    printf("didAcceptNewSocket\n");
}

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    printf("--didConnectToHost-- host = %s\n", [host UTF8String]);
    
    dispatch_block_t block = ^{
        isConnect = YES;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendHeartBeat) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(sendVerify3g)
                                                   object:nil];
        //[self sendHeartBeat];
        
        [self sendVerify3g];
        
    };
    if ([NSThread isMainThread]) {
        block();
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //printf("---didReadData-- tag = %ld\n", tag);
    
    mPacket* mp = [self getPacketByData:data];
    [self processByResponse:mp];
//    switch (tag) {
//        case k_Tag_Read_Header:
//        {
//            NSInteger length = mp.uLength+k_Length_Header;
//            
//            [sock readDataToLength:(0 < length)?length:k_Length_Header withTimeout:k_TimeOut_Tcp tag:k_Tag_Read_Body];
//            break;
//        }
//        case k_Tag_Read_Body:
//        {
//            [sock readDataToLength:k_Length_Header
//                       withTimeout:k_TimeOut_Tcp
//                               tag:k_Tag_Read_Header];
//            break;
//        }
//        default:
//            break;
//    }
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    //printf("---didWriteDataWithTag-- tag = %ld\n", tag);
    
    switch (tag) {
        case CC_CheckState:{
            
            [sock readDataToLength:k_Length_Header+16
                       withTimeout:-1
                               tag:k_Tag_Read_Body];
        }
            break;
        case CC_Verify:
        {
            [sock readDataToLength:k_Length_Header+64
                       withTimeout:-1
                               tag:k_Tag_Read_Body];
        }
            break;
        case 0x0031:            // 开关状态
        case 0x0041:        // 打开开关
        case CC_ClearData:
        case CC_Verify_Response2:
        {
            [sock readDataToLength:k_Length_Header
                       withTimeout:-1
                               tag:k_Tag_Read_Body];
        }
            break;
        default:
            break;
    }
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock{
    
    NSLog(@"---socketDidCloseReadStream-- ");
}

/**
 * Called when a socket disconnects with or without error.
 *
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * this delegate method will be called before the disconnect method returns.
 **/
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"---socketDidDisconnect-- err = %@, %ld\n", err.domain, err.code);
    
    [self stop3gStateTimer];
    dispatch_block_t block = ^{
        isConnect = NO;
        // 断链了3秒钟不断重连
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(ConnectTo3gRouter) withObject:nil afterDelay:k_TimeOut_Tcp];
    };
    if ([NSThread isMainThread]) {
        block();
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@end
