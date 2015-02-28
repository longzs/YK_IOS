//
//  ReservationTypeSelectViewController.m
//  YueKong
//
//  Created by WangXun on 15/2/26.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "ReservationTypeSelectViewController.h"
#import "DeviceTypeViewCell.h"
#import "ReservationDetailViewController.h"

@interface ReservationTypeSelectViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ReservationTypeSelectViewController

#pragma mark - Basic
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的预约";
    [self.collectionView registerNib:[UINib nibWithNibName:@"DeviceTypeViewCell" bundle:nil] forCellWithReuseIdentifier:@"DeviceTypeViewCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (ReservationTypeSelectViewController *)[Utils controllerInMainStroyboardWithID:@"ReservationTypeSelectViewController"];
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self cellNumbersForDataCount:5];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"DeviceTypeViewCell";
    DeviceTypeViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = RGB(252, 252, 252);
    cell.deviceText = @"机顶盒";
    cell.deviceType = HAType_SetTopBox;
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
    ReservationDetailViewController *vc = [ReservationDetailViewController instantiateFromMainStoryboard];
    if (indexPath.row < self.aryReservationMAppType.count) {
        vc.currentSchedue = self.aryReservationMAppType[indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
