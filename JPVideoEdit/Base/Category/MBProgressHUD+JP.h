//
//  MBProgressHUD+JP.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/24.
//

#import <MBProgressHUD/MBProgressHUD.h>



@interface MBProgressHUD (JP)

+ (void)jp_showMessage:(NSString *)message;

+ (void)jp_showMessage:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)jp_showProgressMessage:(NSString *)message;

+ (MBProgressHUD *)jp_showProgressMessage:(NSString *)message toView:(UIView *)view;

+ (void)jp_hideHUD;

- (void)jp_hideHUD;

@end


