//
//  JPCompositionManager.h
//  jper
//
//  Created by FoundaoTEST on 2017/7/7.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JPTag;
@class JPCompositionManager;
@protocol JPCompositionManagerDelegate <NSObject>

- (void)compositionStatusChangeed:(JPCompositionManager *)compositionManager;
- (void)compositionErrorWillBackToPage;
- (void)compositionErrorWillEndEdit;
@end

typedef NS_ENUM(NSInteger, JPCompositionType)
{
    JPCompositionTypeUnknow,
    JPCompositionTypeCompositioning,
    JPCompositionTypeCompositioned,
    JPCompositionTypeWaitUpload,
    JPCompositionTypeUploading,
    JPCompositionTypeUploaded,
    JPCompositionTypeuploadFaild,
    JPCompositionTypeSubmited,
    JPCompositionTypeSubmitError,
    JPCompositionTypeWaitedShare,
    JPCompositionTypeCompositionFaild
};

@interface JPCompositionManager : NSObject
@property (nonatomic, assign) BOOL toMyPage;
@property (nonatomic, strong) JPBaseCompositionPlayer *baseCompositionPlayer;
@property (nonatomic, strong) JPBaseVideoRecordInfo *baseRecordInfo;
@property (nonatomic) JPCompositionType compositinType;
@property (nonatomic, strong) NSArray *stickersArr;
@property (nonatomic, assign) BOOL isSecretVideo;
@property (nonatomic, assign) BOOL isPositionSecret;
@property (nonatomic) JPVideoAspectRatio  aspectRatio;
@property (nonatomic, assign) CGFloat compositionProgress;
@property (nonatomic, assign) CGFloat uploadProgress;
@property (nonatomic, weak) id<JPCompositionManagerDelegate>delegate;
@property (nonatomic, strong) NSString *currentVideoTitle;
@property (nonatomic, strong) NSArray <JPTag *> *currentTags;
@property (nonatomic, strong) JPTag *currentActiveTags;
@property (nonatomic, copy) NSString * filterName;
//新版任务
@property (nonatomic, copy) NSString  * manager_id;
@property (nonatomic, strong) id selectTaskModel;//可能为父任务 也可能为子任务
@property (nonatomic, copy) NSString  * task_id;
@property (nonatomic, copy) NSString  * item_id;
@property (nonatomic, copy) NSString *workName;//作品名称
@property (nonatomic, copy) NSString *workDesc;//作品视频简介
@property (nonatomic, copy) NSString *workDirector;//作品视频导演
@property (nonatomic, copy) NSString *workActor;//作品视频主演
@property (nonatomic, strong) NSArray *labelArr;//活动标签数组
@property (nonatomic, strong) NSArray *copyrightArr;//版权数组
///用于统计时区分短视频和影集
@property (nonatomic, assign) BOOL isAlbumVideo;

@property (nonatomic, strong) NSArray * labelIDArray;
@property (nonatomic, strong) NSArray * copyrightIDArray;
///神策统计
@property (nonatomic, copy) NSString *  task_name;
@property (nonatomic, copy) NSString *  videoaddMethod;
@property (nonatomic, assign) BOOL addFilter;
@property (nonatomic, assign) BOOL addPatterns;
@property (nonatomic, assign) BOOL addAudio;
@property (nonatomic, copy) NSString *  labels;

@property (nonatomic, copy) NSString *works_hope_id;//诉求类类型,诉求类必填
@property (nonatomic, copy) NSString *works_phone;//联系手机，诉求类必填
@property (nonatomic, strong) NSMutableArray *patternIdArr;//图案id数组
@property (nonatomic, strong) NSMutableArray *musicIdArr;//音乐id数组
@property (nonatomic, strong) NSMutableArray *soundIdArr;//音效id数组

@property (nonatomic, strong)  UIImage *firstThumbImage;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, weak) UIViewController *baseViewController;
@property (nonatomic, strong) NSURL *tenMinVideoUrl;
- (instancetype)initWithRecordInfo:(JPBaseVideoRecordInfo *)recordInfo andStikcerArr:(NSArray *)stickersArr;
- (void)destruction;

- (void)startComposition;
- (void)copiesLink;
- (void)shareToIns;
- (void)shareToMeiPai;
- (void)finishWithCompletion:(void(^)(void))completion;
- (void)generateTenMinueteVideoWithWithCompletion:(void(^)(BOOL sucess))completion;
- (void)submitVideoInfoWithCompletionBlock:(void (^)(BOOL success))completionHandler;
- (void)savedVideoToDB;

- (NSMutableDictionary *)configueDict;
- (void)updateInfoWithDict:(NSDictionary *)dict;

@end
