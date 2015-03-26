//
//  DBManager.h
//  YueKong
//
//  Created by zhoushaolong on 15/3/26.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#pragma mark - 宏定义
#define kDatabasePath @""
#define kDBInsertSqlBase @"INSERT OR REPLACE INTO %@(%@) VALUES(%@) "
#define kDBUpdateSqlBase @"UPDATE %@ SET %@ WHERE %@"
#define kDBSearchSqlBase @"SELECT * FROM %@"
#define kDBDeleteSqlBase @"DELETE FROM %@"


@interface DBManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(DBManager)

-(BOOL)initDbPath:(NSString*)dbPath;

@end
