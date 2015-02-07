//
//  RemoteControlViewController.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-19.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "RemoteControlViewController.h"
#import "DeviceSelectCollectionCell.h"

@interface RemoteControlViewController ()

//ui
@property (nonatomic, weak) IBOutlet UILabel *lblStage;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

//目前走到了哪一步
@property (nonatomic) NSInteger currentStage;
@property (nonatomic, strong) NSArray *aryTest;


@end

@implementation RemoteControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"遥控器配置";
    
    _aryTest = @[@[@"空调",@"电视机",@"机顶盒",@"冰箱"],
                 @[@"小米",@"创维",@"小米",@"索尼",@"松下",@"夏普"],
                 @[@"上海",@"北京",@"杭州",@"南京",@"无锡",@"天津"]];
    
    [self.collectionView registerClass:[DeviceSelectCollectionCell class] forCellWithReuseIdentifier:@"DeviceSelectCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DeviceSelectCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"DeviceSelectCollectionCell"];
    
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

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_aryTest[_currentStage] count];
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
    
    cell.textOfCell = [_aryTest[_currentStage] objectAtIndex:indexPath.row];
    
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
    self.currentStage += 1;
    
    if (self.currentStage > 2) {
        self.currentStage = 2;
    }
    else {
        _lblStage.text = [NSString stringWithFormat:@"第%d步",(int)_currentStage+1];
        [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3f];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
