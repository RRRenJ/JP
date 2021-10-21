//
//  JPVideoClipViewController.h
//  jper
//
//  Created by FoundaoTEST on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JPVideoClipViewControllerDelegate <NSObject>

- (void)didFinishedClipVideoModel:(JPVideoModel *)videoModel;

@end
@interface JPVideoClipViewController :JPBaseViewController
@property (nonatomic, strong) JPVideoModel *videoModel;
@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;
@property (nonatomic, weak) id<JPVideoClipViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isSecondStep;
@property (nonatomic, assign) NSInteger videoIndex;
@property (nonatomic, assign) BOOL fromPackage;
@property (nonatomic, assign) BOOL fromThirdApp;
@property (nonatomic, assign) CMTime totalVideoTime;
@end
