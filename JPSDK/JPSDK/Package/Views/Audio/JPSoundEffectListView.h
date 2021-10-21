//
//  JPSoundEffectListView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPSoundEffectListView;
@protocol JPSoundEffectListViewDelegate <NSObject>

- (void)soundEffectListViewWillPop:(JPSoundEffectListView *)view;
- (void)soundEffectListViewSelectedMusic:(JPAudioModel *)model;

@end

@interface JPSoundEffectListView : UIView
@property (nonatomic, weak) id<JPSoundEffectListViewDelegate>delegate;

- (void)getDataList;
- (void)show;

@end
