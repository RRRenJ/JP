//
//  JPPackagePhotoEditGuideView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/8/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackagePhotoEditGuideView.h"
#import "JPGradientAnimateGuideView.h"
//#import "JPSession.h"

#define REDUCE_PHOTO_TAG   999
#define ENLARGE_PHOTO_TAG   1000
#define DELETE_PHOTO_TAG   1001

@interface  JPPackagePhotoEditGuideView(){
    BOOL isAniamte;
}

- (void)removeViewWithTag:(int)tag withAnimation:(BOOL)animation;

@end

@implementation JPPackagePhotoEditGuideView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = JP_SCREEN_WIDTH / 3.0;
//        if (![JPUtil getInfoFromUserDefaults:kPackageOfReducePhotoGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 60) andText:@"缩小"];
//            view.centerX = width / 2.0;
//            view.tag = REDUCE_PHOTO_TAG;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kPackageOfEnlargePhotoGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 60) andText:@"放大"];
//            view.tag = ENLARGE_PHOTO_TAG;
//            view.centerX = width / 2.0 + width;
//            [self addSubview:view];
//        }
//        if (![JPUtil getInfoFromUserDefaults:kPackageOfPhotoDeleteGuideStep]) {
//            JPGradientAnimateGuideView *view = [[JPGradientAnimateGuideView alloc] initWithFrame:CGRectMake(0, 0, width, 60) andText:@"删除"];
//            view.tag = DELETE_PHOTO_TAG;
//            view.centerX = width / 2.0 + width * 2;
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

- (BOOL)hasAnimate {
    return isAniamte;
}

- (void)removeGuide:(NSString *)str withAnimation:(BOOL)animation {
//    [JPSession sharedInstance].showPackagePhotoEditGuide = NO;
//    if ([str isEqualToString:kPackageOfReducePhotoGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfReducePhotoGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfReducePhotoGuideStep];
//        [self removeViewWithTag:REDUCE_PHOTO_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kPackageOfEnlargePhotoGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfEnlargePhotoGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfEnlargePhotoGuideStep];
//        [self removeViewWithTag:ENLARGE_PHOTO_TAG withAnimation:animation];
//        return;
//    }
//    if ([str isEqualToString:kPackageOfPhotoDeleteGuideStep] && ![JPUtil getInfoFromUserDefaults:kPackageOfPhotoDeleteGuideStep]) {
//        [JPUtil saveIssueInfoToUserDefaults:[NSNumber numberWithBool:YES] resouceName:kPackageOfPhotoDeleteGuideStep];
//        [self removeViewWithTag:DELETE_PHOTO_TAG withAnimation:animation];
//        return;
//    }
}

@end
