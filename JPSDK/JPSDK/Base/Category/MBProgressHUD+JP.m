//
//  MBProgressHUD+JP.m
//  JPSDK
//
//  Created by 任敬 on 2021/9/24.
//

#import "MBProgressHUD+JP.h"

@implementation MBProgressHUD (JP)

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(UIImage *)icon view:(UIView *)view{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = text;
    hud.label.font = [UIFont boldSystemFontOfSize:15];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    if (!([UIApplication sharedApplication].keyWindow)) {
        hud.offset = CGPointMake(0, -JP_NAVIGATION_HEIGHT);
    }
    hud.margin = 15;
    if (icon) {
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:icon];
        hud.minSize = CGSizeMake(160, 90);
    }
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0f];
}

/**
 显示信息
 @param message 信息内容
 */
+ (void)jp_showMessage:(NSString *)message{
    [self jp_showMessage:message toView:nil ];
}

+ (void)jp_showMessage:(NSString *)message toView:(UIView *)view{
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self hideHUDForView:view];
    [self show:message icon:nil view:view];
}


+ (MBProgressHUD *)jp_showProgressMessage:(NSString *)message{
    return [self jp_showProgressMessage:message toView:nil];
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)jp_showProgressMessage:(NSString *)message toView:(UIView *)view {
    
    if (!view){
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.text = message;
    hud.label.font = [UIFont boldSystemFontOfSize:15];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    if (!([UIApplication sharedApplication].keyWindow)) {
        hud.offset = CGPointMake(0, -JP_NAVIGATION_HEIGHT);
    }
    if (message.length > 0) {
        hud.minSize = CGSizeMake(180, 100);
    }
    hud.margin = 15;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}
/**
 *  手动关闭MBProgressHUD
 */
+ (void)jp_hideHUD{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self hideHUDForView:view animated:YES];
}


- (void)jp_hideHUD{
    [self hideAnimated:YES afterDelay:0.1];
}


@end
