//
//  JPVideoEditMune.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPVideoEditMune.h"

@interface JPVideoEditMune ()
{
    BOOL canFast;
    BOOL canClid;
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *timeTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *reverseButton;
@property (weak, nonatomic) IBOutlet UIButton *clidButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;


@end

@implementation JPVideoEditMune

- (IBAction)changeTimeTypeAction:(id)sender {
    NSInteger index = _videoModel.timePlayType;
    index++;
    if (index > JPVideoTimePlayTypeFast) {
        index = JPVideoTimePlayTypeNone;
    }
    if (canFast == NO && index == JPVideoTimePlayTypeFast) {
        index = JPVideoTimePlayTypeNone;
    }
    _videoModel.timePlayType = index;
    if (_videoModel.timePlayType == JPVideoTimePlayTypeNone) {
        [_timeTypeButton setImage:JPImageWithName(@"time1.0") forState:UIControlStateNormal];
    }else if (_videoModel.timePlayType == JPVideoTimePlayTypeFast)
    {
        [_timeTypeButton setImage:JPImageWithName(@"time2.0") forState:UIControlStateNormal];
    }else{
        [_timeTypeButton setImage:JPImageWithName(@"time0.5") forState:UIControlStateNormal];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoEditMuneWillEditPlaySpeedThisVideo:)]) {
        [self.delegate videoEditMuneWillEditPlaySpeedThisVideo:_videoModel];
    }
}

- (IBAction)videoReverseAction:(id)sender {
    _videoModel.isReverse = !_videoModel.isReverse;
    CMTimeRange timeRange = _videoModel.timeRange;
    _videoModel.timeRange = CMTimeRangeMake(CMTimeSubtract(_videoModel.videoTime, CMTimeAdd(timeRange.start, timeRange.duration)), timeRange.duration);
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoEditMuneWillEditReverseThisVideo:)]) {
        [self.delegate videoEditMuneWillEditReverseThisVideo:_videoModel];
    }
}

- (IBAction)clidVideoAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoEditMuneWillClidThisVideo:)]) {
        [self.delegate videoEditMuneWillClidThisVideo:_videoModel];
    }
}

- (IBAction)deleteVideoAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoEditMuneWillDelegateThisVideo:)]) {
        [self.delegate videoEditMuneWillDelegateThisVideo:_videoModel];
    }
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor blackColor];
    [JPResourceBundle loadNibNamed:@"JPVideoEditMune" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
    _bottomSpace.constant = JPTabbarHeightLineHeight;
    [self.timeTypeButton jp_layoutButtonWithEdgeInsetsStyle:JPButtonEdgeInsetsStyleTop imageTitleSpace:6];
    [self.reverseButton jp_layoutButtonWithEdgeInsetsStyle:JPButtonEdgeInsetsStyleTop imageTitleSpace:6];
    [self.clidButton jp_layoutButtonWithEdgeInsetsStyle:JPButtonEdgeInsetsStyleTop imageTitleSpace:6];
    [self.deleteButton jp_layoutButtonWithEdgeInsetsStyle:JPButtonEdgeInsetsStyleTop imageTitleSpace:6];
}


- (void)setVideoModel:(JPVideoModel *)videoModel
{
    _videoModel = videoModel;
    if (_videoModel.timePlayType == JPVideoTimePlayTypeNone) {
        [_timeTypeButton setImage:JPImageWithName(@"time1.0") forState:UIControlStateNormal];
    }else if (_videoModel.timePlayType == JPVideoTimePlayTypeFast)
    {
        [_timeTypeButton setImage:JPImageWithName(@"time2.0") forState:UIControlStateNormal];
    }else{
        [_timeTypeButton setImage:JPImageWithName(@"time0.5") forState:UIControlStateNormal];
    }
    canFast = YES;
    canClid = YES;
    if (CMTimeCompare(videoModel.timeRange.duration, CMTimeMake(3, 1)) < 0) {
        canFast = NO;
    }
    if (CMTimeCompare(CMTimeSubtract(_currentTime, videoModel.timeRange.start), JP_VIDEO_MIN_DURATION) < 0) {
        canClid = NO;
    }
    if (CMTimeCompare(CMTimeSubtract(CMTimeAdd(videoModel.timeRange.start, videoModel.timeRange.duration), _currentTime), JP_VIDEO_MIN_DURATION) < 0) {
        canClid = NO;
    }
    if (canClid == NO) {
        _clidButton.userInteractionEnabled = NO;
        [_clidButton setImage:JPImageWithName(@"shot-grey") forState:UIControlStateNormal];
    }else{
        _clidButton.userInteractionEnabled = YES;
        [_clidButton setImage:JPImageWithName(@"shot") forState:UIControlStateNormal];
    }
}
@end
