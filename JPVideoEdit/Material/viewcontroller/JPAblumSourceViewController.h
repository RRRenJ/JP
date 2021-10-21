//
//  JPAblumSourceViewController.h
//  jper
//
//  Created by FoundaoTEST on 2017/5/22.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPBaseViewController.h"
#import "JPLocalFileModel.h"

@protocol JPAblumSourceViewControllerDelegate <NSObject>

- (void)ablumSourceViewControllerDidSelectVideoModel:(JPLocalFileModel *)videoModel;
- (void)ablumSourceViewControllerDidDeselectVideoModel:(JPLocalFileModel *)videoModel;
- (void)ablumSourceViewControllerFinishAddWithVideoModel:(JPVideoModel *)videoModel;
- (JPLocalFileModel *)ablumSourceViewControllerIsSelectThisVideoModel:(JPLocalFileModel *)videoModel;
- (CMTime)ablumSourceViewControllerNeedGetResetTime;

@end


@interface JPAblumSourceViewController : JPBaseViewController
@property (nonatomic) JPAssetType type;
@property (nonatomic, strong) JPVideoRecordInfo *recordInfo;
@property (nonatomic, weak) UINavigationController *baseNavigationController;
@property (nonatomic, assign) BOOL fromPackage;
@property (nonatomic, weak) id<JPAblumSourceViewControllerDelegate> delegate;
@property (nonatomic, assign) CMTime minTime;
- (void)showAVAuthAlertView;

- (void)hiddenAVAuthAlertView;
@property (nonatomic, assign) BOOL isTempalte;
@property (nonatomic, copy) void(^templateSelectBlock)(JPVideoModel *videoModel);
@end
