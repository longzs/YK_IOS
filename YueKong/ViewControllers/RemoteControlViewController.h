//
//  RemoteControlViewController.h
//  YueKong
//
//  Created by zhoushaolong on 15-1-19.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "BaseViewController.h"

@interface RemoteControlViewController : BaseViewController
@property(nonatomic, assign)HouseholdAppliancesType rcCategoryID;
@property(nonatomic, strong)NSString* selectBrandID;
@property(nonatomic, strong)NSString* selectCityID;
@end
