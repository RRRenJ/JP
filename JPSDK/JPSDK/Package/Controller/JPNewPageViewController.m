//
//  JPNewPageViewController.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "JPNewPageViewController.h"
#import "JPSession.h"
#import "JPNewThumbSlider.h"
#import "JPThumbInfoModel.h"
#import "JPAudioMenuBaseView.h"
#import "JPPackageFilterMenuView.h"
#import "JPVideoEditMune.h"
#import "JPPhotoEditMune.h"
#import "JPNewTranstionChangedView.h"
#import "JPNewPatternMuneView.h"
#import "JPPackageGraphPatternMenuView.h"
#import "JPImgPickerViewController.h"
#import "JPPatternInteractiveView.h"
#import "JPPackageViewCache.h"
#import "JPCalibratView.h"
#import "JPPackagePatternAttributeView.h"
#import "JPPatternInputView.h"
#import "JPPackBackView.h"
#import "JPCompositionMessageView.h"
#import "JPShareEditTitleViewController.h"
#import "JPSelectTagsViewController.h"
#import "JPVideoPlayerView.h"
#import "JPNewCameraViewController.h"
#import "JPPackageGuideView.h"
#import "JPPackagePhotoEditGuideView.h"
#import "JPActiveMessageView.h"
#import <ALAssetsLibrary+CustomPhotoAlbum.h>
#import "PKBackTipView.h"
#import "PKBackAlertView.h"
#import "UIButton+ImageAndText.h"

#import "PKPHPhotoImportViewController.h"
#import "PKPHPhotoShowViewController.h"

@interface JPNewPageViewController ()<JPVideoCompositionPlayerDelegate, JPNewThumbSliderDelegate, JPPackageFilterMenuViewDelegate, JPVideoEditMuneDelegate,JPPhotoEditMuneDelegate,JPAudioMenuBaseViewDelegate,MPMediaPickerControllerDelegate,JPNewTranstionChangedViewDelegate, JPNewPatternMuneViewDelegate, JPPackageGraphPatternMenuViewDelegate, JPPackageViewCacheDelegate, JPPackagePatternAttributeViewDelegate,JPPatternInputViewDelegate, JPCompositionMessageViewDelegate>
{
    JPPackageFilterMenuView *filterMenuView;
    JPVideoEditMune *editVideoMune;
    JPPhotoEditMune *editPhotoMune;
    JPNewTranstionChangedView *editTranstionTypeMune;
    JPNewPatternMuneView *newPatternMuneView;
    JPPackageGraphPatternMenuView *graphPatternMuneView;
    JPPackagePatternAttribute *selectedHotGraphAttribute;
    JPCalibratView *calibratView;
    BOOL isShowingGraphPatternMuneView;
    BOOL isShowingPatternMuneView;
    BOOL isShowingFilterMenu;
    BOOL isShowingEditVideoMenu;
    BOOL isShowingEditPhotoMenu;
    JPAudioMenuBaseView *audioMenuBaseView;
    BOOL isShowingAudioMenuBaseView;
    JPAudioModel *itunesMusicModel;
    BOOL isShowingEditTransionTypeMenu;
    BOOL isShowingImgController;
    BOOL isEditSticker;
    BOOL isToLogin;
    BOOL videoisEdit;
    BOOL isAddVideo;
    JPPackagePatternAttributeView *attributeView;
    JPPatternInputView *patternInputView;
    JPPatternInteractiveView *hotGraphInteractiveView;
    JPActiveMessageView *activeMessageView;
}
@property (weak, nonatomic) IBOutlet JPPackBackView *graphBackView;
@property (weak, nonatomic) IBOutlet UIView *navigationBackView;
@property (weak, nonatomic) IBOutlet UIView *videoPlayBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomMenuView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView *thumbSliderBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBackViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBackViewHeightLayoutConstraint;
@property (nonatomic, strong) JPVideoCompositionPlayer *compositionPlayer;
@property (nonatomic, strong) JPNewThumbSlider *thumbSilderView;
@property (nonatomic, assign) BOOL isChooseItunesMusic;
@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, strong) NSMutableArray *patternArray;
@property (nonatomic, strong) JPPackageViewCache *viewCache;
@property (nonatomic, strong) JPPatternInteractiveView *patternInteractiveView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPlayBackViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet JPVideoPlayerView *videoeditMessageView;
- (void)toSelectItunesMusic;
- (void)audioMenuWillShow:(BOOL)show;
@property (weak, nonatomic) IBOutlet UIImageView *messageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBackViewTopC;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIButton *filterBt;
@property (weak, nonatomic) IBOutlet UIButton *musicBt;
@property (weak, nonatomic) IBOutlet UIButton *stickersBt;
@property (nonatomic, strong) UIView * rightBtBackView;

@property (nonatomic, strong) PKGuideView * musicGuideView;

@property (nonatomic, strong) PKGuideView * filterGuideView;

@property (nonatomic, strong) PKGuideView * transformGuideView;

@property (nonatomic, strong) PKGuideView * thumGuideView;

@property (nonatomic, assign) BOOL guide;

@end

@implementation JPNewPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoPlayBackViewHeightLayoutConstraint.constant = SCREEN_WIDTH;
    videoisEdit = NO;
    isAddVideo = NO;
    [JPUtil pageRecordWithVideoId:nil andPosition:@"4"];
    if (![JPSession sharedInstance].cityName.length) {
        [[JPSession sharedInstance] initLocate];
    }
    _navigationBackViewTopC.constant = KStatusBarHeight;
    _bottomViewBottomC.constant = KTabbarHeightLineHeight;
    CGSize size = _recordInfo.videoSize;
    CGFloat maxWidth = size.width >= size.height ? size.width : size.height;
    CGFloat width = SCREEN_WIDTH / maxWidth * size.width;
    CGFloat height = SCREEN_WIDTH / maxWidth * size.height;
    _graphWidth.constant = width;
    _graphHeight.constant = height;
    self.navagatorView = _navigationBackView;
    self.hasRegistAppStatusNotification = YES;
    [self createNavigatorViewWithHeight:KShrinkNavigationHeight];
    [self addLeftButtonWithTittle:nil withImage:[UIImage imageNamed:@"esc"] target:self action:@selector(escPage:)];
    [self addRightButtonWithTittle:@"下一步" withImage:nil target:self action:@selector(finish:)];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont pingFangBoldFontWithSize:15];
    _compositionPlayer = [[JPVideoCompositionPlayer alloc] initWithRecordInfo:_recordInfo withStickers:YES withComposition:NO];
    _compositionPlayer.delegate = self;
    [_videoPlayBackView addSubview:_compositionPlayer.gpuImageView];
    [self audioMenuWillShow:NO];
    _thumbSilderView = [[JPNewThumbSlider alloc] initWithRecordInfo:_recordInfo];
    _thumbSilderView.clipsToBounds = NO;
    _thumbSilderView.delegate = self;
    _thumbSilderView.hideAddView = self.isPhotoAlbum;
    [_thumbSliderBackView addSubview:_thumbSilderView];
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeVideoPlayStatus:)];
    ges.numberOfTapsRequired = 1;
    [_graphBackView addGestureRecognizer:ges];
    _viewCache = [[JPPackageViewCache alloc] init];
    _viewCache.delegate = self;
    _viewCache.scale = ceil((_recordInfo.videoSize.width / width));
    calibratView = [[JPCalibratView alloc] initWithFrame:CGRectZero];
    calibratView.hidden = YES;
    [_graphBackView addSubview:calibratView];
    calibratView.sd_layout.topEqualToView(_graphBackView).widthRatioToView(_graphBackView, 1.0).leftEqualToView(_graphBackView).bottomEqualToView(_graphBackView);
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [_graphBackView addGestureRecognizer:doubleTapGestureRecognizer];
    [ges requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    [self.view bringSubviewToFront:_videoeditMessageView];
    [self.view bringSubviewToFront:self.navigationBackView];
    [self.view bringSubviewToFront:self.statusView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLogin:) name:SUCCESSTOLOGINNOTIFICATION object:nil];
    
    if (_recordInfo.pattnaerArr) {
        _patternArray = _recordInfo.pattnaerArr;
        for (JPPackagePatternAttribute *patternAttribu in _patternArray) {
            if (patternAttribu.patternType == JPPackagePatternTypeWeekPicture || patternAttribu.patternType == JPPackagePatternTypeHollowOutPicture || patternAttribu.patternType == JPPackagePatternTypePicture || patternAttribu.patternType == JPPackagePatternTypeDownloadedPicture) {
                if (patternAttribu.patternType == JPPackagePatternTypeWeekPicture) {
                    selectedHotGraphAttribute = patternAttribu;
                    hotGraphInteractiveView = [_viewCache addCacheFromViewModel:patternAttribu withSuperView:_graphBackView];
                    hotGraphInteractiveView.hidden = YES;
                }
            }else{
                [_viewCache addCacheFromViewModel:patternAttribu withSuperView:_graphBackView];
            }
            [_compositionPlayer addPackagePattern:patternAttribu];
        }
        [self updateStickers];
    }else{
        _patternArray = [NSMutableArray array];
    }

    [self.filterBt layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.stickersBt layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.musicBt layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    
    self.thumbSilderView.hidden = self.isPhotoAlbum;
    self.bottomMenuView.hidden = self.isPhotoAlbum;
    self.guide = [PKGuideManager manager].guide;
    
    
 
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SUCCESSTOLOGINNOTIFICATION object:nil];
    [_compositionPlayer pauseToPlay];
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
}

- (void)addGuideView{
   
    if ([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 2 && self.guide) {
        self.guideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，继续拍摄" type:PKGuideViewTailTypeVertical];
        [self.thumbSilderView.collectionView addSubview:self.guideView];
         self.guideView.frame = CGRectMake(self.thumbSilderView.collectionView.contentSize.width - self.guideView.guideSize.width/2 - 30, -self.guideView.guideSize.height - 30, self.guideView.guideSize.width, self.guideView.guideSize.height);
    }else if([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 4 && self.guide){
        self.guideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，选择滤镜" type:PKGuideViewTailTypeLeft];
        [self.view addSubview:self.guideView];
        self.guideView.frame = CGRectMake(SCREEN_WIDTH/3.0 - self.guideView.guideSize.width / 2.0, SCREEN_HEIGHT - [JPUtil bottomSafeAreaHeight] - 60 - self.guideView.guideSize.height, self.guideView.guideSize.width, self.guideView.guideSize.height);
    }else if ([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 8 && self.guide) {
        self.guideView = [[PKGuideView alloc]initGuideViewWithContent:@"轻点视频，选中" type:PKGuideViewTailTypeVertical];
        [self.thumbSilderView.collectionView addSubview:self.guideView];
        self.guideView.frame = CGRectMake(0, -self.guideView.guideSize.height - 30, self.guideView.guideSize.width, self.guideView.guideSize.height);
    }else if ([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 10 && self.guide) {
        self.guideView = [[PKGuideView alloc]initGuideViewWithContent:@"轻点视频，取消选中" type:PKGuideViewTailTypeVertical];
        [self.thumbSilderView.collectionView addSubview:self.guideView];
        self.guideView.frame = CGRectMake(0, -self.guideView.guideSize.height - 30, self.guideView.guideSize.width, self.guideView.guideSize.height);
    }else if([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 11 && self.guide) {
        self.guideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，添加音乐" type:PKGuideViewTailTypeRight];
        [self.view addSubview:self.guideView];
        self.guideView.frame = CGRectMake(SCREEN_WIDTH / 3.0 * 2 - self.guideView.guideSize.width / 2.0, SCREEN_HEIGHT - [JPUtil bottomSafeAreaHeight] - 60 - self.guideView.guideSize.height, self.guideView.guideSize.width, self.guideView.guideSize.height);
    }
    
    if (![PKGuideManager manager].guide && [PKGuideManager manager].showTouchVideo && !self.isPhotoAlbum) {
        self.guideView = [[PKGuideView alloc]initGuideViewWithContent:@"点击选中视频可进行剪切等处理" type:PKGuideViewTailTypeVertical];
        [self.thumbSilderView.collectionView addSubview:self.guideView];
        self.guideView.frame = CGRectMake(0, -self.guideView.guideSize.height - 30, self.guideView.guideSize.width, self.guideView.guideSize.height);
    }
}

- (void)addMusicGuideView{
    if ([PKGuideManager manager].guide) {
        [self.guideView removeFromSuperview];
        if ([PKGuideManager manager].guideNumber == 11 && self.guide) {
            [PKGuideManager manager].guideNumber = 12;
            [PKGuideManager manager].musicNo = 2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.musicGuideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，添加音乐" type:PKGuideViewTailTypeVertical];
                [audioMenuBaseView.musicMenu.bottomCollecView addSubview:self.musicGuideView];
                self.musicGuideView.frame = CGRectMake(ScreenFitFloat6(80) / 2.0 * 5 - self.musicGuideView.guideSize.width / 2.0,  -self.musicGuideView.guideSize.height - 30, self.musicGuideView.guideSize.width, self.musicGuideView.guideSize.height);
            });
        }else{
            self.guide = NO;
        }
    }

}

- (void)doubleTap:(UITapGestureRecognizer *)tap{
    NSMutableArray *videoModel = [NSMutableArray array];
    for (JPPackagePatternAttribute *patternAttribute in _patternArray) {
        if (CMTimeRangeContainsTime(patternAttribute.timeRange, _thumbSilderView.currentTime) && patternAttribute.patternType != JPPackagePatternTypeWeekPicture) {
            [videoModel addObject:patternAttribute];
        }
    }
    CGPoint point = [tap locationInView:_graphBackView];
    for (JPPackagePatternAttribute *patternAttribute in videoModel) {
        if (CGRectContainsPoint(patternAttribute.frame, point)) {
            [self.compositionPlayer pauseToPlay];
            JPPatternInteractiveView *view = [_viewCache addCacheFromViewModel:patternAttribute withSuperView:_graphBackView];
            [videoModel removeObject:patternAttribute];
            [_viewCache willApearSomeViewWithViewModels:videoModel withSuperView:_graphBackView];
            [self packageViewCacheWillEditTheView:view withViewCache:_viewCache];
            return;
        }
    }
    
}


- (NSDictionary *)getVideoTotalThumbImages{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = 0;
    CMTime duration = _compositionPlayer.videoDuration;
    NSArray *infosArr = _thumbSilderView.dataSource.copy;
    CGSize imageSize = CGSizeZero;
    for (JPThumbInfoModel *info in infosArr) {
        NSArray *imagesArr = info.thumbImageArr;
        for (NSInteger index = info.imageStartIndex; (index - info.imageStartIndex) < info.count; index ++) {
            UIImage *image = nil;
            if (index + info.imageStartIndex >= imagesArr.count) {
                image = [UIImage imageNamed:@"logo@3x-1"];
            }else{
                image = imagesArr[index + info.imageStartIndex];
            }
            [array addObject:image];
        }
        imageSize = info.imageSize;
    }
    Float64 durations = CMTimeGetSeconds(duration);
    NSInteger reallyPixel = (NSInteger)floor(durations * 30) * 2;
    CGFloat width = reallyPixel;
    count = ceil(width / imageSize.width);
    [dic setObject:@(count) forKey:@"count"];
    [dic setObject:@(width) forKey:@"width"];
    [dic setObject:[NSValue valueWithCMTime:duration] forKey:@"duration"];
    [dic setObject:array forKey:@"images"];
    return dic;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([PKGuideManager manager].resetPageGuideState) {
        self.guide = [PKGuideManager manager].guide;
    }
    
    [PKDCManager track:@"pageView" withProperties:@{@"pagename":@"拍摄成功页面",@"pageid" : @"app03"}];
    [_thumbSilderView updateThumSlider];
    [_compositionPlayer returnCurrentPage];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer switchFilter];
    if ((isShowingImgController == NO && isEditSticker == NO && isToLogin == NO && isAddVideo == NO) || _isChooseItunesMusic) {
        _isChooseItunesMusic = NO;
        [_compositionPlayer startPlaying];
        if (_recordInfo.backgroundMusic && _recordInfo.backgroundMusic.fileUrl) {
            [audioMenuBaseView startPlay];
        }
    }
    if (isAddVideo == YES) {
        [_compositionPlayer seekToTime:CMTimeSubtract(_recordInfo.totalVideoDuraion, CMTimeMake(1, 1))];
    }
    isAddVideo = NO;
    isToLogin = NO;
    isShowingImgController = NO;
    
    if ([PKGuideManager manager].guide) {
        
        if ([PKGuideManager manager].guideNumber == 1) {
            [PKGuideManager manager].guideNumber = 2;
        }
        if ([PKGuideManager manager].guideNumber == 3) {
            if(![PKGuideManager manager].resetPageGuideState){
                if (self.recordInfo.videoSource.count == 2) {
                    [PKGuideManager manager].guideNumber = 4;
                }else{
                    self.guide = NO;
                }
            }
        }
    }
    [PKGuideManager manager].resetPageGuideState = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addGuideView];
    });
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (activeMessageView == nil && [_thumbSilderView isCurrentActive]) {
        activeMessageView = [[JPActiveMessageView alloc] initActive];
        [activeMessageView show];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_compositionPlayer pauseToPlay];
    [_compositionPlayer levelCurrentPage];
    [activeMessageView dismiss];
    [self.guideView removeFromSuperview];
}

- (void)appBecomeActive
{
    [_compositionPlayer returnCurrentPage];
    [_compositionPlayer setRecordInfo:_recordInfo];
    if (_patternInteractiveView.hidden == NO) {
        [_compositionPlayer scrollToWatchThumImageWithTime:_patternInteractiveView.patternAttribute.timeRange.start withSticker:NO];
    }else
    {
        [_compositionPlayer scrollToWatchThumImageWithTime:kCMTimeZero withSticker:NO];
    }
}


- (void)appBecomeBackgound
{
    if (_compositionPlayer.isPlaying) {
        [self changeVideoPlayStatus:nil];
    }
    [_compositionPlayer levelCurrentPage];
    
}


#pragma mark JPVideoCompositionPlayerDelegate
- (void)videoCompositionPlayerPlayAtTime:(CMTime)time andAndStickerArr:(NSArray *)patternArr andNeedApear:(BOOL)needApear
{
    [_thumbSilderView scrollToTime:time];
    [audioMenuBaseView setCurrentTime:time];
    NSMutableArray *muArr = (NSMutableArray *)patternArr;
    if (needApear) {
        [self.viewCache willDisAllView];
        if (self.patternInteractiveView != hotGraphInteractiveView) {
            self.patternInteractiveView.hidden = NO;
            if ([muArr containsObject:self.patternInteractiveView.patternAttribute]) {
                [muArr removeObject:self.patternInteractiveView.patternAttribute];
            }
        }
        if (hotGraphInteractiveView) {
            if ([muArr containsObject:hotGraphInteractiveView.patternAttribute]) {
                [muArr removeObject:hotGraphInteractiveView.patternAttribute];
            }
            if (CMTimeCompare(time, _recordInfo.totalVideoDuraion) < 0) {
                if (hotGraphInteractiveView.changeHidden == YES) {
                    hotGraphInteractiveView.changeHidden = NO;
                }
            }else{
                if (hotGraphInteractiveView.changeHidden == NO) {
                    hotGraphInteractiveView.changeHidden = YES;
                }
            }
        }
        [_viewCache willApearSomeViewWithViewModels:patternArr withSuperView:_graphBackView];
    }else{
        [self.viewCache willDisAllView];
        if (hotGraphInteractiveView.changeHidden == NO) {
            hotGraphInteractiveView.changeHidden = YES;
        }
    }
}
- (void)videoCompositionPlayerWillPasue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isEditSticker == NO) {
            [_playButton setHidden:NO];
        }
        if (hotGraphInteractiveView) {
            hotGraphInteractiveView.changeHidden = YES;
        }
    });
}
- (void)videoCompositionPlayerWillPlaying
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_playButton setHidden:YES];
        calibratView.hidden = YES;
    });
    
}


- (void)escPage:(UIButton *)button
{
    if (self.isPhotoAlbum) {
        PKBackAlertView * alert = [[PKBackAlertView alloc]init];
        alert.comfirmBlock = ^{
            [self comfireEscWithPhotoAlbum];
        };
        [alert show];
        
    }else{
        PKBackTipView *tipsView = [[PKBackTipView alloc] initWithFrame:self.view.bounds];
        [tipsView showInView:self.view];
        WEAK(self);
        tipsView.dismissCompletion = ^(BOOL left) {
            if (left) {
                //保存草稿箱
                [weakself comfireEscWithSave:YES];
            }else {
                //直接退出
                [weakself comfireEscWithSave:NO];
            }
        };
    }
    
}


- (void)comfireEscWithSave:(BOOL)isSave
{
    if (isSave) {
        // 草稿箱功能api  下面演示加入j草稿箱的功能,记得贴纸的数组必须再保存时更新,防止使用的贴纸丢失
        _recordInfo.pattnaerArr = _patternArray;
        _recordInfo.saveDate = [NSDate date];
        [JPUtil addRecordInfo:_recordInfo completion:nil];
    }
    
    _recordInfo.backgroundMusic = nil;
    [_recordInfo removeAllAudioFile];
    _recordInfo.pattnaerArr = nil;
    [_compositionPlayer pauseToPlay];
    [self.compositionPlayer destruction];
    [_recordInfo originCompositionBecomeNone];
    [JPSession sharedInstance].tagID = @"";
    if (!_isDrafts) {
        [[JPAppDelegate shareAppdelegate].baseTabBarController swicthToTheHostPage];
        [[JPAppDelegate shareAppdelegate].baseTabBarController.homeNav popToRootViewControllerAnimated:NO];
    }
    __weak typeof(self) weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [_compositionPlayer pauseToPlay];
        [self.compositionPlayer destruction];
        [JPSession sharedInstance].selectTaskModel = nil;
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
    }];
}
- (void)comfireEscWithPhotoAlbum{

    _recordInfo.backgroundMusic = nil;
    [_recordInfo removeAllAudioFile];
    _recordInfo.pattnaerArr = nil;
    [_compositionPlayer pauseToPlay];
    [self.compositionPlayer destruction];
    [_recordInfo originCompositionBecomeNone];
    [JPSession sharedInstance].tagID = @"";
    if (!_isDrafts) {
        [[JPAppDelegate shareAppdelegate].baseTabBarController swicthToTheHostPage];
    }
    NSMutableArray * controllers = self.navigationController.viewControllers.mutableCopy;
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PKPHPhotoImportViewController class]] || [vc isKindOfClass:[PKPHPhotoShowViewController class]]) {
            [controllers removeObject:vc];
        }
    }
    self.navigationController.viewControllers = controllers.copy;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        isToLogin = YES;
        [JPUserInfo needLoginWithNavigation:self.navigationController];
    }
}

#pragma mark - notifications

- (void)successLogin:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:NO];
    [self updateStickers];
    [self pushToTheShareVC];
}
#pragma mark JPCompositionMessageViewDelegate

- (void)compositionMessageViewWillComposition
{
    [self finish:nil];
}

- (void)finish:(id)sender {
    if (_compositionPlayer.isPlaying == YES) {
        [self changeVideoPlayStatus:nil];
    }
//    if ([JPUtil getInfoFromUserDefaults:@"jp_first_composition"] == nil) {
//        JPCompositionMessageView *compositionView = [[JPCompositionMessageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        [self.view addSubview:compositionView];
//        compositionView.delegate = self;
//        [compositionView show];
//        [JPUtil saveIssueInfoToUserDefaults:@"jp_first_composition" resouceName:@"jp_first_composition"];
//        return;
//    }
    
    if (![JPUserInfo shareInstance].isLogin) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"合成视频前，请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [self updateStickers];
        [self pushToTheShareVC];
        [self.rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.rightBtBackView removeFromSuperview];
    }
}

- (void)pushToTheShareVC
{
    JPSelectTagsViewController *vc = [[JPSelectTagsViewController alloc] init];
    JPCompositionManager *compositionManager = [[JPCompositionManager alloc] initWithRecordInfo:_recordInfo andStikcerArr:_patternArray];
    vc.compositionManager = compositionManager;
    if (self.isPhotoAlbum) {
        vc.compositionManager.isAlbumVideo = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -

- (void)toSelectItunesMusic {
    MPMediaPickerController *mpc = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
    [mpc setShowsCloudItems:NO];
    [mpc setShowsItemsWithProtectedAssets:NO];
    mpc.delegate = self;//委托
    mpc.prompt =@"选取音乐";//提示文字
    mpc.allowsPickingMultipleItems = NO;//是否允许一次选择多个
    mpc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:mpc animated:YES completion:nil];
}


- (CGRect)getLocalVideoCropSizeWithOriginSize:(CGSize)originSize
{
    CGRect videoCropRect = CGRectZero;
    CGFloat ratio = 16.0 / 9.0f;
    CGFloat width = originSize.width;
    CGFloat height = originSize.height;
    if (_recordInfo.aspectRatio == JPVideoAspectRatio9X16) {
        ratio = 9.0 / 16.0f;
    }else if (_recordInfo.aspectRatio == JPVideoAspectRatio1X1 || _recordInfo.aspectRatio == JPVideoAspectRatioCircular){
        ratio = 1.0 / 1.0f;
    }else if (_recordInfo.aspectRatio == JPVideoAspectRatio4X3)
    {
        ratio = 4.0 / 3.0;
    }
    if (originSize.width / originSize.height <= ratio) {
        height = originSize.width / ratio;
    }else{
        width = originSize.height * ratio;
    }
    return CGRectMake(0, 0, width, height);
}

- (void)audioMenuWillShow:(BOOL)show {
    CGFloat w = SCREEN_WIDTH;
    CGFloat h = show == NO ? SCREEN_WIDTH : ScreenFitFloat6(259);
    CGRect size = [self getLocalVideoCropSizeWithOriginSize:CGSizeMake(w, h)];
//    JPVideoAspectRatio aspectRatio = _recordInfo.aspectRatio;
//    if (JPVideoAspectRatio1X1 == aspectRatio || JPVideoAspectRatioCircular == aspectRatio) {
//        w = h;
//        _compositionPlayer.gpuImageView.frame = CGRectMake(0, 0, w, h);
//        _compositionPlayer.gpuImageView.centerX = SCREEN_WIDTH / 2.0;
//        _compositionPlayer.gpuImageView.centerY = h / 2.0;
//    } else if (JPVideoAspectRatio16X9 == aspectRatio){
//        h = 9.f/16.f*w;
//    } else if (JPVideoAspectRatio9X16 == aspectRatio){
//        w = h*9.f/16.f;
//    } else if (JPVideoAspectRatio4X3 == aspectRatio){
//        h = w / 4.f * 3.f;
//    }
    _compositionPlayer.gpuImageView.frame = size;
    _compositionPlayer.gpuImageView.centerX = SCREEN_WIDTH / 2.0;
    _compositionPlayer.gpuImageView.centerY = (show ? ScreenFitFloat6(259) : SCREEN_WIDTH) / 2.0;
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    if ([[mediaItemCollection items] count]) {
        MPMediaItem *mediaItem = [[mediaItemCollection items] firstObject];
        NSURL *url =  [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        if (!url) {
            [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:@"您挑选的音乐不在itunes本地，请选择其他音乐。"];
            return;
        }
        _isChooseItunesMusic = YES;
        NSString *name = [mediaItem title];
        NSString *baseName =[JPVideoUtil fileNameForDocumentAudio];
        itunesMusicModel.isBundle = NO;
        itunesMusicModel.baseFilePath = baseName;
        AVAsset *asset = [AVURLAsset assetWithURL:url];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        exportSession.outputURL = [itunesMusicModel fileUrl];
        exportSession.shouldOptimizeForNetworkUse=NO;
        __block BOOL success = NO;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            success = YES;
        }];

        while (success == NO) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.02]];
        }
  
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            itunesMusicModel.isBundle = NO;
            itunesMusicModel.baseFilePath = baseName;
            itunesMusicModel.fileName = name;
            itunesMusicModel.theme = name;
            NSTimeInterval INW = [[mediaItem valueForProperty: MPMediaItemPropertyPlaybackDuration] doubleValue];
            itunesMusicModel.durationTime = CMTimeMakeWithSeconds(INW, NSEC_PER_SEC);
            audioMenuBaseView.music = itunesMusicModel;
            _recordInfo.backgroundMusic = itunesMusicModel;
        }else
        {
            [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:@"您挑选的音乐操作错误，请选择其他音乐。"];
        }
    }
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark JPNewThumbSliderDelegate

- (void)newThumbSliderWillUpdateAddVideo
{
    
    if (self.isPhotoAlbum) {
        return;
    }
    if ([PKGuideManager manager].guideNumber == 2) {
        [PKGuideManager manager].guideNumber = 3;
    }
    [self newThumbSliderWillDeselectThisVideoModel:_recordInfo.videoSource.lastObject];
    JPNewCameraViewController *cameraVC = [[JPNewCameraViewController alloc] init];
    cameraVC.recordInfo = _recordInfo;
    cameraVC.fromPackage = YES;
    isAddVideo = YES;
    [PKGuideManager manager].resetPageGuideState = NO;
    JPBaseNavigationViewController *nav = [[JPBaseNavigationViewController alloc] initWithRootViewController:cameraVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didChangedToTime:(CMTime)currentTime
{
    if (self.compositionPlayer.isPlaying == YES) {
        [self.compositionPlayer pauseToPlay];
    }
    [self.compositionPlayer scrollToWatchThumImageWithTime:currentTime withSticker:NO];
}




- (void)newThumbSliderWillSelectThisVideoModel:(JPVideoModel *)videoModel
{
    if ([PKGuideManager manager].guide) {
        [self.guideView removeFromSuperview];
        if ([PKGuideManager manager].guideNumber == 8 && self.guide) {
            [PKGuideManager manager].guideNumber = 9;
        }else{
            self.guide = NO;
        }
    }
    if (![PKGuideManager manager].guide) {
        [self.guideView removeFromSuperview];
    }
    [activeMessageView dismiss];
    if (videoModel.isImage == NO) {
        [editPhotoMune removeFromSuperview];
        isShowingEditPhotoMenu = NO;
        
        if (editVideoMune == nil) {
            editVideoMune = [[JPVideoEditMune alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60 + KTabbarHeightLineHeight)];
            editVideoMune.delegate = self;
        }
        if ([PKGuideManager manager].guide){
            [self.guideView removeFromSuperview];
            if ([PKGuideManager manager].thumNo == 1  && self.guide) {
                [PKGuideManager manager].thumNo = 2;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   self.thumGuideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，选择快慢速" type:PKGuideViewTailTypeLeft];
                   [self.view addSubview:self.thumGuideView];
                   self.thumGuideView.frame = CGRectMake(10, SCREEN_HEIGHT - [JPUtil bottomSafeAreaHeight] - 60 - self.thumGuideView.guideSize.height, self.thumGuideView.guideSize.width, self.thumGuideView.guideSize.height);
               });
            }else{
                self.guide = NO;
            }
        }
        if (self.compositionPlayer.isPlaying == YES) {
            [self changeVideoPlayStatus:nil];
        }
        [self.view addSubview:editVideoMune];
        
        editVideoMune.currentTime = [_thumbSilderView getCurrentVideoTime];
        editVideoMune.videoModel = videoModel;
        isShowingEditVideoMenu = YES;
        [UIView animateWithDuration:0.2 animations:^{
            editVideoMune.top = SCREEN_HEIGHT - editVideoMune.height;
        }];
    }else{
        [editVideoMune removeFromSuperview];
        isShowingEditVideoMenu = NO;
        if (editPhotoMune == nil) {
            editPhotoMune = [[JPPhotoEditMune alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60 + KTabbarHeightLineHeight )];
            editPhotoMune.delegate = self;
        }
        if (self.compositionPlayer.isPlaying == YES) {
            [self changeVideoPlayStatus:nil];
        }
        [self.view addSubview:editPhotoMune];
        editPhotoMune.videoModel = videoModel;
        isShowingEditPhotoMenu = YES;
        [UIView animateWithDuration:0.2 animations:^{
            editPhotoMune.top = SCREEN_HEIGHT - editPhotoMune.height;
            
        }];
    }
}



- (void)newThumbSliderWillDeselectThisVideoModel:(JPVideoModel *)videoModel
{
    
    if ([PKGuideManager manager].guide){
        [self.thumGuideView removeFromSuperview];
        if([PKGuideManager manager].guideNumber == 10 && self.guide) {
            [PKGuideManager manager].guideNumber = 11;
            [self.guideView removeFromSuperview];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.guideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，添加音乐" type:PKGuideViewTailTypeRight];
                [self.view addSubview:self.guideView];
                self.guideView.frame = CGRectMake(SCREEN_WIDTH / 3.0 * 2 - self.guideView.guideSize.width / 2.0, SCREEN_HEIGHT - [JPUtil bottomSafeAreaHeight] - 60 - self.guideView.guideSize.height, self.guideView.guideSize.width, self.guideView.guideSize.height);
            });
        }else{
//            self.guide = NO;
        }
    }
    if (videoModel.isImage == NO) {
        isShowingEditVideoMenu = NO;
        CGFloat dur = 0.5;
        
        [UIView animateWithDuration:dur animations:^{
            editVideoMune.top = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [editVideoMune removeFromSuperview];
        }];
    }else
    {
        isShowingEditPhotoMenu = NO;
        CGFloat dur = 0.5;
        
        [UIView animateWithDuration:dur animations:^{
            editPhotoMune.top = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [editPhotoMune removeFromSuperview];
        }];
    }
    [_thumbSilderView setThisVideoDeselect:videoModel];
    if (videoisEdit == YES) {
        [_thumbSilderView formatThumbInfos];
        [_compositionPlayer setRecordInfo:_recordInfo];
        
        [_compositionPlayer seekToTime:[_thumbSilderView getStartTimeWithModel:videoModel]];
    }
    if(isShowingEditTransionTypeMenu == YES)
    {
        [self newTranstionChangedViewChangeTranstionModel:editTranstionTypeMune.videoModel.transtionModel withTranstionModel:editTranstionTypeMune.videoModel];
    }
    videoisEdit = NO;
}

- (void)newThumbSliderWillChangeVideoTranstionTypeThisVideoModel:(JPVideoModel *)videoModel
{
    if ([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 6 && self.guide) {
        [self.thumbSilderView removeGuideView];
        [PKGuideManager manager].guideNumber = 7;
    }else{
        self.guide = NO;
    }
    
    isShowingEditPhotoMenu = NO;
    [editPhotoMune removeFromSuperview];
    isShowingEditVideoMenu = NO;
    [editVideoMune removeFromSuperview];
    if (_compositionPlayer.isPlaying == YES) {
        [self changeVideoPlayStatus:nil];
    }
    if (editTranstionTypeMune == nil) {
        editTranstionTypeMune = [[JPNewTranstionChangedView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60 + KBottomSafeAreaHeight)];
        editTranstionTypeMune.delegate = self;
    }
    if ([PKGuideManager manager].guide) {
        [self.guideView removeFromSuperview];
        if (([PKGuideManager manager].transformNo == 1 && self.guide)) {
            [PKGuideManager manager].transformNo = 2;
            self.transformGuideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，选择该转场效果" type:PKGuideViewTailTypeLeft];
            [editTranstionTypeMune.collecView addSubview:self.transformGuideView];
            self.transformGuideView.frame = CGRectMake(SCREEN_WIDTH / 9 * 5 - self.transformGuideView.guideSize.width / 2.0 - 40, -self.transformGuideView.guideSize.height , self.transformGuideView.guideSize.width, self.transformGuideView.guideSize.height);
        }else{
            self.guide = NO;
        }
    }
    [self.view addSubview:editTranstionTypeMune];
    isShowingEditTransionTypeMenu = YES;
    editTranstionTypeMune.videoModel = videoModel;
    [UIView animateWithDuration:0.2 animations:^{
        editTranstionTypeMune.top = SCREEN_HEIGHT - 60 - KBottomSafeAreaHeight;
    }];
}

- (void)newThumbSliderDidExchangeTheVideoIndex:(NSInteger)index toIndex:(NSInteger)toIndex
{
    
    NSArray *originDataArr = _thumbSilderView.dataSource.copy;
    [_recordInfo exchangeVideoFileIndex:index toIndex:toIndex];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_thumbSilderView formatThumbInfos];
    NSMutableArray *newOriginDataArr = _thumbSilderView.dataSource.mutableCopy;
    NSMutableArray *pattrnArr = [NSMutableArray array];
    NSMutableArray *originPattrnArr = _patternArray.mutableCopy;
    for (JPThumbInfoModel *infoMofrl in originDataArr) {
        [pattrnArr removeAllObjects];
        CMTimeRange timeRange = CMTimeRangeMake(infoMofrl.startTime, infoMofrl.reallyDuration);
        for (JPPackagePatternAttribute *attribute in originPattrnArr) {
            if (CMTimeCompare(attribute.timeRange.start, timeRange.start) >= 0 && CMTimeCompare(CMTimeAdd(timeRange.start, timeRange.duration), attribute.timeRange.start) > 0 && attribute.isGlod == NO) {
                [pattrnArr addObject:attribute];
            }
        }
        if (pattrnArr.count == 0) {
            continue;
        }
        [originPattrnArr removeObjectsInArray:pattrnArr];
        JPThumbInfoModel *newThumbInfoModel;
        for (JPThumbInfoModel *info in newOriginDataArr) {
            if (info.videoModel == infoMofrl.videoModel) {
                newThumbInfoModel = info;
                break;
            }
        }
        if (newThumbInfoModel) {
            [newOriginDataArr removeObject:newThumbInfoModel];
            for (JPPackagePatternAttribute *attubute in pattrnArr) {
                CMTime duration = CMTimeSubtract(attubute.timeRange.start, infoMofrl.startTime);
                CMTimeRange timeRange = CMTimeRangeMake(CMTimeAdd(newThumbInfoModel.startTime, duration), attubute.timeRange.duration);
                double currentTime = CMTimeGetSeconds(timeRange.start);
                double startTime = round(currentTime / 0.5);
                CMTime attributeTime = CMTimeMakeWithSeconds(startTime * 0.5, 30);
                if (CMTimeCompare(attributeTime, CMTimeSubtract(_recordInfo.totalVideoDuraion, CMTimeMake(1, 1))) > 0) {
                    attributeTime = CMTimeMakeWithSeconds((startTime - 1) * 0.5, 30);
                }
                attubute.timeRange = CMTimeRangeMake(attributeTime, timeRange.duration);
            }
        }
    }
    [_compositionPlayer startPlaying];
}

- (void)newThumbSliderWillUpdateVideoLong:(JPVideoModel *)videoModel
{
    videoisEdit = YES;
    [_recordInfo originCompositionBecomeNone];
    [self newThumbSliderWillDeselectThisVideoModel:videoModel];
}

- (void)newThumbSliderWillDistranstion:(JPVideoModel *)videoModel
{
    if (isShowingEditTransionTypeMenu) {
        [self newTranstionChangedViewChangeTranstionModel:editTranstionTypeMune.videoModel.transtionModel withTranstionModel:editTranstionTypeMune.videoModel];
    }
}

- (void)newThumbSliderWillMoveVideo
{
    if (_compositionPlayer.isPlaying == YES) {
        [self changeVideoPlayStatus:nil];
    }
    if (isShowingEditVideoMenu == YES) {
        isShowingEditVideoMenu = NO;
        [UIView animateWithDuration:0.2 animations:^{
            editVideoMune.top = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [editVideoMune removeFromSuperview];
        }];
    }else if(isShowingEditPhotoMenu == YES)
    {
        isShowingEditPhotoMenu = NO;
        [UIView animateWithDuration:0.2 animations:^{
            editPhotoMune.top = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [editPhotoMune removeFromSuperview];
        }];
    }
}

#pragma mark -JPNewTranstionChangedViewDelegate
- (void)newTranstionChangedViewChangeTranstionModel:(JPVideoTranstionsModel *)transtionModel withTranstionModel:(JPVideoModel *)videoModel
{
    if ([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 7 && self.guide) {
        [self.transformGuideView removeFromSuperview];
        [PKGuideManager manager].guideNumber = 8;
        self.guideView = [[PKGuideView alloc]initGuideViewWithContent:@"轻点视频，选中" type:PKGuideViewTailTypeVertical];
        [self.thumbSilderView.collectionView addSubview:self.guideView];
        self.guideView.frame = CGRectMake(0, -self.guideView.guideSize.height - 30, self.guideView.guideSize.width, self.guideView.guideSize.height);
    }else{
        self.guide = NO;
    }
    
    
    isShowingEditTransionTypeMenu = NO;
    [UIView animateWithDuration:0.2 animations:^{
        editTranstionTypeMune.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [editTranstionTypeMune removeFromSuperview];
    }];
    if (videoModel.transtionType != transtionModel.transtionIndex) {
        videoModel.transtionType = transtionModel.transtionIndex;
        videoModel.transtionModel  = transtionModel;
        videoisEdit = YES;
        [_recordInfo originCompositionBecomeNone];
        [self newThumbSliderWillDeselectThisVideoModel:videoModel];
        NSArray *videoArr = _recordInfo.videoSource;
        NSInteger index = [videoArr indexOfObject:videoModel];
        if ((index + 1) < videoArr.count) {
            JPVideoModel *lastVideoModel = [videoArr objectAtIndex:(index + 1)];
            [self.compositionPlayer seekToTime:CMTimeSubtract([_thumbSilderView getStartTimeWithModel:lastVideoModel], CMTimeMake(1, 1))];
        }
        [self.compositionPlayer startPlaying];
    }
}


#pragma mark - JPPackageFilterMenuViewDelegate


- (void)collectionScrollViewDidScroll:(UIScrollView *)scrollView{
    if ([PKGuideManager manager].guide) {
        CGFloat offsetX = scrollView.contentOffset.x;
        self.filterGuideView.transform = CGAffineTransformMakeTranslation(-offsetX, 0);
    }
}

- (void)packageFilterMenuViewDidSelectFilter:(JPFilterModel *)filter {
    [self.compositionPlayer seekToTime:kCMTimeZero];
    _recordInfo.currentFilterType = filter.filterType;
    _recordInfo.currentFilterModel = filter;
    [_compositionPlayer switchFilter];
    [self.compositionPlayer startPlaying];
    if ([PKGuideManager manager].guide && [PKGuideManager manager].filterNo == 2 && self.guide) {
        [PKGuideManager manager].filterNo = 3;
        [self.filterGuideView removeFromSuperview];
        self.filterGuideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，选中滤镜" type:PKGuideViewTailTypeRight];
        [filterMenuView addSubview:self.filterGuideView];
        self.filterGuideView.frame = CGRectMake(SCREEN_WIDTH - self.filterGuideView.guideSize.width - 10, -self.filterGuideView.guideSize.height, self.filterGuideView.guideSize.width, self.filterGuideView.guideSize.height);
    }else{
        self.guide = NO;
    }
    
    
    
}

- (void)packageFilterMenuViewWillDismiss {
    isShowingFilterMenu = NO;
    [self someViewWillDismiss];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        filterMenuView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [filterMenuView removeFromSuperview];
        if (_compositionPlayer.isPlaying == NO) {
            [self changeVideoPlayStatus:nil];
        }
    }];
    if ([PKGuideManager manager].guide) {
        [self.filterGuideView removeFromSuperview];
        if ([PKGuideManager manager].guideNumber == 5 && self.guide) {
            [PKGuideManager manager].guideNumber = 6;
        }else{
            self.guide = NO;
        }
    }
}

#pragma mark JPVideoEditMuneDelegate

- (void)videoEditMuneWillDelegateThisVideo:(JPVideoModel *)videoModel
{
  
    if (_recordInfo.videoSource.count == 1) {
        [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:@"只有一段视频时不能删除"];
        return;
    }
    [_recordInfo deleteVideofile:videoModel];
    videoisEdit = YES;
    [_recordInfo originCompositionBecomeNone];
    [self newThumbSliderWillDeselectThisVideoModel:videoModel];
    [self changeVideoPlayStatus:nil];
  
}


- (void)videoEditMuneWillClidThisVideo:(JPVideoModel *)videoModel
{
   
    CMTimeRange timeRange = videoModel.timeRange;
    JPVideoModel *copyModel = [videoModel copy];
    videoModel.timeRange = CMTimeRangeMake(timeRange.start, CMTimeSubtract(editVideoMune.currentTime, timeRange.start));
    if (CMTimeCompare(videoModel.timeRange.duration, CMTimeMake(4, 1)) < 0 && videoModel.timePlayType == JPVideoTimePlayTypeFast) {
        videoModel.timePlayType = JPVideoTimePlayTypeNone;
    }
    videoisEdit = YES;
    [_recordInfo originCompositionBecomeNone];
    [_recordInfo addVideoFile:copyModel];
    copyModel.timeRange = CMTimeRangeMake(editVideoMune.currentTime,CMTimeSubtract(CMTimeAdd(timeRange.start, timeRange.duration), editVideoMune.currentTime));
    if (CMTimeCompare(copyModel.timeRange.duration, CMTimeMake(4, 1)) < 0 && copyModel.timePlayType == JPVideoTimePlayTypeFast) {
        copyModel.timePlayType = JPVideoTimePlayTypeNone;
    }
    NSInteger index = _recordInfo.videoSource.count - 1;
    NSInteger toIndex = [_recordInfo.videoSource indexOfObject:videoModel] + 1;
    [_recordInfo exchangeVideoFileIndex:index toIndex:toIndex];
    [self newThumbSliderWillDeselectThisVideoModel:videoModel];
    [_compositionPlayer seekToTime:CMTimeSubtract([_thumbSilderView getStartTimeWithModel:copyModel], CMTimeMake(1, 1))];
    [self changeVideoPlayStatus:nil];
}


- (void)videoEditMuneWillEditPlaySpeedThisVideo:(JPVideoModel *)videoModel
{
    
    if ([PKGuideManager manager].guide){
        [self.thumGuideView removeFromSuperview];
        if ( [PKGuideManager manager].guideNumber == 9 && self.guide) {
            [PKGuideManager manager].guideNumber = 10;
            self.guideView = [[PKGuideView alloc]initGuideViewWithContent:@"轻点视频，取消选中" type:PKGuideViewTailTypeVertical];
            [self.thumbSilderView.collectionView addSubview:self.guideView];
            self.guideView.frame = CGRectMake(0, -self.guideView.guideSize.height - 30, self.guideView.guideSize.width, self.guideView.guideSize.height);
        }else{
            self.guide = NO;
        }
    }
    
    videoisEdit = YES;
    [_recordInfo originCompositionBecomeNone];
    if (videoModel.timePlayType == JPVideoTimePlayTypeSlow) {
        [_videoeditMessageView updateVideoEditMessage:@"正在转为慢动作视频"];
    }else if (videoModel.timePlayType == JPVideoTimePlayTypeFast)
    {
        [_videoeditMessageView updateVideoEditMessage:@"正在转为延时视频"];
    }
    [_thumbSilderView updateVideoApearTimeWithModel:videoModel];
}


- (void)videoEditMuneWillEditReverseThisVideo:(JPVideoModel *)videoModel
{
//    if (videoEditGuideView && [self.view.subviews containsObject:videoEditGuideView]) {
//        _thumbSilderView.hasClickActive = YES;
//        [videoEditGuideView removeGuide:kPackageOfVideoTranverseGuideStep withAnimation:YES];
//    }
    videoisEdit = YES;
    [_recordInfo originCompositionBecomeNone];
    if (videoModel.isReverse == YES) {
        if (CMTimeCompare(videoModel.videoTime, CMTimeMake(60, 1)) >= 0 && videoModel.reverseUrl == nil) {
            [_videoeditMessageView updateVideoEditMessage:@"您的视频较长，需要更多的时间进行转换，请耐心等待"];
        }else{
            [_videoeditMessageView updateVideoEditMessage:@"正在转为倒序视频"];
        }
    }
    if (videoModel.reverseUrl == nil && videoModel.isReverse == YES) {
        [self showHUD];
        self.view.userInteractionEnabled = NO;
        NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:videoModel.videoUrl options:inputOptions];
        
        __weak typeof(self) blockSelf = self;
        blockSelf.isCancel = NO;
        [inputAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler: ^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *error = nil;
                AVKeyValueStatus tracksStatus = [inputAsset statusOfValueForKey:@"tracks" error:&error];
                if (tracksStatus != AVKeyValueStatusLoaded)
                {
                    [blockSelf checkToMianQueueWithBaseFile:nil andVideoModel:videoModel];
                    return;
                }
                NSString *baseName = [JPVideoUtil fileNameForDocumentMovie];
                [JPVideoUtil assetByReversingAsset:inputAsset videoComposition:nil duration:inputAsset.duration outputURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:baseName]] progressHandle:^(CGFloat progress) {
                    NSLog(@"------%.4f", progress);
                } cancle:&_isCancel compoletion:^(NSURL *url) {
                    [blockSelf checkToMianQueueWithBaseFile:baseName andVideoModel:videoModel];
                }];
            });
        }];
        
    }else{
        [self newThumbSliderWillDeselectThisVideoModel:videoModel];
        [self changeVideoPlayStatus:nil];
    }
}

- (void)checkToMianQueueWithBaseFile:(NSString *)baseFile andVideoModel:(JPVideoModel *)videoModel
{
    NSArray *videoArr = _recordInfo.videoSource;
    for (JPVideoModel *videoModels in videoArr) {
        if (videoModels != videoModel && [videoModels.videoUrl.path isEqualToString:videoModel.videoUrl.path]) {
            videoModels.reverseVideoBaseFile = baseFile;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self hidHUD];
        self.view.userInteractionEnabled = YES;
        videoModel.reverseVideoBaseFile = baseFile;
        [self newThumbSliderWillDeselectThisVideoModel:videoModel];
        [self changeVideoPlayStatus:nil];
    });
}
#pragma mark JPPhotoEditMuneDelegate
- (void)photoEditMuneWillDelegateThisVideo:(JPVideoModel *)videoModel
{
    
    if (_recordInfo.videoSource.count == 1) {
        [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:@"只有一段视频时不能删除"];
        return;
    }
    [_recordInfo deleteVideofile:videoModel];
    videoisEdit = YES;
    [_recordInfo originCompositionBecomeNone];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [self newThumbSliderWillDeselectThisVideoModel:videoModel];
    [self changeVideoPlayStatus:nil];
}


- (void)photoEditMuneWillEditVideoPhotoAnimationTypeWithModel:(JPVideoModel *)videoModel withReduceAction:(BOOL)reduce
{
    
    videoisEdit = YES;
    [self.recordInfo originCompositionBecomeNone];
}

#pragma mark - JPAudioMenuBaseViewDelegate

- (void)musicCollectionViewScrollViewDidScroll:(UIScrollView *)scrollView{
    if ([PKGuideManager manager].guide) {
        CGFloat offsetX = scrollView.contentOffset.x;
        self.musicGuideView.transform = CGAffineTransformMakeTranslation(-offsetX, 0);
    }
}

- (void)musicCollectionViewItemDidSelected{
    if ([PKGuideManager manager].guide) {
        [self.musicGuideView removeFromSuperview];
    }
}

- (void)musicListWillPop{
    if ([PKGuideManager manager].guide && self.guide) {
        [self.musicGuideView removeFromSuperview];
    }
}


- (void)musicListDidPop{

    if ([PKGuideManager manager].guide && [PKGuideManager manager].musicNo == 4 && self.guide) {
        [self.musicGuideView removeFromSuperview];
        self.musicGuideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，选中音乐" type:PKGuideViewTailTypeRight];
        [audioMenuBaseView addSubview:self.musicGuideView];
        self.musicGuideView.frame = CGRectMake(SCREEN_WIDTH - self.musicGuideView.guideSize.width - 10, -self.musicGuideView.guideSize.height, self.musicGuideView.guideSize.width, self.musicGuideView.guideSize.height);
    }else{
        self.guide = NO;
    }
}


- (void)musicCollectionLoadData{

    [self addMusicGuideView];
}
//guide
- (void)firstMusicUnDownload{
    if ([PKGuideManager manager].guide && self.guide) {
        [self.musicGuideView removeFromSuperview];
        self.musicGuideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，下载音乐" type:PKGuideViewTailTypeRight];
        [audioMenuBaseView addSubview:self.musicGuideView];
        self.musicGuideView.frame = CGRectMake(SCREEN_WIDTH - self.musicGuideView.guideSize.width , 10, self.musicGuideView.guideSize.width, self.musicGuideView.guideSize.height);
    }
}

- (void)firstMusicDownloading{
    if ([PKGuideManager manager].guide && self.guide) {
        [self.musicGuideView removeFromSuperview];
    }
}

- (void)firstMusicDownloaded{
    if ([PKGuideManager manager].guide && self.guide && [PKGuideManager manager].musicNo == 2) {
        [PKGuideManager manager].musicNo = 3;
        [self.musicGuideView removeFromSuperview];
        self.musicGuideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，添加音乐" type:PKGuideViewTailTypeRight];
        [audioMenuBaseView addSubview:self.musicGuideView];
        self.musicGuideView.frame = CGRectMake(SCREEN_WIDTH - self.musicGuideView.guideSize.width, 10, self.musicGuideView.guideSize.width, self.musicGuideView.guideSize.height);
    }
}

- (void)selectedBackgroundMusicModel:(JPAudioModel *)model {
    
    if ([PKGuideManager manager].guide){
        if (self.guide && [PKGuideManager manager].musicNo == 3) {
            [PKGuideManager manager].musicNo = 4;
            [self.musicGuideView removeFromSuperview];
            self.musicGuideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，返回" type:PKGuideViewTailTypeLeft];
            [audioMenuBaseView addSubview:self.musicGuideView];
            self.musicGuideView.frame = CGRectMake( 10, -self.musicGuideView.guideSize.height, self.musicGuideView.guideSize.width, self.musicGuideView.guideSize.height);
        }
        [self.guideView removeFromSuperview];
        if ([PKGuideManager manager].guideNumber == 12 && self.guide) {
            [PKGuideManager manager].guideNumber = 13;
        }else{
            self.guide = NO;
        }
    }
    [_compositionPlayer pauseToPlay];
    if (model.isITunes) {
        itunesMusicModel = model;
        [self toSelectItunesMusic];
        return;
    }
    _recordInfo.backgroundMusic = model;
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer seekToTime:kCMTimeZero];
    [_compositionPlayer startPlaying];
}

- (void)didDeleteBackgroundMusic{
    _recordInfo.backgroundMusic = nil;
    [audioMenuBaseView endPlay];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer seekToTime:kCMTimeZero];
}

- (void)audioMenuViewShouldDismiss {
    if ([PKGuideManager manager].guide) {
        [self.musicGuideView removeFromSuperview];
        self.musicGuideView = nil;
    }
    if ([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 13 && self.guide) {
        
        [PKGuideManager manager].guideNumber = 14;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.guideView = [[PKGuideView alloc]initNextGuideViewWith:@"预览视频后，点击这里" andRightSpace:25];
            [self.navagatorView addSubview:self.guideView];
            self.navagatorView.clipsToBounds = NO;
            self.guideView.frame = CGRectMake(SCREEN_WIDTH - self.guideView.guideSize.width - 5, 80, self.guideView.guideSize.width, self.guideView.guideSize.height);
            [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#0091FF"] forState:UIControlStateNormal];
            self.rightBtBackView = [[UIView alloc]init];
            [self.rightButton.superview addSubview:self.rightBtBackView];
            [self.rightButton.superview bringSubviewToFront:self.rightButton];
            self.rightBtBackView.sd_layout.centerXEqualToView(self.rightButton).centerYEqualToView(self.rightButton).heightIs(50).widthIs(50);
            self.rightBtBackView.backgroundColor = UIColor.whiteColor;
            self.rightBtBackView.layer.cornerRadius = 25;
            self.rightBtBackView.layer.masksToBounds = YES;
            self.statusView.backgroundColor = UIColor.clearColor;
            
        });
        
    }
    if (audioMenuBaseView && audioMenuBaseView.superview) {
        [self someViewWillDismiss];
        self.videoPlayBackViewHeightLayoutConstraint.constant = SCREEN_WIDTH;
        isShowingAudioMenuBaseView = NO;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
            audioMenuBaseView.top = SCREEN_HEIGHT;
            [self audioMenuWillShow:NO];
        } completion:^(BOOL finished) {
            [audioMenuBaseView removeFromSuperview];
            if (self.compositionPlayer.isPlaying == NO) {
                [self changeVideoPlayStatus:nil];
            }
        }];
    }
}

- (void)volumeDidChangedToValue:(CGFloat)volume{
    
}

- (void)someViewWillDismiss
{
    [self.promptView dismiss];
    self.promptView = nil;
    [self resetViewFrameWithTop:NO];
}
- (void)someMuneViewWillShow
{
    [self.promptView dismiss];
    self.promptView = nil;
    [_compositionPlayer pauseToPlay];
    [self resetViewFrameWithTop:YES];
    
}


- (void)resetViewFrameWithTop:(BOOL)isTop;
{
    if (isTop) {
        self.navigationBackViewTopLayoutConstraint.constant = -44.0f;
    }else{
        self.navigationBackViewTopLayoutConstraint.constant = 0.0f;
    }
}


- (IBAction)changeVideoPlayStatus:(id)sender {
    if (isShowingPatternMuneView || isShowingGraphPatternMuneView || isEditSticker == YES) {
        return;
    }
    
    if (self.compositionPlayer.isPlaying == YES) {
        [audioMenuBaseView endPlay];
        [self.compositionPlayer pauseToPlay];
    }else{
        if(isShowingEditTransionTypeMenu == YES){
            [self newTranstionChangedViewChangeTranstionModel:editTranstionTypeMune.videoModel.transtionModel withTranstionModel:editTranstionTypeMune.videoModel];
        }
        if (isShowingEditVideoMenu == YES || isShowingEditPhotoMenu == YES) {
            if (isShowingEditPhotoMenu == YES) {
                [self newThumbSliderWillDeselectThisVideoModel:editPhotoMune.videoModel];
            }else{
                [self newThumbSliderWillDeselectThisVideoModel:editVideoMune.videoModel];
            }
        }
        [self updateStickers];
        [self.compositionPlayer startPlaying];
        if (_recordInfo.backgroundMusic && _recordInfo.backgroundMusic.fileUrl) {
            [audioMenuBaseView startPlay];
        }
    }
}

- (void)updateStickers
{
    [_viewCache willDisAllView];
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (JPPackagePatternAttribute *patternAttribute in _patternArray) {
        if (patternAttribute.needUpdate == YES) {
            [self showHUD];
            [_compositionPlayer addPackagePattern:patternAttribute];
            if (patternAttribute.patternType != JPPackagePatternTypeGifPattern) {
                UIImage * image = [_viewCache getImageWithModel:patternAttribute];
                if (patternAttribute.imagePicture) {
                    [patternAttribute.imagePicture removeAllTargets];
                    [[patternAttribute.imagePicture framebufferForOutput] clearAllLocks];
                    [patternAttribute.imagePicture removeOutputFramebuffer];
                    patternAttribute.imagePicture = nil;
                }
                [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
                if (image == nil) {
                    [deleteArr addObject:patternAttribute];
                    [_compositionPlayer removePackagePattern:patternAttribute];
                }else{
                    patternAttribute.imagePicture = [[GPUImagePicture alloc] initWithImage:image];
                    patternAttribute.needUpdate = NO;
                }
            }else
            {
                patternAttribute.needUpdate = NO;
            }
        }
        if (patternAttribute.needUpdateFrame == YES) {
            CGFloat padding = 13;
            if (patternAttribute.patternType == JPPackagePatternTypeHollowOutPicture || patternAttribute.patternType == JPPackagePatternTypeWeekPicture) {
                padding = 0;
            }
            patternAttribute.apearFrame = CGRectMake((patternAttribute.frame.origin.x + padding) / _graphBackView.width, (patternAttribute.frame.origin.y  + padding)/ _graphBackView.height, (patternAttribute.frame.size.width - padding * 2) / _graphBackView.width, (patternAttribute.frame.size.height - padding * 2) / _graphBackView.height);
            patternAttribute.needUpdateFrame = NO;
        }
    }
    [_patternArray removeObjectsInArray:deleteArr];
    [self hidHUD];
    
}


- (IBAction)selectFilterAction:(id)sender {
    if ([PKGuideManager manager].guide) {
        [self.guideView removeFromSuperview];
        if ([PKGuideManager manager].guideNumber == 4 && self.guide) {
            [PKGuideManager manager].guideNumber = 5;
        }else{
            self.guide = NO;
        }
    }
    [self someMuneViewWillShow];
    isShowingFilterMenu = YES;
    [_compositionPlayer scrollToWatchThumImageWithTime:kCMTimeZero withSticker:YES];
    if (!filterMenuView) {
        CGRect frame = CGRectMake(0, self.view.height, SCREEN_WIDTH, self.view.height - SCREEN_WIDTH);
        //滤镜
        filterMenuView = [[JPPackageFilterMenuView alloc] initWithFrame:frame];
        filterMenuView.delegate = self;
        [filterMenuView layoutIfNeeded];
    }
    if ([PKGuideManager manager].guide && [PKGuideManager manager].filterNo == 1 && self.guide) {
        [PKGuideManager manager].filterNo = 2;
        self.filterGuideView = [[PKGuideView alloc]initGuideViewWithContent:@"点这里，选择该滤镜" type:PKGuideViewTailTypeVertical];
        [filterMenuView.collecView addSubview:self.filterGuideView];
        self.filterGuideView.frame = CGRectMake(120 - self.filterGuideView.guideSize.width / 2.0, -self.filterGuideView.guideSize.height - 30 , self.filterGuideView.guideSize.width, self.filterGuideView.guideSize.height);
    }else{
        self.guide = NO;
    }
    [filterMenuView reloadRecordInfo:_recordInfo];
    [self.view addSubview:filterMenuView];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        filterMenuView.top = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark JPNewPatternMuneViewDelegate


- (void)newPatternMuneViewWillDismissWith:(JPNewPatternMuneView *)muneView
{
    [self someViewWillDismiss];
    isShowingPatternMuneView = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        newPatternMuneView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [newPatternMuneView removeFromSuperview];
        if (self.compositionPlayer.isPlaying == NO) {
            [self changeVideoPlayStatus:nil];
        }
    }];
}


- (void)newPatternMuneViewWillAddPatternWith:(JPNewPatternMuneView *)muneView
{
//    isShowingPatternMuneView = NO;
//    if (self.compositionPlayer.isPlaying) {
//        [self changeVideoPlayStatus:nil];
//    }
//    isShowingGraphPatternMuneView = YES;
//    [newPatternMuneView removeFromSuperview];
//    [self someMuneViewWillShow];
//    if (!graphPatternMuneView) {
//        CGRect frame = CGRectMake(0, self.view.height, SCREEN_WIDTH, self.view.height - SCREEN_WIDTH);
//        graphPatternMuneView = [[JPPackageGraphPatternMenuView alloc] initWithFrame:frame];
//        graphPatternMuneView.recordInfo = _recordInfo;
//        [graphPatternMuneView layoutIfNeeded];
//        graphPatternMuneView.delegate = self;
//    }
//    [graphPatternMuneView show];
//    graphPatternMuneView.currentTime = _thumbSilderView.currentTime;
//    graphPatternMuneView.selectHotPatternAttribute = selectedHotGraphAttribute;
//    [self.view addSubview:graphPatternMuneView];
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.view layoutIfNeeded];
//        graphPatternMuneView.top = SCREEN_WIDTH;
//    } completion:^(BOOL finished) {
//
//    }];
    
}

- (IBAction)selectGraphAction:(id)sender {
//    if (guideView && [self.view.subviews containsObject:guideView]) {
//        [guideView removeGuide:kPackageOfAddPatternGuideStep withAnimation:NO];
//    }
//    if (self.compositionPlayer.isPlaying) {
//        [self changeVideoPlayStatus:nil];
//    }
//    [self someMuneViewWillShow];
//    isShowingPatternMuneView = YES;
//    if (newPatternMuneView == nil) {
//        CGRect frame = CGRectMake(0, self.view.height, SCREEN_WIDTH, self.view.height - SCREEN_WIDTH);
//        newPatternMuneView = [[JPNewPatternMuneView alloc] initWithFrame:frame];
//        newPatternMuneView.delegate = self;
//        [newPatternMuneView layoutIfNeeded];
//    }
//    newPatternMuneView.videoCompositionPlayer = _compositionPlayer;
//    NSMutableArray *dataArr = _patternArray.mutableCopy;
//    for (JPPackagePatternAttribute *patternAttribute in _patternArray) {
//        if (patternAttribute.patternType == JPPackagePatternTypeWeekPicture) {
//            [dataArr removeObject:patternAttribute];
//            break;
//        }
//    }
//    newPatternMuneView.dataSource = dataArr;
//    [self.view addSubview:newPatternMuneView];
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.view layoutIfNeeded];
//        newPatternMuneView.top = SCREEN_WIDTH;
//    } completion:^(BOOL finished) {
//    }];
    isShowingPatternMuneView = NO;
    if (self.compositionPlayer.isPlaying) {
        [self changeVideoPlayStatus:nil];
    }
    isShowingGraphPatternMuneView = YES;
    [newPatternMuneView removeFromSuperview];
    [self someMuneViewWillShow];
    if (!graphPatternMuneView) {
        CGRect frame = CGRectMake(0, self.view.height, SCREEN_WIDTH, self.view.height - SCREEN_WIDTH);
        graphPatternMuneView = [[JPPackageGraphPatternMenuView alloc] initWithFrame:frame];
        graphPatternMuneView.recordInfo = _recordInfo;
        [graphPatternMuneView layoutIfNeeded];
        graphPatternMuneView.delegate = self;
    }
    [graphPatternMuneView show];
    graphPatternMuneView.currentTime = _thumbSilderView.currentTime;
    graphPatternMuneView.selectHotPatternAttribute = selectedHotGraphAttribute;
    [self.view addSubview:graphPatternMuneView];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        graphPatternMuneView.top = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        
    }];
    
}
- (IBAction)selectMusicAction:(id)sender {
    
    if (self.compositionPlayer.isPlaying) {
        [self changeVideoPlayStatus:nil];
    }
    [self someMuneViewWillShow];
    CGFloat height = ScreenFitFloat6(259);
    height = height + KStatusBarHeight;
    self.videoPlayBackViewHeightLayoutConstraint.constant = ScreenFitFloat6(259);
    [_compositionPlayer scrollToWatchThumImageWithTime:kCMTimeZero withSticker:YES];
    isShowingAudioMenuBaseView = YES;
    if (!audioMenuBaseView) {
        CGRect frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - height);
        audioMenuBaseView = [[JPAudioMenuBaseView alloc] initWithFrame:frame withVideoCompositionPlayer:_compositionPlayer];
        audioMenuBaseView.delegate = self;
    }
    if (audioMenuBaseView.musicMenu.dataLoad) {
        if ([PKGuideManager manager].musicNo == 1) {
            [self addMusicGuideView];
        }else{
            self.guide = NO;
        }
    }
    [self.view addSubview:audioMenuBaseView];
    [audioMenuBaseView setCurrentTime:_thumbSilderView.currentTime];
    [audioMenuBaseView setRecordInfo:_recordInfo];
    audioMenuBaseView.thumImageDic = [self getVideoTotalThumbImages];
    [audioMenuBaseView refreshMenu];
    [UIView animateWithDuration:0.5 animations:^{
        audioMenuBaseView.top = height;
        [self.view layoutIfNeeded];
        [self audioMenuWillShow:YES];
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark JPPackageGraphPatternMenuViewDelegate

- (void)deleteGraphWithData:(JPPackagePatternAttribute *)data
{
    hotGraphInteractiveView.hidden = YES;
    hotGraphInteractiveView = nil;
    for (JPPackagePatternAttribute *attibute in _patternArray) {
        if (attibute.patternType == JPPackagePatternTypeWeekPicture) {
            [_patternArray removeObject:attibute];
            [_compositionPlayer removePackagePattern:attibute];
            break;
        }
    }
    selectedHotGraphAttribute = nil;
    _patternInteractiveView = nil;
}

- (void)toPicturePickerView
{
    isShowingImgController = YES;
    JPImgPickerViewController *imgPickerVC = [[JPImgPickerViewController alloc] init];
    imgPickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imgPickerVC animated:YES completion:nil];
}

- (void)selectedGraphWithData:(JPPackagePatternAttribute *)data
{
    if (CMTimeCompare(_thumbSilderView.currentTime, _recordInfo.totalVideoDuraion) >= 0 && data.patternType != JPPackagePatternTypeWeekPicture) {
        return;
    }
    if (_compositionPlayer.isPlaying == YES) {
        [self changeVideoPlayStatus:nil];
    }
    if (data.patternType == JPPackagePatternTypeWeekPicture) {
        [_compositionPlayer scrollToWatchThumImageWithTime:kCMTimeZero withSticker:NO];
    }
    JPPackagePatternAttribute *attribute = data.copy;
    if (attribute.patternType == JPPackagePatternTypeHollowOutPicture || attribute.patternType == JPPackagePatternTypeWeekPicture) {
        attribute.videoFrame = _recordInfo.aspectRatio;
        attribute.frame = CGRectMake(0, 0, _graphBackView.width, _graphBackView.height);
    }
    if (attribute.patternType == JPPackagePatternTypeWeekPicture) {
        selectedHotGraphAttribute = attribute;
    }
    double currentTime = CMTimeGetSeconds(_thumbSilderView.currentTime);
    double startTime = round(currentTime / 0.5);
    CMTime attributeTime = CMTimeMakeWithSeconds(startTime * 0.5, 30);
    if (CMTimeCompare(attributeTime, CMTimeSubtract(_recordInfo.totalVideoDuraion, CMTimeMake(1, 1))) > 0) {
        attributeTime = CMTimeMakeWithSeconds((startTime - 1) * 0.5, 30);
    }
    attribute.timeRange = CMTimeRangeMake(attributeTime, CMTimeSubtract(_recordInfo.totalVideoDuraion,attributeTime));
    if (attribute.patternType == JPPackagePatternTypeWeekPicture) {
        attribute.isGlod = YES;
    }
    if (attribute.patternType == JPPackagePatternTypeWeekPicture) {
        [self.patternArray sgrInsertObject:attribute atIndex:[self.patternArray count]];
    } else {
        [self.patternArray addObject:attribute];
    }
    _patternInteractiveView = [_viewCache addCacheFromViewModel:attribute withSuperView:_graphBackView];
    if (JPPackagePatternTypeWeekPicture == attribute.patternType) {
        hotGraphInteractiveView = _patternInteractiveView;
        if (CMTimeCompare(_thumbSilderView.currentTime, _recordInfo.totalVideoDuraion) >= 0) {
            hotGraphInteractiveView.hidden = YES;
        }
        return;
    }
    isShowingGraphPatternMuneView = NO;
    [graphPatternMuneView removeFromSuperview];
    isEditSticker = YES;
    CGRect frame = CGRectMake(0, self.view.height, SCREEN_WIDTH, self.view.height - SCREEN_WIDTH);
    if (!attributeView) {
        attributeView = [[JPPackagePatternAttributeView alloc] initWithFrame:frame];
        attributeView.delegate = self;
    }
    if (![self.view.subviews containsObject:attributeView]) {
        [self.view addSubview:attributeView];
    }
    [attributeView updateViewWithType:attribute andVideoCompositon:_compositionPlayer];
    attributeView.apearView = _patternInteractiveView;
    [_patternInteractiveView updateContent];
    _playButton.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        attributeView.top = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hide
{
    isShowingGraphPatternMuneView = NO;
    [self someViewWillDismiss];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        graphPatternMuneView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [graphPatternMuneView removeFromSuperview];
        if (self.compositionPlayer.isPlaying == NO) {
            [self changeVideoPlayStatus:nil];
        }
    }];
    
}

#pragma mark JPPackageViewCacheDelegate

- (void)packageViewCacheRemoveViewModel:(JPPackagePatternAttribute *)viewModels withViewCache:(JPPackageViewCache *)cache
{
    [self.patternArray removeObject:viewModels];
    [self.compositionPlayer removePackagePattern:viewModels];
    if (attributeView.patternAttributeModel == viewModels) {
        if (isEditSticker == YES) {
            [self patternAttributeViewWillHide];
        }
        self.patternInteractiveView = nil;
    }
    if (isShowingPatternMuneView) {
        newPatternMuneView.videoCompositionPlayer = _compositionPlayer;
        NSMutableArray *dataArr = _patternArray.mutableCopy;
        for (JPPackagePatternAttribute *patternAttribute in _patternArray) {
            if (patternAttribute.patternType == JPPackagePatternTypeWeekPicture) {
                [dataArr removeObject:patternAttribute];
                break;
            }
        }
        newPatternMuneView.dataSource = dataArr;
    }
}


- (void)packageViewCacheWillEditTheView:(JPPatternInteractiveView *)view withViewCache:(JPPackageViewCache *)cache
{
    if (view.patternAttribute.patternType == JPPackagePatternTypeWeekPicture) {
        return;
    }
    if (_compositionPlayer.isPlaying) {
        [_compositionPlayer pauseToPlay];
    }
    if (isShowingPatternMuneView == YES) {
        [newPatternMuneView removeFromSuperview];
        isShowingPatternMuneView = NO;
    }
    if (isShowingGraphPatternMuneView == YES) {
        [graphPatternMuneView removeFromSuperview];
        isShowingGraphPatternMuneView = NO;
    }
    isEditSticker = YES;
    self.patternInteractiveView = view;
    CGRect frame = CGRectMake(0, self.view.height, SCREEN_WIDTH, self.view.height - SCREEN_WIDTH);
    if (attributeView.patternAttributeModel == view.patternAttribute && attributeView.superview != nil) {
        return;
    }
    if (attributeView && attributeView.superview != nil) {
        [attributeView removeFromSuperview];
    }
    [self someMuneViewWillShow];
    _playButton.hidden = YES;
    if (!attributeView) {
        attributeView = [[JPPackagePatternAttributeView alloc] initWithFrame:frame];
        attributeView.delegate = self;
    }
    if (![self.view.subviews containsObject:attributeView]) {
        [self.view addSubview:attributeView];
    }
    [attributeView updateViewWithType:view.patternAttribute andVideoCompositon:_compositionPlayer];
    attributeView.apearView = view;
    [view updateContent];
    [UIView animateWithDuration:0.5 animations:^{
        attributeView.top = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)packageViewCacheWillInputTheView:(JPPatternInteractiveView *)view withViewCache:(JPPackageViewCache *)cache
{
    if (view.patternAttribute.patternType == JPPackagePatternTypeWeekPicture) {
        return;
    }
    JPPackagePatternAttribute *patternAttribute = view.patternAttribute;
    JPPackagePatternType type = patternAttribute.patternType;
    if (type != JPPackagePatternTypeWeather && type != JPPackagePatternTypeDate && type != JPPackagePatternTypePicture && type != JPPackagePatternTypeHollowOutPicture && type != JPPackagePatternTypeWeekPicture && type!= JPPackagePatternTypeDownloadedPicture) {
        if (!patternInputView) {
            patternInputView = [[JPPatternInputView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            patternInputView.delegate  = self;
        }
        isEditSticker = YES;
        self.patternInteractiveView = view;
        if (_compositionPlayer.isPlaying) {
            [self changeVideoPlayStatus:nil];
        }
        [_compositionPlayer levelCurrentPage];
        if (patternInputView && patternInputView.superview == nil) {
            [self.view addSubview:patternInputView];
            [patternInputView showWithPatternInteractiveView:view];
        }
    }
}
- (void)packageViewCacheWillMove:(JPPatternInteractiveView *)view withViewCache:(JPPackageViewCache *)cache
{
    calibratView.hidden = NO;
    
}
- (void)packageViewCacheEndMove:(JPPatternInteractiveView *)view withViewCache:(JPPackageViewCache *)cache
{
    calibratView.hidden = YES;
    view.patternAttribute.frame = view.frame;
}


#pragma mark JPPackagePatternAttributeViewDelegate
- (void)patternAttributeViewWillHide
{
    calibratView.hidden = YES;
    [self.promptView dismiss];
    self.promptView = nil;
    isEditSticker = NO;
    [self someViewWillDismiss];
    self.patternInteractiveView = nil;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        attributeView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [attributeView removeFromSuperview];
        if (self.compositionPlayer.isPlaying == NO) {
            [self changeVideoPlayStatus:nil];
        }
    }];
    
}

#pragma mark - JPPatternInputViewDelegate

- (void)patternInputViewWillDismiss {
    [_compositionPlayer returnCurrentPage];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer scrollToWatchThumImageWithTime:_patternInteractiveView.patternAttribute.timeRange.start withSticker:NO];
}

- (void)setGuide:(BOOL)guide{
    _guide = guide;
    if (!self.guide) {
        [self.thumbSilderView removeGuideView];
        [self.guideView removeFromSuperview];
        [self.musicGuideView removeFromSuperview];
        [self.filterGuideView removeFromSuperview];
        [self.thumGuideView removeFromSuperview];
        [self.transformGuideView removeFromSuperview];
        [self.rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.rightBtBackView removeFromSuperview];
    }
}

@end
