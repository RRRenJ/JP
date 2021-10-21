//
//  JPAudioRecordingProgressView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPAudioRecordingProgressView.h"
#import "JPCircleShapeLayer.h"

@interface JPAudioRecordingProgressView () {
    JPCircleShapeLayer *progressShapeLayer;
    UILabel *timeLb;
}

@end

@implementation JPAudioRecordingProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        timeLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        timeLb.font = [UIFont jp_placardMTStdCondBoldFontWithSize:20];
        timeLb.textColor = [UIColor jp_colorWithHexString:@"0091FF"];
        timeLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLb];
        
        progressShapeLayer = [[JPCircleShapeLayer alloc] initWithStartAngle:(-M_PI/2) endAngle:(3*M_PI/2)];
        progressShapeLayer.frame = self.bounds;
        progressShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        progressShapeLayer.tintColor = [UIColor jp_colorWithHexString:@"0091FF"];
        progressShapeLayer.progressColor = [UIColor jp_colorWithHexString:@"313131"];
        [self.layer addSublayer:progressShapeLayer];
    }
    return self;
}

- (void)dealloc
{
    
}
#pragma mark - public methods

- (void)updateViewWithProgress:(CGFloat)currentValue maxValue:(CGFloat)max {
    progressShapeLayer.maxTime = max;
    progressShapeLayer.currentTime = currentValue;
    timeLb.text = [NSString stringWithFormat:@"%ds",(int)floor(currentValue)];
}

@end
