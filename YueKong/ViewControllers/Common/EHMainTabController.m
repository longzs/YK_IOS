//
//  EHMainTabController.m
//  EHealth
//
//  Created by wangxun on 14/11/18.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import "EHMainTabController.h"

@interface EHMainTabController ()

@end

@implementation EHMainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (EHMainTabController *)[Utils controllerInMainStroyboardWithID:@"EHMainTabController"];
}

@end
