//
//  JPDataBase.m
//  jper
//
//  Created by FoundaoTEST on 2017/5/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//
#import "JPDataBase.h"

@interface JPDataBase ()
{
    FMDatabaseQueue *queue;
}
@property (nonatomic, assign) BOOL isOpen;
@end

@implementation JPDataBase

+ (instancetype)shareInstance
{
    static JPDataBase *dataBase = nil;
    if (dataBase == nil) {
        dataBase = [[JPDataBase alloc] init];
    }
    return dataBase;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
        NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"jper.db"];
        queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        _isOpen = NO;
    }
    return self;
}


- (void)alterTableName:(NSString *)tableName andColumnName:(NSString *)columnName
{
   [queue inDatabase:^(FMDatabase * _Nonnull db) {
       if ([db columnExists:columnName inTableWithName:tableName] == NO) {
           [db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT", tableName, columnName]];
       }
   }];
}


- (void)createTableWithSqlStr:(NSString *)string
{
    [queue inDatabase:^(FMDatabase *db) {
        [db executeStatements:string];
    }];
    [queue close];
}

- (void)executeUpdateWithSqlStr:(NSString*)sql
{
    [queue inDatabase:^(FMDatabase *db) {
        [db executeStatements:sql];
    }];
    [queue close];

}

- (void)loadDataWithSqlStr:(NSString *)sql completion:(void (^)(FMResultSet *))compoletion
{
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        compoletion(result);
    }];
    [queue close]; 
}
@end
