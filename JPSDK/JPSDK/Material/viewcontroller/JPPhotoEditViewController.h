//
//  JPPhotoEditViewController.h
//  jper
//
//  Created by FoundaoTEST on 2017/5/23.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPBaseViewController.h"
#import "JPVideoClipViewController.h"

@interface JPPhotoEditViewController : JPBaseViewController
@property (nonatomic, strong) JPVideoModel *videoModel;
@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;
@property (nonatomic, weak) id<JPVideoClipViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL fromPackage;

@property (nonatomic, assign) CMTime totalVideoTime;


@end
