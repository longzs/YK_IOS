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
#import "YKButtonPopoverView.h"

#define kCollectionCellApplinceSize CGSizeMake(self.view.frame.size.width/4.0, 100)

#define kAddCategory      @"kAddCategory"

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

@property(nonatomic, strong)NSMutableArray* aryRCCategories;
@property(nonatomic, strong)NSMutableArray* aryRCOrderTime;

-(IBAction)clickShowBind:(id)sender;

@end

@implementation DeviceManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备管理";
    
    _imvBG.image = [[UIImage imageNamed:@"bg_img.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    
    YKRemoteControlCategory* addCategory = [[YKRemoteControlCategory alloc] init];
    addCategory.idNo = [NSString stringWithFormat:@"%d", HAType_Add];
    self.aryRCCategories = [NSMutableArray arrayWithObject:addCategory];
    
    self.aryRCOrderTime = [NSMutableArray arrayWithObject:@"111"];
    
    self.collectionDevices.backgroundColor = RGB(245, 245, 245);
    self.collectionDevices.alwaysBounceVertical = YES;
    self.collectionDevices.allowsMultipleSelection = YES;
    [self.collectionDevices registerClass:[HouseholdAppliancesCell class] forCellWithReuseIdentifier:@"HouseholdAppliancesCell"];
    [self.collectionDevices registerClass:[DeviceManagerCollectionHeaderView class]
               forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DeviceManagerCollectionHeaderView"];
    
    //// test
    //[[HomeAppliancesManager sharedInstance] GetBrand:[NSMutableDictionary dictionaryWithObject:@"1" forKey:@"category_id"] responseDelegate:self];
    //[[HomeAppliancesManager sharedInstance] GetCityCovered:nil responseDelegate:self];
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
    
    if (![[EHUserDefaultManager sharedInstance] getCurrentDevice].pdsn) {
        // 如果已经存在pdsn
        self.labNoBindTip.hidden = YES;
        self.collectionDevices.hidden = NO;
        self.labBind.text = @"我得悦控";
        [self.btnBind setBackgroundImage:[UIImage imageNamed:@"button_UCON_Bind"]
                                forState:UIControlStateNormal];
        
        self.labOperationTip.text = @"您还没有配置任何家电遥控器，\n点击“+”马上配置";
        self.imvYKDevice.hidden = YES;
        
        if ([self.aryRCCategories count] <= 1) {
            [[HomeAppliancesManager sharedInstance] GetCategory:nil responseDelegate:self];
        }
        else{
            [self.collectionDevices reloadData];
        }
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
        && nil == [[EHUserDefaultManager sharedInstance] getCurrentDevice].pdsn
        && 0 < [[EHUserDefaultManager sharedInstance] LastPdsn].length) {
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


-(void)processGetCategorys:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSArray *jsonDataAry = [reciveData responsdData];
        if ([jsonDataAry isKindOfClass:[NSArray class]]
            && jsonDataAry.count) {
            
            for (NSDictionary* jsonData in jsonDataAry) {
                
                YKRemoteControlCategory *dm = [[YKRemoteControlCategory alloc] init];
                dm.name = jsonData[@"name"];
                dm.status = [NSString stringWithFormat:@"%d", [jsonData[@"status"] intValue]];
                dm.idNo = [NSString stringWithFormat:@"%d", [jsonData[@"id"] intValue]];
                dm.create_time = jsonData[@"create_time"];
                
                [self.aryRCCategories insertObject:dm atIndex:0];
            }
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
        [Utils showSimpleAlert:strError];
    }
    [self.collectionDevices reloadData];
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
        case CC_GetCategory:
        {
            [self processGetCategorys:ReciveMsg];
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
    if (0 == section) {
        return 8;//self.aryRCCategories.count;
    }
    else{
        return self.aryRCOrderTime.count;
    }
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // 如果有绑定成功的遥控器就显示两个 暂时返回2
    return 2;
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
    cell.backgroundColor = [UIColor clearColor];
    
    CGSize cellSize = kCollectionCellApplinceSize;
    
    NSArray* aryViews = [cell.contentView subviews];
    for (UIView* sub in aryViews) {
        [sub removeFromSuperview];
    }
    cell.selectedBackgroundView = nil;
    
    UIView* ivLine = [[UIView alloc] initWithFrame:CGRectMake(cellSize.width-1, 0, 1, cellSize.height)];
    ivLine.backgroundColor = RGB(170, 170, 170);
    [cell.contentView addSubview:ivLine];
    
    ivLine = [[UIView alloc] initWithFrame:CGRectMake(0, -1, cellSize.width, 1)];
    ivLine.backgroundColor = RGB(170, 170, 170);
    [cell.contentView addSubview:ivLine];
    
    ivLine = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-1, cellSize.width, 1)];
    ivLine.backgroundColor = RGB(170, 170, 170);
    [cell.contentView addSubview:ivLine];
    
    UIImageView *selectView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_click_"]];
    selectView.backgroundColor = [UIColor clearColor];
    selectView.frame = CGRectMake(-1, -1, cellSize.width, cellSize.height);
    cell.selectedBackgroundView = selectView;
    
    if (0 == indexPath.section
        && indexPath.row < self.aryRCCategories.count) {
        
        YKRemoteControlCategory* rcc = [self.aryRCCategories objectAtIndex:indexPath.row];
        NSString* imgName = @"icon_add";
        CGRect rectImg = CGRectMake((cellSize.width-51)/2, (cellSize.height-35-51)/2, 51, 51);
        
        switch ([rcc.idNo intValue]) {
            case HAType_Add:{
                rectImg.origin.y = (cellSize.height-51)/2;
                break;
            }
            case HAType_AirConditioner:{
                imgName = @"icon_AirCondition";
                break;
            }
            case HAType_TV:{
                imgName = @"icon_TV";
                break;
            }
            case HAType_LanBox:{
                imgName = @"icon_NetworkBox";
                break;
            }
            case HAType_SetTopBox:{
                imgName = @"icon_STB";
                break;
            }
            default:
                break;
        }
        
        UIImageView* ivBG = [[UIImageView alloc] initWithFrame:rectImg];
        ivBG.image = [UIImage imageNamed:imgName];
        ivBG.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:ivBG];
        
        rectImg = CGRectMake(0, cellSize.height-35, cellSize.width, 20);
        UILabel *labContent = [[UILabel alloc] initWithFrame:rectImg];
        labContent.text = rcc.name;
        labContent.backgroundColor = [UIColor clearColor];
        labContent.textColor = RGB(100, 100, 100);
        labContent.textAlignment = NSTextAlignmentCenter;
        if (HAType_Add != [rcc.idNo intValue]) {
            [cell.contentView addSubview:labContent];
        }
        if (rcc.bSelect) {
            [cell.contentView addSubview:selectView];
        }
    }
    else if (1 == indexPath.section
             && indexPath.row < self.aryRCOrderTime.count){
        NSString* imgName = @"icon_add";
        CGRect rectImg = CGRectMake((cellSize.width-51)/2, (cellSize.height-51)/2, 51, 51);
        
        UIImageView* ivBG = [[UIImageView alloc] initWithFrame:rectImg];
        ivBG.image = [UIImage imageNamed:imgName];
        ivBG.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:ivBG];
    }
    
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
    //UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //cell.backgroundColor = [UIColor whiteColor];
    
    if ((0 == indexPath.section && indexPath.row < self.aryRCCategories.count)) {
        for (YKRemoteControlCategory* rcc in self.aryRCCategories) {
            rcc.bSelect = NO;
        }
        YKRemoteControlCategory* rcc = [self.aryRCCategories objectAtIndex:indexPath.row];
        if (HAType_Add == rcc.idNo.intValue) {
            RemoteControlViewController* vc = [RemoteControlViewController instantiateFromMainStoryboard];
            vc.rcCategoryID = [rcc.idNo intValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            rcc.bSelect = YES;
            NSArray *imageArray = @[[UIImage imageNamed:@"icon_search.png"],[UIImage imageNamed:@"icon_ShortcutKeys.png"],[UIImage imageNamed:@"icon_delete.png"]];
            YKButtonPopoverView *view = [[YKButtonPopoverView alloc] initWithTitleArray:@[@"查看",@"快捷键设置",@"删除"] imageArray:imageArray];
            [view setSelectIndexBlock:^(NSInteger selectIndex) {
                
            }];
            [view show];
        }
    }
    else if(1 == indexPath.section){
        
    }
    [collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    return YES;
}
@end
