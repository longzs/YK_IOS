//
//  LBleManager.m
//  YueKong
//
//  Created by zhoushaolong on 15/3/4.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "LBleManager.h"

@interface LBleManager()

@property(nonatomic, strong)NSTimer* connectTimer;

@property(nonatomic, strong)NSMutableArray* aryPeripherals;

@end

@implementation LBleManager

DEFINE_SINGLETON_FOR_CLASS(LBleManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aryPeripherals = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

-(void)scanWithDelegate:(id)delegate{
    if (nil == _centralManager) {
        dispatch_queue_t queue = dispatch_queue_create("ykBLe", nil);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
    }
    self.LBledelegate = delegate;
    
    if (self.isScaning) {
        [self stopScan];
    }
//    do {
//        
//    } while (self.isScaning);
    
    // 查找， 成功了在找到合适得然后连接
    [_centralManager scanForPeripheralsWithServices:nil
                                            options:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     @YES, CBCentralManagerScanOptionAllowDuplicatesKey,
                                                     @YES, CBCentralManagerOptionShowPowerAlertKey,nil]];
}

-(void)stopScan{
    
    [_centralManager stopScan];
    self.isScaning = NO;
}

-(void)connectServer{
    
    [_centralManager connectPeripheral:_currentPeripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
    //开一个定时器监控连接超时的情况
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(connectTimeout:) userInfo:_currentPeripheral repeats:NO];
}

-(void)disConnectServer{
    
    [_centralManager cancelPeripheralConnection:_currentPeripheral];
}

-(void)connectTimeout:(NSTimer*)timer{
    // 连接超时
    _connectTimer = nil;
    [_centralManager cancelPeripheralConnection:timer.userInfo];
}

-(void)stopConnectTimer{
    
    if ([_connectTimer isValid]) {
        [_connectTimer invalidate];
    }
    _connectTimer = nil;
}

//写数据
-(void)writeChar:(NSData *)data
{
    [self startSubscribe];
    const char* testChar = "testChar12345678";
    [_currentPeripheral writeValue:[NSData dataWithBytes:testChar length:strlen(testChar)] forCharacteristic:_currentCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

//监听设备
-(void)startSubscribe
{
    [_currentPeripheral setNotifyValue:YES forCharacteristic:_currentCharacteristic];
}

#pragma mark - CBCentralManagerDelegate Methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            break;
            
        case CBCentralManagerStateUnauthorized:
        case CBCentralManagerStatePoweredOff:
        case CBCentralManagerStateUnsupported: {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dang."
//                                                            message:@"Unfortunately this device can not talk to Bluetooth Smart (Low Energy) Devices"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Dismiss"
//                                                  otherButtonTitles:nil];
//            
//            [alert show];
            self.isScaning = NO;
            break;
        }
        case CBCentralManagerStateResetting: {
            //[self.peripheralsTableView reloadData];
            // 更新一下数据
            break;
        }
        case CBCentralManagerStateUnknown:
            NSLog(@"Bluetooth -- StateUnknown");
            self.isScaning = NO;
            break;
        default:
            break;
    }
    if (self.LBledelegate
        && [self.LBledelegate respondsToSelector:@selector(BLeState:)]) {
        [self.LBledelegate BLeState:central.state];
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
    
    [self stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    // 找到了服务
    
    //YMSCBPeripheral *yp = [_centralManager findPeripheral:peripheral];
    self.isScaning = YES;
    
    BOOL bHave = NO;
    for (CBPeripheral* per in self.aryPeripherals) {
        if ([per.name isEqualToString:peripheral.name]
            && [per.identifier isEqual:peripheral.identifier]) {
            bHave = YES;
            break;
        }
    }
    if (!bHave) {
        [self.aryPeripherals addObject:peripheral];
    }
    if ([peripheral.name isEqualToString:NAME_YueKongYKQ_Identifier]
        && [peripheral.identifier isEqual:UUIDSTR_ISSC_YueKongYKQ_Identifier]) {
        // 测试代码
        self.currentPeripheral = peripheral;
        [self stopScan];
    }
    
    // 尝试连接
    [self performSelector:@selector(connectServer) withObject:nil afterDelay:3];
    if (self.LBledelegate
        && [self.LBledelegate respondsToSelector:@selector(didDiscoverPeripheral:advertisementData:RSSI:)]) {
        
        [self.LBledelegate didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
}

//- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
//    DEACentralManager *centralManager = [DEACentralManager sharedService];
//    
//    for (CBPeripheral *peripheral in peripherals) {
//        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
//        if (yp) {
//            yp.delegate = self;
//        }
//    }
//}
//
//- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
//    DEACentralManager *centralManager = [DEACentralManager sharedService];
//    
//    for (CBPeripheral *peripheral in peripherals) {
//        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
//        if (yp) {
//            yp.delegate = self;
//        }
//    }
//}

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
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_YueKongYKQ_SERVICE]])
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
         NSLog(@"Discovered characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_TRANS_RW]])
        {
            
            NSLog(@"Discovered readwrite characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
            
            _currentCharacteristic = characteristic;//保存读的特征
//            
//            if ([self.delegate respondsToSelector:@selector(DidFoundReadChar:)])
//                [self.delegate DidFoundReadChar:characteristic];
//
            [self performSelector:@selector(writeChar:) withObject:nil afterDelay:3.5];
            break;
        }
    }
    
//    if ([self.delegate respondsToSelector:@selector(DidFoundCharacteristic:withPeripheral:error:)])
//        [self.delegate DidFoundCharacteristic:nil withPeripheral:nil error:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        
//        if ([_mainMenuDelegate respondsToSelector:@selector(DidNotifyReadError:)])
//            [_mainMenuDelegate DidNotifyReadError:error];
        
        return;
    }
    
//    [_recvData appendData:characteristic.value];
//    
//    
//    if ([_recvData length] >= 5)//已收到长度
//    {
//        unsigned charchar *buffer = (unsigned charchar *)[_recvData bytes];
//        int nLen = buffer[3]*256 + buffer[4];
//        if ([_recvData length] == (nLen+3+2+2))
//        {
//            //接收完毕，通知代理做事
//            if ([_mainMenuDelegate respondsToSelector:@selector(DidNotifyReadData)])
//                [_mainMenuDelegate DidNotifyReadData];
//            
//        }
//    }
    
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
