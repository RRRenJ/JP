//
//  JPBaseViewController.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/23.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPBaseViewController.h"
#import "JPUtil.h"
#import "JFRecordTitleView.h"
#import "JPHotListTitleView.h"
#import "UIImageView+WebCache.h"

@class JPHotListViewController;
static NSDictionary *JP_PAGE_KEY_VALUE;

@interface JPBaseViewController ()<JFRecordTitleViewDelegate>

@property (nonatomic,strong) JPHotListTitleView *titleView;

@end

@implementation JPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (JP_PAGE_KEY_VALUE == nil) {
        JP_PAGE_KEY_VALUE = @{@"JPNewCameraViewController":@"录制",
                              @"JPNewImportViewController":@"本地导入",
                              @"JPMediaStorageSearchController":@"媒资搜索",
                              @"JPTrimViewController":@"第二步首页",
                              @"JPPackageViewController":@"包装首页",
                              @"JPNewShareViewController":@"分享页",
                              @"JPHotListViewController":@"热门列表页",
                              @"JPSettingViewController":@"设置页首页"
                              };
    }
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_hasRegistAppStatusNotification) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeBackgound) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    //控制显示还是隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self statisticalPageWithStart:YES];
}



- (void)statisticalPageWithStart:(BOOL)isStart
{
    NSString *className  = NSStringFromClass([self class]);
    NSString *page = JP_PAGE_KEY_VALUE[className];
    if (page) {
       
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self statisticalPageWithStart:NO];
    [self.promptView dismiss];
    self.promptView = nil;
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_hasRegistAppStatusNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

- (BOOL)__shouldAutorotate{
    return NO;
}

- (NSUInteger)__supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


- (void)appBecomeActive
{
    NSLog(@"进入前台");
}

- (void)appBecomeBackgound
{
    NSLog(@"进入后台");
    
}

- (UINavigationController *)navigationController
{
    if (_tabNavigationController != nil) {
        return _tabNavigationController;
    }else{
        return [super navigationController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeDisk completion:nil];
}

#pragma  mark - public methods




//- (UIViewController *)viewController {
//    for (UIView* next = [self.navagatorView superview]; next; next = next.superview) {
//        UIResponder *nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)nextResponder;
//        }
//    }
//    return nil;
//}

- (void)createNavigatorViewWithHeight:(CGFloat)height {
    if (!self.navagatorView) {
        self.navagatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JP_SCREEN_WIDTH, height)];
        self.navagatorView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:self.navagatorView];
        self.navagatorView.sd_layout.widthRatioToView(self.view, 1.0);
        self.navagatorView.sd_layout.heightIs(height);
        self.navagatorView.sd_layout.rightEqualToView(self.view);
        self.navagatorView.sd_layout.topEqualToView(self.view);
    }
}


- (void)createHaveStatuBarNavigatorViewWithHeight:(CGFloat)height {
    if (!self.navagatorView) {
        [self createNavigatorViewWithHeight:height];
        self.navagatorView.backgroundColor = self.view.backgroundColor;
    }
}

- (void)addDismissButton {
    if (self.navagatorView && !self.leftButton) {
        CGRect frame = CGRectMake(JPScreenFitFloat6(3), self.navagatorView.height - JPShrinkOnlyNavigationHeight, JPScreenFitFloat6(40), JPShrinkOnlyNavigationHeight);
        
        self.leftButton = [JPUtil createCustomButtonWithTittle:nil
                                                     withImage:[UIImage imageNamed:@"esc"]
                                                     withFrame:frame
                                                        target:self
                                                        action:@selector(dismiss:)];
        [self.navagatorView addSubview:self.leftButton];
        self.leftButton.sd_layout.leftEqualToView(self.navagatorView);
        self.leftButton.sd_layout.bottomEqualToView(self.navagatorView);
        self.leftButton.sd_layout.widthIs(45);
        self.leftButton.sd_layout.heightIs(44.0f);

    }
}

- (void)addPopButton {
    if (self.navagatorView && !self.leftButton) {
        CGRect frame = CGRectMake(0, self.navagatorView.height - JPShrinkOnlyNavigationHeight, JPScreenFitFloat6(40), JPShrinkOnlyNavigationHeight);
        
        self.leftButton = [JPUtil createCustomButtonWithTittle:nil
                                                     withImage:[UIImage imageNamed:@"white-back"]
                                                     withFrame:frame
                                                        target:self
                                                        action:@selector(pop:)];
        [self.navagatorView addSubview:self.leftButton];
        self.leftButton.sd_layout.leftEqualToView(self.navagatorView);
        self.leftButton.sd_layout.bottomEqualToView(self.navagatorView);
        self.leftButton.sd_layout.widthIs(45);
        self.leftButton.sd_layout.heightIs(44.0f);
    }
}

- (void)addCustomTittleViewWithTittle:(NSString *)tittle {
    if(self.titleLabel){
        self.titleLabel.text = tittle;
        return;
    }
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((JP_SCREEN_WIDTH - JPScreenFitFloat6(200))/2.f, 0, JPScreenFitFloat6(200), JPScreenFitFloat6(20))];
    self.titleLabel.font = [UIFont titleFont];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.centerY = self.leftButton.centerY;
    self.titleLabel.text = tittle;
    [self.navagatorView addSubview:self.titleLabel];
    self.titleLabel.sd_layout.centerXEqualToView(self.navagatorView);
    self.titleLabel.sd_layout.bottomEqualToView(self.navagatorView);
    self.titleLabel.sd_layout.heightIs(44.0f);
    self.titleLabel.sd_layout.widthIs(200);
}

- (void)addCustomTittleViewWithImage:(UIImage *)image {
    if (!image || !self.navagatorView) {
        return;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.centerY = self.leftButton.centerY;
    imageView.image = image;
    [self.navagatorView addSubview:imageView];
    
    imageView.sd_layout.centerXEqualToView(self.navagatorView);
    if (self.leftButton) {
        imageView.sd_layout.centerYEqualToView(self.leftButton);
    } else if(self.rightButton) {
        imageView.sd_layout.centerYEqualToView(self.rightButton);
    } else {
        imageView.sd_layout.centerYEqualToView(self.navagatorView);
    }
    imageView.sd_layout.heightIs(image.size.height);
    imageView.sd_layout.widthIs(image.size.width);
    [imageView sizeToFit];
}

- (void)addCustomTittleViewWithStep:(JPVideoEditStep)step {
    if (!self.navagatorView) {
        return;
    }
    
    JFRecordTitleView* titleView = [[JFRecordTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleView.delegate = self;
    [self.navagatorView addSubview:titleView];
    titleView.sd_layout.widthIs(100);
    titleView.sd_layout.heightIs(44.0f);
    titleView.sd_layout.centerXEqualToView(_navagatorView);
    titleView.sd_layout.centerYEqualToView(_navagatorView);
    titleView.step = step;

}

- (void)addHostListTitleViewWithDate:(NSString *)dateStr {
    if (!self.navagatorView) {
        return;
    }
    if (self.titleView) {
        _titleView.dateStr = dateStr;
        return;
    }
    _titleView = [[JPHotListTitleView alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
    [self.navagatorView addSubview:self.titleView];
    _titleView.sd_layout.widthIs(100);
    _titleView.sd_layout.heightIs(44.0f);
    _titleView.sd_layout.centerXEqualToView(_navagatorView);
    _titleView.sd_layout.bottomEqualToView(_navagatorView);
    _titleView.dateStr = dateStr;
}

- (void)addLeftButtonWithTittle:(NSString *)tittle
                      withImage:(UIImage *)image
                         target:(id)target
                         action:(SEL)action{
    if (!self.navagatorView || self.leftButton) {
        return;
    }
    CGRect frame = CGRectMake(0, self.navagatorView.height - JPShrinkOnlyNavigationHeight, JPScreenFitFloat6(40), JPShrinkOnlyNavigationHeight);
    
    self.leftButton = [JPUtil createCustomButtonWithTittle:tittle
                                                 withImage:image
                                                 withFrame:frame
                                                    target:target
                                                    action:action];
    [self.navagatorView addSubview:self.leftButton];
    self.leftButton.sd_layout.leftEqualToView(self.navagatorView);
    self.leftButton.sd_layout.bottomEqualToView(self.navagatorView);
    self.leftButton.sd_layout.widthIs(45);
    self.leftButton.sd_layout.heightIs(44.0f);

    
}

- (void)addRightButtonWithTittle:(NSString *)tittle
                       withImage:(UIImage *)image
                          target:(id)target
                          action:(SEL)action{
    if (!self.navagatorView || self.rightButton) {
        return;
    }
    CGRect frame = CGRectMake(JP_SCREEN_WIDTH - JPScreenFitFloat6(60), self.navagatorView.height - JPShrinkOnlyNavigationHeight, JPScreenFitFloat6(60), JPShrinkOnlyNavigationHeight);
    
    self.rightButton = [JPUtil createCustomButtonWithTittle:tittle
                                                  withImage:image
                                                  withFrame:frame
                                                     target:target
                                                     action:action];
    [self.navagatorView addSubview:self.rightButton];
    self.rightButton.sd_layout.rightSpaceToView(self.navagatorView, 5);
    self.rightButton.sd_layout.bottomEqualToView(self.navagatorView);
    self.rightButton.sd_layout.widthIs(45);
    self.rightButton.sd_layout.heightIs(44.0f);
}

#pragma mark - actions 

- (void)pop:(id)sender {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)recordTitleViewNeedShowStep
{
    [self showSetp];
}

- (void)showSetp
{
    
}


- (void)configuePromptViewWithView:(UIView *)view andType:(JPPromptViewType)type andTopOffset:(CGFloat)topOffset andLeftOffset:(CGFloat)leftOffset andSuperView:(UIView *)superView
{
    [_promptView removeFromSuperview];
    _promptView = nil;
    if (_promptView == nil) {
        _promptView = [[JPPromptView alloc] initWithView:view andType:type andSuperView:superView andTopOffset:topOffset andLeftOffset:leftOffset];
    }

}

- (void)configuePromptViewWithView:(UIView *)view andType:(JPPromptViewType)type andTopOffset:(CGFloat)topOffset andLeftOffset:(CGFloat)leftOffset
{
    [self configuePromptViewWithView:view andType:type andTopOffset:topOffset andLeftOffset:leftOffset andSuperView:self.view];
}

- (void)destruction
{
    
}

- (void)getCameraAndAudioAuthorized:(void (^)(BOOL))completion andTips:(BOOL)tips {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusAuthorized){
        AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if(auth == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(granted);
                });
                if (!granted && tips) {
                    [self alertTitle:@"权限提醒" andMessage:@"需要您开启麦克风权限进行拍摄视频" comfireTitle:@"设置" cancelTitle:@"取消" comfireCompltion:^{
                        [self updateAppAuthorized];
                    } cancelCompletion:nil];
                }
            }];
        } else if(AVAuthorizationStatusAuthorized != auth){
            if (tips) {
                [self alertTitle:@"权限提醒" andMessage:@"需要您开启麦克风权限进行拍摄视频" comfireTitle:@"设置" cancelTitle:@"取消" comfireCompltion:^{
                    [self updateAppAuthorized];
                } cancelCompletion:nil];
            }
        } else {
            completion(YES);
        }
    }else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted && tips) {
                completion(NO);
                [self alertTitle:@"权限提醒" andMessage:@"需要您开启摄像头权限进行拍摄视频" comfireTitle:@"设置" cancelTitle:@"取消" comfireCompltion:^{
                    [self updateAppAuthorized];
                } cancelCompletion:nil];
            }else {
                NSLog(@"！！！特殊情况");
            }
        }];
    }else{
        completion(NO);
        if (tips) {
            [self alertTitle:@"权限提醒" andMessage:@"需要您开启摄像头权限进行拍摄视频" comfireTitle:@"设置" cancelTitle:@"取消" comfireCompltion:^{
                [self updateAppAuthorized];
            } cancelCompletion:nil];
        }
    }
}

- (void)alertTitle:(NSString *)title andMessage:(NSString *)msg comfireTitle:(NSString *)comfireTitle cancelTitle:(NSString *)cancelTitle comfireCompltion:(void (^)(void))comfireAction cancelCompletion:(void (^)(void))cancelCompletion {
    [NSThread jp_asyncSafeInMainQueue:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelCompletion) {
                cancelCompletion();
            }
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:comfireTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (comfireAction) {
                comfireAction();
            }
        }];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)updateAppAuthorized {
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
       [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:^(BOOL success) {
           
       }];
}

@end
