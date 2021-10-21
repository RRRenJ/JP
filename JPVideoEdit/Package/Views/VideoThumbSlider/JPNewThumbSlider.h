//
//  JPNewThumbSlider.h
//  jper
//
//  Created by FoundaoTEST on 2017/7/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPNewThumbSliderDelegate <NSObject>

- (void)didChangedToTime:(CMTime)currentTime;
- (void)newThumbSliderWillSelectThisVideoModel:(JPVideoModel *)videoModel;
- (void)newThumbSliderWillDeselectThisVideoModel:(JPVideoModel *)videoModel;
- (void)newThumbSliderWillChangeVideoTranstionTypeThisVideoModel:(JPVideoModel *)videoModel;
- (void)newThumbSliderWillMoveVideo;
- (void)newThumbSliderDidExchangeTheVideoIndex:(NSInteger)index toIndex:(NSInteger)toIndex;
- (void)newThumbSliderWillUpdateVideoLong:(JPVideoModel *)videoModel;
- (void)newThumbSliderWillUpdateAddVideo;
- (void)newThumbSliderWillDistranstion:(JPVideoModel *)videoModel;

@end

@interface JPNewThumbSlider : UIView

@property (nonatomic, strong, readonly) UICollectionView * collectionView;

@property (nonatomic, weak) id<JPNewThumbSliderDelegate> delegate;
- (instancetype)initWithRecordInfo:(JPVideoRecordInfo *)videoRecordInfo;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *originDataSource;
@property (nonatomic, weak) UIView *buttonView;
@property (nonatomic, assign) BOOL hideAddView;
- (void)scrollToTime:(CMTime)time;
@property (assign, nonatomic) CMTime currentTime;
- (void)formatThumbInfos;
- (void)setThisVideoDeselect:(JPVideoModel *)videoModel;
- (CMTime)getCurrentVideoTime;
- (CMTime)getStartTimeWithModel:(JPVideoModel *)videoModel;
- (void)updateThumSlider;
- (void)updateVideoApearTimeWithModel:(JPVideoModel *)videoModel;
- (BOOL)isShowVideoGuide;
- (BOOL)isCurrentActive;
@property (nonatomic, assign) BOOL hasClickActive;

- (void)removeGuideView;


@end
