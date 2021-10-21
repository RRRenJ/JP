//
//  JPVideoPlayerView.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPVideoPlayerView.h"
#import "JPVideoPlayerView.h"

@interface JPVideoPlayerView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *filterNameView;
@property (weak, nonatomic) IBOutlet UILabel *filterNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *filterEnNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *filterCnNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoAspectRatioLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *videoAspectRatioTimer;

@end
@implementation JPVideoPlayerView


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
    self.backgroundColor = [UIColor clearColor];
    [JPResourceBundle loadNibNamed:@"JPVideoPlayerView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
    self.filterNameView.hidden = YES;
    self.videoAspectRatioLabel.hidden = YES;
    self.filterNumberLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:30];
    self.filterEnNameLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:30];
    self.filterCnNameLabel.font = [UIFont systemFontOfSize:15];
    self.filterNumberLabel.layer.shadowOpacity = 0.15;
    self.filterNumberLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.filterNumberLabel.layer.shadowRadius = 1.5;
    self.filterNumberLabel.layer.shadowColor = [UIColor blackColor].CGColor;

    self.filterEnNameLabel.layer.shadowOpacity = 0.15;
    self.filterEnNameLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.filterEnNameLabel.layer.shadowRadius = 1.5;
    self.filterEnNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
   
    self.filterCnNameLabel.layer.shadowOpacity = 0.15;
    self.filterCnNameLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.filterCnNameLabel.layer.shadowRadius = 1.5;
    self.filterCnNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)updateFilterModel:(JPFilterModel *)filterModel
{
    if (filterModel.filterType != _selectFilterModel.filterType) {
        _selectFilterModel = filterModel;
        [_filterNameView.layer removeAllAnimations];
        _filterNameView.hidden = YES;
        self.filterNumberLabel.text = filterModel.filterNumberString;
        self.filterEnNameLabel.text = filterModel.filterName;
        self.filterCnNameLabel.text = filterModel.filterCNName;
        _filterNameView.alpha = 0.0;
        _filterNameView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _filterNameView.hidden = NO;
        __weak typeof(self) weakSelf = self;
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nameViewDisMiss) userInfo:nil repeats:NO];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.filterNameView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            weakSelf.filterNameView.alpha = 1.0;
        }];
    }
}


- (void)updateVideoEditMessage:(NSString *)message
{
    [_videoAspectRatioLabel.layer removeAllAnimations];
    _videoAspectRatioLabel.hidden = YES;
    _videoAspectRatioLabel.font = [UIFont jp_pingFangWithSize:15.f];
    _videoAspectRatioLabel.backgroundColor = [UIColor jp_colorWithHexString:@"000000" alpha:0.5];
    _videoAspectRatioLabel.textAlignment = NSTextAlignmentNatural;
    _videoAspectRatioLabel.text = [NSString stringWithFormat:@"  %@  ",message] ;
    _videoAspectRatioLabel.height = 32;
    _videoAspectRatioLabel.layer.cornerRadius = 16;
    _videoAspectRatioLabel.layer.masksToBounds = YES;
    _videoAspectRatioLabel.alpha = 0.0;
    _videoAspectRatioLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
    _videoAspectRatioLabel.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [_videoAspectRatioTimer invalidate];
    _videoAspectRatioTimer = nil;
    _videoAspectRatioTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(videoAspectRatioViewDismiss) userInfo:nil repeats:NO];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.videoAspectRatioLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        weakSelf.videoAspectRatioLabel.alpha = 1.0;
    }];
}



- (void)updateVideoAspectRatio:(JPVideoAspectRatio)aspectRatio {
    if (aspectRatio != _selectVideoAspectRatio) {
        _selectVideoAspectRatio = aspectRatio;
        [_videoAspectRatioLabel.layer removeAllAnimations];
        _videoAspectRatioLabel.hidden = YES;
        _videoAspectRatioLabel.font = [UIFont jp_placardMTStdCondBoldFontWithSize:30];
        switch (aspectRatio) {
            case JPVideoAspectRatio16X9:
                _videoAspectRatioLabel.text = @"16 : 9";
                break;
            case JPVideoAspectRatio9X16:
                _videoAspectRatioLabel.text = @"9 : 16";
                break;
            case JPVideoAspectRatio1X1:
                _videoAspectRatioLabel.text = @"1 : 1";
                break;
            case JPVideoAspectRatioCircular:
                _videoAspectRatioLabel.text = @"1 : 1 圆";
                break;
            case JPVideoAspectRatio4X3:
                _videoAspectRatioLabel.text = @"4 : 3";
                break;
            default:
                break;
        }
        _videoAspectRatioLabel.alpha = 0.0;
        _videoAspectRatioLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _videoAspectRatioLabel.hidden = NO;
        __weak typeof(self) weakSelf = self;
        [_videoAspectRatioTimer invalidate];
        _videoAspectRatioTimer = nil;
        _videoAspectRatioTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(videoAspectRatioViewDismiss) userInfo:nil repeats:NO];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.videoAspectRatioLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            weakSelf.videoAspectRatioLabel.alpha = 1.0;
        }];
    }
}

- (void)nameViewDisMiss
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.filterNameView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.filterNameView.hidden = YES;
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
        }
    }];
 
}

- (void)videoAspectRatioViewDismiss{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.videoAspectRatioLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.videoAspectRatioLabel.hidden = YES;
            [weakSelf.videoAspectRatioTimer invalidate];
            weakSelf.videoAspectRatioTimer = nil;
        }
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}
@end
