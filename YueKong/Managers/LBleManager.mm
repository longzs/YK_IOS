//
//  LBleManager.m
//  YueKong
//
//  Created by zhoushaolong on 15/3/4.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "LBleManager.h"
#import "YMSCBPeripheral.h"
#import "DEACentralManager.h"

@interface LBleManager()

@property(nonatomic, strong)DEACentralManager* centralManager;

@property(nonatomic, strong)CBPeripheral*       currentPeripheral;

@property(nonatomic, strong)NSTimer* connectTimer;

@end

@implementation LBleManager

DEFINE_SINGLETON_FOR_CLASS(LBleManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)scanWithDelegate:(id)delegate{
    if (nil == _centralManager) {
        _centralManager = [DEACentralManager initSharedServiceWithDelegate:self];
    }
    // 查找， 成功了在找到合适得然后连接
    [_centralManager startScan];
}

-(void)stopScan{
    
    [_centralManager stopScan];
}

-(void)disConnectServer{
    
    [_centralManager.manager cancelPeripheralConnection:_currentPeripheral];
}

-(void)connectTimeout:(NSTimer*)timer{
    // 连接超时
    _connectTimer = nil;
    [_centralManager.manager cancelPeripheralConnection:_currentPeripheral];
}

-(void)stopConnectTimer{
    
    if ([_connectTimer isValid]) {
        [_connectTimer invalidate];
    }
    _connectTimer = nil;
}

#pragma mark - CBCentralManagerDelegate Methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            break;
            
        case CBCentralManagerStateUnauthorized:
        case CBCentralManagerStatePoweredOff:
        case CBCentralManagerStateUnsupported: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dang."
                                                            message:@"Unfortunately this device can not talk to Bluetooth Smart (Low Energy) Devices"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            
            [alert show];
            break;
        }
        case CBCentralManagerStateResetting: {
            //[self.peripheralsTableView reloadData];
            // 更新一下数据
            break;
        }
        case CBCentralManagerStateUnknown:
            NSLog(@"Bluetooth -- StateUnknown");
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    [self stopConnectTimer];
    
    NSLog(@"Did connect to peripheral: %@", peripheral);
    
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    
//    YMSCBPeripheral *yp = [_centralManager findPeripheral:peripheral];
//    yp.delegate = self;
//    [yp readRSSI];
    
//    for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
//        if (cell.yperipheral == yp) {
//            [cell updateDisplay];
//            break;
//        }
//    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"didDisconnectPeripheral: %@", peripheral);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    // 找到了服务
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    
    YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
    
    // 尝试连接
    _currentPeripheral = peripheral;
    [_centralManager.manager connectPeripheral:yp.cbPeripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
    //开一个定时器监控连接超时的情况
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(connectTimeout:) userInfo:peripheral repeats:NO];
    
//    if (yp.isRenderedInViewCell == NO) {
//        [self.peripheralsTableView reloadData];
//        yp.isRenderedInViewCell = YES;
//    }
//    
//    if (centralManager.isScanning) {
//        for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
//            if (cell.yperipheral.cbPeripheral == peripheral) {
//                if (peripheral.state == CBPeripheralStateDisconnected) {
//                    cell.rssiLabel.text = [NSString stringWithFormat:@"%d", [RSSI integerValue]];
//                    cell.peripheralStatusLabel.text = @"ADVERTISING";
//                    [cell.peripheralStatusLabel setTextColor:[[DEATheme sharedTheme] advertisingColor]];
//                } else {
//                    continue;
//                }
//            }
//        }
//    }
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    
    for (CBPeripheral *peripheral in peripherals) {
        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
        if (yp) {
            yp.delegate = self;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    
    for (CBPeripheral *peripheral in peripherals) {
        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
        if (yp) {
            yp.delegate = self;
        }
    }
}

#pragma mark - CBPeripheralDelegate Methods

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        
//        if ([self.delegate respondsToSelector:@selector(DidNotifyFailConnectService:withPeripheral:error:)])
//            [self.delegate DidNotifyFailConnectService:nil withPeripheral:nil error:nil];
        
        return;
    }
    
    for (CBService *service in peripheral.services)
    {
        NSLog(@"Discovered services for UUID %@", [service.UUID UUIDString]);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_YueKongYKQ_SERVICE]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
            
            break;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        
//        if ([self.delegate respondsToSelector:@selector(DidNotifyFailConnectChar:withPeripheral:error:)])
//            [self.delegate DidNotifyFailConnectChar:nil withPeripheral:nil error:nil];
        
        return;
    }
    
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
         NSLog(@"Discovered read characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_TRANS_TX]])
        {
//            _readCharacteristic = characteristic;//保存读的特征
//            
//            if ([self.delegate respondsToSelector:@selector(DidFoundReadChar:)])
//                [self.delegate DidFoundReadChar:characteristic];
//            
            continue;
        }
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_TRANS_RX]])
        {
            
//            NSLog(@"Discovered write characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
//            _writeCharacteristic = characteristic;//保存写的特征
//            
//            if ([self.delegate respondsToSelector:@selector(DidFoundWriteChar:)])
//                [self.delegate DidFoundWriteChar:characteristic];
//
        }
    }
    
//    if ([self.delegate respondsToSelector:@selector(DidFoundCharacteristic:withPeripheral:error:)])
//        [self.delegate DidFoundCharacteristic:nil withPeripheral:nil error:nil];
}

- (void)performUpdateRSSI:(NSArray *)args {
    CBPeripheral *peripheral = args[0];
    
    [peripheral readRSSI];
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error) {
        NSLog(@"ERROR: readRSSI failed, retrying. %@", error.description);
        
        if (peripheral.state == CBPeripheralStateConnected) {
            NSArray *args = @[peripheral];
            [self performSelector:@selector(performUpdateRSSI:) withObject:args afterDelay:2.0];
        }
        
        return;
    }
    
//    for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
//        if (cell.yperipheral) {
//            if (cell.yperipheral.isConnected) {
//                if (cell.yperipheral.cbPeripheral == peripheral) {
//                    cell.rssiLabel.text = [NSString stringWithFormat:@"%@", peripheral.RSSI];
//                    break;
//                }
//            }
//        }
//    }
    
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
    
    NSArray *args = @[peripheral];
    [self performSelector:@selector(performUpdateRSSI:) withObject:args afterDelay:yp.rssiPingPeriod];
}

@end
