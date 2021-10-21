//
//  JPPhotoEditViewController.m
//  jper
//
//  Created by FoundaoTEST on 2017/5/23.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPhotoEditViewController.h"
#import "JPVideoRecordProgressView.h"

#import "JPNewPageViewController.h"

@interface JPPhotoEditViewController ()
@property (nonatomic) JPVideoAspectRatio  aspectRatio;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *clipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clipViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clipViewHeight;
@property (weak, nonatomic) IBOutlet JPVideoRecordProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *horizontalButton;
@property (weak, nonatomic) IBOutlet UIButton *squareButton;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeDurationLabel;
@property (weak, nonatomic) IBOutlet UISlider *videoDurationView;
@property (nonatomic, assign) CGSize imageViewSize;
@property (nonatomic, assign) CGRect imageSizeRect;
@property (nonatomic, assign) CGFloat imageRadio;
@property (weak, nonatomic) IBOutlet UIButton *fourthreeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clipOriginX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clipOriginY;
@property (weak, nonatomic) IBOutlet UIImageView *circularView;
@property (nonatomic, strong) AVAssetWriter *videoWriter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonTop;


@end

@implementation JPPhotoEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if (_recordInfo.currentFilterType == 0) {
        self.backImageView.image = _videoModel.originImage;
    }else{
        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.videoModel.originImage];
        JPFilterGroupHelper *filterHelp = [[JPFilterGroupHelper alloc] initWithCameraSize:CGSizeZero];
        
        GPUImageFilterGroup *filterGroup = [filterHelp switchToNewFilterType:YES withSessionPreset:JPVideoAspectRatioNomal andFilterDelegate:_recordInfo.filterDelegate];
        GPUImageFilter *disFilter = filterGroup.initialFilters.lastObject;
        [disFilter forceProcessingAtSize:_videoModel.originImage.size];
        [disFilter useNextFrameForImageCapture];
        [stillImageSource addTarget:disFilter];
        //开始渲染
        [stillImageSource processImage];
        UIImage *newImage = [disFilter imageFromCurrentFramebuffer];
        _backImageView.image = newImage;
        [filterGroup endProcessing];
        [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
    }
    _backImageViewTop.constant = JPShrinkStatusBarHeight;
    _rightButtonTop.constant = JPShrinkStatusBarHeight;
    _leftButtonTop.constant = JPShrinkStatusBarHeight;
    _clipView.layer.masksToBounds = YES;
    _clipView.layer.borderWidth = 4;
    _clipView.layer.borderColor = [UIColor whiteColor].CGColor;
    _totalTimeDurationLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:14];
    [_progressView setRecordInfo:_recordInfo];
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanAction:)];
    leftPan.minimumNumberOfTouches = 1;
    leftPan.maximumNumberOfTouches = 5;
    [_clipView addGestureRecognizer:leftPan];
    CGSize imageSize = _videoModel.originImage.size;
    CGFloat maxValue = imageSize.width > imageSize.height ? imageSize.width : imageSize.height;
    CGFloat minValue = imageSize.width > imageSize.height ? imageSize.height : imageSize.width;
    minValue = (JP_SCREEN_WIDTH / maxValue) * minValue;
    maxValue = JP_SCREEN_WIDTH;
    CGSize videoSize = imageSize;
    _imageViewSize = CGSizeMake(minValue, maxValue);
    if (videoSize.height < videoSize.width) {
        _imageViewSize = CGSizeMake(maxValue, minValue);
    }
    _imageSizeRect = CGRectMake((JP_SCREEN_WIDTH - _imageViewSize.width) / 2.0, (JP_SCREEN_WIDTH - _imageViewSize.height) / 2.0, _imageViewSize.width, _imageViewSize.height);
    _imageSizeRect.origin.y = _imageSizeRect.origin.y + JPShrinkStatusBarHeight;
    _aspectRatio = _recordInfo.aspectRatio;
    if (_recordInfo.videoSource.count > 0) {
        self.actionView.hidden = YES;
        switch (_aspectRatio) {
            case JPVideoAspectRatio16X9:
                [self changeFrameRatio:_horizontalButton];
                break;
            case JPVideoAspectRatio1X1:
                [self changeFrameRatio:_squareButton];
                break;
            case JPVideoAspectRatio4X3:
                [self changeFrameRatio:_fourthreeButton];
                break;
            default:
                break;
        }
    }else{
        CGSize videoSize = imageSize;
        if (videoSize.height > videoSize.width) {
            [self changeFrameRatio:_squareButton];
        }else if (((CGFloat)videoSize.width) / ((CGFloat)videoSize.height) >= (16.0 / 10.0)){
            [self changeFrameRatio:_horizontalButton];
        }else if(videoSize.width == videoSize.height){
            [self changeFrameRatio:_squareButton];
        }else{
            [self changeFrameRatio:_fourthreeButton];
        }
        self.actionView.hidden = NO;
    }
  
}

- (void)leftPanAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.clipView];
        _clipOriginX.constant = _clipOriginX.constant + point.x;
        _clipOriginY.constant = _clipOriginY.constant + point.y;
        CGPoint center = CGPointMake(_clipOriginX.constant + _backImageView.centerX, _clipOriginY.constant + _backImageView.centerY);
        CGRect rect = CGRectMake(center.x - _clipViewWidth.constant / 2.0, center.y - _clipViewHeight.constant / 2.0, _clipViewWidth.constant, _clipViewHeight.constant);
        if (rect.origin.x < _imageSizeRect.origin.x) {
            _clipOriginX.constant =  _clipOriginX.constant + _imageSizeRect.origin.x - rect.origin.x;
        }
        if (rect.origin.y < _imageSizeRect.origin.y) {
            _clipOriginY.constant =  _clipOriginY.constant + _imageSizeRect.origin.y - rect.origin.y;
        }
        if ((rect.origin.x + rect.size.width) > (_imageSizeRect.origin.x + _imageSizeRect.size.width)) {
            _clipOriginX.constant =  _clipOriginX.constant - ((rect.origin.x + rect.size.width) - (_imageSizeRect.origin.x + _imageSizeRect.size.width));
        }
        
        if ((rect.origin.y + rect.size.height) > (_imageSizeRect.origin.y + _imageSizeRect.size.height)) {
            _clipOriginY.constant =  _clipOriginY.constant - ((rect.origin.y + rect.size.height) - (_imageSizeRect.origin.y + _imageSizeRect.size.height));
        }
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self.clipView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_progressView becomeAddViewWithVideoSourceType:JPVideoSourceLocal];
    [self changeDuration:self.videoDurationView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView endUpdateViewWithVideoModel:nil];

}
- (IBAction)changeFrameRatio:(id)sender {
    if (sender == self.squareButton) {
        _aspectRatio = JPVideoAspectRatio1X1;
    }else if(sender == self.horizontalButton){
        _aspectRatio = JPVideoAspectRatio16X9;
    }else if (sender == self.fourthreeButton){
        _aspectRatio = JPVideoAspectRatio4X3;
    }
    [self changeImageClipView];
}

- (void)changeImageClipView
{
    
//    model.imageName = @"square-off";
//    model.selectImageName = @"square-on";
//    model.disableImageName = @"square-grey";
//    break;
//case JPVideoAspectRatio16X9:
//    model.imageName = @"transverse-off";
//    model.selectImageName = @"transverse-on";
//    model.disableImageName = @"transverse-grey";
//    break;
//case JPVideoAspectRatio9X16:
//    model.imageName = @"vertical-off";
//    model.selectImageName = @"vertical-on";
//    model.disableImageName = @"vertical-grey";
    [_horizontalButton setImage:JPImageWithName(@"16/9_nm") forState:UIControlStateNormal];
    [_squareButton setImage:JPImageWithName(@"1/1_nm") forState:UIControlStateNormal];
    [_fourthreeButton setImage:JPImageWithName(@"4/3_nm") forState:UIControlStateNormal];
    if (_aspectRatio == JPVideoAspectRatio16X9) {
        [_horizontalButton setImage:JPImageWithName(@"16/9_hl") forState:UIControlStateNormal];
    }else if(_aspectRatio == JPVideoAspectRatio1X1){
        [_squareButton setImage:JPImageWithName(@"1/1_hl") forState:UIControlStateNormal];
    }else if(_aspectRatio == JPVideoAspectRatio4X3){
        [_fourthreeButton setImage:JPImageWithName(@"4/3_hl") forState:UIControlStateNormal];
    }
    CGSize clipRect = [self getLocalVideoCropSizeWithOriginSize:_imageViewSize];
    [UIView animateWithDuration:0.2 animations:^{
        self.clipViewWidth.constant = clipRect.width;
        self.clipViewHeight.constant = clipRect.height;
        self.clipOriginX.constant = 0;
        self.clipOriginY.constant = 0;
        [self.view layoutIfNeeded];
        if (self.aspectRatio == JPVideoAspectRatioCircular) {
            self.circularView.hidden = NO;
        }else{
            self.circularView.hidden = YES;
        }
        
    }];
  }

- (CGSize)getLocalVideoCropSizeWithOriginSize:(CGSize)originSize
{
    CGFloat ratio = 16.0 / 9.0f;
    CGFloat width = originSize.width;
    CGFloat height = originSize.height;
    if (_aspectRatio == JPVideoAspectRatio9X16) {
        ratio = 9.0 / 16.0f;
    }else if (_aspectRatio == JPVideoAspectRatio1X1 || _aspectRatio == JPVideoAspectRatioCircular){
        ratio = 1.0 / 1.0f;
    }else if (_aspectRatio == JPVideoAspectRatio4X3)
    {
        ratio = 4.0f / 3.0f;
    }
    if (originSize.width / originSize.height <= ratio) {
        height = (originSize.width / ratio);
    }else{
        width = (originSize.height * ratio);
    }
    return CGSizeMake(width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popLast:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要退出本次编辑？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * comfirmAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.videoModel.originImage = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:comfirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
   
}
- (IBAction)changeDuration:(id)sender {
    CGFloat value = self.videoDurationView.value;
    CMTime curentDurtion = CMTimeMultiplyByFloat64(CMTimeMake(1, 1), value);
    if (CMTimeCompare(curentDurtion, JP_VIDEO_MIN_DURATION) < 0) {
        curentDurtion = JP_VIDEO_MIN_DURATION;
    }
  if (CMTimeCompare(CMTimeAdd(_recordInfo.currentTotalTime, curentDurtion), _recordInfo.totalDuration) > 0 ) {
      curentDurtion = CMTimeSubtract(_recordInfo.totalDuration, _recordInfo.currentTotalTime);
  }
    value = CMTimeGetSeconds(curentDurtion);
    self.videoDurationView.value = value;
    [_progressView updateViewWidthWithDuration:curentDurtion];
    _totalTimeDurationLabel.text = [NSString stringWithTimeInterval:(NSInteger)ceil(value)];
}

- (IBAction)finishEdit:(id)sender {
    __weak typeof(self) weakSelf = self;
    _recordInfo.aspectRatio = _aspectRatio;
    [self compressImagesCompletion:^(NSString *outName) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf jp_hideHUD];
            weakSelf.view.userInteractionEnabled = YES;
            if (outName == nil) {
                [MBProgressHUD jp_showMessage:@"合成图片出错,请重试"];
                return;
            }
            weakSelf.videoModel.videoBaseFile = outName;
            weakSelf.videoModel.originImage = nil;
            weakSelf.videoModel.videoTime = [JPVideoUtil getVideoDurationWithSourcePath:weakSelf.videoModel.videoUrl];
            weakSelf.videoModel.isImage = YES;
            weakSelf.videoModel.photoTransionType = JPPhotoModelTranstionNormal;
            if (weakSelf.delegate) {
                [weakSelf.delegate didFinishedClipVideoModel:weakSelf.videoModel];
            }
            if (self.fromPackage) {
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
//                [weakSelf.navigationController popViewControllerAnimated:YES];
                JPNewPageViewController *trimVC = [[JPNewPageViewController alloc] initWithNibName:@"JPNewPageViewController" bundle:JPResourceBundle];
                trimVC.recordInfo = self.recordInfo;
                trimVC.jp_cancelGesturesReturn = YES;
                [self.navigationController setViewControllers:@[trimVC] animated:YES];
            }
        });
    }];
   
}

- (CGRect)getLocalVideoCropSizeWithOriginSizeFloat:(CGSize)originSize
{
    CGRect rect = CGRectMake(_clipView.left - _imageSizeRect.origin.x, _clipView.top - _imageSizeRect.origin.y, _clipView.width, _clipView.height);
    if (rect.origin.x < 0 ) {
        rect.origin.x = 0;
    }
    if (rect.origin.y < 0) {
        rect.origin.y = 0;
    }
    double radio = _videoModel.originImage.size.width / _imageViewSize.width;
    CGSize imageSize = [self getLocalVideoCropSizeWithOriginSize:_videoModel.originImage.size];
    CGRect imageRect = CGRectMake(rect.origin.x * radio, rect.origin.y * radio, imageSize.width, imageSize.height);
    if (imageRect.size.width + imageRect.origin.x > _videoModel.originImage.size.width) {
        imageRect.origin.x =_videoModel.originImage.size.width - imageRect.size.width;
    }
    if (imageRect.size.height + imageRect.origin.y > _videoModel.originImage.size.height) {
        imageRect.origin.y = _videoModel.originImage.size.height - imageRect.size.height;
    }
    return imageRect;
}
- (void)compressImagesCompletion:(void(^)(NSString *outName))block;
{
    
    //先裁剪图片
    CGFloat value = self.videoDurationView.value;
    CMTime curentDurtion = CMTimeMultiplyByFloat64(CMTimeMake(1, 1), value);
    if (CMTimeCompare(curentDurtion, JP_VIDEO_MIN_DURATION) < 0) {
        return;
    }
    self.view.userInteractionEnabled = NO;
    [self jp_showHUD];
    UIImage *finalImage = _videoModel.originImage;
    CGRect  floatRect = [self getLocalVideoCropSizeWithOriginSizeFloat:_videoModel.originImage.size];
    finalImage = [UIImage jp_croppedImage:finalImage bounds:floatRect];
    NSString    *outName = [JPVideoUtil fileNameForDocumentMovie];
    CGSize size = _recordInfo.videoSize;//定义视频的大小
     self.videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:outName]]
                                                                   fileType:AVFileTypeQuickTimeMovie
                                                                      error:nil];
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey, nil];
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([self.videoWriter canAddInput:writerInput]);
    [self.videoWriter  addInput:writerInput];
    
    [self.videoWriter  startWriting];
    [self.videoWriter  startSessionAtSourceTime:kCMTimeZero];
    
    //合成多张图片为一个视频文件
    dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue", NULL);
    int __block frame = 0;
    CVPixelBufferRef buffer = NULL;
    if (finalImage == nil || finalImage.size.width == 0 || finalImage.size.height == 0) {
        block(nil);
        return;
    }
    buffer = (CVPixelBufferRef)[UIImage jp_pixelBufferFromCGImage:finalImage.CGImage];
    if (buffer == nil) {
        block(nil);
        return;
    }
    __weak typeof(self) weakSelf = self;
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
       while ([writerInput isReadyForMoreMediaData])
        {
            if(CMTimeCompare(CMTimeMake(frame, 30), curentDurtion) >= 0)
            {
                CFRelease(buffer);
                [writerInput markAsFinished];
                if(weakSelf.videoWriter.status == AVAssetWriterStatusWriting){
                    [weakSelf.videoWriter finishWritingWithCompletionHandler:^{
                        !block?:block(outName);
                    }];
                }
                break;
            }
        

            if (buffer)
            {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, 30)])
                {
                }else
                {
                    frame++;
                }
            }
        }
    }];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    
}

- (void)dealloc
{
    
}



@end
