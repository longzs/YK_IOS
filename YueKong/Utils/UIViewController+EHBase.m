//
//  UIViewController+EHBase.m
//  EHealth
//
//  Created by focusdesign on 14/12/1.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import "UIViewController+EHBase.h"
#import "MBProgressHUD.h"

@implementation UIViewController (EHBase)

- (NSString *)imageNameWithImageType:(BarButtonType)buttonType
{
    NSString *imageName = nil;
    
    switch (buttonType) {
        case BarButtonTypeBack:
            imageName = @"";
            break;
        case BarButtonTypeSearch:
            imageName = @"btn_search";
            break;
        case BarButtonTypeUserCenter:
            imageName = @"btn_user_head";
            break;
        case BarButtonTypeDateSchedules:{
            imageName = @"DateSchedulesPre";
            break;
        }
        default:
            break;
    }
    
    return imageName;
}

- (void)showLoading
{
    [self showLoadingWithTip:nil];
}

- (void)showLoadingWithTip:(NSString*)tip{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = tip;
    [self.view bringSubviewToFront:hud];
}

- (void)hideLoading
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)addBackBarButtonWithAction:(SEL)action
{
    
    UIBarButtonItem *barItem = [Utils backbuttonItemWithTarget:self action:action];
    self.navigationItem.backBarButtonItem = barItem;
    
}

- (void)addDefaultBackButtonOfNext
{
    if (IOS_VERSION_7_LATER) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
    }
    else {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_back.png"] style:(UIBarButtonItemStylePlain) target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
    }
    
}

- (void)addLeftBarButtonWithType:(BarButtonType)buttonType title:(NSString *)title action:(SEL)action
{
    if (buttonType == BarButtonTypeText) {
        UIBarButtonItem *barItem = [Utils leftbuttonItemWithText:title target:self action:action];
        self.navigationItem.leftBarButtonItem = barItem;
    }
    else {
        NSString *imageString = [self imageNameWithImageType:buttonType];
        UIBarButtonItem *barItem = [Utils leftbuttonItemWithImage:imageString highlightedImage:nil target:self action:action];
        self.navigationItem.leftBarButtonItem = barItem;
    }
    
}

- (void)addRightBarButtonWithType:(BarButtonType)buttonType title:(NSString *)title action:(SEL)action
{
    if (buttonType == BarButtonTypeText) {
        UIBarButtonItem *barItem = [Utils rightbuttonItemWithText:title target:self action:action];
        self.navigationItem.rightBarButtonItem = barItem;
    }
    else {
        NSString *imageString = [self imageNameWithImageType:buttonType];
        UIBarButtonItem *barItem = [Utils rightbuttonItemWithImage:imageString highlightedImage:nil target:self action:action];
        self.navigationItem.rightBarButtonItem = barItem;
    }
    
}

@end