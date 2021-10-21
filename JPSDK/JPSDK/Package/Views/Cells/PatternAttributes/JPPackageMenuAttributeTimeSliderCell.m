//
//  JPPackageMenuAttributeTimeSliderCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/5/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageMenuAttributeTimeSliderCell.h"
#import "MARKRangeSlider.h"

@interface JPPackageMenuAttributeTimeSliderCell () {
    MARKRangeSlider *rangeSlider;
}

- (void)createUI;

@end

@implementation JPPackageMenuAttributeTimeSliderCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        
    }
    return self;
}

#pragma mark - 

- (void)createUI {
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    lb.font = [UIFont contentFont];
    lb.textColor = [UIColor jp_colorWithHexString:@"777777"];
    lb.text = @"时间控制";
    [self.contentView addSubview:lb];
    lb.sd_layout.topSpaceToView(self.contentView, 8).leftSpaceToView(self.contentView, 15).widthIs(100).heightIs(13);
    
    rangeSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width - 30, 37)];
    rangeSlider.isTime = YES;
    rangeSlider.backgroundColor = [UIColor clearColor];
    [rangeSlider addTarget:self
                         action:@selector(rangeSliderValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    [rangeSlider addTarget:self
                    action:@selector(rangeSliderValueChangedEnd:)
          forControlEvents:UIControlEventEditingDidEnd];
    [self.contentView addSubview:rangeSlider];
    rangeSlider.sd_layout.topSpaceToView(lb, 15).leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15).heightIs(37);
}


- (UIView *)pointView
{
    return rangeSlider.rightThumbView;
}
- (void)updateSliderWithMinValue:(CGFloat)min
                     andMaxValue:(CGFloat)max
                    andLeftValue:(CGFloat)left
                   andRightVlaue:(CGFloat)right{
    [rangeSlider setMinValue:min maxValue:max];
    [rangeSlider setLeftValue:left rightValue:right];
    rangeSlider.minimumDistance = 1.f;
}

#pragma mark - actions
- (void)rangeSliderValueChangedEnd:(id)sender
{
    MARKRangeSlider *slider = (MARKRangeSlider *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rangeSliderValueDidEndChangeWithLeftValue:andRightValue:)]) {
        [self.delegate rangeSliderValueDidEndChangeWithLeftValue:slider.leftTime andRightValue:slider.rightTime];
    }

}
- (void)rangeSliderValueDidChange:(id)sender {
    MARKRangeSlider *slider = (MARKRangeSlider *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rangeSliderValueDidChangeWithLeftValue:andRightValue:)]) {
        [self.delegate rangeSliderValueDidChangeWithLeftValue:slider.leftTime andRightValue:slider.rightTime];
    }
}

@end
