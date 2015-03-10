//
//  LBleManager.h
//  YueKong
//
//  Created by zhoushaolong on 15/3/4.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "absManager.h"
#import "YMSCBPeripheral.h"
#import "DEACentralManager.h"


#define UUIDSTR_ISSC_YueKongYKQ_Identifier    @"6384E0F3-0642-032A-6DDD-B3499FB43079"

#define NAME_YueKongYKQ_Identifier              @""

#define UUIDSTR_YueKongYKQ_SERVICE            @"FFF0"

// 读写特征
#define UUIDSTR_ISSC_TRANS_RW               @"FFF6"

// 写
#define UUIDSTR_ISSC_TRANS_RX               @"FFF3"

@protocol LBleProcessDelegate <NSObject>
-(void)BLeState:(CBCentralManagerState)state;

//  查找到得最新得 peripheral
-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;

@end


@interface LBleManager : absManager
<CBPeripheralDelegate, CBCentralManagerDelegate>{
    
}
@property(nonatomic, strong)CBCentralManager* centralManager;

@property(nonatomic, strong)CBPeripheral*       currentPeripheral;

@property(nonatomic, strong)CBCharacteristic*       currentCharacteristic;

@property(nonatomic, weak)id<LBleProcessDelegate> LBledelegate;

@property(nonatomic, assign)BOOL isScaning;

DEFINE_SINGLETON_FOR_HEADER(LBleManager);

-(void)scanWithDelegate:(id)delegate;

-(void)stopScan;

-(void)connectServer;

-(void)disConnectServer;

-(void)writeChar:(NSData *)data;

@end
