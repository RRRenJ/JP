//
//  JPAddAudioTrackMenu.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/17.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPMaterialCategory;
@protocol JPMusicMenuViewDelegate <NSObject>

- (void)selectedBackgroundMusicModel:(JPAudioModel *)model;
- (void)didDeleteBackgroundMusic;
- (void)didSelectedMaterialCategory:(JPMaterialCategory *)category;
- (void)musicCollectionViewScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)musicCollectionViewItemDidSelected;

- (void)musicCollectionLoadData;

@end

@interface JPMusicMenuView : UIView

@property (nonatomic, strong, readonly) UIView * bottomCollecView;

@property (nonatomic, strong, readonly) UICollectionView * collecView;

@property (nonatomic, assign, readonly) BOOL dataLoad;

@property (nonatomic, weak) id<JPMusicMenuViewDelegate>delegate;


@property (nonatomic, strong) JPAudioModel *selectAudioModel;

- (void)startPlay;
- (void)endPlay;
@end
