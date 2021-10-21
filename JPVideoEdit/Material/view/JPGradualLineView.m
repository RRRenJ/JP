//
//  JPGradualLineView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/8/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPGradualLineView.h"

@interface JPGradualLineView ()<CAAnimationDelegate>{
    CABasicAnimation *moveAnimation;
}

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIBezierPath *path;
@end

@implementation JPGradualLineView

- (instancetype)initWithFrame:(CGRect )frame{
    if ([super initWithFrame:frame]){
        _path = [UIBezierPath bezierPath];
        [_path moveToPoint:CGPointMake(0 , 0)];
        [_path addLineToPoint:CGPointMake(0, self.height)];
        [_path stroke];
        
        //遮罩层
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor redColor].CGColor;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineWidth = 4;
        
        //渐变图层
        CALayer * grain = [CALayer layer];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [gradientLayer setColors:[NSArray arrayWithObjects:
                                  (id)[UIColor jp_colorWithHexString:@"0091FF"].CGColor,
                                  (id)[[UIColor jp_colorWithHexString:@"0091FF"] colorWithAlphaComponent:0.0].CGColor,
                                  nil]];
        
        // 设置颜色的分割点
        [gradientLayer setLocations:@[@0.01,@1]];
        [grain addSublayer:gradientLayer];
        [grain setMask:_progressLayer];
        [self.layer addSublayer:grain];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame andIsActive:(BOOL)iaActive
{
    if (!iaActive) {
        return [self initWithFrame:frame];
    }else{
        if ([super initWithFrame:frame]){
            _path = [UIBezierPath bezierPath];
            [_path moveToPoint:CGPointMake(0 , 0)];
            [_path addLineToPoint:CGPointMake(0, self.height)];
            [_path stroke];
            
            //遮罩层
            _progressLayer = [CAShapeLayer layer];
            _progressLayer.frame = self.bounds;
            _progressLayer.fillColor = [UIColor clearColor].CGColor;
            _progressLayer.strokeColor = [UIColor redColor].CGColor;
            _progressLayer.lineCap = kCALineCapRound;
            _progressLayer.lineWidth = 4;
            
            //渐变图层
            CALayer * grain = [CALayer layer];
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            [gradientLayer setColors:[NSArray arrayWithObjects:
                                      (id)[UIColor jp_colorWithHexString:@"f40949"].CGColor,
                                      (id)[[UIColor jp_colorWithHexString:@"f40949"] colorWithAlphaComponent:0.0].CGColor,
                                      nil]];
            
            // 设置颜色的分割点
            [gradientLayer setLocations:@[@0.01,@1]];
            [grain addSublayer:gradientLayer];
            [grain setMask:_progressLayer];
            [self.layer addSublayer:grain];
        }
        return self;
    }
}

- (void)startAnimation {
    if (!moveAnimation) {
        moveAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        moveAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        moveAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        moveAnimation.autoreverses = NO;
        moveAnimation.fillMode = kCAFillModeForwards;
        moveAnimation.repeatCount = 0;
        moveAnimation.removedOnCompletion = NO;
        moveAnimation.delegate = self;
        moveAnimation.duration = 1.f;
    }
    if (![_progressLayer.animationKeys containsObject:@"strokeEndAnimation"]) {
        [_progressLayer addAnimation:moveAnimation forKey:@"strokeEndAnimation"];
        _progressLayer.path = _path.CGPath;
    }
}

- (void)stopAnimation {
    if ([_progressLayer.animationKeys containsObject:@"strokeEndAnimation"]) {
        [_progressLayer removeAnimationForKey:@"strokeEndAnimation"];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStart)]) {
        [self.delegate animationDidStart];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self stopAnimation];
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStop)]) {
        [self.delegate animationDidStop];
    }
}

@end
