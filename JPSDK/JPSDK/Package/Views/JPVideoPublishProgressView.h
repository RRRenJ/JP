//
//  JPVideoPublishProgressView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/5/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPVideoPublishProgressView : UIView

@property (nonatomic, strong) UIColor *lineColor;
- (instancetype)initWithFrame:(CGRect)frame withStartAngle:(CGFloat)start endAngle:(CGFloat)end;

- (void)updateViewWithProgress:(double)progress;

- (void)updateViewWithPercentageProgress:(double)progress;

- (void)hideProgerssLb;

- (void)changeProgessColorWithColor:(UIColor *)color andTintColor:(UIColor *)tintColor;

@end
