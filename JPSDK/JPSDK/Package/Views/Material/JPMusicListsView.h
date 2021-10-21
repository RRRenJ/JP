//
//  JPMusicListsView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPMaterialCategory.h"

@class JPMusicListsView;
@protocol JPMusicListsViewDelegate <NSObject>

- (void)willPop:(JPMusicListsView *)view;
- (void)selectedMusic:(JPAudioModel *)model;
//guide
- (void)firstMusicUnDownload;

- (void)firstMusicDownloading;

- (void)firstMusicDownloaded;


@end

@interface JPMusicListsView : UIView

@property (nonatomic, weak) id<JPMusicListsViewDelegate>delegate;

@property (nonatomic, strong) JPAudioModel *audioModel;

- (id)initWithFrame:(CGRect)frame andCategory:(JPMaterialCategory *)category;

- (void)show;

@end
