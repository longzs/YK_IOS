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


#define UUIDSTR_ISSC_YueKongYKQ_Identifier    @"F66BE5FB-41C1-E82B-F9F2-5F1EFF479D62"

#define NAME_YueKongYKQ_Identifier              @"UCON_Bobi"

#define UUIDSTR_YueKongYKQ_SERVICE            @"FFF0"

// 读写特征
#define UUIDSTR_ISSC_TRANS_RW               @"FFF1"

// 写
#define UUIDSTR_ISSC_TRANS_RX               @"FFF3"

@interface ykBlePacketObject : NSObject
@property(nonatomic, assign)unsigned short       lengthBody;
@property(nonatomic, assign)SignedByte  index;
@property(nonatomic, strong)NSData*     body;
@end

@interface ykResBlePacketObject : NSObject
@property(nonatomic, assign)Byte  dataType;
@property(nonatomic, assign)Byte  resType;
@property(nonatomic, strong)NSData*  body;
@end


@protocol LBleProcessDelegate <NSObject>

@optional
-(void)BLeState:(CBCentralManagerState)state;

//  查找到得最新得 peripheral
-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;

-(void)didConnectPeripheral:(CBPeripheral *)peripheral;

-(void)didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

-(void)didDiscoverServices:(CBPeripheral *)peripheral :(NSError *)error;

-(void)didDiscoverCharacteristicsForService:(CBPeripheral *)peripheral :(CBService *)service error:(NSError *)error;

-(void)didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error Peripheral:(CBPeripheral*)peripheral;
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

-(BOOL)connectServer;

-(void)disConnectServer;

-(BOOL)writeUserChar:(NSData *)data;

-(BOOL)bleEnable;

-(void)reSetTransStatus;

-(NSData*)createUserData:(NSData*)userData cmdID:(int)cmdID;

@end
