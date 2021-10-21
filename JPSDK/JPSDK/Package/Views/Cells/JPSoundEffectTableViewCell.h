//
//  JPSoundEffectTableViewCell.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPSoundEffectTableViewCellDelegate <NSObject>
- (void)willDeleteTheAudioModel:(JPAudioModel *)model;
- (void)deleteTheAudioModel:(JPAudioModel *)model;
- (void)didChangeStartTimeWithTheModel:(JPAudioModel *)model;
- (void)didEndChangeStartTimeWithTheModel:(JPAudioModel *)model;
- (void)willChangeStartTimeWithTheModel:(JPAudioModel *)model;
@end

@interface JPSoundEffectTableViewCell : UITableViewCell
@property (nonatomic, assign) CMTime duration;
@property (nonatomic, weak) id<JPSoundEffectTableViewCellDelegate>delegate;

- (void)loadViewWithDataSource:(JPAudioModel *)model;

@end
