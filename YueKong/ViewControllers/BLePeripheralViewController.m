//
//  BLePeripheralViewController.m
//  YueKong
//
//  Created by zhoushaolong on 15/3/6.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "BLePeripheralViewController.h"
#import "UIImageView+PlayGIF.h"

@interface BLePeripheralViewController ()
@property(weak, nonatomic)IBOutlet UITableView* tabPeripheral;
@property(weak, nonatomic)IBOutlet UIView*      viewBLNotOpen;

@property (nonatomic, weak) IBOutlet UIImageView *imvBlueTooth;
@property (nonatomic, weak) IBOutlet UILabel *lblSearch;
@property (nonatomic, weak) IBOutlet UILabel *lblNoResult;
@property (nonatomic, weak) IBOutlet UIButton *btnResearch;

@property(weak, nonatomic)IBOutlet UIView*      viewFinishScan;
@end

@implementation BLePeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加新设备";
    self.tabPeripheral.hidden = YES;
    self.viewFinishScan.hidden = YES;
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"bluetooth.gif" ofType:nil];
    _imvBlueTooth.gifPath = gifPath;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if ([[LBleManager sharedInstance] bleEnable]) {
        [self startToSearch];
    }
    else{
        _lblNoResult.text = @"请打开手机的蓝牙开关完成搜索";
        _btnResearch.hidden = YES;
        _lblSearch.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[LBleManager sharedInstance] stopScan];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instantiateFromMainStoryboard
{
    BLePeripheralViewController* rc = [[BLePeripheralViewController alloc] initWithNibName:@"BLePeripheralViewController" bundle:nil];
    
    return rc;
}

#pragma mark - Method

-(void)didBecomeActive:(NSNotification*)ntf{
    
    if (![[LBleManager sharedInstance] bleEnable]
        || ![LBleManager sharedInstance].isScaning) {
        [self startToSearch];
    }
}

- (void)startToSearch
{
    [[LBleManager sharedInstance] scanWithDelegate:self];
    
    _imvBlueTooth.hidden = NO;
    _lblSearch.hidden = NO;
    _btnResearch.hidden = YES;
    _lblNoResult.hidden = YES;
    
    [_imvBlueTooth startGIF];
}

- (void)stopSearchWithResult:(BOOL)successFlag
{
    [_imvBlueTooth stopGIF];
    
    _imvBlueTooth.hidden = YES;
    _lblSearch.hidden = YES;
    if (successFlag) {
        _btnResearch.hidden = YES;
        _lblNoResult.hidden = YES;
        
        [self.viewFinishScan setHidden:NO];
    }
    else {
        
        _btnResearch.hidden = NO;
        _lblNoResult.hidden = NO;
        _lblNoResult.text = @"没有发现设备";
    }
    
    [[LBleManager sharedInstance] stopScan];
}

#pragma mark - Action
- (IBAction)clickResearch:(id)sender
{
    [self startToSearch];
}

- (IBAction)clickFinish:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- LBleProcessDelegate

-(void)BLeState:(CBCentralManagerState)state{
    if (CBCentralManagerStatePoweredOn == state
        || CBCentralManagerStateResetting == state) {
        if (![LBleManager sharedInstance].isScaning) {
            [self startToSearch];
        }
    }
    else{
        _lblNoResult.text = @"请打开手机的蓝牙开关完成搜索";
        _btnResearch.hidden = YES;
        _lblSearch.hidden = YES;
    }
}

-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    [self stopSearchWithResult:YES];
}

#pragma mark -- UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result;
    result = 40.0;
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SensorTagCellIdentifier = @"PeripheralCell";
    
//    DEACentralManager *centralManager = [DEACentralManager sharedService];
//    YMSCBPeripheral *yp = [centralManager peripheralAtIndex:indexPath.row];
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:SensorTagCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SensorTagCellIdentifier];
    }
    cell.textLabel.text = @"name";
    cell.detailTextLabel.text = @"server";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result = 2;
    return result;
}

@end
