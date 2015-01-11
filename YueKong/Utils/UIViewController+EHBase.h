//
//  UIViewController+EHBase.h
//  EHealth
//
//  Created by focusdesign on 14/12/1.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum BarButtonType_
{
    BarButtonTypeNone,
    BarButtonTypeText,
    BarButtonTypeBack,
    BarButtonTypeSearch,
    BarButtonTypeUserCenter,
    BarButtonTypeDateSchedules
    
}BarButtonType;

/**
 *  UIViewController的扩展
 */
@interface UIViewController (EHBase)

#pragma mark - 加载动画
/**
 *  显示等待加载
 */
- (void)showLoading;

/**
 *  显示加文字等待加载
 */
- (void)showLoadingWithTip:(NSString*)tip;

/**
 *  结束等待
 */
- (void)hideLoading;

#pragma mark - 导航栏订制
/**
 *  添加默认的返回按钮
 *
 *  @param action 事件处理
 */
- (void)addBackBarButtonWithAction:(SEL)action;

/**
 *  添加一个默认的back button,
 */
- (void)addDefaultBackButtonOfNext;

/**
 *  添加一个右边bar button
 *
 *  @param buttonType button 类型
 *  @param title      button 标题，BarButtonImageTypeText类型时使用
 *  @param action     事件处理
 */
- (void)addLeftBarButtonWithType:(BarButtonType)buttonType
                           title:(NSString *)title
                          action:(SEL)action;

/**
 *  添加一个左边bar button
 *
 *  @param buttonType button 类型
 *  @param title      button 标题，BarButtonImageTypeText类型时使用
 *  @param action     事件处理
 */
- (void)addRightBarButtonWithType:(BarButtonType)buttonType
                            title:(NSString *)title
                           action:(SEL)action;




@end
