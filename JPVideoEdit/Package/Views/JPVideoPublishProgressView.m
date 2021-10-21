//
//  JPVideoPublishProgressView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/5/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPVideoPublishProgressView.h"
#import "JPCircleShapeLayer.h"

@interface JPVideoPublishProgressView () {
    JPCircleShapeLayer *progressShapeLayer;
    UILabel *timeLb;
}
@end

@implementation JPVideoPublishProgressView

- (instancetype)initWithFrame:(CGRect)frame withStartAngle:(CGFloat)start endAngle:(CGFloat)end {
    self = [super initWithFrame:frame];
    if (self) {
        timeLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        timeLb.font = [UIFont jp_placardMTStdCondBoldFontWithSize:24];
        timeLb.textColor = [UIColor whiteColor];
        timeLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLb];
        
        progressShapeLayer = [[JPCircleShapeLayer alloc] initWithStartAngle:start endAngle:end];
        progressShapeLayer.frame = self.bounds;
        progressShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        progressShapeLayer.tintColor = [UIColor clearColor];
        progressShapeLayer.progressColor = [UIColor whiteColor];
        [self.layer addSublayer:progressShapeLayer];
    }
    return self;
}

#pragma mark - public methods

- (void)updateViewWithProgress:(double)progress {
    progressShapeLayer.maxTime = 100;
    progressShapeLayer.currentTime = progress*100;
    if (!timeLb.hidden) {
        timeLb.text = [NSString stringWithFormat:@"%d",(int)floor(progress*100)];
    }
}

- (void)updateViewWithPercentageProgress:(double)progress {
    progressShapeLayer.maxTime = 100;
    progressShapeLayer.currentTime = progress*100;
    if (!timeLb.hidden) {
        timeLb.text = [NSString stringWithFormat:@"%d%%",(int)floor(progress*100)];
    }
}

- (void)changeProgessColorWithColor:(UIColor *)color andTintColor:(UIColor *)tintColor {
    progressShapeLayer.progressColor = color;
    progressShapeLayer.tintColor = tintColor;
}

- (void)hideProgerssLb {
    timeLb.hidden = YES;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    progressShapeLayer.progressColor = lineColor;
}
@end
