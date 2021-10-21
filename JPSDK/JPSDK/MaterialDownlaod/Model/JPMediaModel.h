//
//  JPMediaModel.h
//  jper
//
//  Created by FoundaoTEST on 2017/5/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JPMediaModel : NSObject
@property (nonatomic, assign) NSTimeInterval createDate;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSTimeInterval videoDuration;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *videoLocalPath;
@property (nonatomic, assign) BOOL isDownload;
@property (nonatomic, strong) NSString *tempPath;
@property (nonatomic, assign) long long mediaId;
@property (nonatomic, strong) NSString *product_uuid;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *videoFrameSize;
@property (nonatomic, strong) NSString *videoBytes;
@property (nonatomic, strong) NSString *videoDurationStr;
@property (nonatomic, strong) UIImage *thumImage;
+ (void)loadAllDownloadedModelsWithCompoletion:(void(^)(NSArray <JPMediaModel *> *))completion;
+ (void)loadAllModelWithCompoletion:(void(^)(NSArray <JPMediaModel *> *))completion;
+ (void)createMediaTable;
- (void)insertToDB;
- (void)updateToDB;
- (void)deleteFromDb;
@end
