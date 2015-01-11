//
//  EHRootViewController.h
//  EHealth
//
//  Created by wangxun on 14/11/18.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import "BaseViewController.h"
#import "EHBaseNavController.h"
#import "EHMainTabController.h"
//#import "EHHomeViewController.h"
#import "RESideMenu.h"
#import "ViewController.h"

@interface EHRootViewController : BaseViewController
<EHLoadByStoryboard, RESideMenuDelegate>

@property (strong, nonatomic) EHBaseNavController *mainNavController;
//@property (strong ,nonatomic) EHHomeViewController *homeController;
@property (strong, nonatomic) RESideMenu *sideMenuController;
@property (strong, nonatomic) ViewController *bindYKController;
/**
 *  model的方式弹出登录页面
 */
- (void)showLoginViewController;

/**
 *  model的方式弹出登录页面
 *
 *  @param completiongBlock 登录成功的回调
 */
- (void)showLoginViewControllerWithCompletion:(void (^)(BOOL finishFlag))completiongBlock;

/**
 *  从guide页面到主页面
 */
- (void)showMainViewController;

/**
 *  跳转到消息中心
 */
- (void)goMessageCenter;

@end
