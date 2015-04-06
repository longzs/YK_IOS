//
//  RemoteControlViewController.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-19.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "RemoteControlViewController.h"
#import "DeviceSelectCollectionCell.h"
#import "HomeAppliancesManager.h"
#import "ConfigFinishViewController.h"

typedef enum stageType_{
    StageType_Category = 1,
    StageType_Brands ,
    StageType_City ,            // 热点城市
    StageType_CityProvince ,    // 省会
    StageType_CityByProvince ,
    StageType_Bind,
    StageType_DownLoadIndex,
    
    StageType_other = -1
}StageType;

@interface RemoteControlViewController ()<HTTP_MSG_RESPOND,
UIGestureRecognizerDelegate>

//ui
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *ivStudy;

//目前走到了哪一步
@property (nonatomic) NSInteger currentStage;
@property (nonatomic, strong) NSArray *aryTest;

@property (nonatomic, strong)NSMutableArray* aryCategorys;
@property (nonatomic, strong)NSMutableArray* aryBrands;
@property (nonatomic, strong)NSMutableArray* aryCitys;
@property (nonatomic, strong)NSMutableArray* aryRemoteIndex;

@property (nonatomic, strong)NSMutableArray* aryStudyImgaes;

@property (nonatomic, weak) IBOutlet UIImageView *imvFirst;
@property (nonatomic, weak) IBOutlet UIImageView *imvSecond;
@property (nonatomic, weak) IBOutlet UIImageView *imvThrid;
@property (nonatomic, strong) NSMutableArray *aryImages;

@property (nonatomic, weak) IBOutlet UIButton *btnStageFirst;
@property (nonatomic, weak) IBOutlet UIButton *btnStageSecond;
@property (nonatomic, weak) IBOutlet UIButton *btnStageThird;

@property (nonatomic, strong)NSTimer*       timerAnimation;

-(IBAction)clickCategory:(id)sender;
-(IBAction)clickBrandOrCity:(id)sender;
-(IBAction)clickBind:(id)sender;
@end

@implementation RemoteControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"遥控器配置";

//    _aryTest = @[@[@"空调",@"电视机",@"机顶盒",@"冰箱"],
//                 @[@"小米",@"创维",@"小米",@"索尼",@"松下",@"夏普"],
//                 @[@"上海",@"北京",@"杭州",@"南京",@"无锡",@"天津"]];
    
    [self.collectionView registerClass:[DeviceSelectCollectionCell class] forCellWithReuseIdentifier:@"DeviceSelectCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DeviceSelectCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"DeviceSelectCollectionCell"];
    
    _currentStage = StageType_other;
    self.aryCategorys = [NSMutableArray arrayWithCapacity:0];
    self.aryBrands = [NSMutableArray arrayWithCapacity:0];
    self.aryCitys = [NSMutableArray arrayWithCapacity:0];
    self.aryRemoteIndex = [NSMutableArray arrayWithCapacity:0];
    
//    self.aryStudyImgaes = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 1; i <=13; ++i) {
//        [self.aryStudyImgaes addObject:[NSString stringWithFormat:@"step%02d", i]];
//    }
    
    NSMutableArray *firstArray = [NSMutableArray array];
    for (int i = 0; i < 11; i++) {
        NSString *aName = [NSString stringWithFormat:@"01_%02d",i+1];
        UIImage *aImage = [UIImage imageNamed:aName];
        if (aImage) {
            [firstArray addObject:aImage];
        }
    }
    
    NSMutableArray *secondArray = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        NSString *aName = [NSString stringWithFormat:@"02_%02d",i+1];
        UIImage *aImage = [UIImage imageNamed:aName];
        if (aImage) {
            [secondArray addObject:aImage];
        }
    }
    
    NSMutableArray *thirdArray = [NSMutableArray array];
    for (int i = 0; i < 14; i++) {
        NSString *aName = [NSString stringWithFormat:@"03_%02d",i+1];
        UIImage *aImage = [UIImage imageNamed:aName];
        if (aImage) {
            [thirdArray addObject:aImage];
        }
    }
    
    _aryImages = [[NSMutableArray alloc] init];
    [_aryImages addObject:firstArray];
    [_aryImages addObject:secondArray];
    [_aryImages addObject:thirdArray];
    
    _imvFirst.image = _aryImages[0][0];
    _imvSecond.image = _aryImages[1][0];
    _imvThrid.image = _aryImages[2][0];

    _btnStageFirst.enabled = YES;
    _btnStageSecond.enabled = NO;
    _btnStageThird.enabled = NO;
    
    [self showLoadingWithTip:@"正在请求数据。。"];
    [[HomeAppliancesManager sharedInstance] GetCategory:nil responseDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (nil == _ivStudy) {
        _ivStudy  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _ivStudy.userInteractionEnabled = YES;
        [self.view addSubview:_ivStudy];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStudyIv:)];
        [_ivStudy addGestureRecognizer:tap];
    }
    if (StageType_Bind ==  _currentStage) {
        _ivStudy.hidden = NO;
    }
    else{
        _ivStudy.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _ivStudy.frame = _collectionView.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    RemoteControlViewController* rc = [[RemoteControlViewController alloc] initWithNibName:@"RemoteControlViewController" bundle:nil];
    
    return rc;
}

-(void)showStudyImage{
    _collectionView.hidden = YES;
    _ivStudy.hidden = NO;
    _ivStudy.image = [UIImage imageNamed:_aryStudyImgaes[0]];
}

- (void)showAnimation
{
    if (self.timerAnimation) {
        [self.timerAnimation invalidate];
        self.timerAnimation = nil;
    }
    switch (_currentStage) {
        case StageType_Category:{
            self.timerAnimation = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timeFiredFirst:) userInfo:nil repeats:YES];
        }
            break;
        case StageType_City:
        case StageType_Brands:{
            self.timerAnimation = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timeFiredSecond:) userInfo:nil repeats:YES];
        }
            break;
        case StageType_Bind:{
            self.timerAnimation = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timeFiredThird:) userInfo:nil repeats:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)timeFiredFirst:(NSTimer *)timer
{
    //第一步
    if (_imvFirst.image != _aryImages[0][10]
        && StageType_Category == _currentStage) {
        NSInteger index = [_aryImages[0] indexOfObject:_imvFirst.image];
        _imvFirst.image = _aryImages[0][index+1];
    }
    //结束
    else {
        if (_imvSecond.image == _aryImages[1][0]) {
            _imvSecond.image = _aryImages[1][1];
            _btnStageFirst.selected = YES;
            _btnStageSecond.enabled = YES;
        }
        [timer invalidate];
    }
}

- (void)timeFiredSecond:(NSTimer *)timer
{
    
    //第二步
    if (_imvSecond.image != _aryImages[1][11]
        && (StageType_Brands == _currentStage || StageType_City == _currentStage)) {
        NSInteger index = [_aryImages[1] indexOfObject:_imvSecond.image];
        _imvSecond.image = _aryImages[1][index+1];
        if (index == 8) {
            _imvThrid.image = _aryImages[2][1];
            _btnStageSecond.selected = YES;
            _btnStageThird.enabled = YES;
        }
    }
    //结束
    else {
        [timer invalidate];
    }
}
- (void)timeFiredThird:(NSTimer *)timer
{
    //第三步
    if (_imvThrid.image != _aryImages[2][13]) {
        NSInteger index = [_aryImages[2] indexOfObject:_imvThrid.image];
        _imvThrid.image = _aryImages[2][index+1];
    }
    //结束
    else {
        _btnStageThird.selected = YES;
        [timer invalidate];
        
        ConfigFinishViewController* vc = [ConfigFinishViewController instantiateFromMainStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - clickEvents
-(void)tapStudyIv:(UITapGestureRecognizer*)recognizer{
    static int iTapCount = 1;
    if (iTapCount < 7) {
        [UIView animateWithDuration:0.3 animations:^(){
            _ivStudy.image = [UIImage imageNamed:[_aryStudyImgaes objectAtIndex:iTapCount]];
        }];
    }
    iTapCount ++;
    if (7 == iTapCount) {
        _currentStage = StageType_Bind;
        [_btnStageThird setTitle:@"配置成功" forState:UIControlStateNormal];
        [self showAnimation];
    }
}

-(IBAction)clickCategory:(id)sender{
    _collectionView.hidden = NO;
    _ivStudy.hidden = YES;
    
    _currentStage = StageType_Category;
    [self.collectionView reloadData];
    
}

-(IBAction)clickBrandOrCity:(id)sender{
    _collectionView.hidden = NO;
    _ivStudy.hidden = YES;
    
    if (0 == self.aryCategorys.count) {
        return;
    }
    [self.aryRemoteIndex removeAllObjects];
    if (HAType_SetTopBox == _rcCategoryID) {
        
        //[[HomeAppliancesManager sharedInstance] GetCityCovered:nil responseDelegate:self];
        _currentStage = StageType_City;
    }
    else{
        
//        [[HomeAppliancesManager sharedInstance] GetBrand:[NSMutableDictionary dictionaryWithObject:((YKRemoteControlCategory*)ykm).idNo forKey:@"category_id"]
//                                        responseDelegate:self];
        _currentStage = StageType_Brands;
    }
    [self.collectionView reloadData];
}

-(IBAction)clickBind:(id)sender{
    if (0 == self.aryCategorys.count
        &&( 0== self.aryBrands.count
           || 0 == self.aryCitys.count)){
        return;
    }
    ConfigFinishViewController* vc = [ConfigFinishViewController instantiateFromMainStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Request & Process
-(void)processGetCategorys:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSArray *jsonDataAry = [reciveData responsdData];
        if (0 < jsonDataAry.count) {
            [self.aryCategorys removeAllObjects];
        }
        if ([jsonDataAry isKindOfClass:[NSArray class]]
            && jsonDataAry.count) {
            
            for (NSDictionary* jsonData in jsonDataAry) {
                
                YKRemoteControlCategory *dm = [[YKRemoteControlCategory alloc] init];
                dm.name = jsonData[@"name"];
                dm.status = [NSString stringWithFormat:@"%d", [jsonData[@"status"] intValue]];
                dm.idNo = [NSString stringWithFormat:@"%d", [jsonData[@"id"] intValue]];
                dm.create_time = jsonData[@"create_time"];
                
                [self.aryCategorys addObject:dm];
            }
            _currentStage = StageType_Category;
            [self showAnimation];
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
    [self.collectionView reloadData];
}

-(void)processGetBrands:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSArray *jsonDataAry = [reciveData responsdData];
        if (0 < jsonDataAry.count) {
            [self.aryBrands removeAllObjects];
        }
        if ([jsonDataAry isKindOfClass:[NSArray class]]
            && jsonDataAry.count) {
            
            for (NSDictionary* jsonData in jsonDataAry) {
                
                YKRemoteControlBrand *dm = [[YKRemoteControlBrand alloc] init];
                dm.name = jsonData[@"name"];
                dm.category_name = jsonData[@"category_name"];
                dm.status = [NSString stringWithFormat:@"%d", [jsonData[@"status"] intValue]];
                dm.idNo = [NSString stringWithFormat:@"%d", [jsonData[@"id"] intValue]];
                dm.category_id = [NSString stringWithFormat:@"%d", [jsonData[@"category_id"] intValue]];
                dm.create_time = jsonData[@"create_time"];
                
                [self.aryBrands addObject:dm];
            }
            _currentStage = StageType_Brands;
            [self showAnimation];
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
    [self.collectionView reloadData];
}

-(void)processCitesCovered:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSArray *jsonDataAry = [reciveData responsdData];
        if (0 < jsonDataAry.count) {
            [self.aryCitys removeAllObjects];
        }
        if ([jsonDataAry isKindOfClass:[NSArray class]]
            && jsonDataAry.count) {
            
            for (NSDictionary* jsonData in jsonDataAry) {
                
                YKCityModel *dm = [[YKCityModel alloc] init];
                dm.name = jsonData[@"name"];
                dm.idNo = [NSString stringWithFormat:@"%d", [jsonData[@"id"] intValue]];
                dm.code = jsonData[@"code"];
                dm.latitide = [NSString stringWithFormat:@"%f", [jsonData[@"latitide"] doubleValue]];
                dm.longitude = [NSString stringWithFormat:@"%f", [jsonData[@"longitude"] doubleValue]];
                [self.aryCitys addObject:dm];
            }
            YKCityModel *otherCity = [[YKCityModel alloc] init];
            otherCity.name = @"其它城市";
            otherCity.idNo = kOtherCityName;
            [self.aryCitys addObject:otherCity];
            
            _currentStage = StageType_City;
            [self showAnimation];
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
    [self.collectionView reloadData];
}

-(void)processCityProvinces:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSArray *jsonDataAry = [reciveData responsdData];
        if (0 < jsonDataAry.count) {
            [self.aryCitys removeAllObjects];
        }
        if ([jsonDataAry isKindOfClass:[NSArray class]]
            && jsonDataAry.count) {
            
            for (NSDictionary* jsonData in jsonDataAry) {
                
                YKCityModel *dm = [[YKCityModel alloc] init];
                dm.name = jsonData[@"name"];
                dm.idNo = [NSString stringWithFormat:@"%d", [jsonData[@"id"] intValue]];
                dm.code = jsonData[@"code"];
                dm.latitide = [NSString stringWithFormat:@"%f", [jsonData[@"latitide"] doubleValue]];
                dm.longitude = [NSString stringWithFormat:@"%f", [jsonData[@"longitude"] doubleValue]];
                [self.aryCitys addObject:dm];
            }
            _currentStage = StageType_CityProvince;
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
    [self.collectionView reloadData];
}

-(void)processCitesByProvinces:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSArray *jsonDataAry = [reciveData responsdData];
        if (0 < jsonDataAry.count) {
            [self.aryCitys removeAllObjects];
        }
        if ([jsonDataAry isKindOfClass:[NSArray class]]
            && jsonDataAry.count) {
            
            for (NSDictionary* jsonData in jsonDataAry) {
                
                YKCityModel *dm = [[YKCityModel alloc] init];
                dm.name = jsonData[@"name"];
                dm.idNo = [NSString stringWithFormat:@"%d", [jsonData[@"id"] intValue]];
                dm.code = jsonData[@"code"];
                dm.latitide = [NSString stringWithFormat:@"%f", [jsonData[@"latitide"] doubleValue]];
                dm.longitude = [NSString stringWithFormat:@"%f", [jsonData[@"longitude"] doubleValue]];
                [self.aryCitys addObject:dm];
            }
            
            _currentStage = StageType_CityByProvince;
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
    [self.collectionView reloadData];
}

-(void)processList_remote_indexes:(MsgSent*)reciveData{
    
    if ([reciveData isRequestSuccess])
    {
        NSArray *jsonDataAry = [reciveData responsdData];
        if (0 < jsonDataAry.count) {
            [self.aryRemoteIndex removeAllObjects];
        }
        if ([jsonDataAry isKindOfClass:[NSArray class]]
            && jsonDataAry.count) {
            
            for (NSDictionary* jsonData in jsonDataAry) {
                
                ykRemoteControlIndex *dm = [[ykRemoteControlIndex alloc] init];
                dm.idNo = [jsonData[@"id"] intValue];
                dm.category_id = [jsonData[@"category_id"] intValue];
                dm.brand_id = [jsonData[@"brand_id"] intValue];
                dm.city_code = jsonData[@"city_code"];
                dm.operator_id = [jsonData[@"operator_id"] intValue];
                
                dm.category_name = jsonData[@"category_name"];
                dm.brand_name = jsonData[@"brand_name"];
                dm.city_name = jsonData[@"city_name"];
                dm.operator_name = jsonData[@"operator_name"];
                
                dm.protocol = jsonData[@"protocol"];
                dm.remote = jsonData[@"remote"];
                dm.remote_map = jsonData[@"remote_map"];
                
                dm.status = [jsonData[@"status"] intValue];
                [self.aryRemoteIndex addObject:dm];
            }
            _currentStage = StageType_DownLoadIndex;
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
    [self.collectionView reloadData];
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
        case CC_GetCategory:
        {
            [self processGetCategorys:ReciveMsg];
            break;
        }
        case CC_GetBrand:
        {
            [self processGetBrands:ReciveMsg];
            break;
        }
        case CC_GetCitesCovered:
        {
            [self processCitesCovered:ReciveMsg];
            break;
        }
        case CC_GetCityProvinces:
        {
            [self processCityProvinces:ReciveMsg];
            break;
        }
        case CC_GetCitesByProvinces:
        {
            [self processCitesByProvinces:ReciveMsg];
            break;
        }
        case CC_list_remote_indexes:
        {
            [self processList_remote_indexes:ReciveMsg];
            break;
        }
        default:
            
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
    NSInteger ret = 0;
    switch (_currentStage) {
        case StageType_Category:
        {
            ret = self.aryCategorys.count;
            break;
        }
        case StageType_Brands:
        {
            ret = self.aryBrands.count;
            break;
        }
        case StageType_City:
        case StageType_CityProvince:
        case StageType_CityByProvince:
        {
            ret = self.aryCitys.count;
            break;
        }
        case StageType_Bind:
        case StageType_DownLoadIndex:
        {
            ret = self.aryRemoteIndex.count;
            break;
        }
        default:
            break;
    }
    ret = [self cellNumbersForDataCount:ret];
    return ret;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"DeviceSelectCollectionCell";
    DeviceSelectCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = RGB(252, 252, 252);;
    cell.textOfCell = nil;
    YKModel* ykm = nil;
    switch (_currentStage) {
        case StageType_Category:
        {
            if (indexPath.row < self.aryCategorys.count) {
                ykm = [self.aryCategorys objectAtIndex:indexPath.row];
                cell.textOfCell = ((YKRemoteControlCategory*)ykm).name;
            }
            break;
        }
        case StageType_Brands:
        {
            if (indexPath.row < self.aryBrands.count) {
                ykm = [self.aryBrands objectAtIndex:indexPath.row];
                 cell.textOfCell = ((YKRemoteControlBrand*)ykm).name;
            }
            break;
        }
        case StageType_City:
        case StageType_CityProvince:
        case StageType_CityByProvince:
        {
            if (indexPath.row < self.aryCitys.count) {
                ykm = [self.aryCitys objectAtIndex:indexPath.row];
                 cell.textOfCell = ((YKCityModel*)ykm).name;
            }
            break;
        }
        case StageType_Bind:
        case StageType_DownLoadIndex:
        {
            if (indexPath.row < self.aryRemoteIndex.count) {
                ykm = [self.aryRemoteIndex objectAtIndex:indexPath.row];
                ykRemoteControlIndex* yrci = (ykRemoteControlIndex*)ykm;
                if (HAType_AirConditioner == yrci.category_id
                    || HAType_TV == yrci.category_id) {
                    cell.textOfCell = [NSString stringWithFormat:@"%@_%@", yrci.brand_name, yrci.remote];
                }
                else if (HAType_SetTopBox == yrci.category_id){
                    cell.textOfCell = [NSString stringWithFormat:@"%@_%@", yrci.city_name,yrci.remote];
                }
                else{
                    cell.textOfCell = [NSString stringWithFormat:@"%@_%d", yrci.category_name,yrci.category_id];
                }
            }
            break;
        }
        default:
            break;
    }
    cell.showSelected = ykm.bSelect;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width/4.0, 100);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

-(void)setSelectToNO:(NSArray*)setArray{
    for (YKModel* ykm in setArray) {
        ykm.bSelect = NO;
    }
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YKModel* ykm = nil;
    switch (_currentStage) {
        case StageType_Category:
        {
            if (indexPath.row < self.aryCategorys.count) {
                [self setSelectToNO:self.aryCategorys];
                ykm = [self.aryCategorys objectAtIndex:indexPath.row];
                ykm.bSelect = YES;
                _rcCategoryID = ((YKRemoteControlCategory*)ykm).idNo.intValue;
                [_btnStageFirst setTitle:((YKRemoteControlCategory*)ykm).name forState:UIControlStateNormal];
                if (HAType_SetTopBox == _rcCategoryID) {
                    
                    [[HomeAppliancesManager sharedInstance] GetCityCovered:nil responseDelegate:self];
                }
                else{
                    
                    
                    [[HomeAppliancesManager sharedInstance] GetBrand:[NSMutableDictionary dictionaryWithObject:((YKRemoteControlCategory*)ykm).idNo forKey:@"category_id"]
                                                responseDelegate:self];
                }
            }
            break;
        }
        case StageType_Brands:
        {
            if (indexPath.row < self.aryBrands.count) {
                [self setSelectToNO:self.aryBrands];
                ykm = [self.aryBrands objectAtIndex:indexPath.row];
                 ykm.bSelect = YES;
                [_btnStageSecond setTitle:((YKRemoteControlBrand*)ykm).name forState:UIControlStateNormal];
                self.selectBrandID = ((YKRemoteControlBrand*)ykm).idNo;
                _currentStage = StageType_Bind;
            }
            
            break;
        }
        case StageType_City:
        {
            if (indexPath.row < self.aryCitys.count) {
                [self setSelectToNO:self.aryCitys];
                ykm = [self.aryCitys objectAtIndex:indexPath.row];
                 ykm.bSelect = YES;
                
                if ([((YKCityModel*)ykm).idNo isEqualToString:kOtherCityName]) {
                    [[HomeAppliancesManager sharedInstance] GetCityProvinces:nil responseDelegate:self];
                }
                else{
                    [_btnStageSecond setTitle:((YKCityModel*)ykm).name forState:UIControlStateNormal];
                    self.selectCityID = ((YKCityModel*)ykm).idNo;
                    _currentStage = StageType_Bind;
                }
            }
            break;
        }
        case StageType_CityProvince:{
            if (indexPath.row < self.aryCitys.count) {
                [self setSelectToNO:self.aryCitys];
                ykm = [self.aryCitys objectAtIndex:indexPath.row];
                ykm.bSelect = YES;
                if (2 < [((YKCityModel*)ykm).code length]) {
                    NSString* provinceCode = [((YKCityModel*)ykm).code substringToIndex:2];
                    [[HomeAppliancesManager sharedInstance] GetCity:[NSMutableDictionary dictionaryWithObject:provinceCode forKey:@"province_prefix"]
                                                            responseDelegate:self];
                }
            }
            break;
        }
        case StageType_CityByProvince:{
            if (indexPath.row < self.aryCitys.count) {
                [self setSelectToNO:self.aryCitys];
                ykm = [self.aryCitys objectAtIndex:indexPath.row];
                ykm.bSelect = YES;
               
                [_btnStageSecond setTitle:((YKCityModel*)ykm).name forState:UIControlStateNormal];
                self.selectCityID = ((YKCityModel*)ykm).idNo;
                _currentStage = StageType_Bind;
            }
            break;
        }
        case StageType_Bind:
        {
            
            break;
        }
        case StageType_DownLoadIndex:
        {
            if (indexPath.row < self.aryRemoteIndex.count) {
                [self setSelectToNO:self.aryRemoteIndex];
                ykm = [self.aryRemoteIndex objectAtIndex:indexPath.row];
                ykm.bSelect = YES;
                _currentStage = StageType_DownLoadIndex;
                
                NSMutableDictionary *dicBody = [[NSMutableDictionary alloc] initWithCapacity:0];
                dicBody[@"protocol"] = RPLACE_EMPTY_STRING(((ykRemoteControlIndex*)ykm).protocol);
                dicBody[@"remote"] = RPLACE_EMPTY_STRING(((ykRemoteControlIndex*)ykm).remote);
                [[HomeAppliancesManager sharedInstance] DownloadRemoteBinFile:dicBody responseDelegate:self];
            }
            break;
        }
        default:
            break;
    }
    if (StageType_Bind == _currentStage) {
        //[self performSelector:@selector(showStudyImage) withObject:nil afterDelay:.1f];
        
        NSMutableDictionary *dicBody = [[NSMutableDictionary alloc] initWithCapacity:0];
        dicBody[@"category_id"] = [NSString stringWithFormat:@"%d", _rcCategoryID];
        dicBody[@"brand_id"] = RPLACE_EMPTY_STRING(self.selectBrandID);
        dicBody[@"city_code"] = RPLACE_EMPTY_STRING(self.selectCityID);
        [[HomeAppliancesManager sharedInstance] List_remote_indexes:dicBody responseDelegate:self];
    }
    else
    {[self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3f];}
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
