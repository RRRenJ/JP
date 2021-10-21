//
//  JPCircleShapeLayer.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface JPCircleShapeLayer : CAShapeLayer
@property (assign, nonatomic, readonly) double percent;
@property (nonatomic) UIColor *progressColor;
@property (nonatomic) UIColor *tintColor;
@property (nonatomic) NSTimeInterval currentTime;
@property (nonatomic) NSTimeInterval maxTime;

- (instancetype)initWithStartAngle:(CGFloat)start endAngle:(CGFloat)end;

- (instancetype)initWithLineWidth:(CGFloat)lineWidth;

- (void)updateViewWithProgress:(double)progress;

- (void)updateNoAnimationWithProgress:(double)progress;

@end
