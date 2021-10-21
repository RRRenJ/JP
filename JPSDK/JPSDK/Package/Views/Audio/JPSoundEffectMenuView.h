//
//  JPAudioMenuView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPSoundEffectMenuViewDelegate <NSObject>

- (void)showSoundEffectListView;

@end

@interface JPSoundEffectMenuView : UIView

@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;
@property (nonatomic, weak) id<JPSoundEffectMenuViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame andCompositionPlayer:(JPVideoCompositionPlayer *)compositionPlayer;
- (void)updateViews;
- (void)addMusic:(JPAudioModel *)model;
@end
