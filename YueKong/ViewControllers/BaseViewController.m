//
//  BaseViewController.m
//  EHealth
//
//  Created by zhoushaolong on 14-11-14.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import "BaseViewController.h"
#import "IQKeyboardManager.h"
//#import "EHHttpManager.h"

@interface BaseViewController ()
{
    UISwipeGestureRecognizer* rightSwipeToBack;
}
@property (nonatomic, copy) NSString *currnetTitle;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //默认的初始化
    
    if (IOS_VERSION_7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    

    //[self addDefaultBackButtonOfNext];

    //返回按钮
//    UIBarButtonItem *barButton = [Utils backbuttonItemWithTarget:self action:@selector(clickBackBarButton:)];
//    self.navigationItem.leftBarButtonItem = barButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_currnetTitle) {
        self.title = _currnetTitle;
    }
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)rightSwipeToBack:(UISwipeGestureRecognizer*)sender{
    DLog(@"当前导航栈数量：%lu", (unsigned long)[self.navigationController.viewControllers count]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    NSString *tmpTitle = nil;
    if (self.title) {
        tmpTitle = [NSString stringWithFormat:@"%@",self.title];
    }
    
    self.title = @" ";
    
    if (tmpTitle) {
        _currnetTitle = tmpTitle;
    }
    
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    _currnetTitle = title;
}

- (void)clickBackBarButton:(id)sender
{
    DLog(@"当前导航栈数量：%lu", (unsigned long)[self.navigationController.viewControllers count]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    if (self.currentRequestId != 0) {
        //[[EHHttpManager sharedInstance] CancelRequestByID:self.currentRequestId];
    }
}

-(void)requestServerData{
    
}

#pragma mark UIAlertView methods

- (void)showMessage:(NSString *)text withTitle:(NSString *)title {
    UIAlertView * alert =[[UIAlertView alloc] initWithTitle:title
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void) showMessage:(NSString *)text withTag:(int)tag withTarget:(id)target
{
    UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil,nil];
    [alert setDelegate:target];
    [alert setTag:tag];
    [alert show];
}

- (void)showMessage:(NSString *)text  {
    UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
