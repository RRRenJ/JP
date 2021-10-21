//
//  JPPackageGuideView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/8/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageGuideView.h"
#import "JPGradientAnimateGuideView.h"

#define FILTER_SELECTED_TAG   999
#define ADD_PATTERN_TAG   1000
#define ADD_MUSIC_TAG   1001

@interface  JPPackageGuideView(){
    BOOL isAniamte;
}

- (void)removeViewWithTag:(int)tag withAnimation:(BOOL)animation;

@end

@implementation JPPackageGuideView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        CGFloat width = SCREEN_WIDTH / 3.0;
//        if (![JPUtil getInfoFromUserDefaults:kPackageOfFilterSelectedGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 60) andText:@"滤镜"];
//            view.tag = FILTER_SELECTED_TAG;
//            view.centerX = width / 2.0;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kPackageOfAddPatternGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 60) andText:@"图案"];
//            view.centerX = width / 2.0 + width;
//            view.tag = ADD_PATTERN_TAG;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kPackageOfAddMusicGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 60) andText:@"音乐"];
//            view.centerX = width / 2.0 + width * 2;
//            view.tag = ADD_MUSIC_TAG;
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
//    [JPSession sharedInstance].showPackageGuide = NO;
//    if ([str isEqualToString:kPackageOfAddPatternGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfAddPatternGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfAddPatternGuideStep];
//        [self removeViewWithTag:ADD_PATTERN_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kPackageOfAddMusicGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfAddMusicGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfAddMusicGuideStep];
//        [self removeViewWithTag:ADD_MUSIC_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kPackageOfFilterSelectedGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfFilterSelectedGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfFilterSelectedGuideStep];
//        [self removeViewWithTag:FILTER_SELECTED_TAG withAnimation:animation];
//        return;
//    }
}

@end
