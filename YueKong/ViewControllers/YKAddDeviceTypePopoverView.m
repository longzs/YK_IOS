//
//  YKAddDeviceTypePopoverView.m
//  YueKong
//
//  Created by WangXun on 15/3/12.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "YKAddDeviceTypePopoverView.h"

#define kWidthDefault 300.0f
#define kHeightDefault 186.0f
#define kTagButtonBase 1000

@implementation YKAddDeviceTypePopoverView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidthDefault, kHeightDefault)];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *contentView = [[UINib nibWithNibName:@"YKAddDeviceTypePopoverView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    if (contentView) {
        [self addSubview:contentView];
    }
    
}

- (IBAction)clickButton:(UIButton *)sender
{
    NSInteger index = sender.tag - kTagButtonBase;
    if (self.selectIndexBlock) {
        self.selectIndexBlock(index);
    }
    [self dismiss];
    
}

@end
