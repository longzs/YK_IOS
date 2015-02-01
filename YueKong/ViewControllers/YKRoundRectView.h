//
//  YKRoundRectView.h
//  YueKong
//
//  Created by WangXun on 15/2/1.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface YKRoundRectView : UIView

//圆角角度
@property (nonatomic) IBInspectable CGFloat roundRaidus;

//边宽
@property (nonatomic) IBInspectable CGFloat lineWidth;

@property (nonatomic, strong) IBInspectable UIColor *lineColor;

@end
