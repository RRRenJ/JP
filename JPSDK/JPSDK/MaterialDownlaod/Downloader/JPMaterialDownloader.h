//
//  JPMaterialDownloader.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPMaterial.h"



@class JPMaterialDownloader;
@protocol JPMaterialDownloaderDelegate <NSObject>

@optional
- (void)mediaDownloaderUpdateProgressWithModel:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader progress:(CGFloat)progress andSpeed:(NSInteger)speed;
- (void)mediaDownloaderInsertMediaModelWillDownload:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader;
- (void)mediaDownloaderDeleteMediaModel:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader;
- (void)mediaDownloaderMediaModelDidDownload:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader;
- (void)mediaDownloaderMediaModelFailedDownload:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader;

@end

@interface JPMaterialDownloader : NSObject
@property (nonatomic, weak) id<JPMaterialDownloaderDelegate>delegate;

+ (instancetype)shareInstance;
- (void)insertModelToDownload:(JPMaterial *)mediaModel;
- (NSArray <JPMaterial *>*)localMaterials;
- (JPMaterial *)getMaterialWithLocalPath:(NSString *)localPath;
- (void)becomeBackGround;
- (void)becomeActive;
- (void)deleteModel:(JPMaterial *)model;

@end
