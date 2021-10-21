//
//  JPVideoClipViewController.m
//  jper
//
//  Created by FoundaoTEST on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPVideoClipViewController.h"
#import "JPVideoRecordProgressView.h"
#import "JPCoustomButton.h"
#import "JPNewPageViewController.h"
@interface JPVideoClipViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *buttonActionView;
@property (weak, nonatomic) IBOutlet UIView *videoBackView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet JPVideoRecordProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *frameView;
@property (weak, nonatomic) IBOutlet UIImageView *startSliderView;
@property (weak, nonatomic) IBOutlet UIImageView *endSliderView;
@property (weak, nonatomic) IBOutlet UIView *topSliderLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomSliderLineView;
@property(nonatomic, strong) JPVideoLocal *videoLocal;
@property (nonatomic, assign) CGFloat imageViewWidth;
@property (nonatomic, strong) NSMutableArray *thumbImageArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startSliderOriginX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endSliderOriginX;
@property (nonatomic, assign) CMTime reallyHasTime;
@property (nonatomic, assign) CMTime currentHasTime;
@property (nonatomic, assign) CMTime currentStartTime;
@property (weak, nonatomic) IBOutlet UILabel *timeLongLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstActionButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *forthButton;
@property (nonatomic, strong) JPVideoLocal *writeVideoLocal;
@property (weak, nonatomic) IBOutlet UIView *leftPanView;
@property (weak, nonatomic) IBOutlet UIView *rightPanView;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *leftMaskView;
@property (weak, nonatomic) IBOutlet UIView *rightMaskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startSliderWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endSliderWidth;
//@property (nonatomic) JPVideoTranstionType transtionType;
@property (nonatomic) JPPhotoModelTranstionType photoTranstionType;

@property (weak, nonatomic) IBOutlet UIView *imageActionView;

@property (weak, nonatomic) IBOutlet UIButton *noneButton;

@property (weak, nonatomic) IBOutlet UIButton *toBigButton;
@property (weak, nonatomic) IBOutlet UIButton *toSmallButton;
@property (weak, nonatomic) IBOutlet UIImageView *circularView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoBackViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewTop;

- (void)refreshSliderViewsAtMinState:(BOOL)atMin;

@end

@implementation JPVideoClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AVURLAsset *videoAsset = [AVURLAsset assetWithURL:self.videoModel.videoUrl];
    _totalVideoTime = JP_VIDEO_MIN_DURATION;
    if ([videoAsset tracksWithMediaType:AVMediaTypeVideo].count == 0) {
        [MBProgressHUD jp_showMessage:@"视频资源错误,无法合成"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [JPUtil setViewRadius:self.startSliderView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(2, 2)];
    [JPUtil setViewRadius:self.endSliderView byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
    _startTimeLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:12];
    _endTimeLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:12];
    _currentTimeLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:30];
    _totalTimeLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:18];
    _totalTimeLabel.text = [NSString stringWithFormat:@"%ldS", (long)ceil(CMTimeGetSeconds(_videoModel.videoTime))];
    _totalTimeLabel.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.25].CGColor;
    _totalTimeLabel.layer.shadowRadius = 1;
    _totalTimeLabel.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _totalTimeLabel.hidden = YES;
    _leftTimeLabel.font = _rightTimeLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:11];
    _rightTimeLabel.text = _endTimeLabel.text = [NSString stringWithTimeInterval:(NSInteger)ceil(CMTimeGetSeconds(_videoModel.videoTime))];
    [self createNavigatorViewWithHeight:JPShrinkNavigationHeight];
    [self addLeftButtonWithTittle:nil withImage:JPImageWithName(@"exits") target:self action:@selector(escEdit)];
    [self addRightButtonWithTittle:nil withImage:JPImageWithName(@"confirm") target:self action:@selector(finishedEidt:)];
    _progressViewTop.constant = JPShrinkStatusBarHeight;
    _videoBackViewTop.constant = JPShrinkStatusBarHeight;
    [self configueVideoLocal];
    self.navagatorView.backgroundColor = [UIColor clearColor];
    _startSliderView.hidden = YES;
    _startSliderView.tag = 0;
    _endSliderView.hidden = YES;
    _topSliderLineView.hidden = YES;
    _bottomSliderLineView.hidden= YES;
    _rightTimeLabel.hidden = YES;
    _leftTimeLabel.hidden = YES;
    _rightMaskView.hidden = YES;
    _leftMaskView.hidden = YES;
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanAction:)];
    leftPan.minimumNumberOfTouches = 1;
    leftPan.maximumNumberOfTouches = 5;
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanAction:)];
    rightPan.minimumNumberOfTouches = 1;
    rightPan.maximumNumberOfTouches = 5;
    [_progressView setRecordInfo:_recordInfo];
    if (_recordInfo.aspectRatio == JPVideoAspectRatioCircular &&( _recordInfo.videoSource.count != 0 || _recordInfo.hasChangedAspectRatio == YES)) {
        _circularView.hidden = NO;
    }else{
        _circularView.hidden = YES;
    }
    [_leftPanView addGestureRecognizer:leftPan];
    [_rightPanView addGestureRecognizer:rightPan];
    _currentStartTime = kCMTimeZero;
    _reallyHasTime = _videoModel.videoTime;
    _currentHasTime = _videoModel.videoTime;
    if (_isSecondStep) {
        _progressView.hidden = YES;
        _progressViewHeight.constant = 0;
        _timeLongLabel.hidden = NO;
        _buttonActionView.hidden = NO;
        if (self.videoModel.isImage == YES) {
            _imageActionView.hidden = NO;
            if (self.videoModel.photoTransionType == JPPhotoModelTranstionNormal) {
                [self photoActionSelect:self.noneButton];
            }else if (self.videoModel.photoTransionType == JPPhotoModelTranstionBigToSmall)
            {
                [self photoActionSelect:self.toSmallButton];

            }else{
                [self photoActionSelect:self.toBigButton];

            }
        }
//        switch (_videoModel.transtionType) {
//            case JPVideoTranstionNone:
//                [self transtionTypeSelectAction:self.firstActionButton];
//                break;
//            case JPVideoTranstionGradient:
//                [self transtionTypeSelectAction:self.secondButton];
//                break;
//            case JPVideoTranstionIncluded:
//                [self transtionTypeSelectAction:self.thirdButton];
//                break;
//            case JPVideoTranstionSuperposition:
//                [self transtionTypeSelectAction:self.forthButton];
//                break;
//        }
    }
    self.hasRegistAppStatusNotification = YES;
}

- (IBAction)photoActionSelect:(id)sender {
    [self.noneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.toBigButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.toSmallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIButton *button = (UIButton *)sender;
    [button setTitleColor:[UIColor jp_colorWithHexString:@"0091FF"] forState:UIControlStateNormal];
    if (sender == _noneButton) {
        _photoTranstionType = JPPhotoModelTranstionNormal;
    }else if (sender == _toBigButton)
    {
        _photoTranstionType = JPPhotoModelTranstionSmallToBig;
    }else{
        _photoTranstionType = JPPhotoModelTranstionBigToSmall;
    }
    [_videoLocal addPhotoTranstionWithType:_photoTranstionType];
}



- (void)configueVideoLocal
{
    AVURLAsset *urlAset = [AVURLAsset assetWithURL:_videoModel.videoUrl];
    NSLog(@"-----urlast %@", [urlAset tracksWithMediaType:AVMediaTypeVideo]);
    _videoLocal = [[JPVideoLocal alloc] initWithURLPre:urlAset recordInfo:_recordInfo];
    [_videoBackView addSubview:_videoLocal.gpuImageView];
    _videoLocal.gpuImageView.sd_layout.leftEqualToView(_videoBackView);
    _videoLocal.gpuImageView.sd_layout.rightEqualToView(_videoBackView);
    _videoLocal.gpuImageView.sd_layout.topEqualToView(_videoBackView);
    _videoLocal.gpuImageView.sd_layout.bottomEqualToView(_videoBackView);
    _videoLocal.timeRenderLabel = _currentTimeLabel;
    _videoLocal.isClib = YES;
    [_videoBackView bringSubviewToFront:_circularView];
    
}
- (void)appBecomeActive
{
    [self configueVideoLocal];
    [self updateProgress];
    [_videoLocal startProcessing];
}

- (void)appBecomeBackgound
{
    self.view.userInteractionEnabled = YES;
    [self jp_hideHUD];
    [_videoLocal destruction];
    [self.writeVideoLocal destruction];
    _videoLocal = nil;
    _writeVideoLocal = nil;
}

- (void)leftPanAction:(UIPanGestureRecognizer *)pan{
    [self refreshSliderViewsAtMinState:NO];
    _rightTimeLabel.hidden = YES;
    _totalTimeLabel.hidden = YES;
    if (CMTimeCompare(_reallyHasTime,JP_VIDEO_MIN_DURATION) <= 0) {
         return;
    }
    [_videoLocal pause];
    CGPoint point = [pan translationInView:self.startSliderView];
    _startSliderOriginX.constant = _startSliderOriginX.constant + point.x;
    if (_startSliderOriginX.constant <= 7.5) {
        _startSliderOriginX.constant = 7.5;
    }else if(_startSliderOriginX.constant >= (JP_SCREEN_WIDTH - _endSliderOriginX.constant - 16)){
        _startSliderOriginX.constant = (JP_SCREEN_WIDTH - _endSliderOriginX.constant - 16);
    }
    CMTime currentTime = [self videoReallyTime];
    if (CMTimeCompare(currentTime, _reallyHasTime) > 0) {
        currentTime = _reallyHasTime;
        CGFloat width = [self widthWithTime:currentTime];
        _endSliderOriginX.constant = (JP_SCREEN_WIDTH - width - _startSliderOriginX.constant -16);
    }
    CGFloat width = [self widthWithTime:_totalVideoTime];
    if ((JP_SCREEN_WIDTH - _endSliderOriginX.constant - _startSliderOriginX.constant - 16) < width) {
        _endSliderOriginX.constant = (JP_SCREEN_WIDTH - width - _startSliderOriginX.constant -16);
        currentTime = _totalVideoTime;
        if (_endSliderOriginX.constant < 7.5) {
            _endSliderOriginX.constant = 7.5;
            _startSliderOriginX.constant = (JP_SCREEN_WIDTH - width - _endSliderOriginX.constant -16);
        }
    }
    

    if (CMTimeCompare(currentTime, _reallyHasTime) > 0) {
        currentTime = _reallyHasTime;
    }
    if (CMTimeCompare(currentTime, _totalVideoTime) < 0) {
        currentTime = _totalVideoTime;
    }
    _currentHasTime = currentTime;
    width =  [self widthWithTime:_currentHasTime];

    if (pan.state == UIGestureRecognizerStateEnded && width < 31 && _endSliderOriginX.constant == 7.5) {
        [self.view bringSubviewToFront:_leftPanView];
    }
    [self updateProgress];
    [_videoLocal seekToTime:_currentStartTime];
    [pan setTranslation:CGPointMake(0, 0) inView:self.leftPanView];
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (CMTimeCompare(currentTime, _totalVideoTime) == 0) {
            [self refreshSliderViewsAtMinState:YES];
        } else {
            [self refreshSliderViewsAtMinState:NO];
        }
        if ((self.view.width - _endSliderOriginX.constant - _endSliderWidth.constant -_startSliderOriginX.constant - _startSliderWidth.constant) < 40) {
            _rightTimeLabel.hidden = YES;
            _totalTimeLabel.hidden = YES;
        } else {
            _rightTimeLabel.hidden = NO;
            _totalTimeLabel.hidden = NO;
        }
        [_videoLocal seekToTime:_currentStartTime];
        [_videoLocal play];
    }
}

- (void)rightPanAction:(UIPanGestureRecognizer *)pan{
    [self refreshSliderViewsAtMinState:NO];
    _rightTimeLabel.hidden = YES;
    _totalTimeLabel.hidden = YES;
    if (CMTimeCompare(_reallyHasTime,JP_VIDEO_MIN_DURATION) <= 0) {
         return;
    }
    [_videoLocal pause];
    CGPoint point = [pan translationInView:self.endSliderView];
    CGFloat startPoint = _startSliderOriginX.constant;
    CGFloat endPoint = _endSliderOriginX.constant;
    endPoint = endPoint - point.x;
    if (endPoint <= 7.5) {
        endPoint = 7.5;
    }else if (endPoint >= JP_SCREEN_WIDTH - 16 - startPoint)
    {
        endPoint = JP_SCREEN_WIDTH - 16 - startPoint;
    }
    _endSliderOriginX.constant = endPoint;
    CMTime currentTime = [self videoReallyTime];
    if (CMTimeCompare(currentTime, _reallyHasTime) > 0) {
        currentTime = _reallyHasTime;
        CGFloat width = [self widthWithTime:currentTime];
        _startSliderOriginX.constant = (JP_SCREEN_WIDTH - width - _endSliderOriginX.constant - 16);
    }
    
    CGFloat width = [self widthWithTime:_totalVideoTime];
    if ((JP_SCREEN_WIDTH - _endSliderOriginX.constant - _startSliderOriginX.constant - 16) < width) {
         currentTime = _totalVideoTime;
        _startSliderOriginX.constant = (JP_SCREEN_WIDTH - width - _endSliderOriginX.constant -16);
        if (_startSliderOriginX.constant < 7.5) {
            _startSliderOriginX.constant = 7.5;
            _endSliderOriginX.constant = (JP_SCREEN_WIDTH - width - _startSliderOriginX.constant -16);
        }
    }
    
    
    if (CMTimeCompare(currentTime, _reallyHasTime) > 0) {
        currentTime = _reallyHasTime;
    }
    if (CMTimeCompare(currentTime, _totalVideoTime) < 0) {
        currentTime = _totalVideoTime;
    }
    _currentHasTime = currentTime;
    width =  [self widthWithTime:_currentHasTime];
    if (pan.state == UIGestureRecognizerStateEnded && width < 31 && _startSliderOriginX.constant == 7.5) {
        [self.view bringSubviewToFront:_rightPanView];
    }
    [self updateProgress];
    [_videoLocal seekToTime:CMTimeAdd(_currentStartTime, _currentHasTime)];
    [pan setTranslation:CGPointMake(0, 0) inView:self.rightPanView];
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (CMTimeCompare(currentTime, _totalVideoTime) == 0) {
            [self refreshSliderViewsAtMinState:YES];
        } else {
            [self refreshSliderViewsAtMinState:NO];
        }
        if ((self.view.width - _endSliderOriginX.constant - _endSliderWidth.constant -_startSliderOriginX.constant - _startSliderWidth.constant) < 40) {
            _rightTimeLabel.hidden = YES;
            _totalTimeLabel.hidden = YES;
        } else {
            _rightTimeLabel.hidden = NO;
            _totalTimeLabel.hidden = NO;
        }
        [_videoLocal seekToTime:_currentStartTime];
        [_videoLocal play];
    }
}

- (void)refreshSliderViewsAtMinState:(BOOL)atMin {
    if (atMin) {
        _topSliderLineView.backgroundColor = [UIColor whiteColor];
        _bottomSliderLineView.backgroundColor = [UIColor whiteColor];
        _startSliderView.image = JPImageWithName(@"left_slide");
        _endSliderView.image = JPImageWithName(@"right_slide");
        _rightTimeLabel.hidden = YES;
        _totalTimeLabel.hidden = YES;
    } else {
        _rightTimeLabel.hidden = NO;
        _totalTimeLabel.hidden = NO;
        _startSliderView.image = JPImageWithName(@"left_slide");
        _endSliderView.image = JPImageWithName(@"right_slide");
        _topSliderLineView.backgroundColor = [UIColor whiteColor];
        _bottomSliderLineView.backgroundColor = [UIColor whiteColor];
    }
}

- (CMTime)videoReallyTime
{
    NSLog(@"%.2f, %.2f", _startSliderOriginX.constant, _endSliderOriginX.constant);
    CGFloat currentWidth = JP_SCREEN_WIDTH - _endSliderOriginX.constant - _startSliderOriginX.constant - 16;

    return [self videoTimeWithWidth:currentWidth];
}

- (CMTime)videoTimeWithWidth:(CGFloat)width
{
    CGFloat currentWidth = width;
    CGFloat reallyWidth = JP_SCREEN_WIDTH - 31;
    double duration = CMTimeGetSeconds(_videoModel.videoTime);
    double widthseconds = 1.0f * duration / reallyWidth;
    if (widthseconds == 0) {
        return kCMTimeZero;
    }
    double time = widthseconds * currentWidth;
    return CMTimeMakeWithSeconds(time, NSEC_PER_SEC);

}

- (CGFloat)widthWithTime:(CMTime)time
{
    CGFloat reallyWidth = JP_SCREEN_WIDTH - 31;
    double duration = CMTimeGetSeconds(_videoModel.videoTime);
    double widthseconds = 1.0f * duration / reallyWidth;
    if (widthseconds == 0) {
        return 0;
    }
    double seconds = CMTimeGetSeconds(time);
    return seconds / widthseconds;
}
- (IBAction)transtionTypeSelectAction:(id)sender {
    
//    [self.firstActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.thirdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.forthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIButton *button = (UIButton *)sender;
//    [button setTitleColor:[UIColor appMainYellowColor] forState:UIControlStateNormal];
//    if (sender == self.firstActionButton) {
//        self.transtionType = JPVideoTranstionNone;
//        
//    }else if(sender == self.secondButton){
//        self.transtionType = JPVideoTranstionGradient;
//       
//    }else if (sender == self.thirdButton){
//        self.transtionType = JPVideoTranstionIncluded;
//       
//    }else{
//        self.transtionType = JPVideoTranstionSuperposition;;
//        
//    }
}

- (void)setupThumbImageView
{
    for (NSInteger index = 0; index < _thumbImageArr.count; index ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * _imageViewWidth, 0, _imageViewWidth, _frameView.height)];
        imageView.image = _thumbImageArr[index];
        [_frameView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    _startSliderView.hidden = NO;
    _endSliderView.hidden = NO;
    _rightTimeLabel.hidden = NO;
    _leftTimeLabel.hidden = NO;
    _rightMaskView.hidden = NO;
    _leftMaskView.hidden = NO;
    _topSliderLineView.hidden = NO;
    _bottomSliderLineView.hidden = NO;
    _totalTimeLabel.hidden = NO;
}

- (void)escEdit
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确定要退出本次编辑？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是", nil];
    [alert show];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _currentTimeLabel.hidden = _frameView.subviews.count ? NO: YES;
    typeof(self) weakSelf = self;
    if (_isSecondStep == NO) {
        [_progressView becomeAddViewWithVideoSourceType:JPVideoSourceLocal];
    }
    if (_frameView.subviews.count == 0) {
        [JPVideoUtil getVideoFramesWithVideoUrl:_videoModel.videoUrl renderWidth:_frameView.width renderHeight:_frameView.height completion:^(NSArray<UIImage *> *reslut, CGFloat imageViewWidth) {
            weakSelf.thumbImageArr = [reslut copy];
            weakSelf.imageViewWidth = imageViewWidth;
            [weakSelf setupThumbImageView];
            self.currentTimeLabel.hidden = NO;
        }];
        if (CMTimeCompare(CMTimeAdd(_recordInfo.currentTotalTime, _videoModel.videoTime), _recordInfo.totalDuration) > 0 && _isSecondStep == NO) {
            CMTime realyTime = CMTimeSubtract(_recordInfo.totalDuration, _recordInfo.currentTotalTime);
            _reallyHasTime = realyTime;
            _endTimeLabel.text = [NSString stringWithTimeInterval:(NSInteger)CMTimeGetSeconds(_reallyHasTime)];
            CGFloat width = [self widthWithTime:realyTime];
            _endSliderOriginX.constant = (JP_SCREEN_WIDTH - width - _startSliderOriginX.constant -16);
            _currentHasTime = realyTime;
            
        }else if (_isSecondStep){
            CMTime realyTime = _videoModel.timeRange.duration;
            _reallyHasTime = _videoModel.videoTime;
            _endTimeLabel.text = [NSString stringWithTimeInterval:(NSInteger)CMTimeGetSeconds(realyTime)];
            CGFloat originX = [self widthWithTime:_videoModel.timeRange.start];
            _startSliderOriginX.constant = 7.5 + originX;
            CGFloat width = [self widthWithTime:realyTime];
            _endSliderOriginX.constant = (JP_SCREEN_WIDTH - width - _startSliderOriginX.constant -16);
            _currentHasTime = realyTime;
        }
    }
    [self updateProgress];
    [_videoLocal startProcessing];
    [_videoLocal seekToTime:_currentStartTime];
}

- (void)updateProgress
{
    CGFloat currentWidth = _startSliderOriginX.constant - 7.5;
    _currentStartTime = [self videoTimeWithWidth:currentWidth];
    if (CMTimeCompare(CMTimeAdd(_currentStartTime, _currentHasTime), _videoModel.videoTime) >= 0) {
        _currentStartTime = CMTimeSubtract(_videoModel.videoTime, _currentHasTime);
    }
    _videoLocal.playTimeRange = CMTimeRangeMake(_currentStartTime, _currentHasTime);
    _videoLocal.photoModel.timeRange = CMTimeRangeMake(kCMTimeZero, _videoLocal.playTimeRange.duration);
    _totalTimeLabel.text = [NSString stringWithFormat:@"%ldS", (long)ceil(CMTimeGetSeconds(_currentHasTime))];
    NSLog(@"currentStartTime:%.2f,currentHasTime:%.2f", CMTimeGetSeconds(_currentStartTime), CMTimeGetSeconds(_currentHasTime));
    _leftTimeLabel.text =  _startTimeLabel.text = [NSString stringWithTimeInterval:(NSInteger)(CMTimeGetSeconds(_currentStartTime))];
    _rightTimeLabel.text =  _endTimeLabel.text = [NSString stringWithTimeInterval:(NSInteger)ceil(CMTimeGetSeconds(CMTimeAdd(_currentStartTime, _currentHasTime)))];
    if (CMTimeCompare(_currentStartTime, _currentHasTime) == 0) {
        _startTimeLabel.text = _endTimeLabel.text;
    }
    if (_isSecondStep == NO ) {
        [_progressView updateViewWidthWithDuration:_currentHasTime];
    }

}
- (IBAction)finishedEidt:(id)sender {
    NSString *clipBasebame = nil;
    if (CMTimeCompare(kCMTimeZero, _currentStartTime) == 0 && CMTimeCompare(_currentHasTime, _videoModel.videoTime) == 0) {
        clipBasebame = _videoModel.videoBaseFile;
        [self finishedWithVideoBaseName:clipBasebame];
    }else{
        self.view.userInteractionEnabled = NO;
        [self jp_showHUD];
         clipBasebame = [JPVideoUtil fileNameForDocumentMovie];
        CMTime nextClistartTime = kCMTimeZero;
        NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        
        AVMutableComposition *comsition = [AVMutableComposition composition];
        AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:_videoModel.videoUrl options:inputOptions];
        CMTimeRange videoTimeRange = CMTimeRangeMake(_currentStartTime, _currentHasTime);
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
        
              //创建输出
        AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:comsition presetName:AVAssetExportPresetHighestQuality];
        assetExport.outputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:clipBasebame]];//输出路径
        assetExport.outputFileType = AVFileTypeQuickTimeMovie;//输出类型
        assetExport.shouldOptimizeForNetworkUse = YES;
        [assetExport exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (assetExport.status == AVAssetExportSessionStatusFailed) {
                    [self finishedError];
                }else if (assetExport.status == AVAssetExportSessionStatusCompleted)
                {
                    [self finishedWithVideoBaseName:clipBasebame];
                }
            });
        }];

    }
}

- (void)finishedError
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self jp_hideHUD];
        self.view.userInteractionEnabled = YES;
        [self.videoLocal destruction];
        [self.writeVideoLocal destruction];
        self.videoLocal = nil;
        self.writeVideoLocal = nil;
        [MBProgressHUD jp_showMessage:@"剪辑失败,请重试"];
        [self.navigationController popViewControllerAnimated:YES];
    });

}


- (void)dealloc
{
    
}
- (void)finishedWithVideoBaseName:(NSString *)videoBaseName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.recordInfo.hasChangedAspectRatio == NO) {
            if (self.videoModel.aspectRatio == JPVideoAspectRatio9X16) {
                self.recordInfo.aspectRatio = JPVideoAspectRatio1X1;
            }else{
                self.recordInfo.aspectRatio = self.videoModel.aspectRatio;
            }
        }
        NSURL *originMovieUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:videoBaseName]];
        self.videoModel.videoBaseFile = videoBaseName;
        CMTime duration = [JPVideoUtil getVideoDurationWithSourcePath:originMovieUrl];
        self.videoModel.videoTime = duration;
        if (self.delegate) {
            [self.delegate didFinishedClipVideoModel:self.videoModel];
        }
        [self jp_hideHUD];
        self.view.userInteractionEnabled = YES;
        self.currentTimeLabel.hidden = NO;
        [self.videoLocal destruction];
        [self.writeVideoLocal destruction];
        self.videoLocal = nil;
        self.writeVideoLocal = nil;
        if (self.fromThirdApp) {
            [self.recordInfo addVideoFile:self.videoModel];
        }
        if (self.fromPackage) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            JPNewPageViewController *trimVC = [[JPNewPageViewController alloc] initWithNibName:@"JPNewPageViewController" bundle:JPResourceBundle];
            trimVC.recordInfo = self.recordInfo;
            trimVC.jp_cancelGesturesReturn = YES;
            [self.navigationController setViewControllers:@[trimVC] animated:YES];
        }
    });
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_videoLocal destruction];
    [self.writeVideoLocal destruction];
    if (_isSecondStep == NO) {
        [_progressView endUpdateViewWithVideoModel:nil];
    }

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [_videoLocal pause];
        [_videoLocal destruction];
        [self.writeVideoLocal destruction];
        self.videoLocal = nil;
        self.writeVideoLocal = nil;
        if (self.fromThirdApp) {
            __weak typeof(self) weakSelf = self;
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
