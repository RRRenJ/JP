//
//  JPVideoEditMune.h
//  jper
//
//  Created by FoundaoTEST on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPVideoEditMuneDelegate <NSObject>

- (void)videoEditMuneWillDelegateThisVideo:(JPVideoModel *)videoModel;
- (void)videoEditMuneWillEditReverseThisVideo:(JPVideoModel *)videoModel;
- (void)videoEditMuneWillEditPlaySpeedThisVideo:(JPVideoModel *)videoModel;
- (void)videoEditMuneWillClidThisVideo:(JPVideoModel *)videoModel;

@end

@interface JPVideoEditMune : UIView
@property (nonatomic, weak) id<JPVideoEditMuneDelegate> delegate;
@property (nonatomic, weak) JPVideoModel *videoModel;
@property (nonatomic, assign) CMTime currentTime;
@end
