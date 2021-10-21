//
//  JPVideoPlayerView.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JPVideoPlayerView : UIView
@property (nonatomic, strong) JPFilterModel *selectFilterModel;
@property (nonatomic, assign) JPVideoAspectRatio selectVideoAspectRatio;
- (void)updateFilterModel:(JPFilterModel *)filterModel;
- (void)updateVideoAspectRatio:(JPVideoAspectRatio)aspectRatio;
- (void)updateVideoEditMessage:(NSString *)message;
@end
