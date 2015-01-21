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

typedef enum wifiStatus_{
    wifiStatus_OK = 0, //
    wifiStatus_NoHomeSSID,
    wifiStatus_IsNotYKSSID,
    
}wifiStatus;

@interface ViewController ()

@property(weak, nonatomic)IBOutlet UITextField* tfSSID;
@property(weak, nonatomic)IBOutlet UITextField* tfSSIDPWD;

@property(weak, nonatomic)IBOutlet UIButton* btnBind;

@property(nonatomic, strong)NSString* strCurrentSSID;

@property(nonatomic, assign)wifiStatus wifiStatu;

-(IBAction)clickBindYK:(UIButton*)sender;

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
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (ViewController *)[Utils controllerInMainStroyboardWithID:@"ViewController"];
}

-(void)didEnterForground{
    [self performSelector:@selector(checkCurrentSSID) withObject:nil afterDelay:0.1];
}

-(IBAction)clickBindYK:(UIButton*)sender{
    [_tfSSID resignFirstResponder];
    [_tfSSIDPWD resignFirstResponder];
    
    switch (self.wifiStatu) {
        case wifiStatus_OK:
        {
            [self bindYKDevice];
        }
            break;
        case wifiStatus_NoHomeSSID:
        {
            if (0 == self.tfSSID.text) {
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

-(void)checkCurrentSSID{
    NSString* strSSID = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserSSID];
    NSString    *wifiPWD = [[EHUserDefaultManager sharedInstance] getValueFromDefault:k_UserWIFIPWD];
    self.strCurrentSSID = [[SSIDManager sharedInstance] currentWifiSSID];
    
    if ([self.strCurrentSSID isEqualToString:MARVELL_NETWORK_NAME]
        && strSSID.length
        && wifiPWD.length) {
        //  所有条件符合，可以发起绑定
            self.tfSSID.text = self.strCurrentSSID;
        self.tfSSID.enabled = NO;
        self.tfSSIDPWD.hidden = YES;
        [self.btnBind setTitle:@"绑定悦控" forState:UIControlStateNormal];
        
        self.wifiStatu = wifiStatus_OK;
    }
    else if(0 == strSSID.length)
    {
        self.tfSSID.text = self.strCurrentSSID;
        self.tfSSIDPWD.text = wifiPWD;
        self.tfSSID.enabled = YES;
        self.tfSSIDPWD.hidden = NO;
        [self.btnBind setTitle:@"记录wifi" forState:UIControlStateNormal];
        
        [self showMessage:@"请输入您家里使用的wifi名称和密码用来记录在悦控，如果wifi没有密码请不用输入" withTag:11 withTarget:self];
        
        self.wifiStatu = wifiStatus_NoHomeSSID;
    }
    else if(![self.strCurrentSSID isEqualToString:MARVELL_NETWORK_NAME]){
        
        self.tfSSID.text = self.strCurrentSSID;
        self.tfSSIDPWD.text = wifiPWD;
        self.tfSSID.enabled = YES;
        self.tfSSIDPWD.hidden = NO;
        [self.btnBind setTitle:@"记录wifi" forState:UIControlStateNormal];
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
    if (alertView.tag ==10 && buttonIndex==0)
    {
        [self GetAck];
    }
    else if (alertView.tag == 10 && buttonIndex ==1)
    {
        //[self ShowProgressView:@"Confirming network configuration..."];
        //[self setBusy:YES forMessage:@"Confirming network configuration..."];
        //[self performSelector:@selector(ContinueAttempts) withObject:nil afterDelay:1.0];
    }
    else if (11 == alertView.tag)
    {
        // 点击输入家庭wifi和pwd
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Request & Process

-(void)GetAck
{
    NSLog(@"GETACK");
    [self showLoadingWithTip:@"Reset-to-provisioning..."];
    
    NSString *str = [NSString stringWithFormat:@"{\"connection\":{\"station\": {\"configured\":%@,}}}",@"0"];//\"prov\":{\"client_ack\":%@,},
    
    
    NSLog(@"Requested string %@",str);
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",LOCAL_URL,@""];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_POST];
    [sent setDelegate_:self];
    [sent setCmdCode_:CC_GetACK];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:30];
    [sent setDicHeader:header];
    [sent setPostData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

-(void)bindYKDevice{
    
    [self showLoadingWithTip:@"正在绑定悦控基座"];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",LOCAL_URL,@""];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:0];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    MsgSent *sent = [[MsgSent alloc] init];
    [sent setMethod_Req:requestURL];
    [sent setMethod_Http:HTTP_METHOD_GET];
    [sent setDelegate_:self];
    [sent setCmdCode_:CC_BindYKDecive];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:30];
    [sent setDicHeader:header];
    [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

-(void)processBindYKDevice:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSDictionary *jsonData = [reciveData responsdData];
    }
    else
    {   //对于HTTP请求返回的错误,暂时不展开处理
        if (reciveData.httpRsp_ == E_HTTPERR_ASIRequestTimedOutErrorType)
        {
            
        }
        else if(reciveData.httpRsp_ == E_HTTPERR_ASIAuthenticationErrorType)
        {
            
        }
        else
        {
            
        }
        [Utils showSimpleAlert:@"请检查您得wifi连接是否正常"];
    }
}

#pragma mark - httpResponse
-(int)ReciveHttpMsg:(MsgSent*)ReciveMsg{
    
#if 0
    NSString *responseString = [[NSString alloc] initWithData:ReciveMsg.recData_ encoding:NSUTF8StringEncoding];
    NSLog(@"id = %d, httpRsp = %d\nReciveHttpMsg = \n%@,",  ReciveMsg.cmdCode_ , ReciveMsg.httpRsp_,responseString);
#endif
    
    [self hideLoading];
    switch (ReciveMsg.cmdCode_)
    {
        case CC_BindYKDecive:
        {
            [self processBindYKDevice:ReciveMsg];
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
