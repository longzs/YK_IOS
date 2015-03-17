//
//  HomeViewController.m
//  YueKong
//
//  Created by WangXun on 15/3/12.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "HomeViewController.h"
#import "YKAddDeviceTypePopoverView.h"
#import "BLePeripheralViewController.h"
#import "ViewController.h"
#import "RemoteControlViewController.h"

@interface HomeViewController ()

//ui
@property (nonatomic, weak) IBOutlet UIImageView *imvBG;

@end

@implementation HomeViewController

#pragma mark - Basic
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imvBG.hidden = YES;
//    _imvBG.image = [[UIImage imageNamed:@"bg_img.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    
    [LBleManager sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (self.navigationController.navigationBar.hidden) {
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        rect.size.height += 64;
        self.imgBG.frame = rect;
    }
    else{
        self.imgBG.frame = self.view.frame;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (HomeViewController *)[Utils controllerInMainStroyboardWithID:@"HomeViewController"];
}

#pragma mark - Action
- (IBAction)clickAddNewDevice:(id)sender
{
    weakSelf(wSelf);
    YKAddDeviceTypePopoverView *popoverView = [[YKAddDeviceTypePopoverView alloc] init];
    [popoverView setSelectIndexBlock:^(NSInteger selectIndex) {
        DLog(@"click %d",(int)selectIndex);
        
        if (1 == selectIndex) {
            BLePeripheralViewController *vc = [BLePeripheralViewController instantiateFromMainStoryboard];
            [wSelf.navigationController pushViewController:vc animated:YES];
        }
        else{
            RemoteControlViewController *vc = [RemoteControlViewController instantiateFromMainStoryboard];
            [wSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    [popoverView show];
}

- (IBAction)clickOptionButton:(id)sender
{
    [[Utils currentAppDelegate].rootViewController.sideMenuController presentLeftMenuViewController];
}


@end
