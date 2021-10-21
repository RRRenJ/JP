//
//  JPPackageMenuAttributeCollectionViewCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageMenuAttributeColorCell.h"
#import "JPCustomColorSlider.h"

@interface JPPackageMenuAttributeColorCell()
@property (nonatomic, strong) JPCustomColorSlider *customColorSlider;
- (void)setupUI;
@end

@implementation JPPackageMenuAttributeColorCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark - public methods

- (void)setupUI{
    self.textLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (50), (13))];
    self.textLb.font = [UIFont contentFont];
    self.textLb.textColor = [UIColor jp_colorWithHexString:@"777777"];
    self.textLb.centerY = self.centerY;
    [self.contentView addSubview:self.textLb];
    self.textLb.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).heightIs(25).widthIs(50);

    CGRect frame = CGRectMake(80, 0, self.width - 95, 25);
    NSArray *colorArr = [NSArray arrayWithObjects:
                         [UIColor whiteColor],
                         [UIColor jp_colorWithHexString:@"252525"],
                         [UIColor jp_colorWithHexString:@"fb1b45"],
                         [UIColor jp_colorWithHexString:@"f78618"],
                         [UIColor jp_colorWithHexString:@"f7d518"],
                         [UIColor jp_colorWithHexString:@"18df7a"],
                         [UIColor jp_colorWithHexString:@"10ddbb"],
                         [UIColor jp_colorWithHexString:@"1268dc"],
                         [UIColor jp_colorWithHexString:@"7e14e0"],
                         [UIColor jp_colorWithHexString:@"f32dc2"], nil];
    JPCustomColorSlider *colorSlider = [[JPCustomColorSlider alloc] initWithFrame:frame withColors:colorArr];
    [self.contentView addSubview:colorSlider];
    _customColorSlider = colorSlider;
    __weak typeof(self) weakself = self;
    _customColorSlider.valueChangeBlock = ^(NSInteger index, UIColor *color){
        if (weakself.patternInteractiveView) {
            switch (weakself.attributeType) {
                case JPPackagePatternAttributeTypeFontColor:
                    weakself.patternInteractiveView.patternAttribute.textColor = color;
                    weakself.patternInteractiveView.patternAttribute.selectColorIndex = index;

                    break;
                case JPPackagePatternAttributeTypeBackgroundColor:
                    weakself.patternInteractiveView.patternAttribute.backgroundColor = color;
                    weakself.patternInteractiveView.patternAttribute.selectBackColorIndex = index;
                    break;
  
                default:
                    break;
            }
            [weakself.patternInteractiveView updateContent];
        }
    };
}

- (void)setPatternInteractiveView:(JPPatternInteractiveView *)patternInteractiveView
{
    _patternInteractiveView = patternInteractiveView;
    switch (self.attributeType) {
        case JPPackagePatternAttributeTypeFontColor:
            [_customColorSlider setColorIndex:patternInteractiveView.patternAttribute.selectColorIndex];
            break;
        case JPPackagePatternAttributeTypeBackgroundColor:
            [_customColorSlider setColorIndex:patternInteractiveView.patternAttribute.selectBackColorIndex];
            break;
        default:
            break;
    }
}
@end
