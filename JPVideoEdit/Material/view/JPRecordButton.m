//
//  JPRecordButton.m
//  jper
//
//  Created by FoundaoTEST on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPRecordButton.h"
#import "JPProgressView.h"

@interface JPRecordButton ()
@property (nonatomic, strong) UILabel *timeLabel;
@end
@implementation JPRecordButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubview];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.height / 2.0;
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
    _timeLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:24];
    _timeLabel.layer.masksToBounds = YES;
    _timeLabel.layer.cornerRadius = (self.height - 8) / 2.0;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];
    _timeLabel.sd_layout.topSpaceToView(self, 4).rightSpaceToView(self, 4).bottomSpaceToView(self, 4).leftSpaceToView(self, 4);
    

}
- (void)setDuration:(NSInteger)duration
{
    _timeLabel.backgroundColor = [UIColor clearColor];
    _duration = duration;
    _timeLabel.text = [NSString stringWithFormat:@"%dS", duration];
}

- (void)becomeNone
{
    _timeLabel.text = @"";
    _timeLabel.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
}

- (void)startScrollFilter
{
    _timeLabel.backgroundColor = [UIColor clearColor];
}

- (void)endScrollFilter
{
    _timeLabel.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
}
@end
