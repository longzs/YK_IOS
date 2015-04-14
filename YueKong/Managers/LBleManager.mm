//
//  LBleManager.m
//  YueKong
//
//  Created by zhoushaolong on 15/3/4.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "LBleManager.h"

typedef enum ykBLETransState{
    TransState_NotStart,
    
    TransState_Start,
    
    TransState_Over     // 结束
    
}YKBLETRANSSTATE;

@implementation ykBlePacketObject

@end

@implementation ykResBlePacketObject

@end

@interface LBleManager()

@property(nonatomic, strong)NSTimer* connectTimer;

@property(nonatomic, strong)NSMutableArray* aryPeripherals;

// 传输控制
@property(nonatomic, assign)YKBLETRANSSTATE         transState;
@property(nonatomic, assign)int                     indexSend;
@property(nonatomic, assign)NSUInteger              fragmentsSend;     // 发送的分片数
@property(nonatomic, strong)NSData*                 currentDataSend;
@property(nonatomic, strong)NSTimer*                timerSend;

@end

@implementation LBleManager

DEFINE_SINGLETON_FOR_CLASS(LBleManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aryPeripherals = [NSMutableArray arrayWithCapacity:0];
        [self reSetTransStatus];
        
        dispatch_queue_t queue = dispatch_queue_create("ykBLe", nil);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
    }
    return self;
}

+(BOOL)isSameBLEPeripheral:(CBPeripheral*)p1 Peripheral2:(CBPeripheral*)p2{
    return [p1.name isEqualToString:p2.name]
    && [p1.identifier isEqual:p2.identifier];
}

-(void)reSetTransStatus{
    _transState = TransState_NotStart;
    _indexSend = -1;
    _fragmentsSend = 0;
    self.currentDataSend = nil;
}

-(void)scanWithDelegate:(id)delegate{
    if (nil == _centralManager) {
        dispatch_queue_t queue = dispatch_queue_create("ykBLe", nil);
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
    }
    self.LBledelegate = delegate;
    
//    if (self.isScaning) {
//        [self stopScan];
//    }
//    do {
//        
//    } while (self.isScaning);
    
    // 查找， 成功了在找到合适得然后连接
    self.isScaning = YES;
    [_centralManager scanForPeripheralsWithServices:nil
                                            options:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     @YES, CBCentralManagerScanOptionAllowDuplicatesKey,
                                                     @YES, CBCentralManagerOptionShowPowerAlertKey,nil]];
}

-(void)stopScan{
    
    if (!self.isScaning) {
        return;
    }
    [_centralManager stopScan];
    self.isScaning = NO;
    
    if (self.currentPeripheral) {
        [self disConnectServer];
    }
}

-(BOOL)connectServer{
    if (nil == self.currentPeripheral) {
        return NO;
    }
    [_centralManager connectPeripheral:self.currentPeripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
    //开一个定时器监控连接超时的情况
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(connectTimeout:) userInfo:nil repeats:NO];
    return YES;
}

-(void)disConnectServer{
    
    [_centralManager cancelPeripheralConnection:self.currentPeripheral];
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

-(BOOL)bleEnable{
    
    return (CBCentralManagerStatePoweredOn == self.centralManager.state
            || CBCentralManagerStateResetting == self.centralManager.state);
}

-(BOOL)writeValueToYKRemote:(ykBlePacketObject*)sendValue{
    
    ykBlePacketObject* ybpo = [self createSendObject];
    if (nil == ybpo) {
        return NO;
    }
    NSData* wValue = [self createSendPacket:ybpo];
    NSLog(@"writeValue = %@", wValue);
    [_currentPeripheral writeValue:wValue forCharacteristic:_currentCharacteristic type:CBCharacteristicWriteWithoutResponse];
    return YES;
}

//写数据
-(BOOL)writeUserChar:(NSData *)data;
{
    if (0 == data.length
        || TransState_NotStart != _transState
        || -1 != _indexSend) {
        NSLog(@"writeChar error, data is nil or state error");
        return NO;
    }
    NSLog(@"writeChar");
    [self startSubscribe];
    
    // 置状态
    _indexSend = 0;
    _transState = TransState_Start;
    self.currentDataSend = data;
    if (data.length < kLength_YKBLePacket_Body) {
        _fragmentsSend = 1;
    }
    else
    {
        _fragmentsSend = (0 == data.length%kLength_YKBLePacket_Body)?data.length/kLength_YKBLePacket_Body:(data.length/kLength_YKBLePacket_Body)+1;
    }
    
    BOOL bRet = [self writeValueToYKRemote:nil];
    return bRet;
}

//监听设备
-(void)startSubscribe
{
    [_currentPeripheral setNotifyValue:YES forCharacteristic:_currentCharacteristic];
}

-(NSData*)createSendPacket:(ykBlePacketObject*)sendData{
    
    const short packetLen = 3+kLength_YKBLePacket_Body;
    pSendYKBlePacket syb = (pSendYKBlePacket)malloc(packetLen);
    memset(syb, 0, packetLen);
    syb->totalLength = sendData.body.length;
    syb->index = sendData.index;
    
    memcpy(syb->body, sendData.body.bytes, syb->totalLength);
    NSData* retData = [NSData dataWithBytes:syb->body length:packetLen];
    free(syb);
    
    return retData;
}

// 根据 index 和 发送的data 来创建需要发送的包对象
-(ykBlePacketObject*)createSendObject{
    
    if (_indexSend < 0
        || _fragmentsSend < _indexSend) {
        return nil;
    }
    ykBlePacketObject* ybpo = [[ykBlePacketObject alloc] init];
    
    if (_currentDataSend.length <= kLength_YKBLePacket_Body) {
        // 一次发送就完成
        ybpo.index = 0;
        ybpo.body = _currentDataSend;
        ybpo.lengthBody = _currentDataSend.length;
    }
    else{
        // 拆分
        ybpo.index = _indexSend;
        if (ybpo.index+1 < _fragmentsSend) {
            ybpo.lengthBody = kLength_YKBLePacket_Body;
        }
        else{
            ybpo.lengthBody = _currentDataSend.length%kLength_YKBLePacket_Body;
        }
//        if (0 == ybpo.index){
//            ybpo.body = [_currentDataSend subdataWithRange:NSMakeRange(0, ybpo.lengthBody)];
//        }
//        else{
//            ybpo.body = [_currentDataSend subdataWithRange:NSMakeRange(ybpo.index*kLength_YKBLePacket_Body, ybpo.lengthBody)];
//        }
        ybpo.body = [_currentDataSend subdataWithRange:NSMakeRange(ybpo.index*kLength_YKBLePacket_Body, ybpo.lengthBody)];
    }
    
    return ybpo;
}

#pragma mark - CBCentralManagerDelegate Methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            break;
            
        case CBCentralManagerStateUnauthorized:
        case CBCentralManagerStatePoweredOff:
        case CBCentralManagerStateUnsupported: {
            self.isScaning = NO;
            break;
        }
        case CBCentralManagerStateResetting: {
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
    
    weakSelf(wSelf);
    _YMS_PERFORM_ON_MAIN_THREAD(^{
        if (wSelf.LBledelegate
            && [wSelf.LBledelegate respondsToSelector:@selector(BLeState:)]) {
            [wSelf.LBledelegate BLeState:central.state];
        }
    });
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    [self stopConnectTimer];
    
    NSLog(@"Did connect to peripheral: %@", peripheral);
    
    if ([LBleManager isSameBLEPeripheral:self.currentPeripheral Peripheral2:peripheral]) {
        
        [self.currentPeripheral setDelegate:self];
        //[peripheral readRSSI];
        [self.currentPeripheral discoverServices:nil];
        
        weakSelf(wSelf);
        _YMS_PERFORM_ON_MAIN_THREAD(^{
            
            if (wSelf.LBledelegate
                && [wSelf.LBledelegate respondsToSelector:@selector(didConnectPeripheral:)]) {
                
                [wSelf.LBledelegate didConnectPeripheral:peripheral];
            }
        });
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"didDisconnectPeripheral: %@", peripheral);
    
    self.currentPeripheral = nil;
    
    weakSelf(wSelf);
    _YMS_PERFORM_ON_MAIN_THREAD(^{
        
        if (wSelf.LBledelegate
            && [wSelf.LBledelegate respondsToSelector:@selector(didDisconnectPeripheral:error:)]) {
            
            [wSelf.LBledelegate didDisconnectPeripheral:peripheral error:error];
        }
    });
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    // 找到了服务
    
    BOOL bHave = NO;
    for (CBPeripheral* per in self.aryPeripherals) {
        if ([LBleManager isSameBLEPeripheral:per Peripheral2:peripheral]) {
            bHave = YES;
            break;
        }
    }
    if (!bHave) {
        NSLog(@"didDiscoverPeripheral is %@-%@", peripheral.name, peripheral.identifier.UUIDString);
        [self.aryPeripherals addObject:peripheral];
    }
    
    if ([peripheral.name isEqualToString:NAME_YueKongYKQ_Identifier]
        ) {//[peripheral.identifier isEqual:UUIDSTR_ISSC_YueKongYKQ_Identifier]
        
        self.currentPeripheral = peripheral;
        // 测试代码
        //[self stopScan];
    }
    
    weakSelf(wSelf);
    _YMS_PERFORM_ON_MAIN_THREAD(^{
        // 尝试连接
        //[wSelf performSelector:@selector(connectServer) withObject:nil afterDelay:3];
        
        if (wSelf.LBledelegate
            && [wSelf.LBledelegate respondsToSelector:@selector(didDiscoverPeripheral:advertisementData:RSSI:)]) {
            
            [wSelf.LBledelegate didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
        }
    });
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
    weakSelf(wSelf);
    _YMS_PERFORM_ON_MAIN_THREAD(^{
        if (wSelf.LBledelegate
            && [wSelf.LBledelegate respondsToSelector:@selector(didDiscoverServices::)]) {
            
            [wSelf.LBledelegate didDiscoverServices:peripheral :error];
        }
    });
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
            
            self.currentCharacteristic = characteristic;//保存读的特征
            
            break;
        }
    }
    
    if (self.currentCharacteristic) {
        
        weakSelf(wSelf);
        _YMS_PERFORM_ON_MAIN_THREAD(^{
            
            NSData* testData = [NSData dataWithBytes:"0123456789abcdefghij0123456789" length:30];
            [wSelf performSelector:@selector(writeUserChar:) withObject:testData afterDelay:3.5];
            
            if (wSelf.LBledelegate
                && [wSelf.LBledelegate respondsToSelector:@selector(didDiscoverCharacteristicsForService::error:)]) {
                
                [wSelf.LBledelegate didDiscoverCharacteristicsForService:peripheral
                                                                        :service
                                                                   error:error];
            }
        });
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    // 发送是否成功
    
    if (error)
    {
        NSLog(@"didWriteValueForCharacteristic------ %@ error: %@", characteristic.UUID, [error localizedDescription]);
        [self reSetTransStatus];
        return;
    }
    
    NSLog(@"didWriteValueForCharacteristic is success");
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    weakSelf(wSelf);
    _YMS_PERFORM_ON_MAIN_THREAD(^{
        
        NSError* transError = nil;
        if (error) {
            NSLog(@"didUpdateValueForCharacteristic---- %@ error: %@", characteristic.UUID, [error localizedDescription]);
            [wSelf reSetTransStatus];
            transError = error;
        }
        
        if (TransState_Start ==  wSelf.transState) {
            pResponseYKBlePacket prybp = (pResponseYKBlePacket)[characteristic.value bytes];
            if (NULL == prybp) {
                [wSelf reSetTransStatus];
                transError = [NSError errorWithDomain:@"responseData InValid" code:1 userInfo:nil];
            }
            else{
                if (0 != prybp->dataType) {
                    //1字节数据类型应为:0x00，否则APP视为无效确认信息
                    [wSelf reSetTransStatus];
                    transError = [NSError errorWithDomain:@"responseDataType InValid" code:2 userInfo:nil];
                }
                else
                {
                    // 数据类型正确
                    if (kResponseTypeEnd == prybp->responseType) {
                        NSLog(@"kResponseTypeEnd");
                        [wSelf reSetTransStatus];
                    }
                    else if(kResponseTypeContinued == prybp->responseType){
                        //如果当响应类型为0x01时，在响应数据的第一字节存放对端期望的下一个Index号（分片编号）
                        Byte expectIndex = 0;
                        if (NULL != prybp->body) {
                            expectIndex = prybp->body[0];
                        }
                        ++wSelf.indexSend;
                        if (expectIndex == wSelf.indexSend) {
                            // 继续传输
                            NSLog(@"kResponseTypeContinued expectIndex = %c", expectIndex);
                            
                            [wSelf performSelector:@selector(writeValueToYKRemote:) withObject:nil afterDelay:0.15];
                        }
                        else{
                            NSLog(@"kResponseTypeIndex Error expectIndex = %c", expectIndex);
                            
                            [wSelf reSetTransStatus];
                        }
                    }
                    else{
                        NSLog(@"kResponseTypeError");
                        [wSelf reSetTransStatus];
                    }
                }
            }
        }
        else{
            transError = [NSError errorWithDomain:@"responseState Not Start" code:3 userInfo:nil];
            [wSelf reSetTransStatus];
        }
        
        
        if (wSelf.LBledelegate
            && [wSelf.LBledelegate respondsToSelector:@selector(didUpdateValueForCharacteristic:error:Peripheral:)]) {
            
            [wSelf.LBledelegate didUpdateValueForCharacteristic:characteristic error:transError Peripheral:peripheral];
        }
    });
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
