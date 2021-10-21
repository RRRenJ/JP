//
//  JPAudioMenuBaseView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPMusicMenuView.h"

@protocol JPAudioMenuBaseViewDelegate <NSObject>

- (void)selectedBackgroundMusicModel:(JPAudioModel *)model;
- (void)didDeleteBackgroundMusic;
- (void)volumeDidChangedToValue:(CGFloat)volume;
- (void)audioMenuViewShouldDismiss;
- (void)musicCollectionViewScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)musicCollectionViewItemDidSelected;

- (void)musicListWillPop;
- (void)musicListDidPop;

- (void)musicCollectionLoadData;

//guide
- (void)firstMusicUnDownload;

- (void)firstMusicDownloading;

- (void)firstMusicDownloaded;

@end

@interface JPAudioMenuBaseView : UIView
@property (nonatomic, strong, readonly) JPMusicMenuView * musicMenu;
@property (nonatomic, weak) id<JPAudioMenuBaseViewDelegate>delegate;
@property (nonatomic, assign) JPSelectedAudioType selectedAudioType;
@property (nonatomic, strong) JPAudioModel *music;
@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;
@property (nonatomic, strong) NSDictionary *thumImageDic;
@property (nonatomic, assign) CMTime currentTime;

- (id)initWithFrame:(CGRect)frame withVideoCompositionPlayer:(JPVideoCompositionPlayer *)player;
- (void)startPlay;
- (void)endPlay;
- (void)refreshMenu;
@end
