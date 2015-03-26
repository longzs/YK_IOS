//
//  YKDeviceModel.m
//  YueKong
//
//  Created by zhoushaolong on 15-2-5.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "YKDeviceModel.h"

#define kUDUserName @"kUDUserName"
#define kUDUserIdNo @"kUDUserIdNo"
#define kUDUserPdsn @"kUDUserPdsn"

#define kUDUserIpAddress    @"kUDUserIpAddress"
#define kUDUserStatus       @"kUDUserStatus"
#define kUDUserCreateTime @"kUDUserCreateTime"
#define kUDUserVersion @"kUDUserVersion"

#define kUDUnlockReservationDate @"unlockReservationDate"

@implementation YKDeviceModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:kUDUserName];
    
    [aCoder encodeObject:_idNo forKey:kUDUserIdNo];
    
    [aCoder encodeObject:_pdsn forKey:kUDUserPdsn];
    
    [aCoder encodeObject:_ip_address forKey:kUDUserIpAddress];
    
    [aCoder encodeObject:_status forKey:kUDUserStatus];
    
    [aCoder encodeObject:_version forKey:kUDUserVersion];
    
    [aCoder encodeObject:_create_time forKey:kUDUserCreateTime];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:kUDUserName];
        self.idNo = [aDecoder decodeObjectForKey:kUDUserIdNo];
        self.pdsn = [aDecoder decodeObjectForKey:kUDUserPdsn];
        self.ip_address = [aDecoder decodeObjectForKey:kUDUserIpAddress];
        self.status = [aDecoder decodeObjectForKey:kUDUserStatus];
        self.version = [aDecoder decodeObjectForKey:kUDUserVersion];
        self.create_time = [aDecoder decodeObjectForKey:kUDUserCreateTime];
    }
    return self;
}

@end


@implementation YKRemoteControlCategory

@end

@implementation YKRemoteControlBrand

@end

@implementation YKCityModel

@end

@implementation YKMobileModel

@end


@implementation YKMApplicaonSchedueModel

@end




