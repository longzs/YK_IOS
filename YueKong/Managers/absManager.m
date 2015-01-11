//
//  absManager.m
//  EHealth
//
//  Created by zhoushaolong on 14-11-20.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import "absManager.h"

@implementation absManager
@synthesize delegateProcess;

//- (EHCallBack)callBackWithSuccess:(processSuccess)successBlock failure:(processFailed)failureBlock additionalProcessSuccess:(EHCallBack)addtionalBlock
//{
//    EHCallBack callBack = ^(HttpOperation* hop) {
//        
//        //请求成功
//        if ([hop isRequestSuccess]) {
//            
//            //成功返回码
//            if ([hop.jsonData isSuccess]) {
//                
//                //额外的处理
//                if (addtionalBlock) {
//                    addtionalBlock(hop);
//                }
//                
//                if (successBlock) {
//                    successBlock(hop.jsonData.msg);
//                }
//            }
//            else {
//                
//                //返回错误信息
//                if (failureBlock) {
//                    failureBlock(hop.jsonData.msg);
//                }
//            }
//        }
//        
//        else{
//            
//            //网络错误
//            if (failureBlock) {
//                failureBlock(k_Msg_NetWorkErr);
//            }
//        }
//        
//    };
//    
//    return callBack;
//}

@end
