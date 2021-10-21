//
//  JPMaterial.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPMaterial.h"
#import "JPUtil.h"
#import "JPDataBase.h"


static NSString *JPMaterialDataTableName = @"material";
@implementation JPMaterial

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
               @"material_type_id" : @[@"pattern_id", @"sound_id", @"music_id"],
               @"mid"              : @"resource_id",
               @"name"             : @"resource_title",
               @"icon"             : @"resource_icon",
           };
}

- (id)init {
    self = [super init];
    if (self) {
        _materialStatus = JPMaterialStatusUnknown;
        _indexStr = @"";
        _indexWidth = 0;
    }
    return self;
}

- (void)setIndexStr:(NSString *)indexStr {
    _indexStr = indexStr;
    CGSize size = [JPUtil getStringSizeWith:[UIFont jp_placardMTStdCondBoldFontWithSize:12] andContainerSize:CGSizeMake(20000, 14) andString:indexStr];
    self.indexWidth = ceilf(size.width);
}

- (NSString *)localPath{
    if (_localPath != nil) {
        return _localPath;
    }
    NSString *path = [NSString stringWithFormat:@"%ld-%ld-%ld%@",(long)_material_id,(long)_material_type_id,(long)_mid,_resource_name];
    _localPath = path;
    return _localPath;
}

- (NSString *)baseFilePath
{
    return [NSString stringWithFormat:@"Documents/JPSDK/%@", self.localPath];
}

- (NSString *)absoluteLocalPath {
    if (_absoluteLocalPath != nil) {
        return _absoluteLocalPath;
    }
    NSString *path = [JP_MATERIAL_FILES_FOLDER stringByAppendingPathComponent:self.localPath];
    _absoluteLocalPath = path;
    return _absoluteLocalPath;
}

+ (void)loadAllGraphFromDBWithCompoletion:(void(^)(NSArray <JPMaterial *> *))completion{
    [self createMaterialTable];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase loadDataWithSqlStr:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE material_id = %ld", JPMaterialDataTableName,(long)JPMaterialTypeGraph] completion:^(FMResultSet *result) {
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            JPMaterial *model = [[JPMaterial alloc] init];
            model.localPath = [result stringForColumn:@"localPath"];
            model.createDate = [result longLongIntForColumn:@"createDate"];
            model.materialStatus = [result longLongIntForColumn:@"materialStatus"];
            model.material_id = [result longLongIntForColumn:@"material_id"];
            model.material_type_id = [result longLongIntForColumn:@"material_type_id"];
            model.mid = [result longLongIntForColumn:@"mid"];
            model.materialStatus = [result longLongIntForColumn:@"materialStatus"];
            model.indexWidth = [result longLongIntForColumn:@"indexWidth"];
            model.indexStr = [result stringForColumn:@"indexStr"];
            model.resource_name = [result stringForColumn:@"resource_name"];
            model.name = [result stringForColumn:@"name"];
            model.icon = [result stringForColumn:@"icon"];
            model.downloadPro = [result doubleForColumn:@"downloadPro"];
            [array addObject:model];
        }
        completion(array);
    }];
}

+ (void)loadAllMaterialFromDBWithCompoletion:(void(^)(NSArray <JPMaterial *> *))completion {
    [self createMaterialTable];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase loadDataWithSqlStr:[NSString stringWithFormat:@"SELECT * FROM %@", JPMaterialDataTableName] completion:^(FMResultSet *result) {
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            JPMaterial *model = [[JPMaterial alloc] init];
            model.localPath = [result stringForColumn:@"localPath"];
            model.createDate = [result longLongIntForColumn:@"createDate"];
            model.materialStatus = [result longLongIntForColumn:@"materialStatus"];
            model.material_id = [result longLongIntForColumn:@"material_id"];
            model.material_type_id = [result longLongIntForColumn:@"material_type_id"];
            model.mid = [result longLongIntForColumn:@"mid"];
            model.materialStatus = [result longLongIntForColumn:@"materialStatus"];
            model.indexWidth = [result longLongIntForColumn:@"indexWidth"];
            model.indexStr = [result stringForColumn:@"indexStr"];
            model.resource_name = [result stringForColumn:@"resource_name"];
            model.name = [result stringForColumn:@"name"];
            model.icon = [result stringForColumn:@"icon"];
            model.downloadPro = [result doubleForColumn:@"downloadPro"];
            [array addObject:model];
        }
        completion(array);
    }];
}

+ (void)loadAllMusicFromDBWithCompoletion:(void(^)(NSArray <JPMaterial *> *))completion {
    [self createMaterialTable];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase loadDataWithSqlStr:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE material_id = %ld", JPMaterialDataTableName,(long)JPMaterialTypeMusic] completion:^(FMResultSet *result) {
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            JPMaterial *model = [[JPMaterial alloc] init];
            model.localPath = [result stringForColumn:@"localPath"];
            model.createDate = [result longLongIntForColumn:@"createDate"];
            model.materialStatus = [result longLongIntForColumn:@"materialStatus"];
            model.material_id = [result longLongIntForColumn:@"material_id"];
            model.material_type_id = [result longLongIntForColumn:@"material_type_id"];
            model.mid = [result longLongIntForColumn:@"mid"];
            model.materialStatus = [result longLongIntForColumn:@"materialStatus"];
            model.indexWidth = [result longLongIntForColumn:@"indexWidth"];
            model.indexStr = [result stringForColumn:@"indexStr"];
            model.resource_name = [result stringForColumn:@"resource_name"];
            model.name = [result stringForColumn:@"name"];
            model.icon = [result stringForColumn:@"icon"];
            model.downloadPro = [result doubleForColumn:@"downloadPro"];
            [array addObject:model];
        }
        completion(array);
    }];
}

- (void)insertToDB
{
    [[self class] createMaterialTable];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    NSString *sql = [NSString stringWithFormat:@"SELECT localPath FROM %@ WHERE localPath = '%@';", JPMaterialDataTableName, self.localPath];
    __block BOOL hasRecord = NO;
    [dataBase loadDataWithSqlStr:sql completion:^(FMResultSet *result) {
        if ([result next]) {
            hasRecord = YES;
        }
    }];
    if (!hasRecord) {
        NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (createDate, indexWidth, indexStr, resource_name, mid, icon, name, localPath, material_type_id, material_id, materialStatus, downloadPro) values (%.0f, %ld, '%@', '%@', %ld, '%@', '%@', '%@', %ld, %ld, %.0ld, %.0f);", JPMaterialDataTableName,_createDate,(long)_indexWidth,_indexStr,_resource_name,(long)_mid,_icon,_name,self.localPath,(long)_material_type_id,(long)_material_id,(long)_materialStatus,_downloadPro];
        [dataBase executeUpdateWithSqlStr:sqlStr];
    }
}

- (void)updateToDB{
    [[self class] createMaterialTable];
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET materialStatus = %ld WHERE localPath = '%@';", JPMaterialDataTableName, (long)_materialStatus, self.localPath];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase executeUpdateWithSqlStr:sqlStr];
}

- (void)deleteFromDb{
    [[self class] createMaterialTable];
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE localPath = '%@';", JPMaterialDataTableName, self.localPath];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase executeUpdateWithSqlStr:sqlStr];
}

+ (void)createMaterialTable{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *existsSql = [NSString stringWithFormat:@"SELECT * FROM %@", JPMaterialDataTableName] ;
        JPDataBase *dataBase = [JPDataBase shareInstance];
        __block BOOL isExsited = NO;
        
        [dataBase loadDataWithSqlStr:existsSql completion:^(FMResultSet *result) {
            while ([result next] && isExsited == NO)
            {
                NSTimeInterval createDate = [result longLongIntForColumn:@"createDate"];
                NSLog(@"isTableOK %ld", (long)createDate);
                
                if (0 != createDate)
                {
                    isExsited = YES;
                }
                
            }
            
        }];
        if (isExsited == NO) {
            JPDataBase *dataBase = [JPDataBase shareInstance];
            [dataBase createTableWithSqlStr:[NSString stringWithFormat:@"create table %@ (materialId integer primary key autoincrement, createDate integer, indexWidth integer, indexStr text, resource_name text, mid integer, icon text, name text, localPath text, material_type_id integer, material_id integer, materialStatus integer, downloadPro float);", JPMaterialDataTableName]];
        }
    });
    
}

@end
