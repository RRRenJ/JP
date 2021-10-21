//
//  UIViewController+JP.m
//  JPSDK
//
//  Created by 任敬 on 2021/9/24.
//

#import "UIViewController+JP.h"
#import <objc/runtime.h>

static char const * const JPUIViewControllerHUDKey = "JPUIViewControllerHUDKey";
static char const * const jp_cancelGesturesReturnKey = "jpsupportGesturesReturnKey";
static char const * const jp_cancelReturnButtonKey = "jpcancelReturnButtonKey";

@interface UIViewController ()

@property (nonatomic, strong) MBProgressHUD * hudView;

@end


@implementation UIViewController (JP)


- (BOOL)jp_cancelGesturesReturn{
    return [objc_getAssociatedObject(self, jp_cancelGesturesReturnKey) boolValue];
}

- (void)setJp_cancelGesturesReturn:(BOOL)jp_cancelGesturesReturn{
    objc_setAssociatedObject(self, jp_cancelGesturesReturnKey,@(jp_cancelGesturesReturn), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)jp_cancelReturnButton{
    return [objc_getAssociatedObject(self, jp_cancelReturnButtonKey) boolValue];
}

- (void)setJp_cancelReturnButton:(BOOL)jp_cancelReturnButton{
    objc_setAssociatedObject(self, jp_cancelReturnButtonKey,@(jp_cancelReturnButton), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationController*)jp_myNavigationController{
    UINavigationController* nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    }
    else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            nav = ((UITabBarController*)self).selectedViewController.jp_myNavigationController;
        }
        else {
            nav = self.navigationController;
        }
    }
    return nav;
}



- (MBProgressHUD *)hudView{
    return objc_getAssociatedObject(self, JPUIViewControllerHUDKey);
}

- (void)setHudView:(MBProgressHUD *)hudView{
    objc_setAssociatedObject(self, JPUIViewControllerHUDKey, hudView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jp_showHUD{

    if (!self.hudView) {
        self.hudView = [MBProgressHUD jp_showProgressMessage:nil];
    }
    
}

- (void)jp_hideHUD{
    if (self.hudView) {
        [self.hudView jp_hideHUD];
    }
}

@end
