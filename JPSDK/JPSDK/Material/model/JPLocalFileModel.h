//
//  JPLocalFileModel.h
//  jper
//
//  Created by FoundaoTEST on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
typedef NS_ENUM(NSInteger, JPAssetType){
    JPAssetTypeVideo,
    JPAssetTypePhoto,
    JPAssetTypeMediaCloud,
};

@interface JPLocalFileModel : NSObject
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIImage *thumImage;
@property (nonatomic) JPAssetType type;
@property (nonatomic, strong) NSURL *assetUrl;
@property (nonatomic, strong) NSString * movieName;
@property (nonatomic) JPVideoAspectRatio aspectRatio;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval createTimeInterval;
@property (nonatomic, strong) NSString *product_udid;
@property (nonatomic, strong) PHAsset *photoAsset;
@property (nonatomic, strong) JPVideoModel *videoModel;
@property (nonatomic, strong) NSString *localId;
@property (nonatomic, assign) BOOL isInvalid;
@end
