//
//  JPNewPageViewController.h
//  jper
//
//  Created by FoundaoTEST on 2017/7/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPBaseViewController.h"

@interface JPNewPageViewController : JPBaseViewController

@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;

@property (nonatomic, assign) BOOL isPhotoAlbum;//是否为影集跳转进来

@property (nonatomic, assign) BOOL isDrafts;//是否为草稿箱跳转进来


@end
