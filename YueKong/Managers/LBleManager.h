//
//  LBleManager.h
//  YueKong
//
//  Created by zhoushaolong on 15/3/4.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "absManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define UUIDSTR_ISSC_YueKongYKQ_SERVICE    @""

// 读得特征
#define UUIDSTR_ISSC_TRANS_TX               @""

// 写
#define UUIDSTR_ISSC_TRANS_RX               @""

@interface LBleManager : absManager
<CBPeripheralDelegate, CBCentralManagerDelegate>

DEFINE_SINGLETON_FOR_HEADER(LBleManager);

-(void)scanWithDelegate:(id)delegate;

-(void)stopScan;

-(void)disConnectServer;

@end
