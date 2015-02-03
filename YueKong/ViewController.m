//
//  ViewController.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-7.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "ViewController.h"
#import "SSIDManager.h"
#import "Reachability.h"
#import "NetWorkDetails.h"
#import "RemoteControlViewController.h"

typedef enum wifiStatus_{
    wifiStatus_OK = 0, //
    wifiStatus_NoHomeSSID,
    wifiStatus_IsNotYKSSID,
    
}wifiStatus;

@interface ViewController (){
    
    BOOL bLoading;
    
    // 检查是否绑定成功次数  最大请求10次；
    NSInteger uReqCheckBindNumber;
}

@property(weak, nonatomic)IBOutlet UITextField* tfSSID;
@property(weak, nonatomic)IBOutlet UITextField* tfSSIDPWD;

@property(weak, nonatomic)IBOutlet UIButton* btnBind;

@property(weak, nonatomic)IBOutlet UIButton* btnRecordWifi;

@property(nonatomic, strong)NSString* strCurrentSSID;

@property(nonatomic, assign)wifiStatus wifiStatu;

-(IBAction)clickBindYK:(UIButton*)sender;

-(IBAction)clickRecordWifi:(UIButton*)sender;

-(void)checkCurrentSSID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"绑定悦控";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self performSelector:@selector(checkCurrentSSID) withObject:nil afterDelay:0.1];
    //[self bindYKDevice];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (ViewController *)[Utils controllerInMainStroyboardWithID:@"ViewController"];
}

-(void)didEnterForground{
    if (!bLoading) {
        [self performSelector:@selector(checkCurrentSSID) withObject:nil afterDelay:0.1];
    }
}

-(IBAction)clickBindYK:(UIButton*)sender{
    [_tfSSID resignFirstResponder];
    [_tfSSIDPWD resignFirstResponder];
    
    [self bindYKDevice];
    switch (self.wifiStatu) {
        case wifiStatus_OK:
        {
            
        }
            break;
        case wifiStatus_NoHomeSSID:
        {
            if (0 == self.tfSSID.text.length) {
                [self showMessage:@"请输入您家里使用的wifi名称和密码用来记录在悦控，如果wifi没有密码请不用输入" withTag:11 withTarget:self];
                return;
            }
            [[EHUserDefaultManager sharedInstance] updateDefaultValue:k_UserSSID Value:self.tfSSID.text];
            [[EHUserDefaultManager sharedInstance] updateDefaultValue:k_UserWIFIPWD Value:self.tfSSIDPWD.text];
            
            //
            [self showMessage:[NSString stringWithFormat:@"记录成功，请将手机连接至悦控的wifi %@，在返回点击绑定", MARVELL_NETWORK_NAME] withTag:13 withTarget:nil];
        }
            break;
        case wifiStatus_IsNotYKSSID:
        {
            [self showMessage:[NSString stringWithFormat:@"请将手机连接至悦控的wifi %@", MARVELL_NETWORK_NAME] withTag:12 withTarget:nil];
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)clickRecordWifi:(UIButton*)sender{
    if (0 == self.tfSSID.text.length) {
        [Utils showCenterToastWithMessage:@"wifi名称不能为空"];
        return;
    }
    [[EHUserDefaultManager sharedInstance] updateDefaultValue:k_UserSSID Value:self.tfSSID.text];
    [[EHUserDefaultManager sharedInstance] updateDefaultValue:k_UserWIFIPWD Value:self.tfSSIDPWD.text];
}

-(void)checkCurrentSSID{
    NSString* strSSID = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserSSID];
    NSString    *wifiPWD = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserWIFIPWD];
    self.strCurrentSSID = [[SSIDManager sharedInstance] currentWifiSSID];
    
    if ([self.strCurrentSSID isEqualToString:MARVELL_NETWORK_NAME]
        && strSSID.length) {
        //  所有条件符合，可以发起绑定 && wifiPWD.length
        self.tfSSID.text = self.strCurrentSSID;
        
        self.wifiStatu = wifiStatus_OK;
    }
    else if(0 == strSSID.length)
    {
        self.tfSSID.text = self.strCurrentSSID;
        if (wifiPWD.length) {
            self.tfSSIDPWD.text = wifiPWD;
        }
        
        [self showMessage:@"请输入您家里使用的wifi名称和密码用来记录在悦控，如果wifi没有密码请不用输入" withTag:11 withTarget:self];
        
        self.wifiStatu = wifiStatus_NoHomeSSID;
    }
    else if(![self.strCurrentSSID isEqualToString:MARVELL_NETWORK_NAME]){
        
        self.tfSSID.text = strSSID;
        self.tfSSIDPWD.text = wifiPWD;
        [self showMessage:[NSString stringWithFormat:@"请将手机连接至悦控的wifi %@", MARVELL_NETWORK_NAME] withTag:12 withTarget:nil];
        self.wifiStatu = wifiStatus_IsNotYKSSID;
    }
}

#pragma mark - from Marvell
/* Function to check if the device is connected to Marvell Network */
-(void)ScanForDevices
{
    NSLog(@"scan");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:URL_SCAN]];
    [request setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil
                                                             error:&error];
    if (error)
    {
        NSLog(@"error %@",error);
    }
    
    if(!error && [responseData length] > 0)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSDictionary *JSONValue = [responseString mutableObjectFromJSONString];
        NSArray *arrRecords = [JSONValue objectForKey:@"networks"];
        if (arrRecords)
        {
            
            NSMutableArray *arrResults = [[NSMutableArray alloc]init];
            for (int aindex =0 ; aindex<[arrRecords count];aindex++)
            {
                NSString *str = [arrRecords objectAtIndex:aindex];
                NetWorkDetails *networkDetails = [[NetWorkDetails alloc]init];
                NSArray *myString = [str componentsSeparatedByString:@","];
                networkDetails.ssid = [myString objectAtIndex:0];
                networkDetails.bssid = [myString objectAtIndex:1];
                networkDetails.security= [[myString objectAtIndex:2] intValue];
                networkDetails.channel = [[myString objectAtIndex:3] intValue];
                networkDetails.rssi = [[myString objectAtIndex:4] intValue];
                networkDetails.nf = [[myString objectAtIndex:5] intValue];
                [arrResults addObject:networkDetails];
            }
        }
    }
}

- (void)showDeviceNotConnected
{
    if ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound)
    {
        // The device is an iPad running iOS 3.2 or later.
        [self showMessage:MARVELL_NO_NETWORK_IPAD withTitle:@""];//\nNo WIFI available
        return;
    }
    else if ([[UIDevice currentDevice].model rangeOfString:@"iPhone"].location != NSNotFound)
    {
        // The device is an iPhone.
        [self showMessage:MARVELL_NO_NETWORK_IPHONE withTitle:@""];//\nNo WIFI available
        return;
    }
    else
    {
        // The device is an iPod.
        [self showMessage:MARVELL_NO_NETWORK_IPOD withTitle:@""];//\nNo WIFI available
        return;
    }
}

-(void)isYueKongDevice
{
    if ([SSIDManager isWiFiReachable])
    {
        [self bindYKDevice];
    }
    else
    {
        [self showDeviceNotConnected];
    }
}

- (BOOL)checkWifiConnection
{
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    if (ReachableViaWiFi != [wifiReach currentReachabilityStatus])
    {
        [self showDeviceNotConnected];
        return NO;
    }
    else
    {
        self.strCurrentSSID = [[SSIDManager sharedInstance] currentWifiSSID];
        if (([self.strCurrentSSID rangeOfString:MARVELL_NETWORK_NAME].location == NSNotFound) || !self.strCurrentSSID)
        {
            if ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound)
            {
                // The device is an iPad running iOS 3.2 or later.
                [self showMessage:MARVELL_NO_NETWORK_IPAD withTag:70 withTarget:self];
                
                return NO;
            }
            else if ([[UIDevice currentDevice].model rangeOfString:@"iPhone"].location != NSNotFound)
            {
                // The device is an iPhone or iPod touch.
                [self showMessage:MARVELL_NO_NETWORK_IPHONE withTag:70 withTarget:self];
                
                return NO;
            }
            else
            {
                // The device is an iPhone or iPod touch.
                [self showMessage:MARVELL_NO_NETWORK_IPOD withTag:70 withTarget:self];
                
                return NO;
            }
        }
        else
        {
            
            //[self showLoadingWithTip:@"Scanning Network Devices.."];
            [self isYueKongDevice];
        }
    }
    //[self performSelector:@selector(scanDevices) withObject:Nil afterDelay:1.0];
    return YES;
}

/* alertView */
#pragma mark alertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (11 == alertView.tag)
    {
        // 点击输入家庭wifi和pwd
    }
    else if (18 == alertView.tag){
        
        if (0 == buttonIndex) {
            RemoteControlViewController* vc = [RemoteControlViewController instantiateFromMainStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (1 == buttonIndex){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Request & Process

-(int)bindYKDevice{
    
    [self showLoadingWithTip:@"正在连接悦控基座"];
    bLoading = YES;
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",LOCAL_URL,@""];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    /*1.手机 APP 向设备（基座）发送信息，参数如下：
     ssid：wifi 名称 String
     key：wifi 密码 String
     security:加密方式
     channel:
     ip:内网 IP
     pid：手机设备号 String
     设备返回：
     pdsn
     */
    NSMutableDictionary* dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
    dicBody[@"ssid"] = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserSSID];
    dicBody[@"key"] = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserWIFIPWD];
    dicBody[@"security"] = @"";
    dicBody[@"channel"] = @"";
    dicBody[@"ip"] = @"";
    NSString* pid = [OpenUDID value];
    NSLog(@"pid = %@", pid);
    dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_POST];
    [sent setDelegate_:self];
    [sent setCmdCode_:CC_BindYKDecive];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    [sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

-(void)processBindYKDevice:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSDictionary *jsonData = [reciveData responsdData];
        NSString* strPdsn = [jsonData objectForKey:@"pdsn"];
        if (strPdsn.length) {
            [[EHUserDefaultManager sharedInstance] updatelastLastPdsn:strPdsn];
            
            // 提示设备连接成功，并且切回原有wifi
            [self showMessage:@"请切回原有wifi查询是否绑定成功" withTitle:@"连接悦控基座成功"];
//            //s开始轮询 向云端发起请求来判断设备是否绑定成功
//            [self showLoadingWithTip:@"正在查询绑定是否成功"];
//            bLoading = YES;
//            [self performSelector:@selector(checkIsBindYKSuccess) withObject:nil afterDelay:0.1];
        }
    }
    else
    {   //对于HTTP请求返回的错误,暂时不展开处理
        NSString* strError = @"请检查您得wifi连接是否正常";
        if (reciveData.httpRsp_ == E_HTTPERR_ASIRequestTimedOutErrorType)
        {
            strError = @"请求超时";
        }
        else if(reciveData.httpRsp_ == E_HTTPERR_ASIAuthenticationErrorType)
        {
            
        }
        else
        {
            
        }
        [Utils showSimpleAlert:strError];
    }
    bLoading = NO;
}


-(int)checkIsBindYKSuccess{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@",k_URL_GetBindData];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    /*手机 APP 向云端发起请求来判断设备是否绑定成功：
     PID：手机设备号 String
     云端返回：
     PDSN：步骤 2 中向云端注册的设备 ID String
     id：设备的内网 ip，用来进行之后的点对点连接
     */
    
    NSMutableDictionary* dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* pid = [OpenUDID value];
    NSLog(@"pid = %@", pid);
    dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_GET];
    [sent setDelegate_:self];
    [sent setCmdCode_:CC_CheckYKBindSuccess];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:5];
    [sent setDicHeader:header];
    [sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}


-(void)processIsBindYKSuccess:(MsgSent*)reciveData{
    
    BOOL bOk = NO;
    if ([reciveData isRequestSuccess])
    {
        NSDictionary *jsonData = [reciveData responsdData];
        NSString* strPdsn = [jsonData objectForKey:@"pdsn"];
        NSString* strIp = [jsonData objectForKey:@"ip"];
        if (strPdsn.length
            && strIp.length) {
            // 请求成功
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkIsBindYKSuccess) object:nil];
            bOk = YES;
            // 更新最后一次保存的pdsn
            [[EHUserDefaultManager sharedInstance] updatelastLastPdsn:strPdsn];
            // 记录内网yk ip
            [NetControl shareInstance].strIP = strIp;
            
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@""
                                                            message:@"绑定成功"
                                                           delegate:self
                                                  cancelButtonTitle:@"继续添加遥控器"
                                                  otherButtonTitles:@"先看看",nil];
            [alert setTag:18];
            [alert show];
        }
    }
    else
    {   //对于HTTP请求返回的错误,暂时不展开处理
        NSString* strError = @"请检查您得wifi连接是否正常";
        if (reciveData.httpRsp_ == E_HTTPERR_ASIRequestTimedOutErrorType)
        {
            strError = @"请求超时";
        }
        else if(reciveData.httpRsp_ == E_HTTPERR_ASIAuthenticationErrorType)
        {
            
        }
        else
        {
            
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkIsBindYKSuccess) object:nil];
        bOk = YES;
        [Utils showSimpleAlert:strError];
    }
    if (bOk) {
        uReqCheckBindNumber = 0;
        [self hideLoading];
    }
    else{
        if (uReqCheckBindNumber < 10) {
            uReqCheckBindNumber ++;
            [self performSelector:@selector(checkIsBindYKSuccess) withObject:nil afterDelay:0.1];
        }
        else{
            [self hideLoading];
            [Utils showSimpleAlert:@"请求超时"];
        }
    }
}

#pragma mark - httpResponse
-(int)ReciveHttpMsg:(MsgSent*)ReciveMsg{
    
#if 0
    NSString *responseString = [[NSString alloc] initWithData:ReciveMsg.recData_ encoding:NSUTF8StringEncoding];
    NSLog(@"id = %d, httpRsp = %d\nReciveHttpMsg = \n%@,",  ReciveMsg.cmdCode_ , ReciveMsg.httpRsp_,responseString);
#endif
    
    switch (ReciveMsg.cmdCode_)
    {
        case CC_BindYKDecive:
        {
            [self hideLoading];
            [self processBindYKDevice:ReciveMsg];
            break;
        }
        case CC_CheckYKBindSuccess:
        {
            [self processIsBindYKSuccess:ReciveMsg];
            break;
        }
        default:
            [self hideLoading];
            break;
    }
    return 0;
}

-(void)ReciveDidFailed:(MsgSent*)ReciveMsg{
    
}
@end
