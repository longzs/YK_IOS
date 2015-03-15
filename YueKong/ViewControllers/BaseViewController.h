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
#import "NetControl.h"
#import "EHUserDefaultManager.h"
#import "OpenUDID.h"
#import "YKDeviceModel.h"
/**
 *  通过storyboard加载的协议，满足此协议代表是在storyboard中绘制的界面，可以通过instantiateFromMainStoryboard实例化
 */
@protocol EHLoadByStoryboard <NSObject>

+ (instancetype)instantiateFromMainStoryboard;

@end

@interface BaseViewController : UIViewController<EHLoadByStoryboard>

//当前的请求，在dealloc中会cancel
@property (nonatomic) int currentRequestId;

// 不支持右滑返回  默认为NO
@property (nonatomic, assign) BOOL NOSupportRightSwipe;

@property (nonatomic, strong) UIImageView* imgBG;

-(void)requestServerData;

//返回按钮事件
- (void)clickBackBarButton:(id)sender;

-(void) showMessage:(NSString *)text withTitle:(NSString *)title;
-(void) showMessage:(NSString *)text withTag:(int)tag withTarget:(id)target;
-(void) showMessage:(NSString *)text ;

-(NSInteger)cellNumbersForDataCount:(NSUInteger)dataCount;

@end
