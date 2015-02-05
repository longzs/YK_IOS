//
//  DeviceManagerController.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-19.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "DeviceManagerController.h"
#import "RemoteControlViewController.h"
#import "HomeAppliancesManager.h"
#import "ViewController.h"
#import "HouseholdAppliancesCell.h"
#import "DeviceManagerCollectionHeaderView.h"

#define kCollectionCellApplinceSize CGSizeMake(self.view.frame.size.width/4.0, 100)

@interface DeviceManagerController ()<HTTP_MSG_RESPOND>{
    // 检查是否绑定成功次数  最大请求10次；
    NSInteger uReqCheckBindNumber;
}
@property(nonatomic, weak)IBOutlet UIButton *btnBind;
@property(nonatomic, weak)IBOutlet UILabel  *labBind;
@property(nonatomic, weak)IBOutlet UILabel  *labNoBindTip;
@property(nonatomic, weak)IBOutlet UICollectionView  *collectionDevices;

@property (nonatomic, weak) IBOutlet UIImageView *imvBG;

@property (nonatomic, weak) IBOutlet UIImageView *imvYKDevice;
@property(nonatomic, weak)IBOutlet UILabel  *labOperationTip;

-(IBAction)clickShowBind:(id)sender;
@end

@implementation DeviceManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备管理";
    
    _imvBG.image = [[UIImage imageNamed:@"bg_img.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    
    self.collectionDevices.alwaysBounceVertical = YES;
    self.collectionDevices.allowsMultipleSelection = YES;
    [self.collectionDevices registerClass:[HouseholdAppliancesCell class] forCellWithReuseIdentifier:@"HouseholdAppliancesCell"];
    [self.collectionDevices registerClass:[DeviceManagerCollectionHeaderView class]
               forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DeviceManagerCollectionHeaderView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateControlState:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (DeviceManagerController *)[Utils controllerInMainStroyboardWithID:@"DeviceManagerController"];
}

-(void)updateControlState:(BOOL)bRequest{
    
    if ([[EHUserDefaultManager sharedInstance] getCurrentDevice].pdsn) {
        // 如果已经存在pdsn
        self.labNoBindTip.hidden = YES;
        self.collectionDevices.hidden = NO;
        self.labBind.text = @"我得悦控";
        [self.btnBind setBackgroundImage:[UIImage imageNamed:@"button_UCON_Bind"]
                                forState:UIControlStateNormal];
        
        self.labOperationTip.text = @"您还没有配置任何家电遥控器，\n点击“+”马上配置";
        self.imvYKDevice.hidden = YES;
    }
    else{
        //
        self.labNoBindTip.hidden = NO;
        self.collectionDevices.hidden = YES;
        
        self.labBind.text = @"绑定悦控";
        [self.btnBind setBackgroundImage:[UIImage imageNamed:@"button_UCON_my"]
                                forState:UIControlStateNormal];
        
        self.labOperationTip.text = @"请保持电源及无线网络处于打开状态，\nUCON家族请勿分离";
        self.imvYKDevice.hidden = NO;
    }
    if (bRequest
        && nil == [[EHUserDefaultManager sharedInstance] getCurrentDevice].pdsn) {
        [[HomeAppliancesManager sharedInstance] checkIsBindYKSuccess:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)clickShowBind:(id)sender{
    ViewController *vc = [ViewController instantiateFromMainStoryboard];
    //RemoteControlViewController* vc = [RemoteControlViewController instantiateFromMainStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Request & Process
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
            dm.status = jsonData[@"status"];
            dm.idNo = jsonData[@"idNo"];
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
        [NSObject cancelPreviousPerformRequestsWithTarget:ham];
        bOk = YES;
        [Utils showSimpleAlert:strError];
    }
    if (bOk) {
        uReqCheckBindNumber = 0;
        [self hideLoading];
        
        [self updateControlState:NO];
    }
    else{
        if (uReqCheckBindNumber < 10) {
            uReqCheckBindNumber ++;
            [ham performSelector:@selector(checkIsBindYKSuccess:) withObject:self afterDelay:0.1];
        }
        else{
            [self hideLoading];
            [Utils showSimpleAlert:@"请求超时"];
            
            [self updateControlState:NO];
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
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    DeviceManagerCollectionHeaderView *header=nil;
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DeviceManagerCollectionHeaderView" forIndexPath:indexPath];
    }
    if (nil == header) {
        header  = [[DeviceManagerCollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, collectionView.frame.size.width*0.11)];
    }
    if (0 == indexPath.section) {
        header.labTitle.text= @"我的家电";
    }
    else {
        header.labTitle.text= @"我的预约";
    }
    return header;
    
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"HouseholdAppliancesCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    CGSize cellSize = kCollectionCellApplinceSize;
    UIImageView* ivBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height)];
    ivBG.image = [UIImage imageNamed:@"bg_menu_img"];
    [cell.contentView addSubview:ivBG];
//    
//    UILabel *labContent = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 50, 20)];
//    labContent.text = [NSString stringWithFormat:@"%ld %ld", indexPath.section, indexPath.row];
//    labContent.backgroundColor = [UIColor clearColor];
//    labContent.textColor = [UIColor redColor];
//    [cell.contentView addSubview:labContent];
    
    UIView* ivLine = [[UIView alloc] initWithFrame:CGRectMake(cellSize.width-1, 0, 1, cellSize.height)];
    ivLine.backgroundColor = RGB(170, 170, 170);
    [cell.contentView addSubview:ivLine];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return kCollectionCellApplinceSize;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width*0.11);
}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
