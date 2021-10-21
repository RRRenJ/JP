//
//  JPBaseViewController.h
//  jper
//
//  Created by 藩 亜玲 on 2017/3/23.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPromptView.h"

@interface JPBaseViewController : UIViewController

@property (nonatomic, assign) BOOL hasRegistAppStatusNotification;

@property (nonatomic,strong) UIView *navagatorView;

@property (nonatomic,strong) UIButton *leftButton;

@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,strong) UINavigationController *tabNavigationController;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic, strong) JPPromptView *promptView;

- (void)configuePromptViewWithView:(UIView *)view andType:(JPPromptViewType)type andTopOffset:(CGFloat)topOffset andLeftOffset:(CGFloat)leftOffset;
- (void)configuePromptViewWithView:(UIView *)view andType:(JPPromptViewType)type andTopOffset:(CGFloat)topOffset andLeftOffset:(CGFloat)leftOffset andSuperView:(UIView *)superView;

/**
 *  创建导航栏(有状态栏)
 *  @param  height 导航栏高度
 */
- (void)createHaveStatuBarNavigatorViewWithHeight:(CGFloat)height;

/**
 *  创建导航栏
 *  @param  height 导航栏高度
 */
- (void)createNavigatorViewWithHeight:(CGFloat)height;

/**
 * 添加以dismiss方式关闭的返回按钮
 */
- (void)addDismissButton;

/**
 * 添加以pop方式关闭的返回按钮
 */
- (void)addPopButton;

/**
 *  设置导航栏tittle view
 *  @param  tittle 显示文字
 */
- (void)addCustomTittleViewWithTittle:(NSString *)tittle;

/**
 *  设置导航栏tittle view
 *  @param  step 步骤
 */
- (void)addCustomTittleViewWithStep:(JPVideoEditStep)step;

/**
 *  设置导航栏tittle view
 *  @param  dateStr 显示日期
 */
- (void)addHostListTitleViewWithDate:(NSString *)dateStr;

/**
 *  设置导航栏tittle view
 *  @param  image 显示图片
 */
- (void)addCustomTittleViewWithImage:(UIImage *)image;

/**
 *  自定义导航栏左边按钮
 *  @param  tittle 按钮显示文字
 *  @param  image 按钮图片
 *  @param  target 目标对象
 *  @param  action 执行动作
 */
- (void)addLeftButtonWithTittle:(NSString *)tittle
                      withImage:(UIImage *)image
                         target:(id)target
                         action:(SEL)action;

/**
 *  自定义导航栏右边按钮
 *  @param  tittle 按钮显示文字
 *  @param  image 按钮图片
 *  @param  target 目标对象
 *  @param  action 执行动作
 */
- (void)addRightButtonWithTittle:(NSString *)tittle
                      withImage:(UIImage *)image
                         target:(id)target
                         action:(SEL)action;

- (void)appBecomeBackgound;
- (void)appBecomeActive;
- (BOOL)__shouldAutorotate;
- (NSUInteger)__supportedInterfaceOrientations;
- (void)showSetp;
- (void)destruction;

- (void)getCameraAndAudioAuthorized:(void (^)(BOOL))completion andTips:(BOOL)tips;

@end
