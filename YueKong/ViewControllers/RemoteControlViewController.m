//
//  RemoteControlViewController.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-19.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "RemoteControlViewController.h"

@interface RemoteControlViewController ()

@end

@implementation RemoteControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"遥控器配置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    RemoteControlViewController* rc = [[RemoteControlViewController alloc] initWithNibName:@"RemoteControlViewController" bundle:nil];
    
    return rc;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
