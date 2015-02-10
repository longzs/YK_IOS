//
//  YKModel.h
//  YueKong
//
//  Created by zhoushaolong on 15-2-5.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 数据模型协议
/**
 *  支持数据库操作的模型的协议
 */
@protocol YKModel <NSObject>

/**
 *  主键名
 *
 *  @return 主键的名称
 */
+ (NSString *)primaryKeyName;

/**
 *  对应的表名
 *
 *  @return 表名
 */
+ (NSString *)tableName;

/**
 *  通过FMDB查找结果实例化
 *
 *  @param set FMDB查找结果
 *
 *  @return 实例
 */
//+ (instancetype)instanceFromResultSet:(FMResultSet *)set;

/**
 *  所有属性对应的数据库中的字段
 *
 *  @return 字典，key表示数据库中的字段名，value表示对应字段值
 */
- (NSDictionary *)dicForDatabase;

@end

@interface YKModel : NSObject
@property(nonatomic, assign)BOOL bSelect;
@end
