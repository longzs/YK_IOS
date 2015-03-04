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
    _centralManager = [DEACentralManager sharedService];
    if (nil == _centralManager) {
        _centralManager = [DEACentralManager initSharedServiceWithDelegate:self];
    }
    [_centralManager startScan];
}
@end
