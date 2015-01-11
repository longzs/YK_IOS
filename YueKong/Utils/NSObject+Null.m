//
//  NSObject+Null.m
//  XYZ_iOS
//
//  Created by IMAC_jinjianxin on 12-10-22.
//  Copyright (c) 2012年 焦点科技. All rights reserved.
//

#import "NSObject+Null.h"

@implementation NSObject (Null)

- (BOOL)isNullClass
{
    return [self isKindOfClass:[NSNull class]];
}

@end
