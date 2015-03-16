//
//  EHRootViewController.m
//  EHealth
//
//  Created by wangxun on 14/11/18.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import "EHRootViewController.h"
#import "DeviceManagerController.h"



@interface EHRootViewController ()

//@property (nonatomic, strong) EHUserGuideViewController *guideVC;

@end

@implementation EHRootViewController
@synthesize sideMenuController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //给root view controller一个入口
    [Utils currentAppDelegate].rootViewController = self;
    
    //DeviceManagerController *vc = [DeviceManagerController instantiateFromMainStoryboard];
    _homeController = [HomeViewController instantiateFromMainStoryboard];
    _mainNavController = [[EHBaseNavController alloc] initWithRootViewController:_homeController];
    
    LeftViewController* leftVc = [LeftViewController instantiateFromMainStoryboard];
    
    sideMenuController = [[RESideMenu alloc] initWithContentViewController:_mainNavController leftMenuViewController:leftVc rightMenuViewController:nil];
    sideMenuController.delegate = self;
    //sideMenuController.contentViewInPortraitOffsetCenterY = 70;
    //sideMenuController.backgroundImage = [UIImage imageNamed:@"bgUserCenter"];
    
//    //引导页
//    if ([[EHUserDefaultManager sharedInstance] isFirstLaunch]) {
//        [self showGuideViewController];
//    }
//    else {
//        [self showMainViewController];
//    }
    
    [self addChildViewController:sideMenuController];
    [self.view addSubview:sideMenuController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (EHRootViewController *)[Utils controllerInMainStroyboardWithID:@"EHRootViewController"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

#if 0
    EHRegisterViewController *registerVC = [EHRegisterViewController instantiateFromMainStoryboard];
    [self presentViewController:registerVC animated:YES completion:nil];
#endif
}

#pragma mark - Method
- (void)showLoginViewController
{
//    weakSelf(wSelf);
//    EHLoginViewController *vc = [EHLoginViewController instantiateFromMainStoryboard];
//    EHLoginCompletionBlock block = ^(BOOL successFlag){
//        [wSelf.mainNavController dismissViewControllerAnimated:YES completion:nil];
//    };
//    vc.completionBlock = block;
//    EHBaseNavController *nav = [[EHBaseNavController alloc] initWithRootViewController:vc];
//    [self.mainNavController presentViewController:nav animated:YES completion:nil];
}

- (void)showLoginViewControllerWithCompletion:(void (^)(BOOL))completiongBlock
{
//    weakSelf(wSelf);
//    EHLoginViewController *vc = [EHLoginViewController instantiateFromMainStoryboard];
//    EHLoginCompletionBlock block = ^(BOOL successFlag){
//        [wSelf.mainNavController dismissViewControllerAnimated:YES completion:^{
//            if (completiongBlock) {
//                completiongBlock(successFlag);
//            }
//        }];
//    };
//    vc.completionBlock = block;
//    EHBaseNavController *nav = [[EHBaseNavController alloc] initWithRootViewController:vc];
//    [self.mainNavController presentViewController:nav animated:YES completion:nil];
}

- (void)showGuideViewController
{
//    _guideVC = [EHUserGuideViewController instantiateFromMainStoryboard];
//    [self addChildViewController:_guideVC];
//    [self.view addSubview:_guideVC.view];
}

- (void)showMainViewController
{
    
//    [self addChildViewController:sideMenuController];
//    [self.view addSubview:sideMenuController.view];
//    sideMenuController.view.alpha = 0;
//    
//    [UIView animateWithDuration:0.3f animations:^{
//        if (self.guideVC) {
//            self.guideVC.view.alpha = 0;
//        }
//        sideMenuController.view.alpha = 1;
//    } completion:^(BOOL finished) {
//        if (self.guideVC) {
//            [self.guideVC.view removeFromSuperview];
//            [self.guideVC removeFromParentViewController];
//        }
//    }];
}

- (void)goMessageCenter
{
//    //当前不是在消息中心
//    if (![_mainNavController.visibleViewController isKindOfClass:[EHMsgCenterViewController class]]) {
//        EHMsgCenterViewController *vc = [EHMsgCenterViewController instantiateFromMainStoryboard];
//        [_mainNavController pushViewController:vc animated:YES];
//    }
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
//    if ([menuViewController isKindOfClass:[EHUserCenterViewController class]]) {
//        [menuViewController viewWillAppear:YES];
//    }
    
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
//    if ([menuViewController isKindOfClass:[EHUserCenterViewController class]]) {
//        [menuViewController viewDidAppear:YES];
//    }
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end
