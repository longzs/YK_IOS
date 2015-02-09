//
//  EHListPickerView.h
//  EHealth
//
//  Created by WangXun on 15/1/27.
//  Copyright (c) 2015年 focuschina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  3个按钮的popover view
 */
@interface YKButtonPopoverView : UIView
{
    
}

/**
 *  初始化
 *
 *  @param titleArray 按钮标题数组，3个
 *
 *  @return 初始化后的对象
 */
- (instancetype)initWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;

/**
 *  初始化
 *
 *  @param customView 通过自定义view初始化
 *
 *  @return 初始化后的对象
 */
- (instancetype)initWithCustomView:(UIView *)customView;


/**
 *  点击的回调
 */
@property (nonatomic, copy) void(^selectIndexBlock)(NSInteger selectIndex);

/**
 *  展示
 */
- (void)show;

/**
 *  收起
 */
-(void)dismiss;

@end
