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

@interface ViewController ()

@property(weak, nonatomic)IBOutlet UITextField* tfSSID;
@property(weak, nonatomic)IBOutlet UITextField* tfSSIDPWD;

@property(nonatomic, strong)NSString* strCurrentSSID;

-(IBAction)clickBindYK:(UIButton*)sender;
-(void)checkCurrentSSID;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self performSelector:@selector(checkCurrentSSID) withObject:nil afterDelay:0.3];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (ViewController *)[Utils controllerInMainStroyboardWithID:@"ViewController"];
}

-(IBAction)clickBindYK:(UIButton*)sender{
    [self bindYKDevice];
}

-(void)checkCurrentSSID{
    //NSDictionary* dic = [[SSIDManager sharedInstance] fetchSSIDInfo];
    self.tfSSID.text = [[SSIDManager sharedInstance] currentWifiSSID];
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
        
        NSDictionary *JSONValue =  [responseString JSONData];
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
            NSLog(@"arr records count %lu",[arrRecords count]);
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
    else if (alertView.tag == 20 && buttonIndex == 0)
    {
        //[self ValidateFields];
    }
    else if(alertView.tag == 30 && buttonIndex ==0)
    {
//        ScanViewController *scanViewController = [[ScanViewController alloc]initWithNibName:@"ScanView" bundle:nil];
//        [self.navigationController pushViewController:scanViewController animated:YES];
    }
//    else if (alertView.tag == 50 || alertView.tag == 60 || alertView.tag == 70)
//    {
//        self.view.userInteractionEnabled = NO;
//    }
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
    [sent setCmdCode_:CC_GetLocalNumber];
    [sent setIReqType:HTTP_REQ_SHORTRUN];
    [sent setTimeout_:30];
    [sent setDicHeader:header];
    [[HttpMsgCtrl GetInstance] SendHttpMsg:sent];
}

-(void)processBindYKDevice:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSData *data = [reciveData recData_];
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
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
        case CC_GetLocalNumber:
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
