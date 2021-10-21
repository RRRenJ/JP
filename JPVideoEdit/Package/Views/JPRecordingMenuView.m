//
//  JPRecordingMenuView.m
//  jper
//
//  Created by FoundaoTEST on 2017/5/15.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPRecordingMenuView.h"
#import "JPRecordAudioThumCell.h"
#import "JPAudioRecorder.h"
#import "JPRecordInfoView.h"
@interface JPRecordingMenuView ()<UICollectionViewDelegate, UICollectionViewDataSource, JPAudioRecorderDelegate, JPRecordInfoViewDelegate>
{
    BOOL needScorll;
}
@property (nonatomic, weak) JPVideoCompositionPlayer *compositionPlayer;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) JPAudioModel *audioModel;
@property (nonatomic, strong) JPAudioRecorder *audioRecorder;
@property (nonatomic, assign) CMTime startRecordTime;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) NSMutableArray *recordImageViewArr;
@property (nonatomic, strong) JPRecordInfoView *selecAudioModel;
@end

@implementation JPRecordingMenuView

- (IBAction)deleteAction:(id)sender {
    if (self.selecAudioModel != nil && _isRecorder == NO) {
        [_compositionPlayer pauseToPlay];
        [_recordInfo deleteAudioFile:self.selecAudioModel.audioModel];
        [_compositionPlayer setAudioMute:NO];
        [_compositionPlayer setRecordInfo:_recordInfo];
        [_compositionPlayer seekToTime:kCMTimeZero];
        [_recordImageViewArr removeObject:self.selecAudioModel];
        [self.selecAudioModel removeFromSuperview];
        self.selecAudioModel.isSelect = NO;
        self.selecAudioModel = nil;
        self.deleteButton.hidden = YES;
        [_compositionPlayer startPlaying];
    }
}

- (instancetype)initWithFrame:(CGRect)frame andCompositionPlayer:(JPVideoCompositionPlayer *)compositionPlayer
{
    if (self = [self initWithFrame:frame]) {
        _compositionPlayer = compositionPlayer;
        [self createSubviews];
    }
    return self;
}

- (void)setThumImageArr:(NSArray *)thumImageArr
{
    _thumImageArr = thumImageArr;
    UIImage *fisrtImage = thumImageArr.firstObject;
    if (fisrtImage) {
        _collectionViewLayout.itemSize = fisrtImage.size;
    }
    [_collectionView reloadData];
}

- (void)createSubviews
{
    [JPResourceBundle loadNibNamed:@"JPRecordingMenuView" owner:self options:nil];
    [self addSubview:self.view];
    _recordImageViewArr = [NSMutableArray array];
    self.view.sd_layout.topSpaceToView(self, 0).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
    _recordButton.layer.borderWidth = 1.5;
    _recordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _recordButton.layer.cornerRadius = 32;
    _recordButton.layer.masksToBounds = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(0, JP_SCREEN_WIDTH/2, 0,JP_SCREEN_WIDTH/2);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[JPRecordAudioThumCell class] forCellWithReuseIdentifier:@"JPRecordAudioThumCell"];
    _isRecorder = NO;
    self.recordButton.titleLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:24];
}

- (IBAction)recordAction:(id)sender {
    if (_isRecorder == YES) {
        _isRecorder = NO;
        [_compositionPlayer pauseToPlay];
        [self.audioRecorder stopRecord];
        [_compositionPlayer scrollToWatchThumImageWithTime:_currentTime withSticker:YES];
        [self.recordButton setTitle:nil forState:UIControlStateNormal];
        [self.recordButton setImage:JPImageWithName(@"recording") forState:UIControlStateNormal];
        _collectionView.scrollEnabled = YES;
    }else{
        if (CMTimeCompare(_recordInfo.totalVideoDuraion, CMTimeAdd(_currentTime, CMTimeMake(1, 3))) <= 0 ) {
            return;
        }
        _collectionView.scrollEnabled = NO;
        [_compositionPlayer pauseToPlay];
        [_compositionPlayer setAudioMute:YES];
        _isRecorder = YES;
        self.audioModel = [[JPAudioModel alloc] init];
        self.audioModel.startTime = _currentTime;
        self.audioModel.isBundle = NO;
        self.audioModel.baseFilePath = [JPVideoUtil fileNameForDocumentAudio];
        self.audioModel.sourceType = JPAudioSourceTypeRecorded;
        self.audioRecorder = [[JPAudioRecorder alloc] initWithAudioModel:self.audioModel];
        self.audioRecorder.delegate = self;
        [self.audioRecorder startToRecord];
        
        [_compositionPlayer seekToTime:_currentTime];
        [_compositionPlayer startPlaying];
        _startRecordTime = _currentTime;
        [self.recordButton setImage:nil forState:UIControlStateNormal];
        [self.recordButton setTitle:[NSString stringWithFormat:@"%ds", 0] forState:UIControlStateNormal];
    }
}



#pragma mark -- JPAudioRecorderDelegate

- (void)didFinishRecording:(JPAudioRecorder *)recorder audioModel:(JPAudioModel *)model successfully:(BOOL)flag{
    
    model.durationTime = [JPVideoUtil getVideoDurationWithSourcePath:model.fileUrl];
    model.clipTimeRange = CMTimeRangeMake(model.startTime, model.durationTime);
    NSMutableArray *deleteArr = [NSMutableArray array];
    NSMutableArray *addArr = [NSMutableArray array];
    NSMutableArray *deleteAudioArr = [NSMutableArray array];
    for (JPRecordInfoView *view in self.recordImageViewArr) {

        if (CMTimeRangeContainsTime(model.clipTimeRange, view.audioModel.startTime) && CMTimeRangeContainsTime(model.clipTimeRange, CMTimeAdd(view.audioModel.startTime, view.audioModel.durationTime))) {
            [view removeFromSuperview];
            [deleteArr addObject:view];
            [deleteAudioArr addObject:view.audioModel];
            continue;
        }else if (CMTimeRangeContainsTime(view.audioModel.clipTimeRange, model.startTime) && CMTimeRangeContainsTime(view.audioModel.clipTimeRange, CMTimeAdd(model.startTime, model.durationTime))){
            JPAudioModel *copyModel = view.audioModel.copy;
            view.audioModel.durationTime = CMTimeSubtract(model.startTime, view.audioModel.startTime);
            view.audioModel.clipTimeRange = CMTimeRangeMake(view.audioModel.startTime, view.audioModel.durationTime);
            [view updateFrameWithMaxLength:_collectionView.contentSize.width andRecordInfo:_recordInfo];
            if (view.width == 0) {
                [view removeFromSuperview];
                [deleteArr addObject:view];
                [deleteAudioArr addObject:view.audioModel];
            }
            copyModel.durationTime = CMTimeSubtract(CMTimeAdd(copyModel.startTime, copyModel.durationTime), CMTimeAdd(model.startTime, model.durationTime));
            copyModel.startTime = CMTimeAdd(model.startTime, model.durationTime);
            copyModel.clipTimeRange = CMTimeRangeMake(copyModel.startTime, copyModel.durationTime);
            if (CMTimeCompare( copyModel.durationTime, kCMTimeZero)> 0) {
                JPRecordInfoView *infoView = [[JPRecordInfoView alloc] initWithAudioModel:copyModel andMaxLength:_collectionView.contentSize.width andRecordInfo:_recordInfo];
                [self.collectionView addSubview:infoView];
                [self.recordInfo addAudioFile:copyModel];
                infoView.delegate = self;
                [addArr addObject:infoView];
            }
        }else if (CMTimeRangeContainsTime(view.audioModel.clipTimeRange, model.startTime)){
            view.audioModel.durationTime = CMTimeSubtract(model.startTime, view.audioModel.startTime);
            view.audioModel.clipTimeRange = CMTimeRangeMake(view.audioModel.startTime, view.audioModel.durationTime);

            [view updateFrameWithMaxLength:_collectionView.contentSize.width andRecordInfo:_recordInfo];
            if (view.width == 0) {
                [view removeFromSuperview];
                [deleteArr addObject:view];
                [deleteAudioArr addObject:view.audioModel];
            }
        }else if (CMTimeRangeContainsTime(view.audioModel.clipTimeRange, CMTimeAdd(model.startTime, model.durationTime))){
            view.audioModel.durationTime = CMTimeSubtract(CMTimeAdd(view.audioModel.startTime, view.audioModel.durationTime), CMTimeAdd(model.startTime, model.durationTime));
            view.audioModel.startTime = CMTimeAdd(model.startTime, model.durationTime);
            view.audioModel.clipTimeRange = CMTimeRangeMake(view.audioModel.startTime, view.audioModel.durationTime);
            [view updateFrameWithMaxLength:_collectionView.contentSize.width andRecordInfo:_recordInfo];
            if (view.width == 0) {
                [view removeFromSuperview];
                [deleteArr addObject:view];
                [deleteAudioArr addObject:view.audioModel];
            }
        }
    }
    [_compositionPlayer pauseToPlay];
    [_recordInfo removeAudioFilesWithArr:deleteAudioArr];
    [_recordInfo addAudioFile:model];
    [_recordImageViewArr removeObjectsInArray:deleteArr];
    [_recordImageViewArr addObjectsFromArray:addArr];
    [_compositionPlayer setAudioMute:NO];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer seekToTime:model.startTime];
    JPRecordInfoView *infoView = [[JPRecordInfoView alloc] initWithAudioModel:model andMaxLength:_collectionView.contentSize.width andRecordInfo:_recordInfo];
    infoView.delegate = self;
    [self.collectionView addSubview:infoView];
    [self.recordImageViewArr addObject:infoView];
    [_compositionPlayer startPlaying];
    [self clearRecorder];
}

- (void)recordInfoViewNeedSelect:(JPRecordInfoView *)infoView
{
    if (_isRecorder == YES) {
        infoView.isSelect = NO;
        return;
    }
    [_compositionPlayer pauseToPlay];
    self.deleteButton.hidden = NO;
    if (infoView != self.selecAudioModel) {
        self.selecAudioModel.isSelect = NO;
    }
    self.selecAudioModel = infoView;
    self.deleteButton.hidden = NO;

}

- (void)recordInfoViewNeddDeselect:(JPRecordInfoView *)infoView
{
    self.deleteButton.hidden = YES;
}

- (void)encodeErrorDidOccur:(JPAudioRecorder *)recorder audioModel:(JPAudioModel *)model withError:(NSError *)error
{
    [self clearRecorder];
}



- (void)clearRecorder
{
    _audioRecorder.delegate = nil;
    [_audioRecorder releaseRecorder];
}

- (void)dismiss {
    [self clearRecorder];
    [_compositionPlayer setAudioMute:NO];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer seekToTime:_currentTime];
    _isRecorder = NO;
    _collectionView.scrollEnabled = YES;
    [self.recordButton setTitle:nil forState:UIControlStateNormal];
    [self.recordButton setImage:JPImageWithName(@"recording") forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordingMenuViewShouldDismiss)]) {
        [self.delegate recordingMenuViewShouldDismiss];
    }
}

- (void)willMiss
{
    
    [self dismiss];
}

- (void)updateRecordViews {
    for (int i = (int)([self.recordImageViewArr count] - 1); i >= 0; i --) {
        @autoreleasepool {
            JPRecordInfoView *view = (JPRecordInfoView *)[self.recordImageViewArr objectAtIndex:i];
            [view removeFromSuperview];
            [self.recordImageViewArr removeObject:view];
        }
    }
    NSMutableArray *deleteAudioArr = [NSMutableArray array];
    CMTimeRange range = CMTimeRangeMake(kCMTimeZero, _recordInfo.totalVideoDuraion);
    for (int i = 0; i < [_recordInfo.audioSource count]; i ++) {
        @autoreleasepool {
            JPAudioModel *model = (JPAudioModel *)[_recordInfo.audioSource objectAtIndex:i];
            if (CMTimeRangeContainsTime(range, model.startTime)) {
                if ((0 > CMTimeCompare(CMTimeSubtract(_recordInfo.totalVideoDuraion, model.startTime), model.durationTime))) {
                    model.durationTime = CMTimeSubtract(_recordInfo.totalVideoDuraion, model.startTime);
                    model.clipTimeRange = CMTimeRangeMake(model.startTime, model.durationTime);
                    if (CMTimeCompare(model.durationTime, kCMTimeZero) <= 0) {
                        [deleteAudioArr addObject:model];
                        continue;
                    }
                }
            } else{
                [deleteAudioArr addObject:model];
                continue;
            }
            if (CMTimeCompare(model.durationTime, kCMTimeZero)> 0) {
                JPRecordInfoView *infoView = [[JPRecordInfoView alloc] initWithAudioModel:model andMaxLength:_thumImageArr.count*_collectionViewLayout.itemSize.width andRecordInfo:_recordInfo];
                [self.collectionView addSubview:infoView];
                infoView.delegate = self;
                [self.recordImageViewArr addObject:infoView];
            }
        }
    }
    [_recordInfo removeAudioFilesWithArr:deleteAudioArr];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer seekToTime:kCMTimeZero];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_thumImageArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPRecordAudioThumCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPRecordAudioThumCell" forIndexPath:indexPath];
    cell.imgView.image = (UIImage *)[_thumImageArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)setCurrentTime:(CMTime)currentTime
{
    if (needScorll == YES) {
        return;
    }
    if (_isRecorder == YES) {
        CMTime duration = CMTimeSubtract(currentTime, _startRecordTime);
        NSInteger durationTime = (NSInteger)floor(CMTimeGetSeconds(duration));
        [self.recordButton setTitle:[NSString stringWithFormat:@"%lds", durationTime] forState:UIControlStateNormal];

    }
    if (_isRecorder == YES && CMTimeCompare(_recordInfo.totalVideoDuraion, CMTimeAdd(currentTime, CMTimeMake(1, 3))) <= 0 ) {
        [self recordAction:nil];
    }
    _currentTime = currentTime;
    Float64 videoDuration = CMTimeGetSeconds(_recordInfo.totalVideoDuraion);
    Float64 duration = CMTimeGetSeconds(_currentTime);
    CGFloat pixelPerSecends = _collectionView.contentSize.width/videoDuration;
    NSInteger reallyPixel = (NSInteger)floor(duration * pixelPerSecends);
    if (CMTimeCompare(_currentTime, _recordInfo.totalVideoDuraion) >= 0) {
        reallyPixel = _collectionView.contentSize.width;
    }
    [_collectionView setContentOffset:CGPointMake(reallyPixel - self.width/2, 0) animated:NO];
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
        [self culculateVideoCurrentTime:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    needScorll = NO;
}


- (void)culculateVideoCurrentTime:(CGFloat)offset {
    //scrollview拖拽的实际距离
    CGFloat actualDistance = self.width/2+offset;
    if (actualDistance < 0) {
        return;
    }
    if (_compositionPlayer.isPlaying == YES) {
        [_compositionPlayer pauseToPlay];
    }
    NSInteger reallyPixel = (NSInteger)floor(actualDistance);
    CGFloat per = _collectionView.contentSize.width/ CMTimeGetSeconds(_recordInfo.totalVideoDuraion);
    CMTime currentVideoTime = CMTimeMake(reallyPixel/per, 1);
    if (CMTimeCompare(kCMTimeZero, currentVideoTime) >= 0) {
        currentVideoTime = kCMTimeZero;
    }else if (CMTimeCompare(_recordInfo.totalVideoDuraion, currentVideoTime) <= 0){
        currentVideoTime = _recordInfo.totalVideoDuraion;
    }
    _currentTime = currentVideoTime;
    [_compositionPlayer scrollToWatchThumImageWithTime:currentVideoTime withSticker:YES];
}

@end
