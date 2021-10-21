//
//  JPAudioMenuBaseView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPAudioMenuBaseView.h"

#import "JPRecordingMenuView.h"
#import "JPSoundEffectMenuView.h"
#import "JPMusicListsView.h"
#import "JPSoundEffectListView.h"

@interface JPAudioMenuBaseView ()<JPMusicMenuViewDelegate,JPRecordingMenuViewDelegate,JPMusicListsViewDelegate,JPSoundEffectListViewDelegate,JPSoundEffectMenuViewDelegate,CAAnimationDelegate>{
    UIScrollView *src;
    JPMusicMenuView *musicView;
    JPRecordingMenuView *recordView;
    JPSoundEffectMenuView *soundEffectMenuView;
    JPSoundEffectListView *listView;
    CATransition *popAnimation;
    CATransition *pushAnimation;
}

@property (nonatomic, weak) JPVideoCompositionPlayer *compositionPlayer;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIButton *musicBtn;
@property (nonatomic, weak) IBOutlet UIButton *soundEffectBtn;
@property (nonatomic, weak) IBOutlet UIButton *recordAudioBtn;
@property (nonatomic, weak) IBOutlet UIView *volumeView;
@property (nonatomic, weak) IBOutlet UIView *volumeSlideView;
@property (nonatomic, weak) IBOutlet UIView *sliderContentView;
@property (nonatomic, weak) IBOutlet UIImageView *volumeBgView;
@property (nonatomic, weak) IBOutlet UIView *sliderView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectedViewLeftLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectedViewWidthLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *slideViewLeftLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *slideViewWidthLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *slideViewContentViewWidthLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *slideViewContentViewHeightLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *menuViewHeightLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *volumeViewHeightLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *volumeBgViewHeightLayoutConstraint;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *volumeBgViewWidthLayoutConstraint;

//原声later
@property (strong, nonatomic) IBOutlet UIImageView *laterVolumeBgView;
@property (strong, nonatomic) IBOutlet UIView *laterVolumeSlideView;
@property (strong, nonatomic) IBOutlet UIView *laterSliderView;
@property (strong, nonatomic) IBOutlet UIView *laterSliderContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *laterSlideViewLeftLayoutConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *laterSlideViewWidthLayoutConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *laterSlideViewContentViewWidthLayoutConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *laterSlideViewContentViewHeightLayoutConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *laterVolumeBgViewHeightLayoutConstraint;

@property (nonatomic, strong) JPMusicMenuView * musicMenu;

- (void)pushView:(UIView *)view;
@end

@implementation JPAudioMenuBaseView

- (id)initWithFrame:(CGRect)frame withVideoCompositionPlayer:(JPVideoCompositionPlayer *)player {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        _compositionPlayer = player;
        // Initialization code
        [JPResourceBundle loadNibNamed:@"JPAudioMenuBaseView" owner:self options:nil];
        [self addSubview:self.contentView];
        self.contentView.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(self, 0).bottomEqualToView(self);
                
        self.menuViewHeightLayoutConstraint.constant = JPScreenFitFloat6(40);
        self.volumeViewHeightLayoutConstraint.constant = JPScreenFitFloat6(100);
        self.volumeBgViewHeightLayoutConstraint.constant = JPScreenFitFloat6(35);
        self.laterVolumeBgViewHeightLayoutConstraint.constant = JPScreenFitFloat6(35);
        //self.volumeBgViewWidthLayoutConstraint.constant = JP_SCREEN_WIDTH - JPScreenFitFloat6(110);
        [self setNeedsLayout];
        [self layoutIfNeeded];
        self.slideViewContentViewWidthLayoutConstraint.constant = self.slideViewContentViewHeightLayoutConstraint.constant = JPScreenFitFloat6(19);
        CGFloat leftMax = _volumeBgView.left - _slideViewWidthLayoutConstraint.constant/2.f;
        CGFloat rightMax = _volumeBgView.right - _slideViewWidthLayoutConstraint.constant/2.f;
        self.slideViewLeftLayoutConstraint.constant = rightMax - (rightMax - leftMax)*0.5f;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
        self.sliderContentView.transform = transform;
        
        self.laterSlideViewContentViewWidthLayoutConstraint.constant = self.laterSlideViewContentViewHeightLayoutConstraint.constant = JPScreenFitFloat6(19);
        CGFloat laterLeftMax = _laterVolumeBgView.left - _laterSlideViewWidthLayoutConstraint.constant/2.f;
        CGFloat laterRightMax = _laterVolumeBgView.right - _laterSlideViewWidthLayoutConstraint.constant/2.f;
        self.laterSlideViewLeftLayoutConstraint.constant = laterRightMax - (laterRightMax - laterLeftMax)*0.5f;
        CGAffineTransform laterTransform = CGAffineTransformMakeRotation(M_PI_4);
        self.laterSliderContentView.transform = laterTransform;
        
        CGFloat y = self.menuViewHeightLayoutConstraint.constant + self.volumeViewHeightLayoutConstraint.constant;
        src = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, JP_SCREEN_WIDTH, JPScreenFitFloat6(251))];
        src.contentSize = CGSizeMake(JP_SCREEN_WIDTH*3, src.height);
        src.pagingEnabled = YES;
        src.scrollEnabled = NO;
        src.showsVerticalScrollIndicator = NO;
        src.showsHorizontalScrollIndicator = NO;
        src.bounces = NO;
        [self.contentView addSubview:src];
        CGFloat bottom = 0.f;
        src.sd_layout.topSpaceToView(self.volumeView, 0).bottomSpaceToView(self.contentView, bottom).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
        
        musicView = [[JPMusicMenuView alloc] initWithFrame:src.bounds];
        musicView.selectAudioModel = _music;
        musicView.delegate = self;
        self.musicMenu = musicView;
        [src addSubview:musicView];
        bottom = JPTabbarHeightLineHeight;
     musicView.sd_layout.topEqualToView(src).bottomSpaceToView(src, bottom).leftEqualToView(src).widthIs(JP_SCREEN_WIDTH);
        [src setContentOffset:CGPointMake(0, 0) animated:NO];
        _selectedViewLeftLayoutConstraint.constant = (JP_SCREEN_WIDTH - 30)/4 + 15 - _selectedViewWidthLayoutConstraint.constant/2;
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(volumePercentChanged:)];
        panGes.minimumNumberOfTouches = 1;
        panGes.maximumNumberOfTouches = 5;
        [_sliderView addGestureRecognizer:panGes];
        
        UIPanGestureRecognizer *laterPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(laterVolumePercentChanged:)];
        laterPanGes.minimumNumberOfTouches = 1;
        laterPanGes.maximumNumberOfTouches = 5;
        [_laterSliderView addGestureRecognizer:laterPanGes];
    }
    return self;
}

- (void)setRecordInfo:(JPVideoRecordInfo *)recordInfo {
    _recordInfo = recordInfo;
    CGFloat leftMax = _volumeBgView.left - _slideViewWidthLayoutConstraint.constant/2.f;
    CGFloat rightMax = _volumeBgView.right - _slideViewWidthLayoutConstraint.constant/2.f;
    self.slideViewLeftLayoutConstraint.constant = rightMax - (rightMax - leftMax)*(1-_recordInfo.volume);
    self.laterSlideViewLeftLayoutConstraint.constant = rightMax - (rightMax - leftMax)*(1-_recordInfo.laterVolume);
    CGFloat middle = _volumeBgView.left + _volumeBgView.width/2;
    CGFloat consant = self.slideViewLeftLayoutConstraint.constant;
    CGFloat wh = 10;
    if (consant <= middle && consant >= leftMax) {
        wh = 10.f + fabs(9.f/(middle - leftMax))*(middle - consant);
    }
    if (consant >= middle && consant <= rightMax) {
        wh = 10.f + fabs(9.f/(middle - rightMax))*(consant - middle);
    }
    if (wh > JPScreenFitFloat6(19)) {
        wh = JPScreenFitFloat6(19);
    }
    if (wh < 10.f) {
        wh = 10.f;
    }

    _slideViewContentViewHeightLayoutConstraint.constant = _slideViewContentViewWidthLayoutConstraint.constant = wh;
    _laterSlideViewContentViewHeightLayoutConstraint.constant = _laterSlideViewContentViewWidthLayoutConstraint.constant = wh;
    _music = _recordInfo.backgroundMusic;
    musicView.selectAudioModel = _recordInfo.backgroundMusic;
}

- (IBAction)dismiss:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioMenuViewShouldDismiss) ]) {
        [self.delegate audioMenuViewShouldDismiss];
    }
}

- (void)pushView:(UIView *)view {
    if (!pushAnimation) {
        pushAnimation = [CATransition animation];
        pushAnimation.duration = 0.2f;
        pushAnimation.timingFunction = [CAMediaTimingFunction
                                        functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pushAnimation.fillMode = kCAFillModeForwards;
        pushAnimation.delegate = self;
        pushAnimation.type = kCATransitionPush;
        pushAnimation.subtype = kCATransitionFromRight;
    }
    [self.layer addAnimation:pushAnimation forKey:@"pushAnimation"];
    [self.contentView addSubview:view];
    view.sd_layout.topEqualToView(self.contentView).bottomEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if ([anim isEqual:popAnimation]) {
            [self.layer removeAnimationForKey:@"popAnimation"];
        }
        if ([anim isEqual:pushAnimation]) {
            [self.layer removeAnimationForKey:@"pushAnimation"];
        }
    }
}

#pragma mark - JPSoundEffectMenuViewDelegate

- (void)showSoundEffectListView{
    if (!listView) {
        listView = [[JPSoundEffectListView alloc] initWithFrame:self.bounds];
        listView.delegate = self;
    }
    [listView show];
    [listView getDataList];
    [self pushView:listView];
}

#pragma mark - JPSoundEffectListViewDelegate

- (void)soundEffectListViewWillPop:(JPSoundEffectListView *)view {
    if (!popAnimation) {
        popAnimation = [CATransition animation];
        popAnimation.duration = 0.2f;
        popAnimation.timingFunction = [CAMediaTimingFunction
                                       functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        popAnimation.fillMode = kCAFillModeForwards;
        popAnimation.delegate = self;
        popAnimation.type = kCATransitionPush;
        popAnimation.subtype = kCATransitionFromLeft;
    }
    [self.layer addAnimation:popAnimation forKey:@"popAnimation"];
    [view removeFromSuperviewAndClearAutoLayoutSettings];
}

- (void)soundEffectListViewSelectedMusic:(JPAudioModel *)model {
    [soundEffectMenuView addMusic:model];
}

#pragma mark - JPMusicListsViewDelegate

- (void)willPop:(JPMusicListsView *)view {
    if (!popAnimation) {
        popAnimation = [CATransition animation];
        popAnimation.duration = 0.2f;
        popAnimation.timingFunction = [CAMediaTimingFunction
                                       functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        popAnimation.fillMode = kCAFillModeForwards;
        popAnimation.delegate = self;
        popAnimation.type = kCATransitionPush;
        popAnimation.subtype = kCATransitionFromLeft;
    }
    [self.layer addAnimation:popAnimation forKey:@"popAnimation"];
    [view removeFromSuperviewAndClearAutoLayoutSettings];
    if ([self.delegate respondsToSelector:@selector(musicListWillPop)]) {
        [self.delegate musicListWillPop];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(musicListDidPop)]) {
            [self.delegate musicListDidPop];
        }
    });
}

- (void)selectedMusic:(JPAudioModel *)model {
    _music = model;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedBackgroundMusicModel:)]) {
        musicView.selectAudioModel = model;
        [self.delegate selectedBackgroundMusicModel:model];
        [musicView startPlay];
    }
}

//guide
- (void)firstMusicUnDownload{
    if ([self.delegate respondsToSelector:@selector(firstMusicUnDownload)]) {
        [self.delegate firstMusicUnDownload];
    }
}

- (void)firstMusicDownloading{
    if ([self.delegate respondsToSelector:@selector(firstMusicDownloading)]) {
        [self.delegate firstMusicDownloading];
    }
}

- (void)firstMusicDownloaded{
    if ([self.delegate respondsToSelector:@selector(firstMusicDownloaded)]) {
        [self.delegate firstMusicDownloaded];
    }
}

#pragma mark - JPMusicMenuViewDelegate

- (void)musicCollectionLoadData{
    if ([self.delegate respondsToSelector:@selector(musicCollectionLoadData)]) {
        [self.delegate musicCollectionLoadData];
    }
}

- (void)musicCollectionViewScrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([self.delegate respondsToSelector:@selector(musicCollectionViewScrollViewDidScroll:)]) {
        [self.delegate musicCollectionViewScrollViewDidScroll:scrollView];
    }
    
}

- (void)musicCollectionViewItemDidSelected{
    if ([self.delegate respondsToSelector:@selector(musicCollectionViewItemDidSelected)]) {
        [self.delegate musicCollectionViewItemDidSelected];
    }
}

- (void)didSelectedMaterialCategory:(JPMaterialCategory *)category{
    JPMusicListsView *view = [[JPMusicListsView alloc] initWithFrame:self.bounds andCategory:category];
    view.audioModel = _music;
    [view show];
    view.delegate = self;
    [self pushView:view];
}

- (void)selectedBackgroundMusicModel:(JPAudioModel *)model{
    _music = model;
    [musicView startPlay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedBackgroundMusicModel:)]) {
        [self.delegate selectedBackgroundMusicModel:model];
    }
}

- (void)didDeleteBackgroundMusic{
    [musicView endPlay];
    _music = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteBackgroundMusic)]) {
        [self.delegate didDeleteBackgroundMusic];
    }
}

#pragma mark - JPRecordingMenuViewDelegate

#pragma mark -

- (void)volumePercentChanged:(UIPanGestureRecognizer *)pan{
    CGFloat volume = _recordInfo.volume;
    if (pan.state == UIGestureRecognizerStateBegan) {
        [_compositionPlayer pauseToPlay];
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:_sliderView];
        CGFloat consant = _slideViewLeftLayoutConstraint.constant + point.x;
        CGFloat middle = _volumeBgView.left + _volumeBgView.width/2;
        CGFloat leftMax = _volumeBgView.left - _slideViewWidthLayoutConstraint.constant/2.f;
        CGFloat rightMax = _volumeBgView.right - _slideViewWidthLayoutConstraint.constant/2.f;
        CGFloat g = 213.f;
        CGFloat b = 24.f;
        g = 213.f - ((consant - leftMax)*64.f/(rightMax - leftMax));
        b = 24.f + ((consant - leftMax)*23.f/(rightMax - leftMax));
        if (consant < leftMax) {
            consant = leftMax;
            g = 213.f;
            b = 24.f;
        }
        if (consant > rightMax) {
            consant = rightMax;
            g = 149.f;
            b = 47.f;
        }
        _slideViewLeftLayoutConstraint.constant = consant;
        CGFloat wh = 10;
        if (consant <= middle && consant >= leftMax) {
            wh = 10.f + fabs(9.f/(middle - leftMax))*(middle - consant);
        }
        if (consant >= middle && consant <= rightMax) {
            wh = 10.f + fabs(9.f/(middle - rightMax))*(consant - middle);
        }
        if (wh > JPScreenFitFloat6(19)) {
            wh = JPScreenFitFloat6(19);
        }
        if (wh < 10.f) {
            wh = 10.f;
        }
        //_slideViewContentViewHeightLayoutConstraint.constant = _slideViewContentViewWidthLayoutConstraint.constant = wh;
    }
    [pan setTranslation:CGPointMake(0, 0) inView:_sliderView];
    if (UIGestureRecognizerStateEnded == pan.state || UIGestureRecognizerStateCancelled == pan.state) {
        CGFloat leftMax = _volumeBgView.left - _slideViewWidthLayoutConstraint.constant/2.f;
        CGFloat rightMax = _volumeBgView.right - _slideViewWidthLayoutConstraint.constant/2.f;
        CGFloat w = rightMax - leftMax;
        volume = (_slideViewLeftLayoutConstraint.constant - leftMax)/w;
        NSLog(@"volume:%.2f",volume);
        _recordInfo.volume = volume;
        [_compositionPlayer setRecordInfo:_recordInfo];
        [_compositionPlayer seekToTime:kCMTimeZero];
        [_compositionPlayer startPlaying];
        [self startPlay];
    }
}

- (void)laterVolumePercentChanged:(UIPanGestureRecognizer *)pan {
    CGFloat volume = _recordInfo.volume;
    if (pan.state == UIGestureRecognizerStateBegan) {
        [_compositionPlayer pauseToPlay];
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:_laterSliderView];
        CGFloat consant = _laterSlideViewLeftLayoutConstraint.constant + point.x;
        CGFloat middle = _laterVolumeBgView.left + _laterVolumeBgView.width/2;
        CGFloat leftMax = _laterVolumeBgView.left - _laterSlideViewWidthLayoutConstraint.constant/2.f;
        CGFloat rightMax = _laterVolumeBgView.right - _laterSlideViewWidthLayoutConstraint.constant/2.f;
        CGFloat g = 213.f;
        CGFloat b = 24.f;
        g = 213.f - ((consant - leftMax)*64.f/(rightMax - leftMax));
        b = 24.f + ((consant - leftMax)*23.f/(rightMax - leftMax));
        if (consant < leftMax) {
            consant = leftMax;
            g = 213.f;
            b = 24.f;
        }
        if (consant > rightMax) {
            consant = rightMax;
            g = 149.f;
            b = 47.f;
        }
        _laterSlideViewLeftLayoutConstraint.constant = consant;
        CGFloat wh = 10;
        if (consant <= middle && consant >= leftMax) {
            wh = 10.f + fabs(9.f/(middle - leftMax))*(middle - consant);
        }
        if (consant >= middle && consant <= rightMax) {
            wh = 10.f + fabs(9.f/(middle - rightMax))*(consant - middle);
        }
        if (wh > JPScreenFitFloat6(19)) {
            wh = JPScreenFitFloat6(19);
        }
        if (wh < 10.f) {
            wh = 10.f;
        }
        //_laterSlideViewContentViewHeightLayoutConstraint.constant = _laterSlideViewContentViewWidthLayoutConstraint.constant = wh;
    }
    [pan setTranslation:CGPointMake(0, 0) inView:_laterSliderView];
    if (UIGestureRecognizerStateEnded == pan.state || UIGestureRecognizerStateCancelled == pan.state) {
        CGFloat leftMax = _laterVolumeBgView.left - _laterSlideViewWidthLayoutConstraint.constant/2.f;
        CGFloat rightMax = _laterVolumeBgView.right - _laterSlideViewWidthLayoutConstraint.constant/2.f;
        CGFloat w = rightMax - leftMax;
        volume = (_laterSlideViewLeftLayoutConstraint.constant - leftMax)/w;
        NSLog(@"volume:%.2f",volume);
        _recordInfo.laterVolume = volume;
        [_compositionPlayer setRecordInfo:_recordInfo];
        [_compositionPlayer seekToTime:kCMTimeZero];
        [_compositionPlayer startPlaying];
        [self startPlay];
    }
}

- (IBAction)selectAudioType:(id)sender{
    UIButton *btn = (UIButton *)sender;
    JPSelectedAudioType type = (JPSelectedAudioType)btn.tag;
    if (type == _selectedAudioType) {
        return;
    }
    _selectedAudioType = type;
    if (JPSelectedAudioTypeMusic == _selectedAudioType) {
        _selectedViewLeftLayoutConstraint.constant = (JP_SCREEN_WIDTH - 30)/4 + 15 - _selectedViewWidthLayoutConstraint.constant/2;
        [_musicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_soundEffectBtn setTitleColor:[UIColor jp_colorWithHexString:@"767676"] forState:UIControlStateNormal];
        [_recordAudioBtn setTitleColor:[UIColor jp_colorWithHexString:@"767676"] forState:UIControlStateNormal];
        [src setContentOffset:CGPointMake(0, 0) animated:NO];
        [_compositionPlayer pauseToPlay];
        [self endPlay];
    }else if (JPSelectedAudioTypeSoundEffect == _selectedAudioType){
        if (!soundEffectMenuView) {
            soundEffectMenuView = [[JPSoundEffectMenuView alloc] initWithFrame:src.bounds andCompositionPlayer:_compositionPlayer];
            soundEffectMenuView.delegate = self;
            [src addSubview:soundEffectMenuView];
            soundEffectMenuView.sd_layout.topEqualToView(src).bottomEqualToView(src).leftSpaceToView(src, JP_SCREEN_WIDTH).widthIs(JP_SCREEN_WIDTH);
        }
        soundEffectMenuView.recordInfo = _recordInfo;
        [_soundEffectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_musicBtn setTitleColor:[UIColor jp_colorWithHexString:@"767676"] forState:UIControlStateNormal];
        [_recordAudioBtn setTitleColor:[UIColor jp_colorWithHexString:@"767676"] forState:UIControlStateNormal];
//        _selectedViewLeftLayoutConstraint.constant = JP_SCREEN_WIDTH/2 - _selectedViewWidthLayoutConstraint.constant/2;
        _selectedViewLeftLayoutConstraint.constant = (JP_SCREEN_WIDTH - 30)*3/4 + 15 - _selectedViewWidthLayoutConstraint.constant/2;
        [src setContentOffset:CGPointMake(JP_SCREEN_WIDTH, 0) animated:NO];
        [soundEffectMenuView updateViews];
        [self endPlay];
    } else if (JPSelectedAudioTypeRecordAudio == _selectedAudioType){
        if (!recordView) {
            recordView = [[JPRecordingMenuView alloc] initWithFrame:src.bounds andCompositionPlayer:_compositionPlayer];
            recordView.delegate = self;
            [src addSubview:recordView];
            CGFloat bottom = JPTabbarHeightLineHeight;
            recordView.sd_layout.topEqualToView(src).bottomSpaceToView(src, bottom).leftSpaceToView(src, JP_SCREEN_WIDTH*2).widthIs(JP_SCREEN_WIDTH);
        }
        [_compositionPlayer scrollToWatchThumImageWithTime:kCMTimeZero withSticker:NO];
        recordView.recordInfo = _recordInfo;
        [recordView setThumImageArr:[_thumImageDic valueForKey:@"images"]];
        [recordView setCurrentTime:_currentTime];
        [_recordAudioBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_soundEffectBtn setTitleColor:[UIColor jp_colorWithHexString:@"767676"] forState:UIControlStateNormal];
        [_musicBtn setTitleColor:[UIColor jp_colorWithHexString:@"767676"] forState:UIControlStateNormal];
        _selectedViewLeftLayoutConstraint.constant = (JP_SCREEN_WIDTH - 30)*5/6 + 15 - _selectedViewWidthLayoutConstraint.constant/2;
        [src setContentOffset:CGPointMake(JP_SCREEN_WIDTH*2, 0) animated:NO];
        [recordView updateRecordViews];
        [self endPlay];
    }
}

- (void)refreshMenu {
    if (JPSelectedAudioTypeRecordAudio == _selectedAudioType) {
        [_compositionPlayer scrollToWatchThumImageWithTime:kCMTimeZero withSticker:NO];
        recordView.recordInfo = _recordInfo;
        [recordView setThumImageArr:[_thumImageDic valueForKey:@"images"]];
        [recordView setCurrentTime:_currentTime];
        [recordView updateRecordViews];
    } else if (JPSelectedAudioTypeSoundEffect == _selectedAudioType){
        soundEffectMenuView.recordInfo = _recordInfo;
        [soundEffectMenuView updateViews];
    }
}

- (void)setCurrentTime:(CMTime)currentTime {
    _currentTime = currentTime;
    if (!recordView) {
        return;
    }
    [recordView setCurrentTime:_currentTime];
}

- (void)setMusic:(JPAudioModel *)music {
    _music = music;
    musicView.selectAudioModel = _music;
    [musicView startPlay];
}

- (void)startPlay{
    [musicView startPlay];
}

- (void)endPlay{
    [musicView endPlay];
}

@end
