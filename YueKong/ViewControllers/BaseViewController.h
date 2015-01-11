//
//  BaseViewController.h
//  EHealth
//
//  Created by zhoushaolong on 14-11-14.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+EHBase.h"
#import "HttpMsgCtrl.h"

/**
 *  通过storyboard加载的协议，满足此协议代表是在storyboard中绘制的界面，可以通过instantiateFromMainStoryboard实例化
 */
@protocol EHLoadByStoryboard <NSObject>

+ (instancetype)instantiateFromMainStoryboard;

@end

@interface BaseViewController : UIViewController<EHLoadByStoryboard,
HTTP_MSG_RESPOND>

//当前的请求，在dealloc中会cancel
@property (nonatomic) int currentRequestId;

// 不支持右滑返回  默认为NO
@property (nonatomic, assign) BOOL NOSupportRightSwipe;

-(void)requestServerData;

//返回按钮事件
- (void)clickBackBarButton:(id)sender;


@end
