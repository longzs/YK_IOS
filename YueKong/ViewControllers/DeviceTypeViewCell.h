//
//  DeviceTypeViewCell.h
//  YueKong
//
//  Created by WangXun on 15/2/26.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTypeViewCell : UICollectionViewCell

//图片类型
@property (nonatomic) HouseholdAppliancesType deviceType;

//文字
@property (nonatomic, copy) NSString *deviceText;

@end
