//
//  JPCompositionManager.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/7.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPCompositionManager.h"
//#import "JPSession.h"
//#import "JPMultiPartFileUploader.h"
#import <UIKit/UIKit.h>
//#import "JPTag.h"
//#import "JPUploadedVideoModel.h"
//#import "JPShareAccount.h"
//#import "JPAccountBindRulesViewController.h"
#import "JPErrorMessageView.h"
//#import "JPFourGMeesgaeView.h"
//#import "AFNetworkReachabilityManager.h"
#include <sys/param.h>
#include <sys/mount.h>
//#import "JPNewShareViewController.h"
//#import "PKActiveDetailModel.h"
//#import "PKTaskLabelModel.h"
//#import "PKCopyrightModel.h"

@interface JPCompositionManager ()<JPErrorMessageViewDelegate>
{
    NSString *uploadedCoverPath;
    NSString *uploadedVideoPath;
    NSString *videoTitle;
    NSString *sharedUrl;
    CMTime videoDuration;
    BOOL isPublish;
    BOOL isLocate;
    NSString *videoId;
    CGSize videoSize;
    int videoSegment;
    double videoLastProgress;
    NSDate *videoLastDate;
    NSString *sharedType;
    NSString *patterns;
    NSString *bgMusicName;
    NSString *shape;
    int recordAudioCount;
    BOOL isPausedUploading;
    BOOL isFirstLoad;
    NSString *cloudIds;
    NSString *startTimes;
    NSString *endTimes;
    NSString *ymzTypes;
    BOOL isFormat;
    long long videoFileSize;
    UIAlertView *failedAlert;
//    NSArray <JPTag *> *selectedTag;
    JPTag *selectedActiveTag;
    NSString *tagId;
    NSString *tagName;
}
@property (nonatomic, strong) NSURL *savedVideoAssetUrl;
//@property (nonatomic, strong) JPMultiPartFileUploader *videoFileUploader;
@property (nonatomic, strong) NSOperationQueue *uploadVideoQueue;
@property (nonatomic, strong) NSMutableDictionary *videoProgressDic;
@property (nonatomic, strong) AVAssetExportSession *exportSession;
@property (nonatomic, strong) JPErrorMessageView *errorMessageView;
//@property (nonatomic, strong) JPFourGMeesgaeView *fourGMeesgaeView;

//- (void)pushVideoToThirdPlatformWithType:(NSString *)type
//                           andSharedType:(JPShareAccountType)shareType
//                     withCompletionBlock:(void (^)(JPPushVideoStatusCode code, JPShareAccountType type))completionHandler;
@end

@implementation JPCompositionManager

- (void)setIsSecretVideo:(BOOL)isSecretVideo
{
    isPublish = isSecretVideo;
}

- (BOOL)isSecretVideo
{
    return isPublish;
}

- (void)setIsPositionSecret:(BOOL)isPositionSecret
{
    isLocate = isPositionSecret;
}

- (BOOL)isPositionSecret
{
    return isLocate;
}

//- (JPShareAccount *)getAccountWithAccountType:(JPShareAccountType)type andAuthUrl:(NSString *)url {
//
//    JPShareAccount *account = [[JPShareAccount alloc] init];
//    account.type = type;
//    account.authUrl = url;
//    account.rulesUrl = [JPUtil getRulesUrlWithShareType:type];
//    if (JPShareAccountTypeTouTiao == type) {
//        account.name = @"toutiao";
//        account.imageName = @"toutiao";
//        account.descriptionName = @"今日头条";
//    } else if (JPShareAccountTypeWeiBo == type){
//        account.name = @"weibo";
//        account.imageName = @"sina";
//        account.descriptionName = @"微博";
//    }else if (JPShareAccountTypeAiQiYi == type){
//        account.name = @"iqiyi";
//        account.imageName = @"aiqiyi";
//        account.descriptionName = @"爱奇艺";
//    }
//    return account;
//}



- (instancetype)initWithRecordInfo:(JPVideoRecordInfo *)recordInfo andStikcerArr:(NSArray *)stickersArr
{
    if (self = [super init]) {
        _compositinType = JPCompositionTypeUnknow;
        isFormat = NO;
        _baseRecordInfo = recordInfo;
        if (recordInfo.localPath) {
            _videoUrl = [NSURL fileURLWithPath:recordInfo.localPath];
        }
        _manager_id = recordInfo.recordId;
        _stickersArr = stickersArr;
        _videoProgressDic = [NSMutableDictionary dictionary];
//        _videoFileUploader = [[JPMultiPartFileUploader alloc] init];
        _uploadVideoQueue = [[NSOperationQueue alloc] init];
        _uploadVideoQueue.maxConcurrentOperationCount = 1;
        [self creteComposition];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeBackgound) name:UIApplicationDidEnterBackgroundNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successToAuth:) name:SUCCESSTOAUTHTHIRDPLATFORMNOTIFICATION object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faildToAuth:) name:FAILDTOAUTHTHIRDPLATFORMNOTIFICATION object:nil];
    }
    return self;
}


- (NSMutableDictionary *)configueDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.manager_id forKey:@"manager_id"];
    [dict setObject:self.task_id forKey:@"task_id"];
    [dict setObject:self.task_name forKey:@"task_name"];
    [dict setObject:self.videoaddMethod forKey:@"videoaddMethod"];
    [dict setObject:@(self.addPatterns) forKey:@"addPatterns"];
    [dict setObject:@(self.addAudio) forKey:@"addAudio"];
    [dict setObject:@(self.addFilter) forKey:@"addFilter"];
    if (self.item_id) {
        [dict setObject:self.item_id forKey:@"item_id"];
    }
    if (self.workName) {
        [dict setObject:self.workName forKey:@"workName"];
    }
    if (self.workDesc) {
        [dict setObject:self.workDesc forKey:@"workDesc"];
    }
    if (self.workDirector) {
        [dict setObject:self.workDirector forKey:@"workDirector"];
    }
    if (self.workActor) {
        [dict setObject:self.workActor forKey:@"workActor"];
    }
    if (self.labelIDArray && self.labelIDArray.count > 0) {
        [dict setObject:self.labelIDArray forKey:@"labelIDArray"];
    }else{
//        if (self.labelArr) {
//            NSMutableArray * labelIdArr = @[].mutableCopy;
//            for (PKTaskLabelModel *model in self.labelArr) {
//                [labelIdArr sgrAddObject:model.label_id];
//            }
//            self.labelIDArray = labelIdArr.copy;
//            [dict setObject:self.labelIDArray forKey:@"labelIDArray"];
//        }else{
//            [dict setObject:@[] forKey:@"labelIDArray"];
//        }
    }
    if (self.labels) {
        [dict setObject:self.labels forKey:@"labels"];
    }else{
//        if (self.labelArr) {
//            NSMutableArray * labelNameArray = @[].mutableCopy;
//            for (PKTaskLabelModel *model in self.labelArr) {
//                [labelNameArray sgrAddObject:model.label_name];
//            }
//            self.labels = [labelNameArray componentsJoinedByString:@","];
//            [dict setObject:self.labels forKey:@"labels"];
//        }else{
//            [dict setObject:@"" forKey:@"labels"];
//        }
    }
    if (self.copyrightIDArray && self.copyrightIDArray.count > 0) {
        [dict setObject:self.copyrightIDArray forKey:@"copyroghtIDArray"];
    }else{
//        if (self.copyrightArr) {
//            NSMutableArray * copyrightIdArr = @[].mutableCopy;
//            for (PKCopyrightModel *model in self.copyrightArr) {
//                [copyrightIdArr sgrAddObject:model.copr_id];
//            }
//            self.copyrightIDArray = copyrightIdArr.copy;
//            [dict setObject:self.copyrightIDArray forKey:@"copyroghtIDArray"];
//        }else{
//            [dict setObject:@[] forKey:@"copyroghtIDArray"];
//        }
    }
    if (self.works_hope_id) {
        [dict setObject:self.works_hope_id forKey:@"works_hope_id"];
    }
    if (self.works_phone) {
        [dict setObject:self.works_phone forKey:@"works_phone"];
    }
    if (self.patternIdArr) {
        [dict setObject:self.patternIdArr forKey:@"patternIdArr"];
    }
    if (self.musicIdArr) {
        [dict setObject:self.musicIdArr forKey:@"musicIdArr"];
    }
    if (self.soundIdArr) {
        [dict setObject:self.soundIdArr forKey:@"soundIdArr"];
    }

    return dict;
}

- (void)updateInfoWithDict:(NSDictionary *)dict{
    
    self.task_id = [dict objectForKey:@"task_id"];
    self.item_id = [dict objectForKey:@"item_id"];
    self.workName = [dict objectForKey:@"workName"];
    self.workDesc = [dict objectForKey:@"workDesc"];
    self.workDirector = [dict objectForKey:@"workDirector"];
    self.workActor = [dict objectForKey:@"workActor"];
    self.labelIDArray = [dict objectForKey:@"labelIDArray"];
    self.copyrightIDArray = [dict objectForKey:@"copyrightIDArray"];
    self.works_hope_id = [dict objectForKey:@"works_hope_id"];
    self.works_phone = [dict objectForKey:@"works_phone"];
    self.patternIdArr = ((NSArray*)[dict objectForKey:@"patternIdArr"]).mutableCopy;
    self.musicIdArr = ((NSArray*)[dict objectForKey:@"musicIdArr"]).mutableCopy;
    self.soundIdArr = ((NSArray*)[dict objectForKey:@"soundIdArr"]).mutableCopy;
    self.manager_id = [dict objectForKey:@"manager_id"];
    self.task_name = [dict objectForKey:@"task_id"];
    self.videoaddMethod = [dict objectForKey:@"videoaddMethod"];
    self.labels = [dict objectForKey:@"labels"];
    self.addFilter = ((NSNumber *)[dict objectForKey:@"addFilter"]).boolValue;
    self.addAudio = ((NSNumber *)[dict objectForKey:@"addAudio"]).boolValue;
    self.addPatterns = ((NSNumber *)[dict objectForKey:@"addPatterns"]).boolValue;
}

#pragma mark - notificaitons

//- (void)successToAuth:(NSNotification *)notification {
//    NSDictionary *info = notification.object;
//    JPShareAccountType type = (JPShareAccountType)[info sgrGetIntForKey:@"accountType"];
//    if (JPShareAccountTypeWeiBo == type) {
//        [self pushVideoToThirdPlatformWithType:sharedType
//                                 andSharedType:type
//                           withCompletionBlock:^(JPPushVideoStatusCode code,JPShareAccountType type){
//                               if (JPPushVideoStatusCodeInvalidToken == code) {
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                                   message:@"您的微博账号未绑定或绑定已过期，请绑定？"
//                                                                                  delegate:self
//                                                                         cancelButtonTitle:@"否"
//                                                                         otherButtonTitles:@"是", nil];
//                                   alert.tag = type;
//                                   [alert show];
//                               }
//                           }];
//    } else if (JPShareAccountTypeTouTiao == type){
//        [self pushVideoToThirdPlatformWithType:sharedType
//                                 andSharedType:type
//                           withCompletionBlock:^(JPPushVideoStatusCode code,JPShareAccountType type){
//                               if (JPPushVideoStatusCodeInvalidToken == code) {
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                                   message:@"您的头条账号未绑定或绑定已过期，请绑定？"
//                                                                                  delegate:self
//                                                                         cancelButtonTitle:@"否"
//                                                                         otherButtonTitles:@"是", nil];
//                                   alert.tag = type;
//                                   [alert show];
//                               }
//                           }];
//    }else if (JPShareAccountTypeAiQiYi == type){
//        [self pushVideoToThirdPlatformWithType:sharedType
//                                 andSharedType:type
//                           withCompletionBlock:^(JPPushVideoStatusCode code,JPShareAccountType type){
//                               if (JPPushVideoStatusCodeInvalidToken == code) {
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                                   message:@"您的爱奇艺账号未绑定或绑定已过期，请绑定？"
//                                                                                  delegate:self
//                                                                         cancelButtonTitle:@"否"
//                                                                         otherButtonTitles:@"是", nil];
//                                   alert.tag = type;
//                                   [alert show];
//                               }
//                           }];
//    }
//}
//
//- (void)faildToAuth:(NSNotification *)notification {
//    JPShareAccountType type = (JPShareAccountType)[[notification object] integerValue];
//    if (JPShareAccountTypeWeiBo == type) {
//        [MBProgressHUD jp_showMessage:@"微博账号绑定失败。"];
//    } else if (JPShareAccountTypeTouTiao == type){
//        [MBProgressHUD jp_showMessage:@"头条账号绑定失败。"];
//    }else if (JPShareAccountTypeAiQiYi == type){
//        [MBProgressHUD jp_showMessage:@"爱奇艺账号绑定失败。"];
//    }
//}

- (long long)getDivceSize{
    //可用大小
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    //总大小
    struct statfs buf1;
    long long maxspace = 0;
    if (statfs("/", &buf1) >= 0) {
        maxspace = (long long)buf1.f_bsize * buf1.f_blocks;
    }
    if (statfs("/private/var", &buf1) >= 0) {
        maxspace += (long long)buf1.f_bsize * buf1.f_blocks;
    }
    return freespace;
}

- (void)setCurrentVideoTitle:(NSString *)currentVideoTitle
{
    videoTitle = currentVideoTitle;
}

- (NSString *)currentVideoTitle
{
    return videoTitle;
}
- (void)creteComposition
{
    __weak typeof(self) weakSelf = self;
    if (weakSelf.videoUrl) {
        return;
    }
    if (_baseCompositionPlayer) {
        return;
    }
    _baseCompositionPlayer = _baseRecordInfo.getCompositionPlayer;
    [self formatVideoInfo];
    [_baseCompositionPlayer setUpdateProgressBlock:^(CGFloat progress){
        weakSelf.compositionProgress = progress;
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(compositionStatusChangeed:)]) {
            [weakSelf.delegate compositionStatusChangeed:weakSelf];
        }
    }];
}

- (void)startComposition
{
    if (_videoUrl == nil && _baseCompositionPlayer.isPlaying == NO) {
        __weak typeof(self) weakSelf = self;
        _compositinType = JPCompositionTypeCompositioning;
        [_baseCompositionPlayer stopRecordingMovieWithCompletion:^(NSURL *url) {
            NSURL *videoUrl = url;
            NSURL *originUrl = url;
            if (videoUrl == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(compositionErrorWillEndEdit)]) {
                        [self.delegate compositionErrorWillEndEdit];
                    }
                    weakSelf.compositinType = JPCompositionTypeCompositionFaild;
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(compositionStatusChangeed:)]) {
                        [weakSelf.delegate compositionStatusChangeed:weakSelf];
                    }
                });
                return ;
            }else{
                if ([self getDivceSize] < 500 * 1024 * 1024) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.delegate && [self.delegate respondsToSelector:@selector(compositionErrorWillEndEdit)]) {
                            [self.delegate compositionErrorWillEndEdit];
                        }
                        JPErrorMessageView *errorView = [[JPErrorMessageView alloc] initWithErrorType:JPErrorMessageViewTypeMemey];
                        errorView.delegate = self;
                    });
                    
                }
            }
            weakSelf.savedVideoAssetUrl = weakSelf.baseCompositionPlayer.savedAssetUrl;
            weakSelf.baseCompositionPlayer.updateProgressBlock = nil;
            weakSelf.videoUrl = originUrl;
            weakSelf.baseRecordInfo.localPath = originUrl.absoluteString;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.compositinType = JPCompositionTypeCompositioned;
                weakSelf.compositionProgress = 1.0;
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(compositionStatusChangeed:)]) {
                    [weakSelf.delegate compositionStatusChangeed:weakSelf];
                }
//                NSLog(@"%zd", [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus);
//                if (AFNetworkReachabilityStatusReachableViaWiFi == [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus){
//                    [self startUploadFile];
//                }else if(AFNetworkReachabilityStatusNotReachable != [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus){
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(compositionErrorWillEndEdit)]) {
//                        [self.delegate compositionErrorWillEndEdit];
//                    }
//                    long long fileSize;
//                    NSError *err = nil;
//                    NSFileHandle *handle = [NSFileHandle fileHandleForReadingFromURL:weakSelf.videoUrl error:&err];
//                    NSData *fileData = nil;
//                    fileData = [handle readDataToEndOfFile];
//                    fileSize = fileData.length;
//                    fileData = nil;
//                    [handle closeFile];
//                    videoFileSize = fileSize;
//                    NSString *msg = [NSString stringWithFormat:@"%0.2f",(float)fileSize/1024.f/1024.f];
//                    JPFourGMeesgaeView *forFMessageView = [[JPFourGMeesgaeView alloc] initWithFileByteStr:msg];
//                    forFMessageView.delegate = self;
//                    _fourGMeesgaeView = forFMessageView;
//                }else
//                {
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(compositionErrorWillEndEdit)]) {
//                        [self.delegate compositionErrorWillEndEdit];
//                    }
//                    [self fileUploaderDidFailToUploadFile:nil];
//                }
            });
            [weakSelf.baseCompositionPlayer destruction];
            weakSelf.baseCompositionPlayer = nil;
        }
         ];
        
    }
}

//- (void)fourGMeesgaeViewWillContinue:(BOOL)willContinue
//{
//    _fourGMeesgaeView = nil;
//    if (willContinue == YES) {
//        [self startUploadFile];
//    }else{
//        _toMyPage = YES;
////        if ([self.baseViewController isKindOfClass:[JPNewShareViewController class]]) {
////            [self fileUploaderDidPausedByUser:_videoFileUploader];
////        }
//    }
//
//}

- (void)errorViewWillDismiss:(JPErrorMessageView *)errorView
{
    if (errorView.errorType == JPErrorMessageViewTypeComposition) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(compositionErrorWillBackToPage)]) {
            [self.delegate compositionErrorWillBackToPage];
        }
    }else if(errorView.errorType == JPErrorMessageViewTypeNetwork){
//        if(errorView.tag == UPLOAD_FAILD_ALERT_TAG)
//        {
//            videoFileSize = _videoFileUploader.fileSize;
//            [self uploadFaildToSave];
//        }
    }
}

//- (void)setCurrentTags:(NSArray<JPTag *> *)currentTags
//{
//    selectedTag = currentTags;
//    tagId = @"";
//    tagName = @"";
//    for (JPTag *tag in selectedTag) {
//        if (tagId && tagId.length) {
//            tagId = [tagId stringByAppendingString:@","];
//        }
//        tagId = [tagId stringByAppendingString:tag.tagId];
//        if (tagName && tagName.length) {
//            tagName = [tagName stringByAppendingString:@","];
//        }
//        tagName = [tagName stringByAppendingString:tag.name];
//    }
//}




//- (NSArray <JPTag *> *)currentTags
//{
//    return selectedTag;
//}


- (void)setCurrentActiveTags:(JPTag *)currentActiveTags
{
    selectedActiveTag = currentActiveTags;
}

- (JPTag *)currentActiveTags
{
    return selectedActiveTag;
}

- (void)savedVideoToDB {
    [self savedVideoIntoDBWithFilePath:[self.videoUrl absoluteString] withVideoSize:videoFileSize];
    [self destructionTheCompositionPlayer];
    
}

- (void)savedVideoIntoDBWithFilePath:(NSString *)path withVideoSize:(long long)size{
    NSData *data = UIImageJPEGRepresentation(_firstThumbImage, 0.5);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];
    NSString *filter = self.filterName ? self.filterName: @"";
    //1:同意公开   2:不同意公开
    NSNumber *isSecrest = isPublish ? @(1) : @(2);
//    NSString *location = isLocate ? [JPSession sharedInstance].streetName: @"";
    CGFloat w = videoSize.width;
    CGFloat h = videoSize.height;
    NSString *title = videoTitle;
    if (title == nil || title.length == 0 || [title isEqualToString:@"杰出的作品都需要一个好名字"]) {
//        title = JP_VIDEO_SHARE_TITLE;
    }
    
//    NSString *activeId = selectedActiveTag ? selectedActiveTag.tagId: @"";
//    NSString *activeName = selectedActiveTag ? selectedActiveTag.name: @"";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic sgrSetObject:[path lastPathComponent] forKey:@"videoLocalPath"];
    [dic sgrSetObject:title forKey:@"title"];
    [dic sgrSetObject:encodedImageStr forKey:@"thumImage"];
    [dic sgrSetObject:isSecrest forKey:@"isSecret"];
    [dic sgrSetObject:@(CMTimeGetSeconds(videoDuration)) forKey:@"videoDuration"];
    [dic sgrSetObject:@(videoSegment) forKey:@"segment"];
    [dic sgrSetObject:filter forKey:@"filter"];
    [dic sgrSetObject:[NSNumber numberWithFloat:h] forKey:@"height"];
    [dic sgrSetObject:[NSNumber numberWithFloat:w] forKey:@"width"];
    [dic sgrSetObject:tagId forKey:@"tagId"];
    [dic sgrSetObject:tagName forKey:@"tagName"];
//    [dic sgrSetObject:location forKey:@"location"];
    [dic sgrSetObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"createDate"];
    [dic sgrSetObject:@(size) forKey:@"videoSize"];
//    if (activeId != nil) {
//        [dic sgrSetObject:activeId forKey:@"activityId"];
//    }
//    if (activeName != nil) {
//        [dic sgrSetObject:activeName forKey:@"activityName"];
//    }
    if (patterns && patterns.length) {
        [dic sgrSetObject:patterns forKey:@"element"];
    }
    if (shape && shape.length) {
        [dic sgrSetObject:shape forKey:@"shape"];
    }
    if (bgMusicName && bgMusicName.length) {
        [dic sgrSetObject:bgMusicName forKey:@"music"];
    }
    if (recordAudioCount > 0) {
        [dic sgrSetObject:@(recordAudioCount) forKey:@"recordCount"];
    }
//    JPUploadedVideoModel *model = [JPUploadedVideoModel mj_objectWithKeyValues:dic];
//    [model insertToDB];
}
#pragma mark - JPMultiPartFileUploaderDelegate

/* 文件上传失败 */
//- (void)fileUploaderDidFailToUploadFile:(JPMultiPartFileUploader *)uploader {
//    if (_errorMessageView) {
//        return;
//    }
//    dispatch_queue_t queue = dispatch_queue_create("data", 0);
//    dispatch_async(queue, ^{
//        self.compositinType = JPCompositionTypeuploadFaild;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            JPErrorMessageView *errorView = [[JPErrorMessageView alloc] initWithErrorType:JPErrorMessageViewTypeNetwork];
//            errorView.delegate = self;
//            errorView.tag = UPLOAD_FAILD_ALERT_TAG;
//            _errorMessageView = errorView;
//        });
//    });
//}
//
///*文件暂停上传 */
//- (void)fileUploaderDidPausedToUploadFile:(JPMultiPartFileUploader *)uploader {
//
//}
//
///* 文件分割成PartsCount个分片，准备上传 */
//- (void)fileUploader:(JPMultiPartFileUploader *)uploader willUploadFileWithNumberOfParts:(NSInteger)PartsCount {
//    if ([uploader isEqual:_videoFileUploader] && !isPausedUploading) {//上传视频
//        _compositinType = JPCompositionTypeUploading;
//        _uploadProgress = 0.0;
//        videoLastProgress = 0.f;//视频合成进度
//        videoLastDate = [NSDate date];
//    }
//    isPausedUploading = NO;
//}
//
///* 获取某个分片的上传进度 */
//- (void)fileUploader:(JPMultiPartFileUploader *)uploader UploadProgressed:(double)progress ofPartID:(NSInteger)partID {
//    if ([uploader isEqual:_videoFileUploader]) {//上传视频
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *key = [NSString stringWithFormat:@"%ld",(long)partID];
//            if ([[_videoProgressDic allKeys] containsObject:key]) {
//                CGFloat partPro = [[_videoProgressDic valueForKey:[NSString stringWithFormat:@"%ld",(long)partID]] floatValue];
//                if (partPro < progress) {
//                    [_videoProgressDic sgrSetObject:[NSString stringWithFormat:@"%f",progress] forKey:[NSString stringWithFormat:@"%ld",(long)partID]];
//                }
//            } else {
//                [_videoProgressDic sgrSetObject:[NSString stringWithFormat:@"%f",progress] forKey:[NSString stringWithFormat:@"%ld",(long)partID]];
//            }
//            double pro = 0.f;
//            for (NSString *key in [_videoProgressDic allKeys]) {
//                pro += [[_videoProgressDic valueForKey:key] doubleValue];
//            }
//            float p = pro/uploader.numberOfParts;
//
//            if (p > videoLastProgress) {//断点续传
//                NSDate *currentDate = [NSDate date];
//                double time = [currentDate timeIntervalSinceDate:videoLastDate];
//                if (time >= 1) {
//                    videoLastDate = currentDate;
//                    videoLastProgress = p;
//                    _uploadProgress = p;
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(compositionStatusChangeed:)]) {
//                        [self.delegate compositionStatusChangeed:self];
//                    }
//
//                }
//            }
//        });
//    }
//}
//
///* 某个分片上传完成 */
//- (void)fileUploader:(JPMultiPartFileUploader *)uploader didUploadedPartID:(NSInteger)partID descFilename:(NSString *)fileName {
//    if ([uploader isEqual:_videoFileUploader]) {//上传视频
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_videoProgressDic sgrSetObject:@"1.00000" forKey:[NSString stringWithFormat:@"%ld",(long)partID]];
//            double pro = 0.f;
//            for (NSString *key in [_videoProgressDic allKeys]) {
//                pro += [[_videoProgressDic valueForKey:key] doubleValue];
//            }
//            float p = pro/uploader.numberOfParts;
//            if (p > videoLastProgress) {//断点续传
//                videoLastProgress = p;
//                _uploadProgress = p;
//                if (self.delegate && [self.delegate respondsToSelector:@selector(compositionStatusChangeed:)]) {
//                    [self.delegate compositionStatusChangeed:self];
//                }
//            }
//        });
//    }
//}
//
///* 整个文件上传成功 */
//- (void)fileUploaderDidFinishUploadingFile:(JPMultiPartFileUploader *)uploader {
//    uploadedVideoPath = uploader.descFilename;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:uploader.filePathUrl]) {
//        [[NSFileManager defaultManager] removeItemAtPath:uploader.filePathUrl error:nil];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.compositinType = JPCompositionTypeWaitedShare;
//        self.uploadProgress = 1.0;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(compositionStatusChangeed:)]) {
//            [self.delegate compositionStatusChangeed:self];
//        }
//    });
//
//}
//
///* 放弃文件的上传 */
//- (void)fileUploaderDidAbort:(JPMultiPartFileUploader *)uploader {
//
//}
//
//- (void)fileUploaderDidPausedByUser:(JPMultiPartFileUploader *)uploader {
//    [self uploadFaildToSave];
//}
//
//- (void)uploadFaildToSave
//{
//    dispatch_queue_t queue = dispatch_queue_create("data", 0);
//    dispatch_async(queue, ^{
//        [self savedVideoIntoDBWithFilePath:[self.videoUrl absoluteString] withVideoSize:videoFileSize];
//        [self destructionTheCompositionPlayer];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            BOOL toHotList = NO;
//            [[NSNotificationCenter defaultCenter] postNotificationName:FINISHEDUPLOADVIDEOFAILNOTIFICATION object:[NSNumber numberWithBool:toHotList]];
//        });
//    });
//}

- (void)destructionTheCompositionPlayer
{
    [_baseCompositionPlayer destruction];
    [_baseCompositionPlayer setUpdateProgressBlock:nil];
    _baseCompositionPlayer = nil;
}

- (void)formatVideoInfo
{
    [self.musicIdArr removeAllObjects];
    [self.patternIdArr removeAllObjects];
    [self.soundIdArr removeAllObjects];
    _firstThumbImage = [_baseCompositionPlayer getThumbImage];
    //视频时长
    videoDuration = _baseCompositionPlayer.videoDuration;
    //视频分辨率
    videoSize = _baseCompositionPlayer.recordInfo.videoSize;
    //视频段数
    videoSegment = (int)[_baseRecordInfo videoCount];
    //滤镜名字
    self.filterName = _baseRecordInfo.filterCNName;
    //背景音乐
    bgMusicName = _baseRecordInfo.backgorudMusicFileName;
    if (_baseRecordInfo.backgorudMusicResouceId && _baseRecordInfo.backgorudMusicResouceId.length>0) {
        [self.musicIdArr addObject:_baseRecordInfo.backgorudMusicResouceId];
    }
    self.soundIdArr = [NSMutableArray arrayWithArray:_baseRecordInfo.soundsMusicArr];
    //录音段数
    recordAudioCount = (int)_baseRecordInfo.audioCount;
    patterns = @"";
    shape = @"";
    ymzTypes = @"";
    cloudIds = @"";
    startTimes = @"";
    endTimes = @"";
    tagId = @"";
    tagName = @"";
    for (int i =0; i < [_baseRecordInfo.soundsMusicArr count]; i ++) {
        JPAudioModel *model = (JPAudioModel *)[_baseRecordInfo.soundsMusicArr objectAtIndex:i];
        if (![self.soundIdArr containsObject:model.resource_id]) {//音效记录去重
            if (model.resource_id && model.resource_id.length>0) {
                [self.soundIdArr addObject:model.resource_id];
            }
        }
    }
    NSMutableArray *patternArr = [NSMutableArray array];
    for (int i =0; i < [_stickersArr count]; i ++) {
        @autoreleasepool {
            JPPackagePatternAttribute *model = (JPPackagePatternAttribute *)[_stickersArr objectAtIndex:i];
            if ([_baseCompositionPlayer isKindOfClass:[JPVideoCompositionPlayer class]]) {
                JPVideoCompositionPlayer *player = (JPVideoCompositionPlayer *)_baseCompositionPlayer;
                [player addPackagePattern:model];
            }
            if (![patternArr containsObject:model.patternName]) {//压条记录去重
                [patternArr addObject:model.patternName];
                if (model.resource_id && model.resource_id.length>0) {
                    [self.patternIdArr addObject:model.resource_id];
                }
            }
        }
    }
    for (NSString *str in patternArr) {
        @autoreleasepool {
            if ([str rangeOfString:@"P"].location != NSNotFound) {
                NSArray *arr = [[NSArray alloc] initWithArray:[str componentsSeparatedByString:@"P"]];
                if (shape && shape.length ) {
                    shape = [shape stringByAppendingString:@","];
                }
                shape = [shape stringByAppendingString:[arr lastObject]];
            }
            if ([str rangeOfString:@"F"].location != NSNotFound) {
                NSArray *arr = [[NSArray alloc] initWithArray:[str componentsSeparatedByString:@"F"]];
                if (patterns && patterns.length ) {
                    patterns = [patterns stringByAppendingString:@","];
                }
                patterns = [patterns stringByAppendingString:[arr lastObject]];
            }
            
        }
    }
    
    if ([_baseRecordInfo isKindOfClass:[JPVideoRecordInfo class]]) {
        JPVideoRecordInfo *recordInfo = (JPVideoRecordInfo *)_baseRecordInfo;
        for (JPVideoModel *model in recordInfo.videoSource) {
            @autoreleasepool {
                if (JPVideoSourceMediaCloud == model.sourceType) {
                    if (cloudIds && cloudIds.length ) {
                        cloudIds = [cloudIds stringByAppendingString:@","];
                    }
                    cloudIds = [cloudIds stringByAppendingString:model.cloudId];
                    
                    if (ymzTypes && ymzTypes.length ) {
                        ymzTypes = [ymzTypes stringByAppendingString:@","];
                    }
                    ymzTypes = [ymzTypes stringByAppendingString:@"1"];
                    
                    if (startTimes && startTimes.length ) {
                        startTimes = [startTimes stringByAppendingString:@","];
                    }
                    startTimes = [startTimes stringByAppendingString:[NSString stringWithFormat:@"%f",model.startTime]];
                    
                    if (endTimes && endTimes.length ) {
                        endTimes = [endTimes stringByAppendingString:@","];
                    }
                    endTimes = [endTimes stringByAppendingString:[NSString stringWithFormat:@"%f",model.endTime]];
                }
            }
        }
    }
  
}
- (void)appBecomeActive
{
//    if (_videoUrl == nil) {
//        [self creteComposition];
//        [self startComposition];
//    }
//    if (_videoUrl && !uploadedVideoPath) {
//        [self startUploadFile];
//    }
}


//- (void)startUploadFile
//{
//    if (_fourGMeesgaeView || _errorMessageView) {
//        return;
//    }
//    NSString *fileName = [NSString stringWithFormat:@"%@",[self.videoUrl lastPathComponent]];
//    if ([fileName rangeOfString:@".mp4"].location != NSNotFound) {
//        fileName = [[fileName componentsSeparatedByString:@".mp4"] firstObject];
//        if (fileName && fileName.length) {
//            fileName = [fileName md5];
//        }
//        fileName = [fileName stringByAppendingString:@".mp4"];
//    }
//    [self.videoFileUploader uploadFileAtUrl:[self.videoUrl absoluteString] fileName:fileName operationQueue:self.uploadVideoQueue delegate:self toCheckWWan:NO];
//
//}

- (void)appBecomeBackgound
{
 
//    [self destructionTheCompositionPlayer];
//    if (_videoUrl == nil) {
//        _compositinType = JPCompositionTypeUnknow;
//        _compositionProgress = 0.0;
//    }
//
//    if ( _uploadVideoQueue.operationCount) {
//        isPausedUploading = YES;
//        _videoFileUploader.delegate = nil;
//        UIApplication *application = [UIApplication sharedApplication];
//        __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//            [application endBackgroundTask:bgTask];
//            bgTask = UIBackgroundTaskInvalid;
//        }];
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [_videoFileUploader cancel];
//            [application endBackgroundTask:bgTask];
//            bgTask = UIBackgroundTaskInvalid;
//        });
//    }
}



- (void)destruction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self destructionTheCompositionPlayer];
//    [_videoFileUploader cancel];
    [_uploadVideoQueue cancelAllOperations];
    
}

- (void)generateTenMinueteVideoWithWithCompletion:(void (^)(BOOL))completion
{
    self.baseViewController.view.userInteractionEnabled = NO;
    [self.baseViewController jp_showHUD];
    self.tenMinVideoUrl = [JPVideoUtil fileURLForDocumentMovieMP4];
    CMTime nextClistartTime = kCMTimeZero;
    NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    AVMutableComposition *comsition = [AVMutableComposition composition];
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:_videoUrl options:inputOptions];
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(10, 1));
    AVMutableCompositionTrack *videoTrack = [comsition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];
    if ([videoAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
        //音频通道
        AVMutableCompositionTrack * audioTrack = [comsition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        //音频采集通道
        AVAssetTrack * audioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        //加入合成轨道中
        [audioTrack insertTimeRange:videoTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
    }
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    //创建输出
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:comsition presetName:AVAssetExportPresetHighestQuality];
    assetExport.outputURL = self.tenMinVideoUrl;//输出路径
    assetExport.outputFileType = AVFileTypeMPEG4;//输出类型
    assetExport.shouldOptimizeForNetworkUse = YES;
    assetExport.videoComposition = mainCompositionInst;
    ALAssetsLibrary *assersLibrary = [[ALAssetsLibrary alloc] init];
    _exportSession = assetExport;
    __weak typeof(_exportSession) weakAssetExport = _exportSession;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakAssetExport.status == AVAssetExportSessionStatusFailed) {
                completion(NO);
            }else if (weakAssetExport.status == AVAssetExportSessionStatusCompleted)
            {
                [assersLibrary saveVideo:self.tenMinVideoUrl toAlbum:@"未来拍客" completion:^(NSURL *assetURL, NSError *error) {
                    completion(YES);
                } failure:^(NSError *error) {
                    completion(NO);
                }];
                
            }
            self.baseViewController.view.userInteractionEnabled = YES;
            [self.baseViewController jp_hideHUD];
        });
    }];
    
}


//- (void)pushLocalVideoToShareType:(JPShareAccountType)shareType
//{
//    [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:@"weixin://"]];
//}



//- (void)shareLinkToShareType:(JPShareAccountType)shareType
//{
//    if ([JPUtil installMessageWithPlatform:shareType] == NO) {
//        return;
//    }
//    UMSocialPlatformType platformtype = UMSocialPlatformType_WechatSession;
//    switch (shareType) {
//        case JPShareAccountTypeWeiXin:
//            sharedType = @"weixin";
//            platformtype = UMSocialPlatformType_WechatSession;
//            break;
//        case JPShareAccountTypePengYouQuan:
//            sharedType = @"friend";
//            platformtype = UMSocialPlatformType_WechatTimeLine;
//            break;
//        case JPShareAccountTypeWeiBo:
//            sharedType = @"weibo";
//            platformtype = UMSocialPlatformType_Sina;
//            break;
//        case JPShareAccountTypeQQZone:
//            sharedType = @"qzone";
//            platformtype = UMSocialPlatformType_Qzone;
//            break;
//        default:
//            break;
//    }
//    shareAccountType = shareType;
//    __weak typeof(self) weakSelf = self;
//    [self submitVideoInfoWithCompletionBlock:^(BOOL success){
//        if (success) {
//            [weakSelf shareWebPageToPlatformType:platformtype];
//        }
//    }];
//
//}

//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
//    NSString *des = videoTitle;
//    if (des == nil || des.length == 0 || [des isEqualToString:@"杰出的作品都需要一个好名字"]) {
//        des = JP_VIDEO_SHARE_TITLE;
//    }
//    UIImage *img = [JPUtil zoomImage:self.firstThumbImage toScale:CGSizeMake(100, 100)];
//    NSString *linkUrl;
//    if (videoId && videoId.length) {
//        //设置网页地址
//        linkUrl = [NSString stringWithFormat:@"%@?uuid=%@&app_version=%@",kShareUrl,videoId, JP_APP_VERSION];
//    } else {
//        //设置网页地址
//        linkUrl = kShareUrl;
//    }
//    NSString *tittle = @"我的蕉片作品";
//    if ([JPUserInfo shareInstance].isLogin && [JPUserInfo shareInstance].user_nickname && [JPUserInfo shareInstance].user_nickname.length) {
//        tittle = [NSString stringWithFormat:@"%@的蕉片作品",[JPUserInfo shareInstance].user_nickname];
//    }
//    [JPUtil shareWebPageWithType:platformType
//                       andTittle:tittle
//                      andLinkUrl:linkUrl
//                         andDesc:des
//                     andThumbImg:img
//                       andImgUrl:nil
//                   andSharedType:sharedType
//                      andVideoId:videoId];
//}
//
//- (void)uploadFail
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        JPErrorMessageView *errorView = [[JPErrorMessageView alloc] initWithErrorType:JPErrorMessageViewTypeNetwork];
//        errorView.delegate = self;
//    });
//
//}


//- (void)submitVideoInfoWithCompletionBlock:(void (^)(BOOL success))completionHandler {
//    if (MAX_TOU_TIAO_CONTENT_LENGTH < videoTitle.length){
//        [MBProgressHUD jp_showMessage:@"标题至多不超过20个字符，请重新输入。"];
//        return;
//    }
//    if (!uploadedVideoPath) {
//        if (completionHandler) {
//            [self uploadFail];
//            completionHandler(NO);
//        }
//        return;
//    } else if (videoId){
//        if (completionHandler) {
//            completionHandler(YES);
//        }
//        return;
//    }
//    NSString *activeId = selectedActiveTag.tagId ? selectedActiveTag.tagId : nil;
//    [self.baseViewController jp_showHUD];
//    self.baseViewController.view.userInteractionEnabled = NO;
//    NSString *filter = self.filterName ? self.filterName: @"";
//    NSString *url = [NSString stringWithFormat:@"%@user/submit-video-info",API_HOST];
//    //1:同意公开   2:不同意公开
//    NSNumber *isSecrest = isPublish ? @(1) : @(2);
////    NSString *location = isLocate ? [JPSession sharedInstance].streetName: @"";
//    CGFloat w = videoSize.width;
//    CGFloat h = videoSize.height;
//    NSString *title = videoTitle;
//    if (title == nil || title.length == 0 || [title isEqualToString:@"杰出的作品都需要一个好名字"]) {
//        title = JP_VIDEO_SHARE_TITLE;
//    }
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic sgrSetObject:[JPUserInfo shareInstance].token forKey:@"token"];
//    [dic sgrSetObject:uploadedVideoPath forKey:@"video_url"];
//    [dic sgrSetObject:title forKey:@"title"];
//    [dic sgrSetObject:isSecrest forKey:@"is_secret"];
//    [dic sgrSetObject:@(CMTimeGetSeconds(videoDuration)) forKey:@"video_len"];
//    [dic sgrSetObject:@(videoSegment) forKey:@"segment"];
//    [dic sgrSetObject:filter forKey:@"video_filter"];
//    [dic sgrSetObject:[NSNumber numberWithFloat:h] forKey:@"height"];
//    [dic sgrSetObject:[NSNumber numberWithFloat:w] forKey:@"width"];
//    [dic sgrSetObject:tagId forKey:@"tag_id"];
//    [dic sgrSetObject:location forKey:@"location"];
//    if (activeId != nil) {
//        [dic sgrSetObject:activeId forKey:@"activity_id"];
//    }
//    if (patterns && patterns.length) {
//        [dic sgrSetObject:patterns forKey:@"video_element"];
//    }
//    if (shape && shape.length) {
//        [dic sgrSetObject:shape forKey:@"shape"];
//    }
//    if (bgMusicName && bgMusicName.length) {
//        [dic sgrSetObject:bgMusicName forKey:@"music"];
//    }
//    if (recordAudioCount > 0) {
//        [dic sgrSetObject:@(recordAudioCount) forKey:@"recording"];
//    }
//    [JPUtil requestBodyAddParameterWithDic:dic];
//    [JPService requestWithURLString:url
//                         parameters:dic
//                               type:JPHttpRequestTypePost
//                            success:^(JPResultBase *response){
//                                self.baseViewController.view.userInteractionEnabled = YES;
//                                [self.baseViewController jp_hideHUD];
//                                if (response && 0 == [response.code intValue]) {
//                                    if (response.data && [response.data isKindOfClass:[NSDictionary class]]) {
//                                        videoId = [response.data valueForKey:@"uuid"];
//                                        if (videoId && videoId.length) {
//                                            [self videoRecord];
//                                        }
//                                        if (completionHandler) {
//                                            completionHandler(YES);
//                                            return ;
//                                        }
//                                    }
//                                }
//                                if (completionHandler) {
//                                    [self uploadFail];
//                                    completionHandler(NO);
//                                }
//                            }failure:^(NSError *error){
//                                self.baseViewController.view.userInteractionEnabled = YES;
//                                [self.baseViewController jp_hideHUD];
//                                if (completionHandler) {
//                                    [self uploadFail];
//                                    completionHandler(NO);
//                                }
//                            } withErrorMsg:nil];
//}


- (void)videoRecord {
//    NSString *url = [NSString stringWithFormat:@"%@user/video-case",API_HOST];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic sgrSetObject:[JPUserInfo shareInstance].token forKey:@"token"];
//    if (ymzTypes && ymzTypes.length) {
//        [dic sgrSetObject:ymzTypes forKey:@"ymz_type"];
//    }
//    if (cloudIds && cloudIds.length) {
//        [dic sgrSetObject:cloudIds forKey:@"cloud_id"];
//    }
//    if (startTimes && startTimes.length) {
//        [dic sgrSetObject:startTimes forKey:@"start_time"];
//    }
//    if (endTimes && endTimes.length) {
//        [dic sgrSetObject:endTimes forKey:@"end_time"];
//    }
//    NSString *filter = self.filterName ? self.filterName: @"";
//    [dic sgrSetObject:filter forKey:@"video_filter"];
//    if (patterns && patterns.length) {
//        [dic sgrSetObject:patterns forKey:@"video_element"];
//    }
//    if (shape && shape.length) {
//        [dic sgrSetObject:shape forKey:@"shape"];
//    }
//    if (bgMusicName && bgMusicName.length) {
//        [dic sgrSetObject:bgMusicName forKey:@"music"];
//    }
//    [dic sgrSetObject:videoId forKey:@"uuid"];
//    [JPUtil requestBodyAddParameterWithDic:dic];
//    [JPService requestWithURLString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response){
//        if (response.code && 0 == [response.code intValue]) {
//
//        } else {
//
//        }
//
//    }failure:^(NSError *error){
//
//    } withErrorMsg:nil];
}


//- (void)copiesLink
//{
//    [self submitVideoInfoWithCompletionBlock:^(BOOL success) {
//        if (success) {
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            NSString *linkUrl;
//            if (videoId && videoId.length) {
//                //设置网页地址
//                linkUrl = [NSString stringWithFormat:@"%@?uuid=%@&app_version=%@",kShareUrl,videoId, JP_APP_VERSION];
//            } else {
//                //设置网页地址
//                linkUrl = kShareUrl;
//            }
//            pasteboard.string = linkUrl;
//            [MBProgressHUD jp_showMessage:@"已复制内容到剪切板"];
//        }
//    }];
//}


//- (void)shareToIns
//{
//    if ([JPUtil installMessageWithPlatform:JPShareAccountTypeIns] == NO) {
//        return;
//    }
//    
//    if (!self.savedVideoAssetUrl) {
//        return;
//    }
//    NSString *assetUrl = [self.savedVideoAssetUrl absoluteString];
//    NSString *caption = @"caption";
//    NSURL *instagramURL = [NSURL URLWithString:
//                           [NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@",
//                            [assetUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]],
//                            [caption stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]]
//                           ];
//    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//        [[UIApplication sharedApplication] openURL:instagramURL];
//    }else {
//        NSLog(@"Can't open Instagram");
//    }
//}
//
//- (void)shareToMeiPai
//{
//    if ([JPUtil installMessageWithPlatform:JPShareAccountTypeBeatifulTakePhoto] == NO) {
//        return;
//    }
//    if (!self.savedVideoAssetUrl) {
//        return;
//    }
//    [MPShareSDK shareVideoAtPathToMeiPai:self.savedVideoAssetUrl];
//}

//- (void)shareToBindWithShareType:(JPShareAccountType)accountType
//{
//    NSString *account = @"头条账号";
//    switch (accountType) {
//        case JPShareAccountTypeAiQiYi:
//            sharedType = @"iqiyi";
//            account = @"爱奇艺账号";
//            break;
//        case JPShareAccountTypeTouTiao:
//            sharedType = @"toutiao";
//            break;
//        case JPShareAccountTypeWeiBo:
//            sharedType = @"weibo";
//            account = @"微博账号";
//            break;
//        default:
//            break;
//    }
//    shareAccountType = accountType;
//    __weak typeof(self) weakSelf = self;
//    //    [self submitVideoInfoWithCompletionBlock:^(BOOL success){
//    //        if (success) {
//    [weakSelf pushVideoToThirdPlatformWithType:sharedType
//                                 andSharedType:accountType
//                           withCompletionBlock:^(JPPushVideoStatusCode code,JPShareAccountType type){
//                               if (JPPushVideoStatusCodeInvalidToken == code) {
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                                   message:[NSString stringWithFormat:@"您的%@未绑定或绑定已过期，请绑定？", account]
//                                                                                  delegate:self
//                                                                         cancelButtonTitle:@"否"
//                                                                         otherButtonTitles:@"是", nil];
//                                   alert.tag = type;
//                                   [alert show];
//                               }
//                           }];
//    //        }
//    //    }];
//    
//}
//
//- (void)pushVideoToThirdPlatformWithType:(NSString *)type
//                           andSharedType:(JPShareAccountType)shareType
//                     withCompletionBlock:(void (^)(JPPushVideoStatusCode code, JPShareAccountType t))completionHandler{
//    self.baseViewController.view.userInteractionEnabled = NO;
//    [self.baseViewController jp_showHUD];
//    if (!videoId || !videoId.length) {
//        [self.baseViewController jp_hideHUD];
//        [self.baseViewController.view setUserInteractionEnabled:YES];
//        [MBProgressHUD jp_showMessage:@"推送失败!"];
//        if (completionHandler) {
//            completionHandler(JPPushVideoStatusCodeFailed,shareType);
//        }
//        return;
//    }
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic sgrSetObject:[JPUserInfo shareInstance].token forKey:@"token"];
//    [dic sgrSetObject:videoId forKey:@"uuid"];
//    [dic sgrSetObject:type forKey:@"type"];
//    NSString *url = [NSString stringWithFormat:@"%@user/push",API_HOST];
//    [JPService requestWithURLString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response){
//        [self.baseViewController jp_hideHUD];
//        [self.baseViewController.view setUserInteractionEnabled:YES];
//        if (response.code && 0 == [response.code intValue]) {
//            [MBProgressHUD jp_showMessage:@"推送成功!"];
//            if (completionHandler) {
//                completionHandler(JPPushVideoStatusCodeSuccess,shareType);
//            }
//        } else if(response.code && JPPushVideoStatusCodeIsPushed == [response.code intValue]){
//            [MBProgressHUD jp_showMessage:response.msg];
//            if (completionHandler) {
//                completionHandler(JPPushVideoStatusCodeFailed,shareType);
//            }
//        }else if(response.code && JPPushVideoStatusCodeInvalidToken == [response.code intValue]) {
//            if (completionHandler) {
//                completionHandler(JPPushVideoStatusCodeInvalidToken,shareType);
//            }
//        } else {
//            [MBProgressHUD jp_showMessage:@"推送失败!"];
//            if (completionHandler) {
//                completionHandler(JPPushVideoStatusCodeFailed,shareType);
//            }
//        }
//        
//    }failure:^(NSError *error){
//        [self.baseViewController jp_hideHUD];
//        [self.baseViewController.view setUserInteractionEnabled:YES];
//        if (completionHandler) {
//            completionHandler(JPPushVideoStatusCodeFailed,shareType);
//        }
//    } withErrorMsg:@"推送出错啦!"];
//}


- (void)finishWithCompletion:(void (^)(void))completion
{
    [self destructionTheCompositionPlayer];
    [self submitVideoInfoWithCompletionBlock:^(BOOL success){
        completion();
    }];
    
}


- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }else if ([object isKindOfClass:[self class]])
    {
        JPCompositionManager * manager = (JPCompositionManager *)object;
        if ([manager.manager_id isEqualToString:self.manager_id]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

- (NSUInteger)hash
{
    return [_manager_id integerValue];
}


- (NSURL *)tenMinVideoUrl
{
    if (_tenMinVideoUrl == nil) {
        if (CMTimeCompare(_baseCompositionPlayer.videoDuration, CMTimeMake(10, 1)) < 0) {
            self.tenMinVideoUrl = _videoUrl;
        }
    }
    return _tenMinVideoUrl;
}

- (void)dealloc
{
    
}

- (JPVideoAspectRatio)aspectRatio
{
    
    return _baseRecordInfo.aspectRatio;
}

- (NSMutableArray *)patternIdArr {
    if (!_patternIdArr) {
        _patternIdArr = [NSMutableArray array];
    }
    return _patternIdArr;
}

- (NSMutableArray *)musicIdArr {
    if (!_musicIdArr) {
        _musicIdArr = [NSMutableArray array];
    }
    return _musicIdArr;
}

- (NSMutableArray *)soundIdArr {
    if (!_soundIdArr) {
        _soundIdArr = [NSMutableArray array];
    }
    return _soundIdArr;
}

@end
