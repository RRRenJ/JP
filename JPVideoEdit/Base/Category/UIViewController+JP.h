//
//  UIViewController+JP.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/24.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (JP)
// navigation
@property (nonatomic, assign, readwrite) BOOL jp_cancelGesturesReturn;
@property (nonatomic, assign, readwrite) BOOL jp_cancelReturnButton;
@property(nonatomic,strong,readonly)UINavigationController * jp_myNavigationController;

//hud
- (void)jp_showHUD;
- (void)jp_hideHUD;



@end

NS_ASSUME_NONNULL_END
