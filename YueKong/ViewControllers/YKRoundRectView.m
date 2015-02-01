//
//  YKRoundRectView.m
//  YueKong
//
//  Created by WangXun on 15/2/1.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "YKRoundRectView.h"
#import <QuartzCore/QuartzCore.h>

@implementation YKRoundRectView

- (void)setRoundRaidus:(CGFloat)roundRaidus
{
    self.layer.cornerRadius = roundRaidus;
    
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    self.layer.borderWidth = lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor
{
    self.layer.borderColor = [lineColor CGColor];
}

@end
