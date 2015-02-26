//
//  ReservationDetailViewController.m
//  YueKong
//
//  Created by WangXun on 15/2/26.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "ReservationDetailViewController.h"

@interface ReservationDetailViewController ()

@end

@implementation ReservationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addRightBarButtonWithType:BarButtonTypeText title:@"保存" action:@selector(clickRightBarButton:)];
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
    UIButton *button = (UIButton *)item.customView;
    [button setTitleColor:RGB(40, 140, 225) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (ReservationDetailViewController *)[Utils controllerInMainStroyboardWithID:@"ReservationDetailViewController"];
}

- (void)clickRightBarButton:(id)sender
{
    
}

@end
