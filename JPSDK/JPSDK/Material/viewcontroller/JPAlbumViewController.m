//
//  JPAlbumViewController.m
//  jper
//
//  Created by FoundaoTEST on 2017/5/22.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPAlbumViewController.h"
#import "JPAblumSourceViewController.h"
#import "JPAlertView.h"
@interface JPAlbumViewController () {
    JPAlertView *avauthAlertView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewOriginX;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) JPAblumSourceViewController *videoVC;
@property (nonatomic, strong) JPAblumSourceViewController *photoVC;

@end

@implementation JPAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigatorViewWithHeight:JPShrinkNavigationHeight];
    [self addCustomTittleViewWithTittle:@"本地相机"];
    [self addPopButton];
    self.view.backgroundColor = [UIColor jp_colorWithHexString:@"0b0b0b"];
    _lineViewOriginX.constant = JP_SCREEN_WIDTH / 4.0 - 12.5;
    self.videoVC = [self loadVCWithSourceType:JPAssetTypeVideo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [avauthAlertView removeFromSuperviewAndClearAutoLayoutSettings];
    BOOL show = [JPUtil showAlbumAuthorizationAlert];
    if (show) {
        if (!avauthAlertView) {
            NSString *str = @"让大家看看手机里的精美素材吧~请在「设置」-「隐私」-「照片」中打开未来拍客的本地图库获取权限";
            avauthAlertView = [[JPAlertView alloc] initWithTitle:str
                                                        andFrame:CGRectMake(0, 0, JP_SCREEN_WIDTH, JP_SCREEN_WIDTH)];
        }
        [self.view addSubview:avauthAlertView];
        avauthAlertView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(JP_SCREEN_WIDTH).heightIs(JP_SCREEN_WIDTH);
    }
}



- (JPAblumSourceViewController *)loadVCWithSourceType:(JPAssetType)type
{
    JPAblumSourceViewController *ablumVC = [[JPAblumSourceViewController alloc] init];
    ablumVC.type = type;
    ablumVC.recordInfo = _recordInfo;
    [self addChildViewController:ablumVC];
    [_containerView addSubview:ablumVC.view];
    ablumVC.view.sd_layout.topEqualToView(_containerView).bottomEqualToView(_containerView).widthIs(JP_SCREEN_WIDTH);
    if (type == JPAssetTypeVideo) {
        ablumVC.view.sd_layout.leftEqualToView(_containerView);
    }else{
        ablumVC.view.sd_layout.rightEqualToView(_containerView);
    }
    ablumVC.baseNavigationController = self.navigationController;
    return ablumVC;
}
- (IBAction)switchSourceAction:(id)sender {
    CGFloat originX = JP_SCREEN_WIDTH / 4.0 - 12.5;
    if (sender == self.videoButton) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        if (self.photoVC == nil) {
            self.photoVC = [self loadVCWithSourceType:JPAssetTypePhoto];
        }
        [_scrollView setContentOffset:CGPointMake(JP_SCREEN_WIDTH, 0) animated:YES];
        originX = JP_SCREEN_WIDTH / 4.0 - 12.5 + JP_SCREEN_WIDTH / 2.0;
    }
    [UIView animateWithDuration:0.2 animations:^{
        
        _lineViewOriginX.constant = originX;
        [self.videoButton.superview layoutIfNeeded];
    }];
}


- (void)dealloc
{
    
}
@end
