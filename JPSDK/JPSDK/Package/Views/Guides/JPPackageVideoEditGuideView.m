//
//  JPPackageVideoEditGuideView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/8/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageVideoEditGuideView.h"
#import "JPGradientAnimateGuideView.h"

#define VIDEO_SPEED_TAG   999
#define TRANVERSE_VIDEO_TAG   1000
#define TRIM_VIDEO_TAG   1001
#define DELETE_VIDEO_TAG   1002

@interface  JPPackageVideoEditGuideView(){
    BOOL isAniamte;
    BOOL _isActive;
}

- (void)removeViewWithTag:(int)tag withAnimation:(BOOL)animation;

@end

@implementation JPPackageVideoEditGuideView

- (id)initWithFrame:(CGRect)frame andIsActive:(BOOL)isActive {
    self = [super initWithFrame:frame];
    if (self) {
        _isActive = isActive;
        CGFloat width = JP_SCREEN_WIDTH / 4.0;
        self.userInteractionEnabled = NO;
//        if (![JPUtil getInfoFromUserDefaults:kPackageOfVideoSpeedGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 40) andText:@"快慢速"];
//            view.centerX = width / 2.0;
//            view.tag = VIDEO_SPEED_TAG;
//            [self addSubview:view];
//        }
//        if ((![JPUtil getInfoFromUserDefaults:kPackageOfVideoTranverseGuideStep])    || isActive) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 40) andText:@"时间倒序" andIsActive:isActive];
//            view.tag = TRANVERSE_VIDEO_TAG;
//            view.centerX = width / 2.0 + width;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kPackageOfvideoTrimGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 40) andText:@"剪切"];
//            view.tag = TRIM_VIDEO_TAG;
//            view.centerX = width / 2.0 + width * 2;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kPackageOfVideoDeleteGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 40) andText:@"删除"];
//            view.tag = DELETE_VIDEO_TAG;
//            view.centerX = width / 2.0 + width * 3;
//            [self addSubview:view];
//        }
    }
    return self;
}

#pragma mark -

- (void)removeViewWithTag:(int)tag withAnimation:(BOOL)animation{
    JPGradientAnimateGuideView *v = [self viewWithTag:tag];
    if (v) {
        if (animation) {
            [UIView animateWithDuration:0.5 animations:^{
                v.alpha = 0.f;
            }completion:^(BOOL finish){
                [v removeFromSuperview];
                [self removeFromSuperview];
            }];
        } else {
            [v removeFromSuperview];
            [self removeFromSuperview];
        }
    }
    
}

- (BOOL)hasAnimate {
    return isAniamte;
}

- (void)startAnimation {
    isAniamte = YES;
    for (UIView *view in [self subviews]) {
        if ([JPGradientAnimateGuideView class]) {
            JPGradientAnimateGuideView *v = (JPGradientAnimateGuideView *)view;
            [v startAnimation];
        }
    }
}

- (void)removeGuide:(NSString *)str withAnimation:(BOOL)animation {
//    [JPSession sharedInstance].showPackageVdieoEditGuide = NO;
//    if ([str isEqualToString:kPackageOfVideoSpeedGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfVideoSpeedGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfVideoSpeedGuideStep];
//        [self removeViewWithTag:VIDEO_SPEED_TAG withAnimation:animation];
//        return;
//    }
//    if (([str isEqualToString:kPackageOfVideoTranverseGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfVideoTranverseGuideStep]) || _isActive) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfVideoTranverseGuideStep];
//        [self removeViewWithTag:TRANVERSE_VIDEO_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kPackageOfvideoTrimGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfvideoTrimGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfvideoTrimGuideStep];
//        [self removeViewWithTag:TRIM_VIDEO_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kPackageOfVideoDeleteGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfVideoDeleteGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfVideoDeleteGuideStep];
//        [self removeViewWithTag:DELETE_VIDEO_TAG withAnimation:animation];
//        return;
//    }
}

@end
