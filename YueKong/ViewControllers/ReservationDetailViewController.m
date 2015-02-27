//
//  ReservationDetailViewController.m
//  YueKong
//
//  Created by WangXun on 15/2/26.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "ReservationDetailViewController.h"

@interface ReservationDetailViewController ()

@property (nonatomic, weak) IBOutlet UIButton *btnOpen;
@property (nonatomic, weak) IBOutlet UITextField *txfChannel;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation ReservationDetailViewController

#pragma mark Basic
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

#pragma mrak - Actions
- (void)clickRightBarButton:(id)sender
{
    
}

- (IBAction)clickOpenButton:(id)sender
{
    
}

@end
