//
//  AppDelegate.h
//  YueKong
//
//  Created by zhoushaolong on 15-1-7.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHRootViewController.h"

//psm-set nvram pdsn P00000000000013
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) EHRootViewController *rootViewController;

@end

