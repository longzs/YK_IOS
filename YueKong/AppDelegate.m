//
//  AppDelegate.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-7.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "HomeAppliancesManager.h"
#import "DBManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (k_IS_Report_Exception) {
        
    }
    //初始化
    
    //数据库
    [self createDB];
    
    //测试 wangxun..
    
    //ui
    //self.window.backgroundColor = [UIColor blackColor];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setupNavigationBarSytle];
    [self setupKeyboardManager];
    
//    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
//        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }else
//        
//    {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
//    
//    NSDictionary * pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (pushInfo) {
//        _startFromNoti = YES;
//        [self clearAppBadge];
//    }
    
//    DLog(@"did load:%@",launchOptions);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)createDB{
    NSString* dbPath = [APP_DOC_PATH stringByAppendingPathComponent:@"gblcd.sqlite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        // 移动文件
        NSError* err = nil;
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"gblcd" ofType:@"sqlite"];
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:dbPath error:&err];
        
        if (err) {
            NSLog(@"copy file err %@", err);
        }
    }
    [[DBManager sharedInstance] initDbPath:dbPath];
}

#pragma mark - Setup
-(void)setupNavigationBarSytle{
    //UIApplication* application = [UIApplication sharedApplication];
    if (IOS_VERSION_7_LATER) {
        UIImage* barImage = [[UIImage imageNamed:@"NavBarShadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [[UINavigationBar appearance] setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];//kColorNavigationBar
        [[UINavigationBar appearance] setTintColor:RGB(80, 80, 80)];
//        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"icon_back_normal"]];
//        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"icon_back_click"]];
    }
//    else {
//        [[UINavigationBar appearance] setBackgroundImage:[Utils createImageWithColor:kColorNavigationBar] forBarMetrics:UIBarMetricsDefault];
//        [[UINavigationBar appearance] setShadowImage:[Utils createImageWithColor:[UIColor colorWithWhite:0.3 alpha:0.15]]];
//        [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
//    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:17.0f],
                                NSFontAttributeName,
                                kColorTextGray,
                                NSForegroundColorAttributeName,
                                nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    // end
}

- (void)setupKeyboardManager
{
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}

@end
