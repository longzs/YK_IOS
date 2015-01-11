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
    CC_GetProfile               = 0x0108,
    CC_GetLocalNumber           = 0x0109,
    CC_SetAPNS                  = 0x010A,
    CC_ResignAPNS               = 0x010B,

	
	// mix
    CC_GETMSGLIST                       = 0x0201, // 获取消息列表
    CC_MIX_GetOffLineMsg                = 0x0202,
    CC_MIX_SetReadStateToServer         = 0x0203,
    CC_MIX_GetUnitMsgByID               = 0x0204,
    CC_MIX_GetLocationImage             = 0x0205,
    CC_MIX_GetNearbyLocation            = 0x0206,
    CC_MIX_GetDescriptionByLocation     = 0x0207,
    CC_MIX_GetUniMsgInfoByIDs           = 0X0208,
    CC_MIX_loadMessageFromServerInbox   = 0X0209,
    CC_MIX_RequestUnitMessageWithAccount = 0X0210,
    CC_MIX_RequestMMSAttachmentWithURL  = 0X0211,
    CC_MIX_RequestMsgIDWithOID          = 0X0212,
    CC_MIX_RequestSendSMSWithParam      = 0X0213,
    CC_MIX_RequestMapImageWithLatitude  = 0X0214,
    CC_MIX_RequestSendMMSWithParam      = 0X0215,
    CC_MIX_RequestSendLocationWithMMS   = 0X0216,
    
    
    
    // cab                      0x0300  开始
    
    CC_Presence_DownloadPhoto        = 0x0301,
    CC_Presence_CreateContacts       = 0x0302,
    CC_Presence_UpdateContacts       = 0x0303,
    CC_Presence_DeleteContacts       = 0x0304,
	CC_Presence_DeleteAllContacts    = 0x0305,
    CC_Presence_GetContactProfiles   = 0x0306,
    CC_Presence_GetAllContactProfiles   = 0x0307,
    
    // sns                      0x0400  开始
    CC_GET_SNS_BIND             = 0x0401,
    CC_GET_SNS_BIG_IMAGE_URL    = 0x0402,
    CC_GET_SNS_BIG_IMAGE        = 0x0403,
    CC_GET_SNS_FEED_LIST        = 0x0404,
    CC_GET_SNS_FRIEND_LIST      = 0x0405,
    CC_GET_SNS_DIRECT_MESSAGE   = 0x0406,
    CC_GET_SNS_TWITTER_FOLLERS  = 0x0407,
    CC_GET_SNS_LIKE             = 0x0408,
    CC_GET_SNS_UNLIKE           = 0x0409,
    CC_GET_SNS_TWITTER_ONEPAGE_FOLLERS = 0x0410,
    CC_GET_SNS_PROFILE          = 0x0411,
    CC_GET_SNS_BINDURL          = 0x0412,
    CC_GET_SNS_UNBIND           = 0x0413,
    CC_GET_SNS_UPDATEPROFILE    = 0x0414,
    CC_GET_SNS_UPLOADIMAGE      = 0x0415,
    CC_GET_SNS_UPLOADVIDEO      = 0x0416,
    CC_GET_SNS_NEWDM            = 0x0417,
    CC_GET_SNS_NEWTEXTFEED      = 0x0418,
    CC_GET_SNS_TWSHAREFEED      = 0x0419,
    CC_GET_SNS_UPLOADCOMMENT    = 0x0420,
    CC_GET_SNS_GETCOMMENTLIST   = 0x0421,
    CC_GET_SNS_DOWNLOAD_IMAGE   = 0x0422,
    CC_GET_SNS_UPDATE_FEDDINFO  = 0x0423,
    // im                       0x0500      
    
    //M+
    CC_Services_Get_Status           = 0x1001,
    CC_Services_Set_Status_WithID    = 0x1002,
    CC_Services_Add_Status_WithID    = 0x1003,
    //Sign
    CC_Services_Get_SignContent      = 0x1004,
    CC_Services_Modifiy_SignContent  = 0x1005,
    CC_Services_Add_SignContent      = 0x1006,
    //autoreply
    CC_Services_Get_AutoreplyContent = 0x1007,
    CC_Services_Mod_AutoreplyContent = 0x1008,
    CC_Services_Add_AutoreplyContent = 0x1009,
    //ForWord
    CC_Services_Add_ForwordPolicy    = 0x100A,
    CC_Services_Delete_ForwordPolicy = 0x100B,
    CC_Services_Modify_ForwordPolicy = 0x100C,
    CC_Services_Get_ForwordPolicy    = 0x100D,
    //blacklist
    CC_Services_Get_BlacklistContent = 0x100E,
    CC_Services_Add_BlacklistContent = 0x100F,
    CC_Services_Del_BlacklistContent = 0x1010,

    //Dual-channel
    CC_Services_Get_IPLegacyPolicy   = 0x1011,
    CC_Services_Set_IPLegacyPolicy   = 0x1012,

	CC_Unknown                  = -1,
}E_CMDCODE;


