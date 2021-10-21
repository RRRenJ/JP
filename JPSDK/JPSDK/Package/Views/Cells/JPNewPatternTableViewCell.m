//
//  JPNewPatternTableViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewPatternTableViewCell.h"
#import "MARKRangeSlider.h"
#import "UIImageView+WebCache.h"
@interface JPNewPatternTableViewCell ()
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) MARKRangeSlider * timeRangeSlider;
@end

@implementation JPNewPatternTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor blackColor];
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_titleImageView];
    _titleImageView.sd_layout.topSpaceToView(self.contentView, 25).leftSpaceToView(self.contentView, 15).heightIs(30).widthIs(30);
    _timeRangeSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width - 85, 37)];
    _timeRangeSlider.isTime = YES;
    _timeRangeSlider.backgroundColor = [UIColor clearColor];
    [_timeRangeSlider addTarget:self
                    action:@selector(rangeSliderValueDidChange:)
          forControlEvents:UIControlEventValueChanged];
    [_timeRangeSlider addTarget:self
                    action:@selector(rangeSliderValueChangedEnd:)
          forControlEvents:UIControlEventEditingDidEnd];
    [self.contentView addSubview:_timeRangeSlider];
    _timeRangeSlider.sd_layout.bottomSpaceToView(self.contentView, 12.5)    .leftSpaceToView(_titleImageView, 25).rightSpaceToView(self.contentView, 15).heightIs(37);
}

- (void)setAtturbue:(JPPackagePatternAttribute *)atturbue
{
    _atturbue = atturbue;
    JPPackagePatternAttribute *pattern = atturbue;
    if (pattern.thumPicture != nil) {
        _titleImageView.image = pattern.thumPicture;
    }else if (pattern.thumImageUrl != nil)
    {
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:atturbue.thumImageUrl] placeholderImage:nil];
    }else if (pattern.patternType == JPPackagePatternTypeGifPattern)
    {
        _titleImageView.image = [pattern getlastImage];
    }else{
        _titleImageView.image = nil;
    }
    if (atturbue.patternType == JPPackagePatternTypeWeekPicture) {
        _timeRangeSlider.userInteractionEnabled = NO;
    }else{
        _timeRangeSlider.userInteractionEnabled = YES;
    }
}

- (void)updateSliderWithMinValue:(CGFloat)min
                     andMaxValue:(CGFloat)max
                    andLeftValue:(CGFloat)left
                   andRightVlaue:(CGFloat)right{
    [_timeRangeSlider setMinValue:min maxValue:max];
    [_timeRangeSlider setLeftValue:left rightValue:right];
    _timeRangeSlider.minimumDistance = 1.f;
}

#pragma mark - actions
- (void)rangeSliderValueChangedEnd:(id)sender
{
    MARKRangeSlider *slider = (MARKRangeSlider *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rangeSliderValueDidEndChangeWithLeftValue:andRightValue:andAttrubute:)]) {
        [self.delegate rangeSliderValueDidEndChangeWithLeftValue:slider.leftTime andRightValue:slider.rightTime andAttrubute:self.atturbue];
    }
    
}
- (void)rangeSliderValueDidChange:(id)sender {
    MARKRangeSlider *slider = (MARKRangeSlider *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rangeSliderValueDidChangeWithLeftValue:andRightValue:andAttrubute:)]) {
        [self.delegate rangeSliderValueDidChangeWithLeftValue:slider.leftTime andRightValue:slider.rightTime andAttrubute:self.atturbue];
    }
}

@end
