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
#import "JSONKit.h"
#import "HomeAppliancesManager.h"

typedef enum wifiStatus_{
    wifiStatus_OK = 0, //
    wifiStatus_NoHomeSSID,
    wifiStatus_IsNotYKSSID,
    
}wifiStatus;

@interface ViewController (){
    
    BOOL bLoading;
    
    // 检查是否绑定成功次数  最大请求10次；
    NSInteger uReqCheckBindNumber;
    
    int Mode;       // 网络连接类型
}

@property(weak, nonatomic)IBOutlet UITextField* tfSSID;
@property(weak, nonatomic)IBOutlet UITextField* tfSSIDPWD;

@property(weak, nonatomic)IBOutlet UIButton* btnBind;

@property(weak, nonatomic)IBOutlet UIButton* btnRecordWifi;

@property(nonatomic, strong)NSString* strCurrentSSID;

@property(nonatomic, strong)NSString* security;

@property(nonatomic, strong)NSString* channel;

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
    
    
    switch (self.wifiStatu) {
        case wifiStatus_OK:
        {
            [self isYkDevice];
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
//            [self showMessage:[NSString stringWithFormat:@"记录成功，请将手机连接至悦控的wifi %@，在返回点击绑定", MARVELL_NETWORK_NAME] withTag:13 withTarget:nil];
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
    
    [self showMessage:[NSString stringWithFormat:@"记录成功，请将手机wifi连接至悦控设备wifi热点，名称包含（%@），来发起绑定，O(∩_∩)O", MARVELL_NETWORK_NAME]
              withTag:31
           withTarget:self];
}

-(void)checkCurrentSSID{
    Mode = 0;
    if (![SSIDManager isWiFiReachable]) {
        Mode = -1;
        [self showMessage:MARVELL_NO_NETWORK_IPHONE withTag:70 withTarget:nil];
    }
    NSString* strSSID = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserSSID];
    NSString    *wifiPWD = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserWIFIPWD];
    self.strCurrentSSID = [[SSIDManager sharedInstance] currentWifiSSID];
    
    if ([self.strCurrentSSID rangeOfString:MARVELL_NETWORK_NAME options:NSCaseInsensitiveSearch].length
        && strSSID.length) {
        //  所有条件符合，可以发起绑定 && wifiPWD.length
        self.tfSSID.text = self.strCurrentSSID;
        self.wifiStatu = wifiStatus_OK;
        
        [self showMessage:@"您已经连接上悦控wifi热点，请点击绑定按钮发起绑定"
                  withTag:21 withTarget:self];
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
        
        self.tfSSID.text = self.strCurrentSSID;
        self.tfSSIDPWD.text = @"";//wifiPWD;
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
        [self isYkDevice];
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

-(int)isYkDevice{
    [self showLoadingWithTip:@"正在连接悦控基座"];
    bLoading = YES;
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",LOCAL_URL,@""];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_GET];
    [sent setDelegate_:self];
    [sent setCmdCode_:CC_IsYKDecive];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setDicHeader:header];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

-(void)processIsYkDevice:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSDictionary *JSONValue =  [reciveData.responseJsonString mutableObjectFromJSONStringWithParseOptions:JKParseOptionValidFlags];
       
        DLog(@"startProvisioning::Output:%@",JSONValue);
        
        int configured = [[[[JSONValue objectForKey:@"connection"] objectForKey:@"station"] objectForKey:@"configured"] intValue];
        int Status =[[[[JSONValue objectForKey:@"connection"] objectForKey:@"station"] objectForKey:@"status"] intValue];
        
        NSString *pdsn = [[JSONValue objectForKey:@"connection"] objectForKey:@"pdsn"];
        if ([pdsn isKindOfClass:[NSString class]]
            && 5 < pdsn.length) {
            [[EHUserDefaultManager sharedInstance] updatelastLastPdsn:pdsn];
        }
        if (Mode==-1)
        {
//            SetBSSID([[[JSONValue objectForKey:@"connection"] objectForKey:@"uap"] objectForKey:@"bssid"]);
//            NSLog(@"bssid %@",GetBSSID);
        }
        if (configured == 1 && Status == 2)
        {
            [self showMessage:MARVELL_PROVISIONED withTitle:@""];//@"Device is already provisioned Please connect to another device"
//            ScanViewController *scanViewController = [[ScanViewController alloc]initWithNibName:@"ScanView" bundle:Nil];
//            [self.navigationController pushViewController:scanViewController animated:YES];
        }
        else if (configured == 0)
        {
            if (Mode ==0)
            {
                self.security = [[[JSONValue objectForKey:@"connection"] objectForKey:@"uap"] objectForKey:@"security"];
                self.channel = [[[JSONValue objectForKey:@"connection"] objectForKey:@"uap"] objectForKey:@"channel"];
                [self bindYKDevice];
            }
            else if(Mode != -1)
            {
//                txtPassword.text = @"";
//                sleep(3);
//                CGRect frame = self.popViewSecurity.frame;
//                frame.size.height = 0;
//                self.popViewSecurity.frame = frame;
//                self.viewPassphrase.hidden = YES;
//                frame = self.imgViewPassword.frame;
//                self.btnProvision.frame = frame;
//                
//                [self.btnNetwork setTitle:@"Choose Network" forState:UIControlStateNormal];
//                [self showMessage:MARVELL_RESET];//@"Reset to provisioning successful"
//                self.btnProvision.enabled = NO;
//                TimerCount=0;
            }
            
        }
        else if ((configured == 1 && Status == 1) || (configured == 1 && Status == 0))
        {
            //Device is already configured\n Do you want to proceed?
//            alertVw = [[UIAlertView alloc]initWithTitle:@"" message:@"Device is trying to connect \n Do you want to Reset to provisioning or continue attempts?" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alertVw addButtonWithTitle:@"Reset"];
//            [alertVw addButtonWithTitle:@"Continue"];
//            alertVw.tag = 10;
//            [alertVw show];
//            [alertVw release];
            //[self showMessage:@"Device is already configured"];
        }
        else
        {
            NSString *status = [[JSONValue objectForKey:@"prov"] objectForKey:@"types"] ;
            NSLog(@"prov->types  status:%@",status);
            
            if([status isEqualToString:@"no \"marvell\""])
            {
                [self showMessage:@"Not a valid device, try WPS"];
            }
            else
            {
                [self showMessage:@"Not a valid device"];
            }
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

-(int)bindYKDevice{
    
    [self showLoadingWithTip:@"正在配置悦控基座"];
    bLoading = YES;
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",LOCAL_URL,@"network"];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    NSMutableDictionary* dicBody = [NSMutableDictionary dictionaryWithCapacity:0];
    dicBody[@"ssid"] = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserSSID];
    dicBody[@"key"] = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserWIFIPWD];
    dicBody[@"security"] = RPLACE_EMPTY_STRING(self.security);
    dicBody[@"channel"] = RPLACE_EMPTY_STRING(self.channel);
    dicBody[@"ip"] = @"1";
    NSString* pid = [OpenUDID value];
    NSLog(@"pid = %@", pid);
    dicBody[@"pid"] = RPLACE_EMPTY_STRING(pid);
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_POST];
    [sent setDelegate_:self];
    [sent setCmdCode_:CC_BindYKDecive];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setDicHeader:header];
    [sent setPostData:[dicBody JSONData]];
    return [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

-(void)processBindYKDevice:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSDictionary *JSONValue =  [reciveData.responseJsonString mutableObjectFromJSONStringWithParseOptions:JKParseOptionValidFlags];
        NSString *strValue = [JSONValue objectForKey:@"success"];
        
        if(strValue)
        {
            // 提示设备连接成功，并且切回原有wifi
            //[self showMessage:@"请切回原有wifi查询是否绑定成功" withTitle:@"连接悦控基座成功"];
            [self checkYKIsBindSuccess];
        }
        else
        {
            strValue = [JSONValue objectForKey:@"error"];
            if (strValue)
            {
                [self showMessage:strValue];
            }
            else
            {
                [self showMessage:MARVELL_INCORRECT_DATA];
            }
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

-(int)checkYKIsBindSuccess{
    
    [self showLoadingWithTip:@"正在检查悦控基座是否绑定成功，请稍等 ^_^"];
    return [[HomeAppliancesManager sharedInstance] checkIsBindYKSuccess:self];
}

-(void)processIsBindYKSuccess:(MsgSent*)reciveData{
    
    BOOL bOk = NO;
    HomeAppliancesManager* ham = [HomeAppliancesManager sharedInstance];
    if ([reciveData isRequestSuccess])
    {
        NSDictionary *jsonData = [reciveData responsdData];
        NSString* strPdsn = [jsonData objectForKey:@"pdsn"];
        NSString* strIp = [jsonData objectForKey:@"ip_address"];
        if (strPdsn.length
            && strIp.length) {
            // 请求成功
            [NSObject cancelPreviousPerformRequestsWithTarget:ham];
            
            if (nil == [[EHUserDefaultManager sharedInstance] getCurrentDevice]) {
                UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@""
                                                                message:@"绑定成功"
                                                               delegate:self
                                                      cancelButtonTitle:@"继续添加遥控器"
                                                      otherButtonTitles:@"先看看",nil];
                [alert setTag:18];
                [alert show];
            }
            bOk = YES;
            // 更新最后一次保存的pdsn
            [[EHUserDefaultManager sharedInstance] updatelastLastPdsn:strPdsn];
            // 记录内网yk ip
            [NetControl shareInstance].strIP = strIp;
            
            YKDeviceModel *dm = [[YKDeviceModel alloc] init];
            dm.pdsn = strPdsn;
            dm.ip_address = strIp;
            dm.name = jsonData[@"name"];
            dm.status = [NSString stringWithFormat:@"%d", [jsonData[@"status"] intValue]];
            dm.idNo = [NSString stringWithFormat:@"%d", [jsonData[@"id"] intValue]];
            dm.create_time = jsonData[@"create_time"];
            [[EHUserDefaultManager sharedInstance] updateCurrentDevice:dm];
            //[dm release];
        }
    }
    else
    {   //对于HTTP请求返回的错误,暂时不展开处理
        NSString* strError = @"请检查您得网络连接是否正常";
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
//        [NSObject cancelPreviousPerformRequestsWithTarget:ham];
//        bOk = YES;
//        [Utils showSimpleAlert:strError];
    }
    // 请求10次，每次相隔1秒
    if (bOk) {
        uReqCheckBindNumber = 0;
        [self hideLoading];
    }
    else{
        if (uReqCheckBindNumber < 10) {
            uReqCheckBindNumber ++;
            [ham performSelector:@selector(checkIsBindYKSuccess:) withObject:self afterDelay:1];
        }
        else{
            [self hideLoading];
            [Utils showSimpleAlert:@"请求超时, 请重新在查询"];
        }
    }
}

#pragma mark - httpResponse
-(int)ReciveHttpMsg:(MsgSent*)ReciveMsg{
    
#if 0
    NSString *responseString = [[NSString alloc] initWithData:ReciveMsg.recData_ encoding:NSUTF8StringEncoding];
    NSLog(@"id = %d, httpRsp = %d\nReciveHttpMsg = \n%@,",  ReciveMsg.cmdCode_ , ReciveMsg.httpRsp_,responseString);
#endif
    
    if (CC_CheckYKBindSuccess != ReciveMsg.cmdCode_) {
       [self hideLoading];
    }
    switch (ReciveMsg.cmdCode_)
    {
        case CC_BindYKDecive:
        {
            [self processBindYKDevice:ReciveMsg];
            break;
        }
        case CC_CheckYKBindSuccess:
        {
            [self processIsBindYKSuccess:ReciveMsg];
            break;
        }
        case CC_IsYKDecive:
        {
            [self processIsYkDevice:ReciveMsg];
            break;
        }
        default:
            break;
    }
    return 0;
}

-(void)ReciveDidFailed:(MsgSent*)ReciveMsg{
    
}
@end
