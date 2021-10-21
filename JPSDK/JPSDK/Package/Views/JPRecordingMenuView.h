//
//  JPRecordingMenuView.h
//  jper
//
//  Created by FoundaoTEST on 2017/5/15.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPRecordingMenuViewDelegate <NSObject>
- (void)recordingMenuViewShouldDismiss;

@end

@interface JPRecordingMenuView : UIView

- (instancetype)initWithFrame:(CGRect)frame andCompositionPlayer:(JPVideoCompositionPlayer *)compositionPlayer;
@property (nonatomic, weak) id<JPRecordingMenuViewDelegate>delegate;
@property (nonatomic, weak) NSArray *thumImageArr;
@property (nonatomic, assign) CMTime currentTime;
@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;
@property (nonatomic, assign, readonly) BOOL isRecorder;
- (void)willMiss;
- (void)updateRecordViews;
@end
