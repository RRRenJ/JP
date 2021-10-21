//
//  JPRecordGuideView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/8/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPRecordGuideView.h"
#import "JPGradientAnimateGuideView.h"

#define VIDEO_SPEED_TAG   999
#define CAMARA_FLIP_TAG   1000
#define FILTER_SELECTED_TAG   1001
#define FLASH_LIGHT_TAG   1002
#define VIDEO_FRAME_TAG   1003

@interface JPRecordGuideView (){
    BOOL isAniamte;
}

- (void)removeViewWithTag:(int)tag withAnimation:(BOOL)animation;

@end

@implementation JPRecordGuideView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        CGFloat height = JPKShrinkStatusBarHeight;
//        CGFloat width = (SCREEN_WIDTH - 30) / 5.0;
//        if (![JPUtil getInfoFromUserDefaults:kRecordOfVideoSpeedGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(JPScreenFitFloat6(31), height, JPScreenFitFloat6(50), 60) andText:@"快慢速"];
//            view.centerX =15 + width / 2.0;
//            view.tag = VIDEO_SPEED_TAG;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kRecordOfCamaraFlipGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(JPScreenFitFloat6(95), height, JPScreenFitFloat6(80), 60) andText:@"翻转镜头"];
//            view.tag = CAMARA_FLIP_TAG;
//            view.centerX =15 + width / 2.0 + width;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kRecordOfFilterSelectedGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(JPScreenFitFloat6(175), height, JPScreenFitFloat6(50), 60) andText:@"滤镜"];
//            view.tag = FILTER_SELECTED_TAG;
//            view.centerX =15 + width / 2.0 + width * 2;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kRecordOfFlashLightSelectedGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(JPScreenFitFloat6(240), height, JPScreenFitFloat6(80), 60) andText:@"闪光灯"];
//            view.tag = FLASH_LIGHT_TAG;
//            view.centerX =15 + width / 2.0 + width * 3;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kRecordOfVideoFrameGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - JPScreenFitFloat6(74), height, JPScreenFitFloat6(100), 60) andText:@"选择画幅"];
//            view.centerX =15 + width / 2.0 + width * 4;
//            view.tag = VIDEO_FRAME_TAG;
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

- (void)startAnimation {
    isAniamte = YES;
    for (UIView *view in [self subviews]) {
        if ([JPGradientAnimateGuideView class]) {
            JPGradientAnimateGuideView *v = (JPGradientAnimateGuideView *)view;
            [v startAnimation];
        }
    }
}

- (BOOL)hasAnimate{
    return isAniamte;
}

- (void)removeGuide:(NSString *)str withAnimation:(BOOL)animation {
//    [JPSession sharedInstance].showRecordGuide = NO;
//    if ([str isEqualToString:kRecordOfVideoSpeedGuideStep] && ![JPUtil getInfoFromUserDefaults:kRecordOfVideoSpeedGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kRecordOfVideoSpeedGuideStep];
//        [self removeViewWithTag:VIDEO_SPEED_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kRecordOfCamaraFlipGuideStep] && ![JPUtil getInfoFromUserDefaults:kRecordOfCamaraFlipGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kRecordOfCamaraFlipGuideStep];
//        [self removeViewWithTag:CAMARA_FLIP_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kRecordOfFilterSelectedGuideStep] && ![JPUtil getInfoFromUserDefaults:kRecordOfFilterSelectedGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kRecordOfFilterSelectedGuideStep];
//        [self removeViewWithTag:FILTER_SELECTED_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kRecordOfFlashLightSelectedGuideStep] && ![JPUtil getInfoFromUserDefaults:kRecordOfFlashLightSelectedGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kRecordOfFlashLightSelectedGuideStep];
//        [self removeViewWithTag:FLASH_LIGHT_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kRecordOfVideoFrameGuideStep] && ![JPUtil getInfoFromUserDefaults:kRecordOfVideoFrameGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kRecordOfVideoFrameGuideStep];
//        [self removeViewWithTag:VIDEO_FRAME_TAG withAnimation:animation];
//        return;
//    }
}

@end
