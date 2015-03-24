//
//  LeftMenuTableViewCell.h
//  YueKong
//
//  Created by WangXun on 15/3/25.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import <UIKit/UIKit.h>

//状态
typedef enum LeftMenuTableViewCellState_
{
    LeftMenuTableViewCellStateNomarl = 0,   //普通
    LeftMenuTableViewCellStateFull,     //完整版
    LeftMenuTableViewCellStateAddNew    //添加新
}LeftMenuTableViewCellState;


@interface LeftMenuTableViewCell : UITableViewCell

//状态
@property (nonatomic) LeftMenuTableViewCellState cellState;

@property (nonatomic, copy) NSString *cellTitle;

@property (nonatomic) BOOL cellDisable;

@end
