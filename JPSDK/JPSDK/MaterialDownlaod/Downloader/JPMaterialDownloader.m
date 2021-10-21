//
//  JPMaterialDownloader.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPMaterialDownloader.h"
//#import <AFNetworking.h>

@interface JPMaterialDownloader() {
    dispatch_queue_t _queue;
}

//@property (nonatomic, strong) AFHTTPRequestSerializer *serializer;
@property (nonatomic, strong) NSMutableDictionary *downloadTask;
@property (nonatomic, strong) NSMutableArray *mediaArr;

@end

@implementation JPMaterialDownloader

+(instancetype)shareInstance
{
    static JPMaterialDownloader *downloader;
    if (downloader == nil) {
        downloader = [[JPMaterialDownloader alloc] init];
    }
    return downloader;
}

- (instancetype)init
{
    if (self = [super init]) {
//        _serializer = [AFHTTPRequestSerializer serializer];
//        _queue = dispatch_queue_create([[NSString stringWithFormat:@"com.jper.downloader.%@", self] UTF8String], NULL);
//        _downloadTask = [NSMutableDictionary dictionary];
//        _mediaArr = [NSMutableArray array];
//        [JPMaterial loadAllMaterialFromDBWithCompoletion:^(NSArray<JPMaterial *> * result) {
//            if (result != nil) {
//                [_mediaArr addObjectsFromArray:result];
//            }
//        }];
//        for (JPMaterial *model in _mediaArr) {
//            if (JPMaterialStatusDownLoaded != model.materialStatus) {
//                [self startToDownloadMedia:model];
//            }
//        }
    }
    return self;
}

//- (AFURLSessionManager *)sessionManager
//{
//    static AFURLSessionManager *manager = nil;
//    if (manager == nil) {
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    }
//    return manager;
//}

- (void)insertModelToDownload:(JPMaterial *)mediaModel
{
    dispatch_sync(_queue, ^{
        if ([_mediaArr containsObject:mediaModel] == NO) {
            mediaModel.createDate = [[NSDate date] timeIntervalSince1970];
            mediaModel.materialStatus = JPMaterialStatusWillDownload;
            [_mediaArr addObject:mediaModel];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [mediaModel insertToDB];
            });
            if (self.delegate && [self.delegate respondsToSelector:@selector(mediaDownloaderInsertMediaModelWillDownload:withDownLoader:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate mediaDownloaderInsertMediaModelWillDownload:mediaModel withDownLoader:self];
                });
            }
            [self startToDownloadMedia:mediaModel];
        }
        
    });
}

- (void)startToDownloadMedia:(JPMaterial *)model {
//    model.materialStatus = JPMaterialStatusDownloading;
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters sgrSetObject:@(model.mid) forKey:@"id"];
//    if (model.material_id == 1) {
//        //图片下载
//        [parameters sgrSetObject:@"App.Material_Pattern.Download" forKey:@"service"];
//    }
//    else if (model.material_id == 2) {
//        //音乐
//        [parameters sgrSetObject:@"App.Material_Music.Download" forKey:@"service"];
//    }
//    else if (model.material_id == 3) {
//        //音效
//        [parameters sgrSetObject:@"App.Material_Sound.Download" forKey:@"service"];
//    }else {
//        //错误情况
//        return;
//    }
//    
//    AFURLSessionManager *sessionManger = [self sessionManager];
////    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
////    [parameters sgrSetObject:[NSString stringWithFormat:@"%.0f", timeInterval] forKey:@"time"];
////    NSString *signStr = [JPUtil signStringWithDictionary:parameters];
////    [parameters sgrSetObject:signStr forKey:@"sign"];
//
//    NSMutableURLRequest *request =[_serializer requestWithMethod:@"POST" URLString:API_HOST parameters:parameters error:nil];
//    __block NSProgress *pro;
//    __block CFAbsoluteTime currentActualTime = CFAbsoluteTimeGetCurrent();
//    __block int64_t completedUnitCount = 0;
//    NSURLSessionDownloadTask *downloadTask = [sessionManger downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        pro = downloadProgress;
//        int64_t changeCount = downloadProgress.completedUnitCount - completedUnitCount;
//        CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
//        CGFloat actualTimeDifference = currentTime - currentActualTime;
//        completedUnitCount = downloadProgress.completedUnitCount;
//        currentActualTime = currentTime;
//        dispatch_sync(_queue, ^{
//            if (self.delegate && [self.delegate respondsToSelector:@selector(mediaDownloaderUpdateProgressWithModel:withDownLoader:progress:andSpeed:)]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.delegate mediaDownloaderUpdateProgressWithModel:model withDownLoader:self progress:(CGFloat)downloadProgress.completedUnitCount / (CGFloat)downloadProgress.totalUnitCount  andSpeed:changeCount / 1000 / actualTimeDifference];
//                });
//            }
//        });
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        return [NSURL fileURLWithPath:model.absoluteLocalPath];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        if (error == nil && pro && (pro.totalUnitCount <= pro.completedUnitCount)) {
//            model.materialStatus = JPMaterialStatusDownLoaded;
//            [model updateToDB];
//            dispatch_sync(_queue, ^{
//                if (self.delegate && [self.delegate respondsToSelector:@selector(mediaDownloaderMediaModelDidDownload:withDownLoader:)]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.delegate mediaDownloaderMediaModelDidDownload:model withDownLoader:self];
//                    });
//                }
//                
//                for (NSString *key  in _downloadTask) {
//                    if ([key isEqualToString:model.localPath]) {
//                        NSArray *object = _downloadTask[key];
//                        NSURLSessionDownloadTask *task = object.firstObject;
//                        [task suspend];
//                        [_downloadTask removeObjectForKey:key];
//                        break;
//                    }
//                }
//            });
//        } else {
//            NSLog(@"--------%@--%@--error", error, response);
//            model.materialStatus = JPMaterialStatusUnknown;
//            [model deleteFromDb];
//            if ([[NSFileManager defaultManager] fileExistsAtPath:model.absoluteLocalPath]){
//                [[NSFileManager defaultManager] removeItemAtPath:model.absoluteLocalPath error:nil];
//            }
//            dispatch_sync(_queue, ^{
//                if (self.delegate && [self.delegate respondsToSelector:@selector(mediaDownloaderMediaModelFailedDownload:withDownLoader:)]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.delegate mediaDownloaderMediaModelFailedDownload:model withDownLoader:self];
//                    });
//                }
//                
//                for (NSString *key  in _downloadTask) {
//                    if ([key isEqualToString:model.localPath]) {
//                        NSArray *object = _downloadTask[key];
//                        NSURLSessionDownloadTask *task = object.firstObject;
//                        [task suspend];
//                        [_downloadTask removeObjectForKey:key];
//                        break;
//                    }
//                }
//            });
//        }
//    }];
//    [downloadTask resume];
//    [_downloadTask sgrSetObject:@[downloadTask, model] forKey:model.localPath];
}

- (void)becomeBackGround
{
    dispatch_sync(_queue, ^{
        
        for (NSString *key  in _downloadTask) {
            NSArray *object = _downloadTask[key];
            NSURLSessionDownloadTask *task = object.firstObject;
            [task suspend];
        }
    });
}

- (void)becomeActive
{
    dispatch_sync(_queue, ^{
        
        for (NSString *key  in _downloadTask) {
            NSArray *object = _downloadTask[key];
            NSURLSessionDownloadTask *task = object.firstObject;
            [task resume];
        }
    });
}

- (void)deleteModel:(JPMaterial *)model{
    dispatch_sync(_queue, ^{
        if ([self.mediaArr containsObject:model]) {
            [self.mediaArr removeObject:model];
            if (self.delegate && [self.delegate respondsToSelector:@selector(mediaDownloaderDeleteMediaModel:withDownLoader:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate mediaDownloaderDeleteMediaModel:model withDownLoader:self];
                });
            }
        }
        for (NSString *key  in _downloadTask) {
            if ([key isEqualToString:model.localPath]) {
                NSArray *object = _downloadTask[key];
                NSURLSessionDownloadTask *task = object.firstObject;
                [task suspend];
                [_downloadTask removeObjectForKey:key];
                break;
            }
        }
    });
    [model deleteFromDb];
    
}

- (NSArray<JPMaterial *> *)localMaterials{
    return _mediaArr.copy;
}

- (JPMaterial *)getMaterialWithLocalPath:(NSString *)localPath {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localPath == %@", localPath];
    NSArray *results = [_mediaArr filteredArrayUsingPredicate:predicate];
    if (results && results.count) {
        return [results firstObject];
    }
    return nil;
}

@end
