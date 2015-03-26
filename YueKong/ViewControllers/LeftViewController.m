//
//  LeftViewController.m
//  YueKong
//
//  Created by zhoushaolong on 15/3/16.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftMenuTableViewCell.h"

@interface LeftViewController ()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imvHeader;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UITableView *tabList;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.imgBG removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    LeftViewController* rc = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    
    return rc;
}

#pragma mark - Actions
- (IBAction)clickOptionButton:(id)sender
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[UINib nibWithNibName:@"LeftMenuTableViewCell" bundle:nil] instantiateWithOwner:self options:nil] lastObject];
    }
    
    if (indexPath.row == 0) {
        cell.cellTitle = @"Chirs的悦控";
        cell.cellState = LeftMenuTableViewCellStateNomarl;
    }
    else if (indexPath.row == 1) {
        cell.cellTitle = @"Lion的客厅";
        cell.cellState = LeftMenuTableViewCellStateFull;
    }
    else if (indexPath.row == 2) {
        cell.cellTitle = @"Carina的房间";
        cell.cellState = LeftMenuTableViewCellStateFull;
        cell.cellDisable = YES;
    }
    else if (indexPath.row == 3) {
        cell.cellTitle = @"添加新设备";
        cell.cellState = LeftMenuTableViewCellStateAddNew;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
