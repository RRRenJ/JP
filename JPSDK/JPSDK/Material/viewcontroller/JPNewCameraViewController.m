//
//  JPNewCameraViewController.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewCameraViewController.h"
#import "JPVideoPlayerView.h"
#import "JPVideoRecordProgressView.h"
#import "JPNewFilterCollectionView.h"
#import "JPCameraSettingView.h"
#import "JPStartRecordButton.h"
#import "JPNewPageViewController.h"
#import "JPSettingViewController.h"
#import "JPHotListViewController.h"
#import "JPNewImportViewController.h"
#import "JPAlertView.h"
#import "JPNextButton.h"
#import "JPSession.h"
#import "JPRecordGuideView.h"
#import "JPGradientAnimateGuideView.h"
#import "JPWebViewController.h"
#import "PKActiveDetailModel.h"

#import "PKGuideCameraView.h"

#import "PKGuideVideoView.h"

@interface JPNewCameraViewController ()<JPCameraSettingViewDelegate, JPNewFilterCollectionViewDelegate,UIAlertViewDelegate>
{
    JPAlertView *avAuthorizationAlertView;
    dispatch_queue_t _graphManagementQueue;
    BOOL isLongPressToRecord;
    BOOL isAnimateGuide;
}
@property (strong, nonatomic) IBOutlet PKGuideCameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *videoPlayerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPlayerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPlayerOriginX;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIButton *escButton;
@property (weak, nonatomic) IBOutlet JPVideoPlayerView *filterNameView;
@property (weak, nonatomic) IBOutlet JPVideoRecordProgressView *progressView;
@property (weak, nonatomic) IBOutlet JPNewFilterCollectionView *filterCollectionView;
@property (weak, nonatomic) IBOutlet JPCameraSettingView *cameraSettingView;
@property (weak, nonatomic) IBOutlet JPStartRecordButton *startRecordButton;
@property (weak, nonatomic) IBOutlet UILabel *startBtStatusLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterCollectionViewOriginX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sunTop;
@property (weak, nonatomic) IBOutlet UIView *focusView;
@property (nonatomic, strong) JPVideoCamera *videoCamera;
@property (nonatomic, strong) NSTimer *focusTimer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foucusViewOriginY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *focusviewOriginX;
@property (weak, nonatomic) IBOutlet UIView *navigationBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic) JPVideoHowFast howFastType;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CMTime recordTime;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIImageView *circularView;
@property (nonatomic, assign) CMTime totalRecordTime;
@property (weak, nonatomic) IBOutlet UIButton *nextGreyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterTop;
@property (nonatomic, assign) BOOL isFirstInit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeights;

@property (nonatomic, strong) PKGuideVideoView * guideVideoView;

@property (nonatomic, strong) UIView * guideVideoMaskView;

@end

@implementation JPNewCameraViewController

- (IBAction)watchHotVideo:(id)sender {
    [JPSession sharedInstance].tagID = @"";
    [[JPAppDelegate shareAppdelegate].baseTabBarController swicthToTheHostPage];
    __weak typeof(self) weakSelf = self;
    [_recordInfo becomeOrigin];
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
    }];
   
    [JPSession sharedInstance].selectTaskModel = nil;
    
}
- (IBAction)clickToSettingVC:(id)sender {
    

    JPSettingViewController *settingVC = [[JPSettingViewController alloc] init];
    settingVC.cancelGesturesReturn = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (IBAction)escRecording:(id)sender {
    if (sender) {
        [MobClick event:@"firstStepLose"];
    }
    if (_fromPackage) {
        [_videoCamera stopCameraCapture];
        [_videoCamera destruction];
        _videoCamera = nil;

        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"确定要退出本次编辑？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是", nil];
        [alert show];
    }
}
- (IBAction)addVideoAction:(id)sender {

    
    JPNewImportViewController *newImportVC = [[JPNewImportViewController alloc] init];
    newImportVC.recordInfo = _recordInfo;
    newImportVC.fromPackage = _fromPackage;

    
    [self.navigationController pushViewController:newImportVC animated:YES];
}
- (IBAction)nextRecording:(id)sender {
    [_videoCamera stopCameraCapture];
    [_videoCamera destruction];
    _videoCamera = nil;
    if (_fromPackage) {

        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else{

        JPNewPageViewController *trimVC = [[JPNewPageViewController alloc] init];
        trimVC.recordInfo = _recordInfo;
        trimVC.cancelGesturesReturn = NO;
        
        [self.navigationController setViewControllers:@[trimVC] animated:YES];
        
    }
}

- (IBAction)recordAction:(id)sender {
    if (self.guideVideoView) {
        [self.guideVideoView removeFromSuperview];
        [self.guideVideoView stop];
    }
    [self getCameraAndAudioAuthorized:^(BOOL isAuthorized) {
        if (isAuthorized) {
            self.startRecordButton.userInteractionEnabled = NO;
            [self recordSomething];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.startRecordButton.userInteractionEnabled = YES;
            });
        }
    } andTips:YES];
}

- (void)recordSomething {
    if (_videoCamera.isRecordingMovie && CMTimeCompare(_recordTime, JP_VIDEO_MIN_DURATION) < 0) {
        [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:@"录制时间太短"];
        return;
    }
    
    
    _cameraSettingView.hidden = YES;
    _recordTime = kCMTimeZero;
    _progressView.hidden = NO;
    _addButton.hidden = YES;
    self.navigationBackView.hidden = YES;
    if (_videoCamera.isRecordingMovie) {
        self.startBtStatusLb.text = @"拍摄";
        __weak typeof(self) weakSelf = self;
        [_videoCamera stopRecordingMovieWithCompletion:^(NSString *basevideoPath, NSString *originvideoPath) {
            JPVideoModel *model = [[JPVideoModel alloc] init];
            model.videoBaseFile = originvideoPath;
            model.videoTime = [JPVideoUtil getVideoDurationWithSourcePath:model.videoUrl];
            if (CMTimeCompare(model.videoTime, JP_VIDEO_MIN_DURATION) >= 0) {
                model.sourceType = JPVideoSourceCamera;
                model.originThumbImage = [JPVideoUtil getFirstImageWithVideoUrl:model.videoUrl];
                [_progressView endUpdateViewWithVideoModel:model];
                [weakSelf.recordInfo addVideoFile:model];
                [self nextRecording:nil];
            }else{
                [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:@"录制时间太短，最短须3秒"];
                [_progressView endUpdateViewWithVideoModel:nil];
            }
            [weakSelf setRecordInfo:weakSelf.recordInfo];
        }];
      
        _cameraSettingView.hidden = NO;
        self.navigationBackView.hidden = NO;
        _addButton.hidden = NO;
        [_startRecordButton endRecord];
        [_timer invalidate];
        _timer = nil;
//        if ([JPUtil getInfoFromUserDefaults:@"first-record"] == nil) {
//            [self configuePromptViewWithView:_addButton andType:JPPromptViewTypeFirst andTopOffset:5 andLeftOffset:0];
//            [self.promptView show];
//            [JPUtil saveIssueInfoToUserDefaults:@"first-record" resouceName:@"first-record"];
//        }
    }else{

        self.startBtStatusLb.text = @"";
       if (CMTimeCompare(_recordInfo.currentTotalTime, CMTimeSubtract(_recordInfo.totalDuration, JP_VIDEO_MIN_DURATION)) >= 0) {
           [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:@"已达编辑视频时长30min上限啦～"];
            _cameraSettingView.hidden = NO;
            self.navigationBackView.hidden = NO;
            _addButton.hidden = NO;
            [_startRecordButton endRecord];
            [_timer invalidate];
            _timer = nil;
            return;
        }
        [_cameraSettingView hasRecord];
        [_videoCamera focusAndLockAtPoint:CGPointMake(.5, .5)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_videoCamera startRecordingMovie];
            _totalRecordTime = CMTimeSubtract(_recordInfo.totalDuration, _recordInfo.currentTotalTime);
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
            [_startRecordButton updateProgressWithTime:kCMTimeZero];
            [_progressView becomeAddViewWithVideoSourceType:JPVideoSourceCamera];        });
    }
}

- (void)showAVAuthorizationAlertWithTittle:(NSString *)tittle {
    CGFloat height = KShrinkStatusBarHeight;
    avAuthorizationAlertView = [[JPAlertView alloc] initWithTitle:tittle
                                                         andFrame:CGRectMake(0, 44 + height, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self.view addSubview:avAuthorizationAlertView];
    avAuthorizationAlertView.sd_layout.topSpaceToView(self.view, 44).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(SCREEN_WIDTH);
}

- (void)hiddenAVAuthorizationAlert {
    [avAuthorizationAlertView removeFromSuperviewAndClearAutoLayoutSettings];
    avAuthorizationAlertView = nil;
}

- (void)updateProgress
{
    _recordTime = CMTimeAdd(_recordTime, CMTimeMake(10, 100));
    CMTime reallyTime = _recordTime;
    CGFloat scale = 1.0;
    if (_howFastType == JPVideoHowFastFast) {
        scale = 0.2f;
    }else if (_howFastType == JPVideoHowFastSlow){
        scale = 4.0f;
    }
    reallyTime =CMTimeMultiplyByFloat64(reallyTime, scale);
    if (CMTimeCompare(kCMTimeZero, reallyTime) >= 0) {
        reallyTime = kCMTimeZero;
    }
    [_progressView updateViewWidthWithDuration:reallyTime];
    if (CMTimeCompare(reallyTime, _totalRecordTime) >= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self recordAction:self.startRecordButton];
        });
        return;
    }
    [_startRecordButton updateProgressWithTime:reallyTime];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    if (![JPSession sharedInstance].cityName.length) {
        [[JPSession sharedInstance] initLocate];
    }
    _howFastType = JPVideoHowFastNormal;
    _progressViewTop.constant = KShrinkStatusBarHeight;
    _navigationBarHeights.constant = KShrinkNavigationHeight;
    _graphManagementQueue = dispatch_queue_create("video.session.graph", 0);
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor blackColor];
    if (!_recordInfo) {
        _recordInfo = [[JPVideoRecordInfo alloc] initWithFilterManager:[[JPFilterManagers alloc] init]];
        _recordInfo.currentFilterModel = _filterCollectionView.currentFilterModel;
        _recordInfo.currentFilterType = _recordInfo.currentFilterType;
    }
    if (_fromPackage) {
        [_escButton setImage:[UIImage imageNamed:@"down-1"] forState:UIControlStateNormal];
    }
    _videoCamera = [[JPVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack withRecordInfo:_recordInfo];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusPoint:)];
    [self.filterNameView addGestureRecognizer:tap];
    self.focusView.hidden = YES;
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanAction:)];
    leftPan.minimumNumberOfTouches = 1;
    leftPan.maximumNumberOfTouches = 5;
    [self.filterNameView addGestureRecognizer:leftPan];
    _filterTop.constant = SCREEN_WIDTH + 44 - 90;
    _filterCollectionView.delegate = self;
    _filterCollectionViewOriginX.constant = SCREEN_WIDTH;
    _filterCollectionView.isPage = NO;
    self.recordInfo = _recordInfo;
    _cameraSettingView.delegate = self;
    if (_videoCamera == nil) {
        return;
    }
    [_videoPlayerView addSubview:_videoCamera.gpuImageView];
    _videoCamera.gpuImageView.sd_layout.leftEqualToView(_videoPlayerView);
    _videoCamera.gpuImageView.sd_layout.rightEqualToView(_videoPlayerView);
    _videoCamera.gpuImageView.sd_layout.topEqualToView(_videoPlayerView);
    _videoCamera.gpuImageView.sd_layout.bottomEqualToView(_videoPlayerView);
    _videoCamera.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [_cameraSettingView setSupportSlow:_videoCamera.supportSlow];
    __weak typeof(self) weakSelf = self;
    [_videoCamera setVideoCameraFinishRecordBlock:^{
        weakSelf.cameraSettingView.hidden = NO;
        weakSelf.cameraSettingView.hidden = NO;
        weakSelf.navigationBackView.hidden = NO;
        weakSelf.addButton.hidden = NO;
        [weakSelf.startRecordButton endRecord];
        [weakSelf.timer invalidate];
        weakSelf.timer = nil;
        [weakSelf.progressView endUpdateViewWithVideoModel:nil];
    }];
    [self.videoPlayerView bringSubviewToFront:_circularView];
    [self.videoPlayerView bringSubviewToFront:self.focusView];
    self.hasRegistAppStatusNotification = YES;
    _isFirstInit = NO;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(audoFoucs:)];
    longPress.minimumPressDuration = 1.0;
    [self.view addGestureRecognizer:longPress];
    [tap requireGestureRecognizerToFail:longPress];
    
    UILongPressGestureRecognizer *recordLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToRecord:)];
    recordLongPress.minimumPressDuration = 1.0;
    [self.startRecordButton addGestureRecognizer:recordLongPress];
    
    if (self.fromPackage) {
        self.nextGreyButton.hidden = YES;
    }else{
        if ([JPSession sharedInstance].selectTaskModel) {
            self.nextGreyButton.hidden = YES;
        }else{
            self.nextGreyButton.hidden = NO;
        }
    }
    
    if ([[PKGuideManager manager] guideAgain] && !self.nextGreyButton.hidden) {
        self.guideView = [[PKGuideView alloc]initNextGuideViewWith:@"点击这里，可以继续测试" andRightSpace:15];
        [self.navigationBackView addSubview:self.guideView];
        self.guideView.frame = CGRectMake(SCREEN_WIDTH - self.guideView.guideSize.width - 5, KISIPhoneX ? 100 : 60, self.guideView.guideSize.width, self.guideView.guideSize.height);
    }
    WEAK(self);
    self.cameraView.touchBlock = ^{
        if ([PKGuideManager manager].guideAgain && !self.nextGreyButton.hidden) {
            [weakself.guideView removeFromSuperview];
            [[PKGuideManager manager] closeGuideAgain];
        }
        if ([PKGuideManager manager].guide) {
            if (weakself.guideVideoView) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakself.guideVideoView.alpha = 0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        if (weakself.guideVideoHideBlock) {
                            weakself.guideVideoHideBlock();
                        }
                        [weakself.guideVideoView stop];
                        [weakself.guideVideoView removeFromSuperview];
                        [weakself.guideVideoMaskView removeFromSuperview];
                        weakself.guideVideoView = nil;
                        if ([PKGuideManager manager].guideNumber == 1) {
                            [weakself showHandClickedGuideView];
                        }
                        if ([PKGuideManager manager].guideNumber == 3) {
                            [weakself showAroundClickedGuideView];
                        }
                    }
                }];
            }
        }
    };
}



- (void)addGuideView{

    if ([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 1) {
        [self showHandClickedGuideView];
    }
    if ([PKGuideManager manager].guide && [PKGuideManager manager].guideNumber == 3) {
        [self showAroundClickedGuideView];
    }
}

- (void)showHandClickedGuideView{
    [self.guideView removeFromSuperview];
    self.guideView = nil;
    self.guideView = [[PKGuideView alloc]initClickGuideViewWithContent:@"选择对象A拍摄一段3S以上的视频" type:PKGuideViewTailTypeVertical];
    [self.view addSubview:self.guideView];
    self.guideView.sd_layout.centerXEqualToView(self.videoPlayerView).heightIs(self.guideView.guideSize.height).widthIs(self.guideView.guideSize.width).bottomSpaceToView(self.videoPlayerView, 0);
    WEAK(self);
    self.guideView.clickedBlock = ^{
        [weakself.guideView removeFromSuperview];
        [weakself loadHandGuideVideo];
    };
}

- (void)showAroundClickedGuideView{
    [self.guideView removeFromSuperview];
    self.guideView = nil;
    self.guideView = [[PKGuideView alloc]initClickGuideViewWithContent:@"选择对象B拍摄一段3S以上的视频" type:PKGuideViewTailTypeVertical];
    [self.view addSubview:self.guideView];
    self.guideView.sd_layout.centerXEqualToView(self.videoPlayerView).heightIs(self.guideView.guideSize.height).widthIs(self.guideView.guideSize.width).bottomSpaceToView(self.videoPlayerView, 0);
    WEAK(self);
    self.guideView.clickedBlock = ^{
        [weakself.guideView removeFromSuperview];
        [weakself loadAroundGuideVideo];
    };
}


- (void)longPressToRecord:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        if (!_videoCamera.isRecordingMovie) {
            isLongPressToRecord = YES;
            [self recordAction:nil];
        }
    }else if (ges.state == UIGestureRecognizerStateEnded){
        if (isLongPressToRecord) {
            [self recordAction:nil];
            isLongPressToRecord = NO;
        }
    }
}

- (void)back {
    [_recordInfo becomeOrigin];
    self.recordInfo = _recordInfo;
}

- (void)failUploaded:(NSNotification *)notification
{
    [_recordInfo becomeOrigin];
    self.recordInfo = _recordInfo;

    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)toHotList:(NSNotification *)notification {
    [_recordInfo becomeOrigin];
    self.recordInfo = _recordInfo;
    BOOL toHotList = [[notification object] boolValue];
    if (toHotList) {
        [[JPAppDelegate shareAppdelegate].baseTabBarController swicthToTheHostPage];
        __weak typeof(self) weakSelf = self;
        

        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        }];
    } else {
        __weak typeof(self) weakSelf = self;
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        }];

    }
}

- (void)appBecomeBackgound
{
    [_videoCamera stopCameraCapture];
}

- (void)appBecomeActive
{
    [_videoCamera startCameraCapture];
    self.recordInfo = _recordInfo;
}


- (void)leftPanAction:(UIPanGestureRecognizer *)pan
{
    if (self.focusView.isHidden) {
        return;
    }
    [_focusTimer invalidate];
    _focusTimer = nil;
    [self.focusView.layer removeAllAnimations];
    CGPoint point = [pan translationInView:self.videoPlayerView];
    NSLog(@"%f,%f",point.x,point.y);
    self.sunTop.constant = self.sunTop.constant + point.y / 10.0f;
    if (self.sunTop.constant < 0) {
        self.sunTop.constant = 0;
    }else if (self.sunTop.constant > 90){
        self.sunTop.constant = 90;
    }
    self.videoCamera.currentBrightness = -((self.sunTop.constant - 45.0) / 45.0f);
    [pan setTranslation:CGPointMake(0, 0) inView:self.focusView];
    if (pan.state == UIGestureRecognizerStateEnded) {
        _focusTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(focusViewDismiss) userInfo:nil repeats:NO];
    }
    
}


- (void)audoFoucs:(UILongPressGestureRecognizer *)longPressG
{
    CGPoint prssPoint = [longPressG locationInView:self.videoPlayerView];
    CGRect rect = self.videoPlayerView.bounds;
    BOOL contains =CGRectContainsPoint(rect, prssPoint);
    if (contains && longPressG.state == UIGestureRecognizerStateBegan) {
        self.focusView.hidden = YES;
        [_focusTimer invalidate];
        _focusTimer = nil;
        [self.focusView.layer removeAllAnimations];
        CGSize focusSize = self.focusView.bounds.size;
        _focusviewOriginX.constant = prssPoint.x - 25;
        _foucusViewOriginY.constant = prssPoint.y - focusSize.height / 2.0;
        self.focusView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.focusView.hidden = NO;
        [UIView animateWithDuration:0.15 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        [_videoCamera lockFocusAndAutoLight:[self captureDevicePointForPoint:prssPoint]];
        [UIView animateWithDuration:0.3 animations:^{
            self.focusView.alpha = 0.3;
            self.focusView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
    }
}

- (void)focusPoint:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:self.videoPlayerView];
    CGRect rect = self.videoPlayerView.bounds;
    BOOL contains =CGRectContainsPoint(rect, tapPoint);
    if (contains) {
        self.focusView.alpha = 1.0;
        self.focusView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.focusView.hidden = YES;
        [_focusTimer invalidate];
        _focusTimer = nil;
        [self.focusView.layer removeAllAnimations];
        CGSize focusSize = self.focusView.bounds.size;
        _focusviewOriginX.constant = tapPoint.x - 25;
        _foucusViewOriginY.constant = tapPoint.y - focusSize.height / 2.0;
        self.focusView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.focusView.hidden = NO;
        [UIView animateWithDuration:0.15 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        [_videoCamera focusAndLockAtPoint:[self captureDevicePointForPoint:tapPoint]];
        _focusTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(focusViewDismiss) userInfo:nil repeats:NO];
    }
}

- (CGPoint)captureDevicePointForPoint:(CGPoint)point {
    CGSize videpReallySize = _videoCamera.videoSize;
    CGSize videoReallyScreenSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / videpReallySize.width * videpReallySize.height);
    CGPoint cameraPoint = CGPointMake(point.x / videoReallyScreenSize.width, (point.y + (videoReallyScreenSize.height - _videoPlayerView.height) / 2.0) / videoReallyScreenSize.height);
    return cameraPoint;
}
// 将屏幕坐标系的点转换为摄像头坐标系的点

- (void)focusViewDismiss
{
    [_focusTimer invalidate];
    _focusTimer = nil;
    [UIView animateWithDuration:0.2 animations:^{
        self.focusView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.focusView.hidden = YES;
        self.focusView.alpha = 1.0;
    }];
}


- (void)setRecordInfo:(JPVideoRecordInfo *)recordInfo
{
    _recordInfo = recordInfo;
    _cameraSettingView.recordInfo = recordInfo;
    _videoCamera.recordInfo = recordInfo;
    [_videoCamera switchFilter];
    [_filterNameView setSelectFilterModel:_recordInfo.currentFilterModel];
    [_filterNameView setSelectVideoAspectRatio:_recordInfo.aspectRatio];
    [_videoCamera switchSessionPreset:_recordInfo.aspectRatio];
    [_filterCollectionView reloadRecordInfo:recordInfo];
    if (_recordInfo.videoSource.count > 0) {
        _progressView.hidden = NO;
        _progressView.recordInfo = recordInfo;
        [_cameraSettingView hasRecord];
        _hotButton.hidden = YES;
        _escButton.hidden = NO;
    }else{
        _progressView.hidden = YES;
        _progressView.recordInfo = recordInfo;
        [_cameraSettingView startRecord];
        _hotButton.hidden = NO;
        _escButton.hidden = YES;
    }
    CGFloat originY = 0;
    CGFloat height = SCREEN_HEIGHT;
    CGFloat defautHeight = KShrinkNavigationHeight;
  
    _circularView.hidden = YES;
    switch (_recordInfo.aspectRatio) {
        case JPVideoAspectRatio16X9:
            height = SCREEN_WIDTH / 16.0 * 9.0;
            originY = defautHeight + SCREEN_WIDTH / 16.0 * 3.5;
            break;
        case JPVideoAspectRatio1X1:
            originY = defautHeight;
            height = SCREEN_WIDTH;
            break;
        case JPVideoAspectRatioCircular:
            originY = defautHeight;
            height = SCREEN_WIDTH;
            _circularView.hidden = NO;
            break;
            
        case JPVideoAspectRatio4X3:
            originY = defautHeight + SCREEN_WIDTH / 4.0 * 0.5;
            height = (SCREEN_WIDTH / 4.0) * 3.0;
            break;
        default:
            break;
    }
    _videoPlayerHeight.constant = height;
    _videoPlayerOriginX.constant = originY;
    if (originY != 0) {
        self.navigationBackView.backgroundColor = [UIColor clearColor];
        self.bottomView.backgroundColor = [UIColor clearColor];
    }else{
        self.navigationBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addGuideView];
    
    [PKDCManager track:@"pageView" withProperties:@{@"pagename":@"拍摄页面",@"pageid":@"app02"}];
    
    if ([JPSession sharedInstance].selectTaskModel) {
        if (![((PKActiveDetailModel *)[JPSession sharedInstance].selectTaskModel).task_id isEqualToString:@"1"]) {
            [PKDCManager track:@"capturePageView" withProperties:@{@"entrance":@"任务页【立即投稿】按钮"}];
        }
    }else{
         [PKDCManager track:@"capturePageView" withProperties:@{@"entrance":@"首页【相机图标】"}];
    }
  
    [JPUtil setupStatusBarHidden:YES];
    
    _startRecordButton.enabled = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.recordInfo = _recordInfo;
        [self enabledRecordVideo];
        [self hiddenAVAuthorizationAlert];
        [JPUtil showVideoAuthorizationAlertWithCompletionHandler:^(BOOL grant){
            [JPUtil showAudioAuthorizationAlertWithCompletionHandler:^(BOOL agree){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!agree && !grant) {
                        [self disabledRecordVideo];
                        NSString *str = @"没有摄像头，拍不到美丽的画面呀~请在「设置」-「隐私」-「相机」中打开未来拍客的相机获取权限\n\n不用麦克风，岂不回到默片时代？请在「设置」-「隐私」-「麦克风」中打开未来拍客的麦克风获取权限";
                        [self showAVAuthorizationAlertWithTittle:str];
                    } else if(!grant){
                        NSString *str = @"没有摄像头，拍不到美丽的画面呀~请在「设置」-「隐私」-「相机」中打开未来拍客的相机获取权限";
                        [self showAVAuthorizationAlertWithTittle:str];
                    } else if (!agree){
                        NSString *str = @"不用麦克风，岂不回到默片时代？请在「设置」-「隐私」-「麦克风」中打开未来拍客的麦克风获取权限";
                        [self showAVAuthorizationAlertWithTittle:str];
                    }
                });
            }];
        }];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_videoCamera startCameraCapture];
    _startRecordButton.enabled = YES;


}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_videoCamera stopCameraCapture];
}

- (void)enabledRecordVideo {
    _startRecordButton.enabled = YES;
}

- (void)disabledRecordVideo{
    _startRecordButton.enabled = NO;
}


#pragma mark JPCameraSettingViewDelegate

- (void)cameraSettingViewDidChangeCameraSession
{
    [_videoCamera rotateCamera];
    [self focusViewDismiss];
    [self.videoCamera focusAndLockAtPoint:CGPointMake(0.5, 0.5)];

}

- (void)cameraSettingViewWillChangeVideoFrame{

}

- (void)cameraSettingViewWillChangeVideoHowFast{

    
}

- (void)cameraSettingViewDidChangeVideoFrame:(JPVideoAspectRatio)aspectRatio
{
    _recordInfo.aspectRatio = aspectRatio;
    _recordInfo.hasChangedAspectRatio = YES;
    [_filterNameView updateVideoAspectRatio:aspectRatio];
    CGFloat originY = 0;
    CGFloat height = SCREEN_HEIGHT;
    CGFloat defautHeight = KShrinkNavigationHeight;
    
    _circularView.hidden = YES;
    switch (_recordInfo.aspectRatio) {
        case JPVideoAspectRatio16X9:
            height = SCREEN_WIDTH / 16.0 * 9.0;
            originY = defautHeight + SCREEN_WIDTH / 16.0 * 3.5;
            break;
        case JPVideoAspectRatio1X1:
            originY = defautHeight;
            height = SCREEN_WIDTH;
            break;
        case JPVideoAspectRatioCircular:
            originY = defautHeight;
            height = SCREEN_WIDTH;
            _circularView.hidden = NO;
            break;
            
        case JPVideoAspectRatio4X3:
            originY = defautHeight + SCREEN_WIDTH / 4.0 * 0.5;
            height = (SCREEN_WIDTH / 4.0) * 3.0;
            break;
        default:
            break;
    }
    [_filterCollectionView reloadRecordInfo:_recordInfo];
    [UIView animateWithDuration:0.2 animations:^{
        _videoPlayerHeight.constant = height;
        _videoPlayerOriginX.constant = originY;
        [_videoPlayerView.superview layoutIfNeeded];
        [_videoPlayerView layoutIfNeeded];
      
        if (originY != 0) {
            self.navigationBackView.backgroundColor = [UIColor clearColor];
            self.bottomView.backgroundColor = [UIColor clearColor];
        }else{
            self.navigationBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        }
    }];
    

}
- (void)cameraSettingViewDidChangeVideoHowFast:(JPVideoHowFast)howFast{

    _howFastType = howFast;
    [_videoCamera setHowFastType:howFast];
}
- (void)cameraSettingViewDidChangeOpenLight:(BOOL)isOpenLight
{
    if (isOpenLight) {
        [_videoCamera openFlashlight];
    }else{
        [_videoCamera closeFlashlight];
    }


}
- (void)cameraSettingViewDidChangeFilter:(BOOL)isOpenFilter
{
    [_filterCollectionView reloadRecordInfo:_recordInfo];
    [_filterCollectionView.layer removeAllAnimations];
    [_filterCollectionView.superview.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (isOpenFilter) {
            _filterCollectionViewOriginX.constant = 0;

        }else{
            _filterCollectionViewOriginX.constant = SCREEN_WIDTH;
        }
        [_filterCollectionView.superview layoutIfNeeded];
        
    } completion:^(BOOL finish){

    }];
}

#pragma mark JPNewFilterCollectionViewDelegate
- (void)newFilterCollectionViewDidSelectFilter:(JPFilterModel *)filterModel
{
    _recordInfo.currentFilterType = filterModel.filterType;
    _recordInfo.currentFilterModel = filterModel;
    [_videoCamera switchFilter];
    [_filterNameView updateFilterModel:filterModel];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [self watchHotVideo:nil];
    }
}

- (void)destruction
{
    [_videoCamera destruction];
    _videoCamera = nil;
}
- (IBAction)nextHtmlVC:(id)sender {

    if (![PKGuideManager manager].guide) {
        self.nextGreyButton.hidden = YES;
        [[PKGuideManager manager] start];
        if( self.guideView){
            [self.guideView removeFromSuperview];
            self.guideView = nil;
        }
        [self requestGuideTask];
        [self addGuideView];
        [PKDCManager track:@"beginTest" withProperties:@{}];
    }
    

}

- (void)dealloc
{
    
}

#pragma mark - request
- (void)requestGuideTask {
    NSMutableDictionary *dic = @{@"service":@"App.Content_Task.Info",
                                 @"task_id":@"1"
                                }.mutableCopy;
    WEAK(self);
    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response) {
        if ([response.ret integerValue] == 200) {
            PKActiveDetailModel * model = [PKActiveDetailModel mj_objectWithKeyValues:response.data];
            [JPSession sharedInstance].selectTaskModel = model;
        }else {
            [[JPAppDelegate shareAppdelegate] showAlertViewWithTitle:response.message];
        }
    } failure:^(NSError *error) {
        [weakself hidHUD];
    } withErrorMsg:@"网络出错，请稍后重试"];
}

- (void)loadHandGuideVideo{
    if (self.guideVideoView) {
        return;
    }
    if (self.guideVideoShowBlock) {
        self.guideVideoShowBlock();
    }
    self.guideVideoView = [[PKGuideVideoView alloc]initWithVideoName:@"guide_video_1"];
    [self.cameraView addSubview:self.guideVideoMaskView];
    [self.videoPlayerView addSubview:self.guideVideoView];
    [self.cameraView bringSubviewToFront:self.videoPlayerView];
    self.guideVideoView.frame = self.videoPlayerView.bounds;
    [self.guideVideoView play];
    WEAK(self);
    self.guideVideoView.playToEndBlock = ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.guideVideoView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [weakself.guideVideoView stop];
                [weakself.guideVideoView removeFromSuperview];
                [weakself.guideVideoMaskView removeFromSuperview];
                weakself.guideVideoView = nil;
                [weakself showHandClickedGuideView];
            }
        }];
    };
    
    self.guideVideoView.playBreakBlock = ^{
        [weakself.guideVideoView removeFromSuperview];
        [weakself.guideVideoMaskView removeFromSuperview];
        weakself.guideVideoView = nil;
        [weakself showHandClickedGuideView];
    };
}

- (void)loadAroundGuideVideo{
    if (self.guideVideoView) {
        return;
    }
    if (self.guideVideoShowBlock) {
        self.guideVideoShowBlock();
    }
    self.guideVideoView = [[PKGuideVideoView alloc]initWithVideoName:@"guide_video_2"];
    [self.cameraView addSubview:self.guideVideoMaskView];
    [self.videoPlayerView addSubview:self.guideVideoView];
    [self.cameraView bringSubviewToFront:self.videoPlayerView];
    self.guideVideoView.frame = self.videoPlayerView.bounds;
    [self.guideVideoView play];
    WEAK(self);
    self.guideVideoView.playToEndBlock = ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.guideVideoView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [weakself.guideVideoView stop];
                [weakself.guideVideoView removeFromSuperview];
                [weakself.guideVideoMaskView removeFromSuperview];
                weakself.guideVideoView = nil;
                [weakself showAroundClickedGuideView];
            }
        }];
    };
    
    self.guideVideoView.playBreakBlock = ^{
        [weakself.guideVideoView removeFromSuperview];
        [weakself.guideVideoMaskView removeFromSuperview];
        weakself.guideVideoView = nil;
        [weakself showAroundClickedGuideView];
    };
}

- (void)guideVideoHide{
    if (self.guideVideoView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.guideVideoView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.guideVideoView stop];
                [self.guideVideoView removeFromSuperview];
                [self.guideVideoMaskView removeFromSuperview];
                self.guideVideoView = nil;
                if ([PKGuideManager manager].guideNumber == 1) {
                    [self showHandClickedGuideView];
                }
                if ([PKGuideManager manager].guideNumber == 3) {
                    [self showAroundClickedGuideView];
                }
            }
        }];
    }
}

- (UIView *)guideVideoMaskView{
    if (!_guideVideoMaskView) {
        _guideVideoMaskView = [[UIView alloc]initWithFrame:self.view.bounds];
        _guideVideoMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    }
    return _guideVideoMaskView;
}

@end
