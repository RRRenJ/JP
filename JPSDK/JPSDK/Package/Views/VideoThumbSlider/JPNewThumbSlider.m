//
//  JPNewThumbSlider.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewThumbSlider.h"
#import "JPNewVideoThumbCollectionViewCell.h"
#import "JPNewClidView.h"
#import "JPThumImageLayout.h"

@interface JPNewThumbSlider ()<UICollectionViewDataSource, JPNewVideoThumbCollectionViewCellDelegate, JPNewClidViewDelegate, UICollectionViewDelegateTimelineLayout>
{
    UICollectionView *collecView;
    UILabel *timeLb;
    JPThumImageLayout * layout;
    UIView *trackView;
    BOOL needScorll;
    JPThumbInfoModel *selctInfoModel;
    CGFloat currentScrollOfsset;
    BOOL isBeginAnimation;
}

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, weak) JPVideoRecordInfo *recordInfo;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIImageView *moveImageView;
@property (nonatomic, strong) JPThumbInfoModel *willMoveInfoModel;
@property (nonatomic, strong) JPThumbInfoModel *plahoderModel;

@property (nonatomic, strong) NSIndexPath *moveIndexPath;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) BOOL willMove;
@property (nonatomic, strong) JPNewClidView *clidView;
@property (nonatomic, strong) UIImageView *addTransitionTip;

@property (nonatomic, assign) CGFloat collctionTotalOffset;
@property (nonatomic, assign) CGFloat collctionTotalWidth;
@property (nonatomic, assign) CGFloat collctionCurrentOffset;
@property (nonatomic, assign) CGFloat collctionCurrentWidth;
@property (nonatomic, assign) CGFloat collctionViewCurrentOffset;

@property (nonatomic, strong) NSTimer *annimationTimer;

@end

@implementation JPNewThumbSlider

- (instancetype)initWithRecordInfo:(JPVideoRecordInfo *)videoRecordInfo
{
    CGRect frame = CGRectMake(0, 0, JP_SCREEN_WIDTH, 70);
    if (self = [self initWithFrame:frame]) {
        _recordInfo = videoRecordInfo;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _hasClickActive = NO;
    [self formatThumbInfos];
    if (timeLb != nil) {
        return;
    }
    timeLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 12)];
    timeLb.font = [UIFont jp_placardMTStdCondBoldFontWithSize:12];
    timeLb.textColor = [UIColor jp_colorWithHexString:@"525252"];
    timeLb.textAlignment = NSTextAlignmentCenter;
    timeLb.text = @"00:00";
    [self addSubview:timeLb];
    timeLb.sd_layout.topEqualToView(self).leftEqualToView(self).rightEqualToView(self).heightIs(13);
    layout = [[JPThumImageLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.trackHeight = 50;
    collecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 17 , self.width,self.height - 20)collectionViewLayout:layout];
    collecView.contentInset = UIEdgeInsetsMake(0, self.width/2, 0, self.width/2);
    collecView.delegate = self;
    collecView.backgroundColor = self.backgroundColor;
    collecView.dataSource = self;
    collecView.bounces = YES;
    collecView.showsHorizontalScrollIndicator = NO;
    collecView.showsVerticalScrollIndicator = NO;
    collecView.clipsToBounds = NO;
    [collecView registerNib:[UINib nibWithNibName:@"JPNewVideoThumbCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:@"JPNewVideoThumbCollectionViewCell"];
    [self addSubview:collecView];
    collecView.clipsToBounds = NO;
    self.clipsToBounds = NO;
    collecView.sd_layout.topSpaceToView(timeLb, 4).leftEqualToView(self).rightEqualToView(self).heightIs(50);
    self.collectionView = collecView;


    
    trackView = [[UIView alloc] initWithFrame:CGRectMake(0, 14, 10, collecView.height + 6)];
    trackView.clipsToBounds = NO;
    trackView.userInteractionEnabled = NO;
    [self addSubview:trackView];
    trackView.sd_layout.centerXEqualToView(self).widthIs(10).heightIs(56).centerYEqualToView(collecView);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, trackView.height)];
    lineView.backgroundColor = [UIColor whiteColor];
    [trackView addSubview:lineView];
    lineView.sd_layout.centerXEqualToView(trackView).widthIs(1).topEqualToView(trackView).bottomEqualToView(trackView);
    [collecView reloadData];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(xwp_longPressed:)];
    _longPressGesture = longPress;
    longPress.minimumPressDuration = 0.5;
    [collecView addGestureRecognizer:longPress];
    _clidView = [[JPNewClidView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    _clidView.hidden = YES;
    _clidView.delegate = self;
    [collecView addSubview:_clidView];
}

- (void)xwp_longPressed:(UILongPressGestureRecognizer *)longPressGesture{
    if (_dataSource.count == 1 || needScorll == YES) {
        return;
    }
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self xwp_gestureBegan:longPressGesture];
    }else if (longPressGesture.state == UIGestureRecognizerStateChanged)
    {
        if (isBeginAnimation == YES) {
            return;
        }
        [self xwp_gestureChange:longPressGesture];
 
    }else{
        [self xwp_gestureEndOrCancle:longPressGesture];
  
    }
  }

- (void)xwp_gestureBegan:(UILongPressGestureRecognizer *)longPressGesture
{
    _willMove = YES;
    isBeginAnimation = YES;
    if (selctInfoModel) {
        _clidView.hidden = YES;
        selctInfoModel = nil;
    }
    CGPoint point = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    _lastPoint = point;
    if (self.delegate && [self.delegate respondsToSelector:@selector(newThumbSliderWillMoveVideo)]) {
        [self.delegate newThumbSliderWillMoveVideo];
    }
    _moveIndexPath = [collecView indexPathForItemAtPoint:point];
    JPNewVideoThumbCollectionViewCell *cell = (JPNewVideoThumbCollectionViewCell *)[collecView cellForItemAtIndexPath:_moveIndexPath];
    CGRect frame = [cell convertRect:cell.bounds toView:self];
    UIImage *thumbImage = nil;
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(cell.backgroundClibView.bounds.size, NO,0);
        [cell.backgroundClibView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        thumbImage = image;
    }
    _moveImageView = [[UIImageView alloc] initWithFrame:frame];
    _moveImageView.contentMode = UIViewContentModeScaleAspectFill;
    _moveImageView.image = thumbImage;
    _moveImageView.clipsToBounds = YES;
    [self addSubview:_moveImageView];
    _willMoveInfoModel = cell.infoModel;
    JPThumbInfoModel *lastInfoModel = [[JPThumbInfoModel alloc] init];
    lastInfoModel.isLast = YES;
    lastInfoModel.videoModel = _willMoveInfoModel.videoModel;
    lastInfoModel.isSelect = NO;
    lastInfoModel.width = 80;
    lastInfoModel.count = 0;
    _originDataSource = [NSMutableArray array];
    CGFloat offset = 0;
    CGFloat currentOffset = 0;
    BOOL currentPlace = NO;
    JPThumbInfoModel *placeModel = lastInfoModel;
    for (NSInteger count = 0 ; count < _dataSource.count; count++) {
        JPThumbInfoModel *thumbInfo = _dataSource[count];
        if (thumbInfo != _willMoveInfoModel) {
            JPThumbInfoModel *infoModel = [[JPThumbInfoModel alloc] init];
            infoModel.isLast = NO;
            infoModel.videoModel = _willMoveInfoModel.videoModel;
            infoModel.isSelect = NO;
            infoModel.width = 80;
            infoModel.count = 0;
            infoModel.contentOffset = offset;
            [_originDataSource addObject:infoModel];
            if (currentPlace == YES) {
                placeModel = infoModel;
                currentPlace = NO;
            }
            offset = offset + infoModel.width + infoModel.transtionPlaceWidth;
            thumbInfo.width = 80;
            thumbInfo.contentOffset = offset;
            [_originDataSource addObject:thumbInfo];
            offset = offset + thumbInfo.width + thumbInfo.transtionPlaceWidth;
        }else{
            currentPlace = YES;
            currentOffset = offset;
        }
    }
    [_originDataSource addObject:lastInfoModel];
    CGPoint points = [longPressGesture locationOfTouch:0 inView:self];
    CGPoint pointOffset = [longPressGesture locationOfTouch:0 inView:cell];
    placeModel.width = _willMoveInfoModel.width;
    collecView.contentInset = UIEdgeInsetsMake(0, points.x - 40.0, 0, self.width/2);
    [collecView reloadData];
    [collecView setContentOffset:CGPointMake(currentOffset - (points.x - 40.0) + pointOffset.x, 0) animated:NO];
    _collctionViewCurrentOffset = currentOffset - (points.x - 40.0) + pointOffset.x;
    CGFloat top = _moveImageView.top;
    _moveImageView.frame = CGRectMake(points.x - 40, top - 8, 80, 50);
     _collctionCurrentOffset = 0;
    _collctionCurrentWidth = 0;
    _collctionTotalWidth = (placeModel.width - 80);
    _collctionTotalOffset = pointOffset.x;
    _plahoderModel = placeModel;
    _annimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animationsCollection:) userInfo:nil repeats:YES];
    _lastPoint = point;
}


- (void)animationsCollection:(NSTimer *)timer
{
    if (_willMoveInfoModel == nil) {
        isBeginAnimation = NO;
        [_annimationTimer invalidate];
        _annimationTimer = nil;
        return ;
    }
    CGFloat changeWidth = _collctionTotalWidth / 30.0;
    CGFloat originX = _collctionTotalOffset / 30.0;
    _collctionCurrentWidth = _collctionCurrentWidth + changeWidth;
    _collctionCurrentOffset = _collctionCurrentOffset + originX;
    _plahoderModel.width = _willMoveInfoModel.width - _collctionCurrentWidth;
    if (_collctionCurrentOffset >= _collctionTotalOffset) {
        isBeginAnimation = NO;
        [_annimationTimer invalidate];
        _annimationTimer = nil;
    }
    [layout adjustedToWidth:_plahoderModel.width];
    [collecView setContentOffset:CGPointMake(_collctionViewCurrentOffset - _collctionCurrentOffset, 0) animated:NO];
}
- (void)xwp_gestureChange:(UILongPressGestureRecognizer *)longPressGesture
{
    CGPoint point = [longPressGesture locationOfTouch:0 inView:collecView];
    CGFloat changed = point.x - _lastPoint.x;
    CGPoint points = [longPressGesture locationOfTouch:0 inView:self];
    _moveImageView.centerX = points.x;
    CGFloat offset = collecView.contentOffset.x;
    if (_moveImageView.right >= JP_SCREEN_WIDTH) {
        _moveImageView.right = JP_SCREEN_WIDTH;
        offset = offset + changed;
    }else if (_moveImageView.left <= 0)
    {
        _moveImageView.left = 0;
        offset = offset + changed;
    }
    CGRect frame = [_moveImageView convertRect:_moveImageView.bounds toView:collecView];
    NSLog(@"-------%@--frame", NSStringFromCGRect(frame));
    if (frame.origin.x >= 0 && frame.origin.x + frame.size.width <= collecView.contentSize.width) {
        [collecView setContentOffset:CGPointMake(offset, 0)];
    }else{
        if (frame.origin.x <= 0) {
            _moveImageView.left = _moveImageView.left - frame.origin.x;
        }else if (frame.origin.x + frame.size.width <= collecView.contentSize.width)
        {
            _moveImageView.right = _moveImageView.right - (frame.origin.x + frame.size.width - collecView.contentSize.width);

        }
    }
    _lastPoint = point;
}

- (void)xwp_gestureEndOrCancle:(UILongPressGestureRecognizer *)longPressGesture
{
    CGPoint point = [longPressGesture locationOfTouch:0 inView:collecView];
    NSInteger targetIndexPath = 0;
    for (NSInteger index = 0; index < _originDataSource.count; index++) {
        JPThumbInfoModel *infoModel = _originDataSource[index];
        if (index == 0) {
            if (point.x <= infoModel.width + infoModel.transtionPlaceWidth) {
                targetIndexPath = index;
                break;
            }
        }else if (index == _originDataSource.count - 1)
        {
            if (point.x > infoModel.contentOffset) {
                targetIndexPath = index;
                break;
            }
        }else{
            if (point.x > infoModel.contentOffset && point.x <= (infoModel.contentOffset + infoModel.width)) {
                targetIndexPath = index;
                break;
            }
        }
    }
    NSInteger targetIndex = 0;
    JPThumbInfoModel *beforeModel = nil;
    if (targetIndexPath >= _originDataSource.count) {
        targetIndexPath = _originDataSource.count - 1;
    }
    if (targetIndexPath == 0) {
        beforeModel = nil;
    }else if (targetIndexPath % 2 == 0)
    {
        beforeModel = _originDataSource[targetIndexPath - 1];
    }else{
        beforeModel = _originDataSource[targetIndexPath];
    }
    if (beforeModel == nil) {
        targetIndex = 0;
    }else{
        targetIndex = [_dataSource indexOfObject:beforeModel] + 1;
        if (targetIndex >= _dataSource.count - 1) {
            targetIndex = _dataSource.count - 1;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(newThumbSliderDidExchangeTheVideoIndex:toIndex:)]) {
        [self.delegate newThumbSliderDidExchangeTheVideoIndex:_moveIndexPath.row toIndex:targetIndex];
    }
    [_moveImageView removeFromSuperview];
    _moveImageView = nil;
    _willMove = NO;
    collecView.contentInset = UIEdgeInsetsMake(0, self.width/2, 0, self.width/2);
    [collecView setContentOffset:CGPointMake(- self.width / 2.0, 0) animated:YES];
    _willMoveInfoModel = nil;

}

- (void)updateThumSlider {
    if ([_originDataSource count] == [_recordInfo.videoSource count]) {
        return;
    }
    [_dataSource removeAllObjects];
    NSArray *videoArr = _recordInfo.videoSource;
    CGFloat offset = 0;
    CMTime startTime = kCMTimeZero;
    JPVideoModel *lastModel = videoArr.lastObject;
    for (JPVideoModel *videoModel in videoArr) {
        JPThumbInfoModel *infoModel = [[JPThumbInfoModel alloc] init];
        if (lastModel == videoModel) {
            infoModel.isLast = YES;
        }else{
            infoModel.isLast = NO;
        }
        infoModel.videoModel = videoModel;
        infoModel.isSelect = NO;
        infoModel.contentOffset = offset;
        infoModel.startTime = startTime;
        [_dataSource addObject:infoModel];
        offset = infoModel.width + infoModel.transtionPlaceWidth + offset;
        startTime = CMTimeAdd(startTime, infoModel.reallyDuration);
    }
    _originDataSource = _dataSource;
    if (collecView) {
        [collecView reloadData];
    }
}

- (void)formatThumbInfos
{
    NSArray *videoArr = _recordInfo.videoSource;
    _dataSource = [NSMutableArray array];
    CGFloat offset = 0;
    CMTime startTime = kCMTimeZero;
    JPVideoModel *lastModel = videoArr.lastObject;
    for (JPVideoModel *videoModel in videoArr) {
        JPThumbInfoModel *infoModel = [[JPThumbInfoModel alloc] init];
        if (lastModel == videoModel) {
            infoModel.isLast = YES;
        }else{
            infoModel.isLast = NO;
        }
        infoModel.videoModel = videoModel;
        infoModel.isSelect = NO;
        infoModel.contentOffset = offset;
        infoModel.startTime = startTime;
        [_dataSource addObject:infoModel];
        offset = infoModel.width + infoModel.transtionPlaceWidth + offset;
        startTime = CMTimeAdd(startTime, infoModel.reallyDuration);
    }
    _originDataSource = _dataSource;
    if (collecView) {
        [collecView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_originDataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPNewVideoThumbCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPNewVideoThumbCollectionViewCell" forIndexPath:indexPath];
    cell.infoModel = _originDataSource[indexPath.row];
    if (indexPath.row == _originDataSource.count - 1) {
        cell.isLast = YES;
        _buttonView = cell.buttonView;
        cell.addIV.hidden = self.hideAddView;
    }else{
        cell.isLast = NO;
        cell.addIV.hidden = NO;
    }
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPThumbInfoModel *infoModel = _originDataSource[indexPath.item];
    return infoModel.width + infoModel.transtionPlaceWidth;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JPThumbInfoModel *slectModel = selctInfoModel;
    slectModel.isSelect = NO;
    JPThumbInfoModel *infoModel = _originDataSource[indexPath.row];
    if (infoModel == slectModel) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(newThumbSliderWillDeselectThisVideoModel:)]) {
            [self.delegate newThumbSliderWillDeselectThisVideoModel:infoModel.videoModel];
        }
        _clidView.hidden = YES;
    }else{
        infoModel.isSelect = YES;
        selctInfoModel = infoModel;
        [collectionView reloadData];
        CGFloat offset = collecView.contentOffset.x;
        CGFloat actualDistance = self.width/2+offset;
        _clidView.left = infoModel.contentOffset;
        _clidView.width = infoModel.width;
        _clidView.hidden = NO;
        _clidView.thumbInfoModel = infoModel;
        _clidView.totalTimeLabel.text = [NSString stringWithFormat:@"%.0f s", CMTimeGetSeconds(infoModel.videoDuration) * selctInfoModel.videoModel.radios];
        _clidView.startTimeLabel.text = [NSString stringWithTimeInterval:floor(CMTimeGetSeconds(infoModel.videoModel.timeRange.start) * infoModel.videoModel.radios)];
        _clidView.endTimeLabel.text = [NSString stringWithTimeInterval:ceil(CMTimeGetSeconds(CMTimeAdd(infoModel.videoModel.timeRange.duration, infoModel.videoModel.timeRange.start)) * infoModel.videoModel.radios)];

        _clidView.recordInfo = _recordInfo;
        currentScrollOfsset = collecView.contentOffset.x;
        if (actualDistance < infoModel.contentOffset || actualDistance >  infoModel.contentOffset + infoModel.width) {
            [collecView setContentOffset:CGPointMake(infoModel.contentOffset - self.width / 2.0, 0) animated:YES];
            currentScrollOfsset = infoModel.contentOffset - self.width / 2.0;
            _currentTime = infoModel.startTime;
            if (self.delegate && [self.delegate respondsToSelector:@selector(didChangedToTime:)]) {
                [self.delegate didChangedToTime:infoModel.startTime];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(newThumbSliderWillSelectThisVideoModel:)]) {
            [self.delegate newThumbSliderWillSelectThisVideoModel:infoModel.videoModel];
        }

    }
}

- (CMTime)getCurrentVideoTime
{
    CGFloat reallyScroll = currentScrollOfsset + self.width / 2.0 - selctInfoModel.contentOffset;
    CGFloat radio = reallyScroll / selctInfoModel.width;
    if (radio <= 0) {
        radio = 0;
    }else if (radio >= 1)
    {
        radio = 1;
    }
    return CMTimeAdd(selctInfoModel.videoModel.timeRange.start, CMTimeMultiplyByFloat64(selctInfoModel.videoModel.timeRange.duration, radio));
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        needScorll = NO;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    needScorll = YES;
    [self culculateVideoCurrentTime:scrollView.contentOffset.x];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (needScorll == YES) {
        if (selctInfoModel) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(newThumbSliderWillDeselectThisVideoModel:)]) {
                [self.delegate newThumbSliderWillDeselectThisVideoModel:selctInfoModel.videoModel];
            }

        }
        [self culculateVideoCurrentTime:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    needScorll = NO;
}

- (void)culculateVideoCurrentTime:(CGFloat)offset {
    if (_willMove == YES) {
        return;
    }
    //scrollview拖拽的实际距离
    CGFloat actualDistance = self.width/2+offset;
    JPThumbInfoModel *thumbInfoModel = nil;
    for (JPThumbInfoModel *model in _originDataSource) {
        if (model.contentOffset <= actualDistance && (model.contentOffset + model.width + model.transtionPlaceWidth) >= actualDistance ) {
            thumbInfoModel = model;
            break;
        }
    }
    if (thumbInfoModel == nil) {
        return;
    }
    CGFloat reallyPixel = actualDistance - thumbInfoModel.contentOffset;
    CGFloat radio = reallyPixel / thumbInfoModel.width;
    if (radio <= 0) {
        radio = 0;
    }else if (radio >= 1.0)
    {
        radio = 1.0;
    }
    
    CMTime currentVideoTime = CMTimeAdd(thumbInfoModel.startTime, CMTimeMultiplyByFloat64(thumbInfoModel.reallyDuration, radio));
    _currentTime = currentVideoTime;
    timeLb.text = [JPUtil formatSecond:CMTimeGetSeconds(currentVideoTime)];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangedToTime:)]) {
        [self.delegate didChangedToTime:currentVideoTime];
    }
    thumbInfoModel = _originDataSource.lastObject;
    if (thumbInfoModel) {
        if (actualDistance >= thumbInfoModel.width + thumbInfoModel.contentOffset) {
            [collecView setContentOffset:CGPointMake(thumbInfoModel.width + thumbInfoModel.contentOffset - self.width / 2.0, 0) animated:NO];
        }
    }
   
}

- (void)scrollToTime:(CMTime)time
{
    
    if (needScorll == YES || selctInfoModel || _willMove == YES) {
        return;
    }
    _currentTime = time;
    JPThumbInfoModel *thumbInfoModel = nil;
    for (JPThumbInfoModel *model in _originDataSource) {
        if (CMTimeCompare(model.startTime, time) <= 0 && CMTimeCompare(CMTimeAdd(model.startTime, model.reallyDuration), time) >= 0) {
            thumbInfoModel = model;
            break;
        }
    }
    if (thumbInfoModel == nil) {
        thumbInfoModel = _originDataSource.lastObject;
        if (CMTimeCompare(time, CMTimeAdd(thumbInfoModel.startTime, thumbInfoModel.reallyDuration)) >= 0) {
            [collecView setContentOffset:CGPointMake(thumbInfoModel.width + thumbInfoModel.contentOffset - self.width / 2.0, 0) animated:NO];
        }
        return;
    }
//    if ([JPUtil getInfoFromUserDefaults:@"video-can-drag"] == nil) {
//        if ([_dataSource indexOfObject:thumbInfoModel] != 0) {
//            [self addPromptVideoView];
//        }
//    }
    Float64 duration = CMTimeGetSeconds(time);
    Float64 videoDuration = CMTimeGetSeconds(thumbInfoModel.reallyDuration);
    Float64 startTime = CMTimeGetSeconds(thumbInfoModel.startTime);
    CGFloat radio = (duration - startTime) / videoDuration;
    if (radio <= 0) {
        radio = 0;
    }else if (radio >= 1.0)
    {
        radio = 1.0;
    }
    CGFloat reallyPixel = thumbInfoModel.contentOffset + thumbInfoModel.width * radio;
    [collecView setContentOffset:CGPointMake(reallyPixel - self.width / 2.0, 0) animated:NO];
    timeLb.text = [JPUtil formatSecond:CMTimeGetSeconds(time)];
    
}


- (void)addPromptVideoView
{
    [JPUtil saveIssueInfoToUserDefaults:@"video-can-drag" resouceName:@"video-can-drag"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:JPImageWithName(@"Prompt-video")];
    [imageView sizeToFit];
    JPThumbInfoModel *infoModel = _dataSource.lastObject;
    imageView.centerX = infoModel.contentOffset + infoModel.width - 60.f;
    imageView.bottom = - 5.0;
    imageView.alpha = 0.0;
    [collecView addSubview:imageView];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.alpha = 1.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
    });
}

- (void)setThisVideoDeselect:(JPVideoModel *)videoModel
{
    for (JPThumbInfoModel *infoModel in _originDataSource) {
        infoModel.isSelect = NO;
    }
    [collecView reloadData];
    _clidView.hidden = YES;
     selctInfoModel = nil;
}


- (void)changeVideoTranstionTypeDisInfoModel:(JPThumbInfoModel *)infoModel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newThumbSliderWillDistranstion:)]) {
        [self.delegate newThumbSliderWillDistranstion:infoModel.videoModel];
    }
}

- (void)changeVideoTranstionTypeWithInfoModel:(JPThumbInfoModel *)infoModel
{
    
    JPThumbInfoModel *slectModel = selctInfoModel;
    slectModel.isSelect = NO;
    selctInfoModel = infoModel;
    if (slectModel != infoModel) {
        JPNewVideoThumbCollectionViewCell *cell = (JPNewVideoThumbCollectionViewCell *)[collecView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[_originDataSource indexOfObject:slectModel] inSection:0]];
        [cell setInfoModel:selctInfoModel];
    }
    JPNewVideoThumbCollectionViewCell *cell = (JPNewVideoThumbCollectionViewCell *)[collecView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[_originDataSource indexOfObject:infoModel] inSection:0]];
    [cell setTranstionModelSelect:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(newThumbSliderWillChangeVideoTranstionTypeThisVideoModel:)]) {
        [self.delegate newThumbSliderWillChangeVideoTranstionTypeThisVideoModel:infoModel.videoModel];
    }
}

- (void)changeVideoTranstionTypeAddVideo
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newThumbSliderWillUpdateAddVideo)]) {
        
        [self.delegate newThumbSliderWillUpdateAddVideo];
    }
}

- (void)changeStartPoint:(CGFloat)startPoint andWidth:(CGFloat)width
{
    CGFloat offset = collecView.contentOffset.x;
    CGFloat start = selctInfoModel.startPoint;
    CGFloat changed = start - startPoint;
    selctInfoModel.width = width;
    selctInfoModel.startPoint = startPoint;
    offset = offset + changed;
    [layout adjustedToWidth:width];
    CGRect frame = [_clidView convertRect:_clidView.bounds toView:self];
    if (frame.origin.x >= 30 && frame.origin.x <= JP_SCREEN_WIDTH - 30) {
        [collecView setContentOffset:CGPointMake(offset, 0)];
    }
    NSArray *avilCell = [collecView visibleCells].copy;
    for (JPNewVideoThumbCollectionViewCell *cell in avilCell) {
        if (cell.infoModel == selctInfoModel) {
            [cell setOffset:selctInfoModel.startPoint];
            break;
        }
    }
    _clidView.width = width;
    CMTime duration = CMTimeMultiply(CMTimeMake(1, 30), width / 2.0);
    _clidView.totalTimeLabel.text = [NSString stringWithFormat:@"%.0f s", CMTimeGetSeconds(duration) * selctInfoModel.videoModel.radios];
    CMTime startTime = CMTimeMultiply(CMTimeMake(1, 30), selctInfoModel.startPoint / 2.0);
    _clidView.startTimeLabel.text = [NSString stringWithTimeInterval:floor(CMTimeGetSeconds(startTime) * selctInfoModel.videoModel.radios)];
}

- (void)changeEndPoint:(CGFloat)endPoint
{
    CGFloat originWidth = selctInfoModel.width;
    CGFloat offset = collecView.contentOffset.x;
    selctInfoModel.width = endPoint;
    CGFloat changed = originWidth - endPoint;
    offset = offset - changed;
    [layout adjustedToWidth:endPoint];
    CGRect frame = [_clidView convertRect:_clidView.bounds toView:self];
    if (frame.origin.x + frame.size.width <= 30 || frame.origin.x + frame.size.width >= JP_SCREEN_WIDTH - 30) {
        [collecView setContentOffset:CGPointMake(offset, 0)];
    }
    _clidView.width = endPoint;
    CMTime duration = CMTimeMultiply(CMTimeMake(1, 30), endPoint / 2.0);
    _clidView.totalTimeLabel.text = [NSString stringWithFormat:@"%.0f s", CMTimeGetSeconds(duration) * selctInfoModel.videoModel.radios];
    CMTime startTime = CMTimeMultiply(CMTimeMake(1, 30), (selctInfoModel.startPoint + selctInfoModel.width) / 2.0);
    _clidView.endTimeLabel.text = [NSString stringWithTimeInterval:ceil(CMTimeGetSeconds(startTime) * selctInfoModel.videoModel.radios)];

}

- (void)updateVideoApearTimeWithModel:(JPVideoModel *)videoModel
{
    _clidView.totalTimeLabel.text = [NSString stringWithFormat:@"%.0f s", CMTimeGetSeconds(videoModel.timeRange.duration) * videoModel.radios];
    _clidView.startTimeLabel.text = [NSString stringWithTimeInterval:floor(CMTimeGetSeconds(videoModel.timeRange.start) * videoModel.radios)];
    _clidView.endTimeLabel.text = [NSString stringWithTimeInterval:floor(CMTimeGetSeconds(CMTimeAdd(videoModel.timeRange.duration, videoModel.timeRange.start)) * videoModel.radios)];
}

- (void)endUpdateWithInfoModel:(JPThumbInfoModel *)infoModel
{
    JPVideoModel *videoModel = infoModel.videoModel;
    CMTime startTime = CMTimeMultiply(CMTimeMake(1, 30), infoModel.startPoint / 2.0);
    CMTime duration = CMTimeMultiply(CMTimeMake(1, 30), infoModel.width / 2.0);
    if (CMTimeCompare(startTime, kCMTimeZero) <= 0) {
        startTime = kCMTimeZero;
    }
    if (CMTimeCompare(CMTimeAdd(startTime, duration), infoModel.totalDuration) >= 0) {
        duration = CMTimeSubtract(infoModel.totalDuration, startTime);
    }
    videoModel.timeRange = CMTimeRangeMake(startTime, duration);
    if (self.delegate && [self.delegate respondsToSelector:@selector(newThumbSliderWillUpdateVideoLong:)]) {
        [self.delegate newThumbSliderWillUpdateVideoLong:videoModel];
    }
}


- (CMTime)getStartTimeWithModel:(JPVideoModel *)videoModel
{
    for (JPThumbInfoModel *infoModel in _dataSource) {
        if (infoModel.videoModel == videoModel) {
            return infoModel.startTime;
        }
    }
    return kCMTimeZero;
}



- (BOOL)isCurrentActive
{

    return NO;
}


@end
