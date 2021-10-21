//
//  JPMediaModel.m
//  jper
//
//  Created by FoundaoTEST on 2017/5/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//



#import "JPMediaModel.h"
#import "JPDataBase.h"

static NSString *JPMediaDataTableName = @"media";
@implementation JPMediaModel

- (NSString *)tempPath{
    if (_tempPath != nil) {
        return _tempPath;
    }
    NSString *path = [NSString stringWithFormat:@"%@.mp4", _product_uuid];
    NSString *filePath = [JPER_RECORD_FILES_FOLDER stringByAppendingPathComponent:path];
    _tempPath = filePath;
    return _tempPath;
}

- (NSString *)videoLocalPath
{
    if (_videoLocalPath != nil) {
        return _videoLocalPath;
    }
    NSString *path =  [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", @"Jper"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    NSString *videoPath = [NSString stringWithFormat:@"%@.mp4", _product_uuid];
    NSString *filePath = [path stringByAppendingPathComponent:videoPath];
    _videoLocalPath = filePath;
    return _videoLocalPath;
}

+ (void)loadAllModelWithCompoletion:(void(^)(NSArray <JPMediaModel *> *))completion
{
    [self createMediaTable];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase loadDataWithSqlStr:[NSString stringWithFormat:@"SELECT * FROM %@", JPMediaDataTableName] completion:^(FMResultSet *result) {
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            JPMediaModel *model = [[JPMediaModel alloc] init];
            model.mediaId = [result longLongIntForColumn:@"mediaId"];
            model.videoPath = [result stringForColumn:@"videoPath"];
            model.createDate = [result longLongIntForColumn:@"createDate"];
            model.videoDuration = [result longLongIntForColumn:@"videoDuration"];
            model.image = [result stringForColumn:@"image"];
            model.title = [result stringForColumn:@"title"];
            model.isDownload = [result boolForColumn:@"isDownload"];
            model.product_uuid = [result stringForColumn:@"product_uuid"];
            model.keyword = [result stringForColumn:@"keyword"];
            [array addObject:model];
        }
        completion(array);
    }];
}

+ (void)loadAllDownloadedModelsWithCompoletion:(void(^)(NSArray <JPMediaModel *> *))completion {
    [self createMediaTable];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase loadDataWithSqlStr:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE isDownload = '%d'", JPMediaDataTableName,YES] completion:^(FMResultSet *result) {
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            JPMediaModel *model = [[JPMediaModel alloc] init];
            model.mediaId = [result longLongIntForColumn:@"mediaId"];
            model.videoPath = [result stringForColumn:@"videoPath"];
            model.createDate = [result longLongIntForColumn:@"createDate"];
            model.videoDuration = [result longLongIntForColumn:@"videoDuration"];
            model.image = [result stringForColumn:@"image"];
            model.title = [result stringForColumn:@"title"];
            model.isDownload = [result boolForColumn:@"isDownload"];
            model.product_uuid = [result stringForColumn:@"product_uuid"];
            model.keyword = [result stringForColumn:@"keyword"];
            [array addObject:model];
        }
        completion(array);
    }];
}

- (void)insertToDB
{
    [[self class] createMediaTable];
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (createDate, image, title, videoDuration, videoPath, videoLocalPath, isDownload, tempPath, product_uuid, keyword) values (%.0f, '%@', '%@', %.0f, '%@', '%@', %d, '%@', '%@','%@');", JPMediaDataTableName,_createDate, _image, _title, _videoDuration, _videoPath, self.videoLocalPath, _isDownload, self.tempPath, self.product_uuid,self.keyword];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase executeUpdateWithSqlStr:sqlStr];
}

- (void)updateToDB
{
    [[self class] createMediaTable];
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET isDownload = %d WHERE product_uuid = '%@';", JPMediaDataTableName, _isDownload, _product_uuid];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase executeUpdateWithSqlStr:sqlStr];
}

- (void)deleteFromDb
{
    [[self class] createMediaTable];
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE product_uuid = '%@';", JPMediaDataTableName, _product_uuid];
    JPDataBase *dataBase = [JPDataBase shareInstance];
    [dataBase executeUpdateWithSqlStr:sqlStr];
}

+ (void)createMediaTable
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *existsSql = [NSString stringWithFormat:@"SELECT * FROM %@", JPMediaDataTableName] ;
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
            [dataBase createTableWithSqlStr:[NSString stringWithFormat:@"create table %@ (mediaId integer primary key autoincrement, createDate integer, image text, title text, videoDuration integer, videoPath text, videoLocalPath text, isDownload integer, tempPath text, product_uuid text, keyword text);", JPMediaDataTableName]];
        }
    });
    
}

@end
