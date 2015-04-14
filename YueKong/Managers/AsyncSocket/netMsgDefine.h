//
//  netMsgDefine.h
//
//
//  Created by zhousl on 13-3-22.
//  Copyright (c) 2013年 . All rights reserved.
//

#ifndef LAFS_netMsgDefine_h
#define LAFS_netMsgDefine_h

#define k_Http_Domain   @"http://www.ch-wifi.com/myWiFi/baseInfo"

typedef enum moduleType     // 客户端用到的moule id
{
    MT_Person = 0x01,           //
    
    MT_UNKONW = -1
    
}E_MODULE;

typedef enum commandCode{                           //push 开始的都是推送消息
    
    CC_heartBeat                = 0x0000,
    // wifi
    CC_Verify                   = 0x0001,
    CC_Verify_Response1                   = 0x0101, //Route →App  Ask a Question
    CC_Verify_Response2                   = 0x0002, //App → Route Answer
    CC_Verify_Response3                   = 0x0102, // Route →App
    
    CC_CheckState                   = 0x0010,       //向路由器查询设备状态
    CC_CheckState_Res                   = 0x0110,
    
    CC_ClearData                   = 0x0021,
    CC_ClearData_Res                   = 0x0121,
    CC_UNKONW = -1
}E_COMMAND;

/*
 1. TCP server 通信端口：7000， 数据长度定义使用大端模式，低位在前，高位在后
 2. 数据包定义： App －＞server ：    功能ID（1byte） + 数据长度低8位（1byte） + 数据长度高8位（1byte） + 数据（长度有数据长度指定）
 Server －＞App  ： （功能ID + 0x80） + 数据长度低8位（1byte） + 数据长度高8位（1byte） + 数据（长度有数据长度指定）
 
 目前定义了3个功能ID
 1 ：获得ＰＤＳＮ　　　  App —>server  :     0x1     0x0     0x0
 Server －＞App :    0x81     0x10   0x0  P000000000011111  #数据长度为16, 数据为“P000000000011111”
 
 2：获取按键K的红外码    App —>server  :     0x2     0x1      0x0   0x1          #0x1表示按键的序号， 开始学习按键0x1
 Server －＞App :     0x82   0x3     0x0   0x1  OK    #暂时返回按键序号 + "OK" 3个字节数据, 表示按键0x1学习成功
 
 3：系统reboot              App —>server  :     0x3     0x2     0x0   0x88  0x13  #0x1388表示延时5000ms后系统重启
 Server －＞App :    0x83   0x1     0x0   0x0             #数据0表示命令执行成功， 系统稍后重启
 */

#define kState_SendAndNotify    0xFF
#define kState_Recive_Success   0

#define PACK_LENGTH_UDP_HEADER  11
#define k_LENGTH_UDPSIZE        2

#pragma pack(1)
typedef struct tcpPacket{
    
    Byte           hn;                  // 3G Router    0xA5
    Byte           version;             //
    int            cSerialNumber;    //流水号
    short int      usLength;            //实际消息体部分大小
    short int      cCmdID;           //命令ID
    Byte           param;               // Param
    char           pBody[0];            // 消息体
}TCPPACKET,*pTcpPacket;
#pragma park()

#pragma pack(1)
typedef struct routerState{
    
    Byte           signal;                  //	3G信号强度： 	0 ~ 5
    Byte           connected;               //  3G连接： 	0x00 – 未连接， 0x01 – 已连接
    Byte            electricity;             // 电池电量：	0% ~ 100%
    Byte            userNum;                //  路由用户量：连接到3G无线路由器的用户数量
    short          upSpeed;                 //  上行速度：	Kpbs
    short          downSpeed;
    int           upStream;                 //   上行流量：	Kbytes
    int           downStream;
}ROUTERSTATE,*pRouterState;
#pragma park()

#define kLength_YKBLePacket_Body    16

#define kResponseTypeEnd            0x00        //表示本次用户层数据传输全部完成

#define kResponseTypeContinued      0x01        //表示本次分片传输完成，在响应数据部分为对端期望的下一个Index号

#define kResponseTypeError            0x02        //表示对端错误，APP侧应终止用户层传输

#pragma pack(1)
typedef struct ykSendBlePacket{
    
    short           totalLength;                  //	2字节总长度
    SignedByte      index;
    char            body[kLength_YKBLePacket_Body];
}YKSENDBLEPACKET,*pSendYKBlePacket;

typedef struct ykResponseBlePacket{
    
    Byte            dataType;                 //1字节数据类型应为：0x00，否则APP视为无效确认信
    Byte            responseType;
    char            body[kLength_YKBLePacket_Body];
}YKResponseBLEPACKET,*pResponseYKBlePacket;
#pragma park()

#define PACK_LENGTH_MIN  5
#define k_Type_PDUPack_TEXT     0
#define k_Type_PDUPack_MEDIA    1

#define k_Type_MEDIA_AUDIO     0
#define k_Type_MEDIA_VEDIO     1

#define k_MIRROR_NONEED     0
#define k_MIRROR_NEED       1

#pragma pack(1)
typedef struct mediaPacket
{
    Byte		cTypePack:1;        //0-（文字，控制等）数据包 1-音视频数据包

    Byte		cTypeMedia:1;		// 0-音频 1-视频
    
    Byte		cMirrorImage:1;		// 镜像 0-不需要做垂直镜像 1-需要做垂直镜像
    
    Byte		cPackEnd:1;         //0-未结束得包  1-最后一个包，音频每一帧都是一个结束包，填1
    
    Byte		cMediaNumber:4;         // 当前媒体路数 1-6路
   
    unsigned short int	sFramenIndex;   // 帧序 每一帧的序号， 从0开始
    
    Byte		cPacknIndex;		// 包序 每一帧拆包后的序号 从0开始
    
    Byte		cFrameType:2;		// 数据包帧的类型 1：sps帧，2：pps帧，3：关键帧
    
    Byte		cRotation:1;		// 旋转标记 0：不旋转， 1：旋转
    
    Byte        cCapType:2;         //采集数据类型；0:420sp(手机的采集数据类型),1:420p(pc采集的数据类型)
    
    Byte		cSpare:3;			// 备用
    
    char		pData[0];           // send data
}MEDIAPACKET;
#pragma park()

#endif
