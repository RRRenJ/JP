//
//  JPCircleShapeLayer.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPCircleShapeLayer.h"

@interface JPCircleShapeLayer() {
    CGFloat startAngle;
    CGFloat endAngle;
}
@property (assign, nonatomic) double initialProgress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

- (void)setupLayer;
@end

@implementation JPCircleShapeLayer
@synthesize percent = _percent;

- (instancetype)initWithStartAngle:(CGFloat)start endAngle:(CGFloat)end {
    self = [super init];
    if (self) {
        startAngle = start;
        endAngle = end;
        self.lineWidth = 2;
        [self setupLayer];
    }
    return self;
}

- (instancetype)initWithLineWidth:(CGFloat)lineWidth
{
    if (self = [super init]) {
        startAngle = - M_PI * 0.5;
        endAngle = M_PI * 1.5;
        self.lineWidth = lineWidth;
        [self setupLayer];
    }
    return self;
}

- (void)layoutSublayers {
    
    self.path = [self drawPathWithArcCenter];
    self.progressLayer.path = [self drawPathWithArcCenter];
    [super layoutSublayers];
}

- (void)setupLayer {
    
    self.path = [self drawPathWithArcCenter];
    self.fillColor = [UIColor clearColor].CGColor;
    self.strokeColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:0.4f].CGColor;
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = [self drawPathWithArcCenter];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayer.lineWidth = 2;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineJoin = kCALineJoinRound;
    self.progressLayer.strokeStart = 0.0;
    self.progressLayer.strokeEnd = 0.0;
    [self addSublayer:self.progressLayer];
    
}

- (CGPathRef)drawPathWithArcCenter {
    
    CGFloat position_y = self.frame.size.height/2;
    CGFloat position_x = self.frame.size.width/2; // Assuming that width == height
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(position_x, position_y)
                                          radius:position_y
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES].CGPath;
}

- (void)dealloc
{
    
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    _initialProgress = [self calculatePercent:_currentTime toTime:_maxTime];
    _currentTime = currentTime;
    self.progressLayer.strokeEnd = self.percent;
    [self startAnimation];
}

- (void)updateViewWithProgress:(double)progress {
    _percent = progress;
    self.progressLayer.strokeEnd = self.percent;
}

- (void)updateNoAnimationWithProgress:(double)progress{
    self.progressLayer.strokeEnd = progress;
}

- (double)percent {

    _percent = [self calculatePercent:_currentTime toTime:_maxTime];
    return _percent;
}

- (void)setProgressColor:(UIColor *)progressColor {
    self.progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    self.strokeColor = tintColor.CGColor;
}

- (double)calculatePercent:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime {

    if ((toTime > 0) && (fromTime > 0)) {

        CGFloat progress = 0;

        progress = fromTime / toTime;

        if ((progress * 100) > 100) {
            progress = 1.0f;
        }
        return progress;
    }else
        return 0.0f;
}

- (void)startAnimation {
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue = @(self.initialProgress);
    pathAnimation.toValue = @(self.percent);
    pathAnimation.removedOnCompletion = YES;
    [self.progressLayer addAnimation:pathAnimation forKey:nil];
    
}

@end
