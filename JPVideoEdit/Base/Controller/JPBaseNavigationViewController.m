//
//  JPBaseNavigationViewController.m
//  jper
//
//  Created by FoundaoTEST on 2017/3/20.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPBaseNavigationViewController.h"
#import "JPBaseViewController.h"

@interface JPBaseNavigationViewController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation JPBaseNavigationViewController

+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.tintColor = [UIColor jp_colorWithHexString:@"#353535"];
    navBar.barTintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor jp_colorWithHexString:@"#333333"],
        NSFontAttributeName : [UIFont jp_pingFangWithSize:17 weight:UIFontWeightMedium]};
    //设置透明的背景图，便于识别底部线条有没有被隐藏
    [navBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    //此处使底部线条失效
    [navBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    //设置导航栏透明度
    self.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationControllerdidRotate:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)navigationControllerdidRotate:(NSNotification *)noti {
    
    if (self.navigationBarHidden) {
        return;
    }
    UIInterfaceOrientation stateBarcurrentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (stateBarcurrentOrientation != UIInterfaceOrientationLandscapeLeft && stateBarcurrentOrientation != UIInterfaceOrientationLandscapeRight) {
        //如果屏幕方向 变为竖屏了 重置下导航栏的frame
        CGRect windowFrame = UIScreen.mainScreen.bounds;
        self.navigationBar.frame = CGRectMake(0, 20, windowFrame.size.width, JP_NAVIGATION_HEIGHT - 20);
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count >= 1) {
        [self setupViewController:viewController];
    }
}

- (void)setupViewController:(UIViewController *)viewController
{
//    if (viewController && viewController.cancelReturnButton == NO) {
//        viewController.hidesBottomBarWhenPushed = YES;
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"white-back"] style:UIBarButtonItemStyleDone target:self action:@selector(popAction)];
//    }
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    for (NSInteger index = 1; index < self.viewControllers.count; index ++) {
        JPBaseViewController *baseVC = self.viewControllers[index];
        if ([baseVC isKindOfClass:[JPBaseViewController class]]) {
            [baseVC destruction];
        }
    }
    return [super popToRootViewControllerAnimated:YES];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSInteger targetIndex = [self.viewControllers indexOfObject:viewController];
    for (NSInteger index = (targetIndex + 1); index < self.viewControllers.count; index ++) {
        JPBaseViewController *baseVC = self.viewControllers[index];
        if ([baseVC isKindOfClass:[JPBaseViewController class]]) {
            [baseVC destruction];
        }
    }
    return [super popToViewController:viewController animated:YES];
}

- (void)popAction {
    [self popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate {

    return [((JPBaseViewController *)self.topViewController) __shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    UIInterfaceOrientationMask ori = [((JPBaseViewController *)self.topViewController) __supportedInterfaceOrientations];
    return ori;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

@end
