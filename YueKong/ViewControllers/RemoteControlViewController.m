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

typedef enum stageType_{
    StageType_Category = 1,
    StageType_Brands ,
    StageType_City ,
    StageType_Bind,
    
    StageType_other = -1
}StageType;

@interface RemoteControlViewController ()<HTTP_MSG_RESPOND>

//ui
@property (nonatomic, weak) IBOutlet UILabel *lblStage;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

//目前走到了哪一步
@property (nonatomic) NSInteger currentStage;
@property (nonatomic, strong) NSArray *aryTest;

@property (nonatomic, strong)NSMutableArray* aryCategorys;
@property (nonatomic, strong)NSMutableArray* aryBrands;
@property (nonatomic, strong)NSMutableArray* aryCitys;

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
    
    [[HomeAppliancesManager sharedInstance] GetCategory:nil responseDelegate:self];
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

#pragma mark - Request & Process
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

#pragma mark - httpResponse
-(int)ReciveHttpMsg:(MsgSent*)ReciveMsg{
    
#if 0
    NSString *responseString = [[NSString alloc] initWithData:ReciveMsg.recData_ encoding:NSUTF8StringEncoding];
    NSLog(@"id = %d, httpRsp = %d\nReciveHttpMsg = \n%@,",  ReciveMsg.cmdCode_ , ReciveMsg.httpRsp_,responseString);
#endif
    
    switch (ReciveMsg.cmdCode_)
    {
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

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YKModel* ykm = nil;
    switch (_currentStage) {
        case StageType_Category:
        {
            if (indexPath.row < self.aryCategorys.count) {
                if (HAType_SetTopBox == _rcCategoryID) {
                    //
                }
                else{
                    ykm = [self.aryCategorys objectAtIndex:indexPath.row];
                    [[HomeAppliancesManager sharedInstance] GetBrand:[NSMutableDictionary dictionaryWithObject:((YKRemoteControlCategory*)ykm).idNo forKey:@"category_id"]
                                                responseDelegate:self];
                }
            }
            break;
        }
        case StageType_Brands:
        {
            if (indexPath.row < self.aryBrands.count) {
                ykm = [self.aryBrands objectAtIndex:indexPath.row];
            }
            break;
        }
        case StageType_City:
        {
            if (indexPath.row < self.aryCitys.count) {
                ykm = [self.aryCitys objectAtIndex:indexPath.row];
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
    
    _lblStage.text = [NSString stringWithFormat:@"第%d步",(int)_currentStage];
    [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3f];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
