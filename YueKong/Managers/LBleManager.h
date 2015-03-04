//
//  LBleManager.h
//  YueKong
//
//  Created by zhoushaolong on 15/3/4.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "absManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface LBleManager : absManager
<CBPeripheralDelegate>

DEFINE_SINGLETON_FOR_HEADER(LBleManager);

@end
