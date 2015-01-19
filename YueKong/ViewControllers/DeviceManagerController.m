//
//  DeviceManagerController.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-19.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "DeviceManagerController.h"
#import "RemoteControlViewController.h"
#import "ViewController.h"
#import "HouseholdAppliancesCell.h"

@interface DeviceManagerController ()
@property(nonatomic, weak)IBOutlet UIButton *btnBind;
@property(nonatomic, weak)IBOutlet UILabel  *labBind;
@property(nonatomic, weak)IBOutlet UILabel  *labNoBindTip;
@property(nonatomic, weak)IBOutlet UICollectionView  *collectionDevices;

-(IBAction)clickShowBind:(id)sender;
@end

@implementation DeviceManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备管理";
    
    [self.collectionDevices registerClass:[HouseholdAppliancesCell class] forCellWithReuseIdentifier:@"HouseholdAppliancesCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (DeviceManagerController *)[Utils controllerInMainStroyboardWithID:@"DeviceManagerController"];
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


#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"HouseholdAppliancesCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    
    UILabel *labContent = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 50, 20)];
    labContent.text = [NSString stringWithFormat:@"%ld %ld", indexPath.section, indexPath.row];
    labContent.backgroundColor = [UIColor clearColor];
    labContent.textColor = [UIColor redColor];
    
    [cell.contentView addSubview:labContent];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/4.0, 80);
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
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
