//
//  mPacket.h
//  Router3G
//
//  Created by zhousl on 14-6-17.
//  Copyright (c) 2014年 zsl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MsgStatus {
    E_SUCCESS = 0,                      // 成功
    E_FAILED_DATA_ERROR = 111,            // 数据包构造错误 这个值代表是服务器返回的error
    E_FAILED_NET_ERROR = 112,             // 网络错误
    E_FAILED_SEND_TIMEOUT = 113,
    
    E_FAILED_OTHER = -1                 // 其它
}msgStatus;

@interface mPacket : NSObject
@property(nonatomic, assign)short               uLength;
@property(nonatomic, assign)short int           cmdID;
@property(nonatomic, assign)char                stateOper;
@property(nonatomic, strong)NSData*             sendData;// 网络传送过来的data
@property(nonatomic, strong)NSData*             responseData;// 网络传送过来的data
@property(nonatomic, assign)int                 bTag;
@property(nonatomic, assign)msgStatus           status;
@property(nonatomic, assign)NSUInteger          timeout_;
@property(nonatomic, strong)NSString*           body;
@end

/*
 * 发送与服务器请求返回消息
 */
//@interface udpSendMsg : mPacket
//@property(nonatomic, retain)NSMutableDictionary* responseInfo;// 请求返回的数据 key与解析方法中设置的key值一致
//
//@property(nonatomic, assign)id                  targetd;            // 回传指针
///*
// *回调函数 参数暂定为发送对象 目前是在子线程中回调 在收到解析数据后处理完db以及业务，要在主线程抛通知给 UI
// */
//@property(nonatomic, assign)SEL                 didReciveMsgSel;
//@property(nonatomic, retain)NSDictionary*       userInfo;           //附加参数
//@end

/*
 * 服务器推送消息
 */
//@interface udpNotifyMsg : mPacket
//@property(nonatomic, retain)NSString*           responseString; //返回的字符串
//@end


