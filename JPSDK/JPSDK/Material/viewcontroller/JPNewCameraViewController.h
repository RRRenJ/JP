//
//  JPNewCameraViewController.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPBaseViewController.h"


@interface JPNewCameraViewController : JPBaseViewController
@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;
@property (nonatomic, assign) BOOL fromPackage;

//开始选择视频
@property (nonatomic, copy) void (^startTakeVideo)();

//引导视频开始展示
@property (nonatomic, copy) void (^guideVideoShowBlock)();

//引导视频隐藏
@property (nonatomic, copy) void (^guideVideoHideBlock)();

//隐藏引导视频
- (void)guideVideoHide;

@end

