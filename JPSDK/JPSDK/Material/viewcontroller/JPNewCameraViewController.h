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
@property (nonatomic, copy) void (^startTakeVideo)(void);




@end

