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
    StageType_City ,
    StageType_Bind,
    
    StageType_other = -1
}StageType;

@interface RemoteControlViewController ()<HTTP_MSG_RESPOND>

//ui
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *ivStudy;

//目前走到了哪一步
@property (nonatomic) NSInteger currentStage;
@property (nonatomic, strong) NSArray *aryTest;

@property (nonatomic, strong)NSMutableArray* aryCategorys;
@property (nonatomic, strong)NSMutableArray* aryBrands;
@property (nonatomic, strong)NSMutableArray* aryCitys;

@property (nonatomic, strong)NSMutableArray* aryStudyImgaes;

@property (nonatomic, strong) IBOutlet UIImageView *imvFirst;
@property (nonatomic, strong) IBOutlet UIImageView *imvSecond;
@property (nonatomic, strong) IBOutlet UIImageView *imvThrid;
@property (nonatomic, strong) NSMutableArray *aryImages;

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
    
    _currentStage = StageType_Category;
    self.aryCategorys = [NSMutableArray arrayWithCapacity:0];
    self.aryBrands = [NSMutableArray arrayWithCapacity:0];
    self.aryCitys = [NSMutableArray arrayWithCapacity:0];
    self.aryStudyImgaes = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i <=13; ++i) {
        [self.aryStudyImgaes addObject:[NSString stringWithFormat:@"step%02d", i]];
    }
    
    [[HomeAppliancesManager sharedInstance] GetCategory:nil responseDelegate:self];
    
    
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

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (nil == _ivStudy) {
        _ivStudy  = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_ivStudy];
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
    self.timerAnimation = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timeFired:) userInfo:nil repeats:YES];
}

- (void)timeFired:(NSTimer *)timer
{
    
    //第一步
    if (_imvFirst.image != _aryImages[0][10]) {
        NSInteger index = [_aryImages[0] indexOfObject:_imvFirst.image];
        _imvFirst.image = _aryImages[0][index+1];
        if (_imvSecond.image == _aryImages[1][0]) {
            _imvSecond.image = _aryImages[1][1];
        }
    }
    //第二步
    else if (_imvSecond.image != _aryImages[1][11]) {
        NSInteger index = [_aryImages[1] indexOfObject:_imvSecond.image];
        _imvSecond.image = _aryImages[1][index+1];
        if (index == 8) {
            _imvThrid.image = _aryImages[2][1];
        }
    }
    
    //第三步
    else if (_imvThrid.image != _aryImages[2][13]) {
        NSInteger index = [_aryImages[2] indexOfObject:_imvThrid.image];
        _imvThrid.image = _aryImages[2][index+1];
    }
    
    //结束
    else {
        [timer invalidate];
    }
}

#pragma mark - clickEvents
-(IBAction)clickCategory:(id)sender{
    _collectionView.hidden = NO;
    _ivStudy.hidden = YES;
    
    _currentStage = StageType_Category;
    [self.collectionView reloadData];
    
    [self showAnimation];
}

-(IBAction)clickBrandOrCity:(id)sender{
    _collectionView.hidden = NO;
    _ivStudy.hidden = YES;
    
    if (0 == self.aryCategorys.count) {
        return;
    }
    
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
            //[self processGetCategorys:ReciveMsg];
            break;
        }
        case CC_GetCitesByProvinces:
        {
            //[self processGetCategorys:ReciveMsg];
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
        {
            ret = self.aryCitys.count;
            break;
        }
        case StageType_Bind:
        {
            break;
        }
        default:
            break;
    }
    if (0 != ret%4) {
        ret = (ret/4 + 1)*4;
    }
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
    cell.backgroundColor = [UIColor clearColor];
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
        {
            if (indexPath.row < self.aryCitys.count) {
                ykm = [self.aryCitys objectAtIndex:indexPath.row];
                 cell.textOfCell = ((YKCityModel*)ykm).name;
            }
            break;
        }
        case StageType_Bind:
        {
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
                if (HAType_SetTopBox == _rcCategoryID) {
                    
                    [[HomeAppliancesManager sharedInstance] GetCityCovered:nil responseDelegate:self];
                    
                    _currentStage = StageType_City;
                }
                else{
                    
                    
                    [[HomeAppliancesManager sharedInstance] GetBrand:[NSMutableDictionary dictionaryWithObject:((YKRemoteControlCategory*)ykm).idNo forKey:@"category_id"]
                                                responseDelegate:self];
                    _currentStage = StageType_Brands;
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
                _currentStage = StageType_Bind;
            }
            break;
        }
        case StageType_Bind:
        {
            break;
        }
        default:
            break;
    }
    if (StageType_Bind == _currentStage) {
        [self performSelector:@selector(showStudyImage) withObject:nil afterDelay:.1f];
    }
    else{
        [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3f];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
