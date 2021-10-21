//
//  JPNewImportViewController.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewImportViewController.h"
#import "JPNewSegementView.h"
#import "JPAblumSourceViewController.h"
#import "JPNewPageViewController.h"
#import "JPNextButton.h"
#import "JPVideoRecordProgressView.h"
#import "JPNewImportButton.h"
@interface JPNewImportViewController ()<JPAblumSourceViewControllerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet JPNewSegementView *segementView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) JPVideoRecordProgressView *progressView;
@property (nonatomic, strong) JPAblumSourceViewController *videoVC;
@property (nonatomic, strong) JPAblumSourceViewController *photoVC;
@property (nonatomic, strong) JPNewImportButton *importButton;
@property (nonatomic, strong) NSMutableArray *selectFileModels;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;

@property (nonatomic, assign) BOOL isDragging;

@end

@implementation JPNewImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigatorViewWithHeight:JPShrinkNavigationHeight];
    self.navagatorView.backgroundColor = [UIColor blackColor];
    [self addCustomTittleViewWithTittle:@"导入视频"];
    [self addPopButton];
    _contentViewTop.constant = JPShrinkNavigationHeight;
    if (_fromPackage) {
        self.importButton = [JPNewImportButton buttonWithType:UIButtonTypeCustom];
        [self.importButton setBackgroundColor:[UIColor clearColor]];
        CGFloat height = JPShrinkStatusBarHeight;
        self.importButton.frame = CGRectMake(JP_SCREEN_WIDTH - 120, height, 120, 44);
        [self.navagatorView addSubview:self.importButton];
        [self.importButton setupNumber:0];
        _selectFileModels = [NSMutableArray array];
        [_importButton addTarget:self action:@selector(finishSelectVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    self.progressView = [[JPVideoRecordProgressView alloc] init];
    self.progressView.frame = CGRectMake(0, 0, JP_SCREEN_WIDTH, 3);
    //self.progressView.hidden= YES;
    [self.navagatorView addSubview:self.progressView];
    self.progressView.sd_layout.topSpaceToView(self.navagatorView, 0).leftSpaceToView(self.navagatorView, 0).rightSpaceToView(self.navagatorView, 0).heightIs(3);
    self.segementView.titles = @[@"视频", @"照片"];
    [self.segementView addTarget:self action:@selector(didChangePage:) forControlEvents:UIControlEventValueChanged];
    self.videoVC = [self loadVCWithSourceType:JPAssetTypeVideo];
    self.photoVC = [self loadVCWithSourceType:JPAssetTypePhoto];
    self.scrollView.contentSize = CGSizeMake(JP_SCREEN_WIDTH * 2, 0);
    self.scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateVideoTimeProgress];
    BOOL show = [JPUtil showAlbumAuthorizationAlert];
    if (show) {
        [_videoVC showAVAuthAlertView];
        [_photoVC showAVAuthAlertView];
    } else {
        [_videoVC hiddenAVAuthAlertView];
        [_photoVC hiddenAVAuthAlertView];
    }
}

- (JPAblumSourceViewController *)loadVCWithSourceType:(JPAssetType)type
{
    JPAblumSourceViewController *ablumVC = [[JPAblumSourceViewController alloc] init];
    ablumVC.type = type;
    ablumVC.fromPackage = _fromPackage;
    ablumVC.recordInfo = _recordInfo;
    [self addChildViewController:ablumVC];
    [self.scrollView addSubview:ablumVC.view];
    ablumVC.view.sd_layout.topEqualToView(self.scrollView).bottomEqualToView(self.scrollView).widthIs(JP_SCREEN_WIDTH);
    if (type == JPAssetTypeVideo) {
        ablumVC.view.sd_layout.leftEqualToView(self.scrollView);
    }else{
        ablumVC.view.sd_layout.leftSpaceToView(self.scrollView, JP_SCREEN_WIDTH);
    }
    if (_fromPackage) {
        ablumVC.delegate = self;
    }
    ablumVC.baseNavigationController = self.navigationController;
    return ablumVC;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.isDragging) {
        return;
    }
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX / JP_SCREEN_WIDTH < 0.1 ) {
        if (self.segementView.cureenrIndex != 0) {
            [self.segementView setCurrentIndex:0];
            self.isDragging = NO;
        }

    }
    if (offsetX / JP_SCREEN_WIDTH > 0.9 ) {
        if (self.segementView.cureenrIndex != 1) {
            [self.segementView setCurrentIndex:1];
            self.isDragging = NO;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.isDragging = YES;
}


- (void)didChangePage:(JPNewSegementView *)segementview
{
    [self.view endEditing:YES];
    if (segementview.cureenrIndex == 0) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if(segementview.cureenrIndex == 1){
        if (self.photoVC == nil) {
            self.photoVC = [self loadVCWithSourceType:JPAssetTypePhoto];
        }
        [_scrollView setContentOffset:CGPointMake(JP_SCREEN_WIDTH, 0) animated:YES];
    }
}


- (void)setRecordInfo:(JPVideoRecordInfo *)recordInfo
{
    _recordInfo = recordInfo;

}

- (void)finishSelectVideo
{
    if (_selectFileModels.count == 0) {
        return;
    }
    [self ablumSourceViewControllerFinishAddWithVideoModel:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.recordInfo = _recordInfo;
//    if ([JPUtil getInfoFromUserDefaults:@"second-import"] == nil) {
//        NSArray *videoArr = _recordInfo.videoSource;
//        for (JPVideoModel *videoModel in videoArr) {
//            if (videoModel.sourceType != JPVideoSourceCamera) {
//                [self configuePromptViewWithView:self.leftButton andType:JPPromptViewTypeSecond andTopOffset:-5 andLeftOffset:8];
//                [self.promptView show];
//                [JPUtil saveIssueInfoToUserDefaults:@"second-import" resouceName:@"second-import"];
//                break;
//            }
//        }
//    }
    if (!_fromPackage) {
        if (_recordInfo.videoSource.count == 1 && _recordInfo.hasAddVideo == NO) {
            _recordInfo.hasAddVideo = YES;
            [self finishedEidt:nil];
        }
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark JPSelectVideosViewDelegate

- (void)selectVideosViewShouldDeleteVideoModel:(JPVideoModel *)videoModel{
    [_recordInfo deleteVideofile:videoModel];
    self.recordInfo = _recordInfo;
}

#pragma mark - 

- (void)finishedEidt:(id)sender {
    if (_fromPackage) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        JPNewPageViewController *trimVC = [[JPNewPageViewController alloc] initWithNibName:@"JPNewPageViewController" bundle:JPResourceBundle];
        trimVC.recordInfo = _recordInfo;
        trimVC.jp_cancelGesturesReturn = YES;
        [self.navigationController setViewControllers:@[trimVC] animated:YES];
    }
}


#pragma mark -- JPAblumSourceViewControllerDelegate

- (void)ablumSourceViewControllerDidSelectVideoModel:(JPLocalFileModel *)videoModel
{
    if ([self ablumSourceViewControllerIsSelectThisVideoModel:videoModel] == nil) {
        if (videoModel.videoModel.thumbImages == nil) {
            [videoModel.videoModel asyncGetAllThumbImages];
        }
        [_selectFileModels addObject:videoModel];
        videoModel.selectIndex = _selectFileModels.count;
        [_importButton setupNumber:_selectFileModels.count];
    }
    [self updateVideoTimeProgress];
 }

- (void)ablumSourceViewControllerDidDeselectVideoModel:(JPLocalFileModel *)videoModel
{
    JPLocalFileModel *fileModel = [self ablumSourceViewControllerIsSelectThisVideoModel:videoModel];
    if (fileModel) {
        NSInteger index = [_selectFileModels indexOfObject:fileModel];
        [_selectFileModels removeObject:fileModel];
        for (; index < _selectFileModels.count; index++) {
            JPLocalFileModel *sfileModel = _selectFileModels[index];
            sfileModel.selectIndex = index + 1;
        }
        [_importButton setupNumber:_selectFileModels.count];
    }
    [self updateVideoTimeProgress];
}

- (void)ablumSourceViewControllerFinishAddWithVideoModel:(JPVideoModel *)videoModel
{
    for (JPLocalFileModel * fileModel in _selectFileModels) {
        [_recordInfo addVideoFile:fileModel.videoModel];
    }
    if (videoModel) {
        [_recordInfo addVideoFile:videoModel];
    }
}


- (JPLocalFileModel *)ablumSourceViewControllerIsSelectThisVideoModel:(JPLocalFileModel *)videoModel
{
    JPLocalFileModel *fileModel = nil;
    for (JPLocalFileModel *localFileModel in _selectFileModels) {
        if ([localFileModel.localId isEqualToString:videoModel.localId]) {
            fileModel = localFileModel;
            break;
        }
    }
    return fileModel;
}

- (CMTime )ablumSourceViewControllerNeedGetResetTime
{
    CMTime restTime = CMTimeSubtract(_recordInfo.totalDuration, _recordInfo.currentTotalTime);
    for (JPLocalFileModel *localFileModel in _selectFileModels) {
        restTime = CMTimeSubtract(restTime, localFileModel.videoModel.timeRange.duration);
    }
    return restTime;

}


- (void)updateVideoTimeProgress
{
    CGFloat resetTime = CMTimeGetSeconds([self ablumSourceViewControllerNeedGetResetTime]);
    CGFloat progress = 1.0f - resetTime / 300.0f;
    if (progress > 1.0) {
        progress = 1.0;
    }
    if (_selectFileModels.count == 0 && _recordInfo.videoSource.count == 0) {
        self.progressView.hidden = YES;
    }else{
        self.progressView.hidden = NO;
    }
    [self.progressView changeProgress:progress];
}
@end
