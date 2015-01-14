//
//  MsgConstant.h
//  
//
//  Created by zhoushaolong on 12-2-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/*
 此类定义所有公共接口消息
 */


//typedef enum SenderType
//{
//	ST_Mobile  = 0,
//	ST_Web	   = 2,
//	ST_MAA     = 8,
//	ST_Unknown = -1,
//}E_SENDERTYPE;
//
//typedef enum MsgType
//{
//	MT_ARG  = 1,
//	MT_ACK  = 2,
//	MT_NOTIFY  = 3,
//	MT_Unknown = -1,
//}E_MSGTYPE;

typedef enum MsgClass
{
	MC_System				   = 0x00,
	MC_PersonalInformation     = 0x01,
	MC_InstanceMessage         = 0x03,
	MC_NotifyMessage           = 0x04,
	MC_DirectionMsg			   = 0x05,
	MC_Unknown                 = -1,
}E_MSGCLASS;

typedef enum CmdCode
{
	// 系统命令
	CC_VersionCheck             = 0x0001,
	CC_NetCheck					= 0x0002, // 网络检测
	
	// aas
	CC_Login                    = 0x0101,
	CC_Logout					= 0x0102, // 
    CC_RefreshToken             = 0x0103,
    CC_HeartBeat                = 0x0104,
    CC_CreatUser                = 0x0105,
    CC_UpdateProfile            = 0x0106,
    CC_GetBalance               = 0x0107,
    CC_GetACK               = 0x0108,
    CC_GetLocalNumber           = 0x0109,
    CC_SetAPNS                  = 0x010A,
    CC_ResignAPNS               = 0x010B,

	CC_Unknown                  = -1,
}E_CMDCODE;


