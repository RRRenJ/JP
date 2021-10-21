//
//  JPAblumSourceViewController.m
//  jper
//
//  Created by FoundaoTEST on 2017/5/22.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPAblumSourceViewController.h"
#import <Photos/Photos.h>
#import "JPLocalFileCollectionViewCell.h"
#import "JPVideoClipViewController.h"
#import "JPPhotoEditViewController.h"
#import "JPAlertView.h"

static PHImageRequestOptions *requestOptions;

@interface JPAblumSourceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,PHPhotoLibraryChangeObserver, JPVideoClipViewControllerDelegate> {
    JPAlertView *avauthAlertView;
    MJRefreshAutoNormalFooter *refreshFooter;
    NSInteger pageCount;
    NSInteger currentIndex;
    BOOL isFirstLoad;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *reallydata;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@end

@implementation JPAblumSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = NO;
    if (!requestOptions) {
        requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.synchronous = YES;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    }
    pageCount = 30;
    currentIndex = 0;
    _dataSource = [NSMutableArray array];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((JP_SCREEN_WIDTH - 46)/3, (JP_SCREEN_WIDTH - 46)/3);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(JPScreenFitFloat6(15), self.navagatorView.bottom + JPScreenFitFloat6(15) , JP_SCREEN_WIDTH - JPScreenFitFloat6(30),JP_SCREEN_HEIGHT - self.navagatorView.bottom - JPScreenFitFloat6(100)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.backgroundColor = self.view.backgroundColor;
    _collectionView.dataSource = self;
    _collectionView.bounces = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"JPLocalFileCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:@"JPLocalFileCollectionViewCell"];
    [self.view addSubview:_collectionView];
    _collectionView.sd_layout.topSpaceToView(self.view, 5).bottomSpaceToView(self.view, 10).leftSpaceToView(self.view, 13).rightSpaceToView(self.view, 13);
    [_collectionView reloadData];
    if (!refreshFooter) {
        refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
        [refreshFooter setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
    }
    _collectionView.mj_footer = refreshFooter;
    [self loadSource];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    if (_fetchResult == nil || _fetchResult.count == 0) {
        [self loadSource];
    }else{
       PHFetchResultChangeDetails *details = [changeInstance changeDetailsForFetchResult:_fetchResult];
        if (details.hasIncrementalChanges == YES) {
            [self loadSource];
        }
    }
}

- (void)reloadResourceData
{
    if (_collectionView.mj_footer.isRefreshing) {
        [_collectionView.mj_footer endRefreshing];
    }
    currentIndex = 0;
    _reallydata = [NSMutableArray array];
    [self requestMoreData];
}

- (void)requestMoreData
{
    NSInteger startIndex = currentIndex * pageCount;
    NSArray *data = _dataSource.copy;
    if (data.count > startIndex) {
        if (data.count - startIndex <= pageCount) {
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
            [_reallydata addObjectsFromArray:[data subarrayWithRange:NSMakeRange(startIndex, data.count - startIndex)]];
        }else{
            [_reallydata addObjectsFromArray:[data subarrayWithRange:NSMakeRange(startIndex, pageCount)]];
        }
    }
    NSTimeInterval restTime = 0;
    if (_fromPackage) {
        restTime = CMTimeGetSeconds([self.delegate ablumSourceViewControllerNeedGetResetTime]);
    }
    for (NSInteger index = startIndex; index < _reallydata.count; index ++) {
        JPLocalFileModel *localModel = _reallydata[index];
        localModel.isInvalid = NO;
        if (_fromPackage && ((localModel.duration > restTime && _type == JPAssetTypeVideo) || restTime < 2.0)) {
            localModel.isInvalid = YES;
        }
        [self requestThumbImageWithAsset:localModel.photoAsset andFileModel:localModel];
    }
    [_collectionView reloadData];
    if (_collectionView.mj_footer.isRefreshing) {
        [_collectionView.mj_footer endRefreshing];
    }
    currentIndex++;
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - 

- (void)showAVAuthAlertView {
    if (!avauthAlertView) {
        NSString *str = @"让大家看看手机里的精美素材吧~请在「设置」-「隐私」-「照片」中打开未来拍客的本地图库获取权限";
        avauthAlertView = [[JPAlertView alloc] initWithTitle:str
                                                    andFrame:CGRectMake(0, 0, JP_SCREEN_WIDTH, JP_SCREEN_WIDTH)];
    }
    if (![self.view.subviews containsObject:avauthAlertView]) {
        [self.view addSubview:avauthAlertView];
        avauthAlertView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(JP_SCREEN_WIDTH).heightIs(JP_SCREEN_WIDTH);
    }
}

- (void)hiddenAVAuthAlertView {
    [avauthAlertView removeFromSuperviewAndClearAutoLayoutSettings];
}

- (void)loadSource
{
    @synchronized (self) {
        _dataSource = [NSMutableArray array];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHAssetMediaType mediaType = PHAssetMediaTypeImage;
            if (self.type == JPAssetTypeVideo) {
                mediaType = PHAssetMediaTypeVideo;
            }
            PHFetchResult *smartAlbums = [PHAsset fetchAssetsWithMediaType:mediaType options:option];
            self.fetchResult = smartAlbums;
            for (int i = 0; i < smartAlbums.count; i++) {
                @autoreleasepool {
                    PHAsset *originAsset = [smartAlbums objectAtIndex:i];
                    if (originAsset) {
                        JPLocalFileModel *model = [[JPLocalFileModel alloc] init];
                        model.photoAsset = originAsset;
                        if (((CGFloat)originAsset.pixelHeight) > ((CGFloat)originAsset.pixelWidth)) {
                            model.aspectRatio = JPVideoAspectRatio9X16;
                        }else if (((CGFloat)originAsset.pixelWidth) / ((CGFloat)originAsset.pixelHeight) >= (16.0 / 10.0)){
                            model.aspectRatio = JPVideoAspectRatio16X9;
                        }else if (originAsset.pixelWidth == originAsset.pixelHeight){
                            model.aspectRatio = JPVideoAspectRatio1X1;
                        }else{
                            model.aspectRatio = JPVideoAspectRatio4X3;
                            
                        }
                        model.duration = originAsset.duration;
                        model.createTimeInterval = [originAsset.creationDate timeIntervalSince1970];
                        model.movieName = [NSString stringWithFormat:@"%.0f",[originAsset.creationDate timeIntervalSince1970]];
                        if (originAsset.mediaType == PHAssetMediaTypeImage && self.type == JPAssetTypePhoto && ([originAsset respondsToSelector:@selector(sourceType)] == NO || originAsset.sourceType == PHAssetSourceTypeUserLibrary)) {
                            model.type = JPAssetTypePhoto;
                            model.localId = originAsset.localIdentifier;
                            [self.dataSource addObject:model];
                        }else if (originAsset.mediaType == PHAssetMediaTypeVideo && self.type == JPAssetTypeVideo){
                            if (self.isTempalte == NO) {
                                self.minTime = JP_VIDEO_MIN_DURATION;
                            }
                            if ( model.duration >= CMTimeGetSeconds(self.minTime)) {
                                model.type = JPAssetTypeVideo;
                                model.localId = originAsset.localIdentifier;
                                [self.dataSource addObject:model];
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                @synchronized (self) {
                   [self reloadResourceData];
                }
            });
        });
 
    }
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)requestThumbImageWithAsset:(PHAsset *)asset andFileModel:(JPLocalFileModel *)model
{
    if (model.thumImage) {
        return;
    }
    @autoreleasepool {
        PHImageManager *imageManager = [PHImageManager defaultManager];
        CGSize imageSize = CGSizeMake(floorf((JP_SCREEN_WIDTH - 46)/3 * 1.4) , floorf((JP_SCREEN_WIDTH - 46)/3 * 1.4)  );
        [imageManager requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeDefault options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            model.thumImage = result;
        }];
    }
}


- (void)updateModel:(JPLocalFileModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _reallydata.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= _reallydata.count) {
        return nil;
    }
    JPLocalFileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPLocalFileCollectionViewCell" forIndexPath:indexPath];
    JPLocalFileModel *localfileModel = _reallydata[indexPath.item];
    localfileModel.isSelect = NO;
    if (_fromPackage) {
        JPLocalFileModel *selectModel = [self.delegate ablumSourceViewControllerIsSelectThisVideoModel:localfileModel];
        if (selectModel) {
            localfileModel.isSelect = YES;
            localfileModel.selectIndex = selectModel.selectIndex;
        }
    }
    cell.fileModel = localfileModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPLocalFileModel *fileModel = [_reallydata objectAtIndex:indexPath.item];
    if (fileModel.isInvalid == YES && fileModel.isSelect == NO) {
        return;
    }
    if (_type == JPAssetTypePhoto) {
        [self requestOriginPhotoWithLocalfile:fileModel];
    }else{
        [self requestVideoAssetWithLocalfile:fileModel];
    }
}


- (void)requestVideoAssetWithLocalfile:(JPLocalFileModel *)fileModel
{
    if (_fromPackage) {
        JPLocalFileModel *selectfileModel = [self.delegate ablumSourceViewControllerIsSelectThisVideoModel:fileModel];
        if (selectfileModel) {
            [self setFileModelDesSelect:fileModel];
            return;
        }
    }
    if (fileModel.videoModel) {
        [self requestVideoSuccessWith:fileModel];
        return;
    }
    [self configueRateVideo:fileModel];
}


- (void)configueRateVideo:(JPLocalFileModel *)fileModel
{
    [self jp_showHUD];
    self.baseNavigationController.view.userInteractionEnabled = NO;
    PHImageManager *asserManager = [PHImageManager defaultManager];
    [asserManager requestExportSessionForVideo:fileModel.photoAsset options:nil exportPreset:AVAssetExportPresetHighestQuality resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        
        if (!exportSession && [info objectForKey:PHImageResultIsInCloudKey]) {
            PHVideoRequestOptions * options = [[PHVideoRequestOptions alloc]init];
            options.networkAccessAllowed = YES;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            options.version = PHVideoRequestOptionsVersionOriginal;
            [[PHImageManager defaultManager] requestAVAssetForVideo:fileModel.photoAsset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
                AVURLAsset *videoAsset = (AVURLAsset*)avasset;
                [self startExportVideoWithVideoAsset:videoAsset fileModel:fileModel];
            }];
            
        }else{
            NSString *baseAname = [JPVideoUtil fileNameForDocumentMovie];
            exportSession.outputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:baseAname]];
            exportSession.outputFileType = AVFileTypeQuickTimeMovie;
            exportSession.shouldOptimizeForNetworkUse = YES;
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
                    AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:baseAname]] options:inputOptions];
                    if (inputAsset != nil) {
                        if (CMTimeCompare(inputAsset.duration, JP_VIDEO_MIN_DURATION) >= 0) {
                            JPVideoModel *videoModel = [[JPVideoModel alloc] init];
                            videoModel.videoTime = inputAsset.duration;
                            videoModel.videoBaseFile = baseAname;
                            videoModel.sourceType = JPVideoSourceLocal;
                            videoModel.originThumbImage = fileModel.thumImage;
                            videoModel.aspectRatio = fileModel.aspectRatio;
                            videoModel.movieName = fileModel.movieName;
                            videoModel.timeRange = CMTimeRangeMake(kCMTimeZero, inputAsset.duration);
                            fileModel.videoModel = videoModel;
                            [self requestVideoSuccessWith:fileModel];
                        }else {
                            [self jp_hideHUD];
                            [MBProgressHUD jp_showMessage:@"导入视频不能少于3秒"];
                            
                        }
                    }else
                    {
                        [self requesetRateVideofail];
                    }
                }else if (exportSession.status == AVAssetExportSessionStatusFailed)
                {
                    [self requesetRateVideofail];
                }
            }];
        }
    }];
}

- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset fileModel:(JPLocalFileModel *)fileModel {
    // Find compatible presets by video asset.
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    
    // Begin to compress video
    // Now we just compress to low resolution if it supports
    // If you need to upload to the server, but server does't support to upload by streaming,
    // You can compress the resolution to lower. Or you can support more higher resolution.
    if ([presets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
    
        NSString *baseAname = [JPVideoUtil fileNameForDocumentMovie];
        NSString *outputPath = [NSHomeDirectory() stringByAppendingPathComponent:baseAname];
        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeQuickTimeMovie]) {
            session.outputFileType = AVFileTypeQuickTimeMovie;
        } else if (supportedTypeArray.count == 0) {
            [self requesetRateVideofail];
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
            
        }
        // NSLog(@"video outputPath = %@",outputPath);
        session.outputURL = [NSURL fileURLWithPath:outputPath];

        AVMutableVideoComposition *videoComposition = [self fixedCompositionWithAsset:videoAsset];
        if (videoComposition.renderSize.width) {
            // 修正视频转向
            session.videoComposition = videoComposition;
        }

        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (session.status) {
                    case AVAssetExportSessionStatusUnknown: {
                        NSLog(@"AVAssetExportSessionStatusUnknown");
                    }  break;
                    case AVAssetExportSessionStatusWaiting: {
                        NSLog(@"AVAssetExportSessionStatusWaiting");
                    }  break;
                    case AVAssetExportSessionStatusExporting: {
                        NSLog(@"AVAssetExportSessionStatusExporting");
                    }  break;
                    case AVAssetExportSessionStatusCompleted: {
                        NSLog(@"AVAssetExportSessionStatusCompleted");
                        NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
                        AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:baseAname]] options:inputOptions];
                        if (inputAsset != nil) {
                            if (CMTimeCompare(inputAsset.duration, JP_VIDEO_MIN_DURATION) >= 0) {
                                JPVideoModel *videoModel = [[JPVideoModel alloc] init];
                                videoModel.videoTime = inputAsset.duration;
                                videoModel.videoBaseFile = baseAname;
                                videoModel.sourceType = JPVideoSourceLocal;
                                videoModel.originThumbImage = fileModel.thumImage;
                                videoModel.aspectRatio = fileModel.aspectRatio;
                                videoModel.movieName = fileModel.movieName;
                                videoModel.timeRange = CMTimeRangeMake(kCMTimeZero, inputAsset.duration);
                                fileModel.videoModel = videoModel;
                                [self requestVideoSuccessWith:fileModel];
                            }else {
                                [self jp_hideHUD];
                                [MBProgressHUD jp_showMessage:@"导入视频不能少于3秒"];
                            }
                        }
                    }  break;
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"AVAssetExportSessionStatusFailed");
                        [self requesetRateVideofail];
                    }  break;
                    case AVAssetExportSessionStatusCancelled: {
                        NSLog(@"AVAssetExportSessionStatusCancelled");
                        [self requesetRateVideofail];
                    }  break;
                    default: break;
                }
            });
        }];
    } else {
        [self requesetRateVideofail];
    }
}

/// 获取优化后的视频转向信息
- (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self degressFromVideoFileWithAsset:videoAsset];
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        videoComposition.frameDuration = CMTimeMake(1, 30);
        
        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // 加入视频方向信息
        videoComposition.instructions = @[roateInstruction];
    }
    return videoComposition;
}

/// 获取视频角度
- (int)degressFromVideoFileWithAsset:(AVAsset *)asset {
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}


- (void)requestVideoSuccessWith:(JPLocalFileModel *)localModel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.baseNavigationController.view.userInteractionEnabled = YES;
        [self jp_hideHUD];
        if (self.fromPackage) {
            [self.delegate ablumSourceViewControllerDidSelectVideoModel:localModel];
            NSTimeInterval restTime = CMTimeGetSeconds([self.delegate ablumSourceViewControllerNeedGetResetTime]);
            for (JPLocalFileModel *model in self.reallydata) {
                model.isInvalid = NO;
                if (self.fromPackage && ((model.duration > restTime && self.type == JPAssetTypeVideo) || restTime < 2.0)) {
                    model.isInvalid = YES;
                }
            }
            [self.collectionView reloadData];
        }else{
            [self pushToTheViewClipVCWithVideoModel:localModel.videoModel];
        }
    });
}

- (void)requesetRateVideofail
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self jp_hideHUD];
        self.baseNavigationController.view.userInteractionEnabled = YES;
        [MBProgressHUD jp_showMessage:@"导出视频失败,请重试"];
    });
}

- (void)setFileModelDesSelect:(JPLocalFileModel *)fileModel
{
    [self.delegate ablumSourceViewControllerDidDeselectVideoModel:fileModel];
    NSTimeInterval restTime = CMTimeGetSeconds([self.delegate ablumSourceViewControllerNeedGetResetTime]);
    for (JPLocalFileModel *model in _reallydata) {
        model.isInvalid = NO;
        if (_fromPackage && ((model.duration > restTime && _type == JPAssetTypeVideo) || restTime < 2.0)) {
            model.isInvalid = YES;
        }
    }
    [_collectionView reloadData];
}

- (void)requestOriginPhotoWithLocalfile:(JPLocalFileModel *)fileModel
{
    self.baseNavigationController.view.userInteractionEnabled = NO;
    PHImageManager *asserManager = [PHImageManager defaultManager];
    __weak typeof(self) weakSelf = self;
    @autoreleasepool {
        CGSize imageSize = CGSizeMake(1280, 1280);
        [asserManager requestImageForAsset:fileModel.photoAsset targetSize:imageSize contentMode:PHImageContentModeDefault options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            __block UIImage * resultImage ;
            if (!result && [info objectForKey:PHImageResultIsInCloudKey]) {
                PHImageRequestOptions * options = [[PHImageRequestOptions alloc]init];
                options.networkAccessAllowed = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                [asserManager requestImageDataForAsset:fileModel.photoAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    UIImage * image = [UIImage imageWithData:imageData];
                    resultImage = [UIImage jp_fixOrientation:image];
                    if (resultImage) {
                        JPVideoModel *videoModel = [[JPVideoModel alloc] init];
                        videoModel.sourceType = JPVideoSourceLocal;
                        videoModel.originThumbImage = fileModel.thumImage;
                        videoModel.originImage = [UIImage jp_fixOrientation:result];
                        videoModel.aspectRatio = fileModel.aspectRatio;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.baseNavigationController.view.userInteractionEnabled = YES;
                            if (self.isTempalte == YES) {
                                self.templateSelectBlock(videoModel);
                                return ;
                            }
                            JPPhotoEditViewController *videoClipVC = [[JPPhotoEditViewController alloc] initWithNibName:@"JPPhotoEditViewController" bundle:JPResourceBundle];
                            videoClipVC.fromPackage = self.fromPackage;
                            videoClipVC.jp_cancelGesturesReturn = YES;
                            videoClipVC.jp_cancelReturnButton = YES;
                            videoClipVC.videoModel = videoModel;
                            videoClipVC.recordInfo = self.recordInfo;
                            videoClipVC.delegate = self;
                            [weakSelf.baseNavigationController pushViewController:videoClipVC animated:YES];
                        });
                    }else{
                        [self requesetRateVideofail];
                    }
                }];
            }else{
                resultImage = [UIImage jp_fixOrientation:result];
                if (resultImage) {
                    JPVideoModel *videoModel = [[JPVideoModel alloc] init];
                    videoModel.sourceType = JPVideoSourceLocal;
                    videoModel.originThumbImage = fileModel.thumImage;
                    videoModel.originImage = [UIImage jp_fixOrientation:result];
                    videoModel.aspectRatio = fileModel.aspectRatio;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.baseNavigationController.view.userInteractionEnabled = YES;
                        if (self.isTempalte == YES) {
                            self.templateSelectBlock(videoModel);
                            return ;
                        }
                        JPPhotoEditViewController *videoClipVC = [[JPPhotoEditViewController alloc] initWithNibName:@"JPPhotoEditViewController" bundle:JPResourceBundle];
                        videoClipVC.fromPackage = self.fromPackage;
                        videoClipVC.jp_cancelGesturesReturn = YES;
                        videoClipVC.jp_cancelReturnButton = YES;
                        videoClipVC.videoModel = videoModel;
                        videoClipVC.recordInfo = self.recordInfo;
                        videoClipVC.delegate = self;
                        [weakSelf.baseNavigationController pushViewController:videoClipVC animated:YES];
                    });
                }else{
                    [self requesetRateVideofail];
                }
            }
            
        }];
    }
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    @autoreleasepool {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
        [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
        
    }
    
}
- (void)pushToTheViewClipVCWithVideoModel:(JPVideoModel *)videoModel
{
    
    if (_isTempalte == YES) {
        self.templateSelectBlock(videoModel);
        return;
    }
    JPVideoClipViewController *videoClipVC = [[JPVideoClipViewController alloc] initWithNibName:@"JPVideoClipViewController" bundle:JPResourceBundle];
    videoClipVC.jp_cancelGesturesReturn = YES;
    videoClipVC.jp_cancelReturnButton = YES;
    videoClipVC.fromPackage = _fromPackage;
    videoClipVC.videoModel = videoModel;
    videoClipVC.recordInfo = _recordInfo;
    videoClipVC.delegate = self;
    [self.baseNavigationController pushViewController:videoClipVC animated:YES];
}

#pragma mark JPVideoClipViewControllerDelegate
- (void)didFinishedClipVideoModel:(JPVideoModel *)videoModel
{
    if (_fromPackage) {
        [self.delegate ablumSourceViewControllerFinishAddWithVideoModel:videoModel];
        return;
    }
    [_recordInfo addVideoFile:videoModel];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((JP_SCREEN_WIDTH - 46)/3, (JP_SCREEN_WIDTH - 46)/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.f;
}



@end
