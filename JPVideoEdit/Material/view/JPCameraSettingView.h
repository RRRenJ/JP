//
//  JPCameraSettingView.h
//  jper
//
//  Created by FoundaoTEST on 2017/4/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JPCameraSettingViewDelegate <NSObject>

- (void)cameraSettingViewDidChangeCameraSession;
- (void)cameraSettingViewDidChangeVideoFrame:(JPVideoAspectRatio)aspectRatio;
- (void)cameraSettingViewWillChangeVideoFrame;
- (void)cameraSettingViewWillChangeVideoHowFast;
- (void)cameraSettingViewDidChangeVideoHowFast:(JPVideoHowFast)howFast;
- (void)cameraSettingViewDidChangeOpenLight:(BOOL)isOpenLight;
- (void)cameraSettingViewDidChangeFilter:(BOOL)isOpenFilter;

@end

@interface JPCameraSettingView : UIView

@property (nonatomic, weak) id<JPCameraSettingViewDelegate>delegate;
@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;
@property (nonatomic, assign) BOOL supportSlow;
- (void)hasRecord;
- (void)startRecord;
- (IBAction)changeVideoFrame:(id)sender;

- (void)settingCameraViewBeRecording;
- (void)startFilters;
@end
