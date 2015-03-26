//
//  DBManager.m
//  YueKong
//
//  Created by zhoushaolong on 15/3/26.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "DBManager.h"


@interface DBManager()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSArray *aryAllVersionInfo;

@end

@implementation DBManager

DEFINE_SINGLETON_FOR_CLASS(DBManager)

#pragma mark Initlization
- (instancetype)init
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

-(BOOL)initDbPath:(NSString*)dbPath{
    
    NSFileManager*fileManager =[NSFileManager defaultManager];
    
    //如果是新建表，则保存表版本为最新
    if (![fileManager fileExistsAtPath:dbPath]) {
 
        //NSError*error;
        //NSString*resourcePath =[[NSBundle mainBundle] pathForResource:@"database" ofType:@"sqlite"];
        //[fileManager copyItemAtPath:resourcePath toPath:kDatabasePath error:&error];
    }
    
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    DLog(@"DBPATH:%@",dbPath);
    if (nil == _dbQueue) {
        DLog(@"database not exist!!!!");
        return NO;
    }
    //[self createTables];
    
    return YES;
}
@end
