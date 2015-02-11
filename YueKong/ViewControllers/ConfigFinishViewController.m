//
//  ConfigFinishViewController.m
//  YueKong
//
//  Created by WangXun on 15/2/11.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "ConfigFinishViewController.h"

@interface ConfigFinishViewController ()

@property (nonatomic, weak) IBOutlet UITextField *txfName;

@end

@implementation ConfigFinishViewController

#pragma mark - Basic
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"配置家电遥控器";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (ConfigFinishViewController *)[Utils controllerInMainStroyboardWithID:@"ConfigFinishViewController"];
}

#pragma mark - Action
- (IBAction)clickFinish:(id)sender
{
    
}

- (IBAction)clickFirstButton:(id)sender
{
    
}

- (IBAction)clickSecondButton:(id)sender
{
    
}

@end
