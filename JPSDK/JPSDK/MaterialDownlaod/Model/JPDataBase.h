//
//  JPDataBase.h
//  jper
//
//  Created by FoundaoTEST on 2017/5/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JPDataBase : NSObject
+ (instancetype)shareInstance;
- (void)createTableWithSqlStr:(NSString *)string;
- (void)executeUpdateWithSqlStr:(NSString*)sql;
- (void)loadDataWithSqlStr:(NSString *)sql completion:(void(^)(FMResultSet *result))compoletion;
- (void)alterTableName:(NSString *)tableName andColumnName:(NSString *)columnName;
@end
