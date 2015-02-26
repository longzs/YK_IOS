//
//  DeviceTypeViewCell.m
//  YueKong
//
//  Created by WangXun on 15/2/26.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "DeviceTypeViewCell.h"

@interface DeviceTypeViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *imvDevice;
@property (nonatomic, weak) IBOutlet UILabel *lblDeviceName;

@end

@implementation DeviceTypeViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDeviceType:(HouseholdAppliancesType)deviceType
{
    NSString *imgName = nil;
    switch (deviceType) {
        case HAType_AirConditioner:{
            imgName = @"icon_AirCondition";
            break;
        }
        case HAType_TV:{
            imgName = @"icon_TV";
            break;
        }
        case HAType_LanBox:{
            imgName = @"icon_NetworkBox";
            break;
        }
        case HAType_SetTopBox:{
            imgName = @"icon_STB";
            break;
        }
        default:
            break;
    }
    
    if (imgName) {
        _imvDevice.image = [UIImage imageNamed:imgName];
    }
    else {
        _imvDevice.image = nil;
    }
    
}

- (void)setDeviceText:(NSString *)deviceText
{
    _lblDeviceName.text = deviceText;
}

@end
