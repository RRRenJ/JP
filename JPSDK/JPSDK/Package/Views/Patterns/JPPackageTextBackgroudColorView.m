//
//  JPPackageTextBackgroudColorView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageTextBackgroudColorView.h"

@interface JPPackageTextBackgroudColorView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@end

@implementation JPPackageTextBackgroudColorView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    [JPResourceBundle loadNibNamed:@"JPPackageTextBackgroudColorView" owner:self options:nil];
    self.view.backgroundColor = [UIColor clearColor];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).bottomEqualToView(self).leftEqualToView(self).rightEqualToView(self);
    self.textLabel.font = [UIFont boldSystemFontOfSize:14];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
    self.textLabel.text = patternAttribute.text;
    self.textLabel.backgroundColor = patternAttribute.backgroundColor;
    self.textLabel.textColor = patternAttribute.textColor;
    self.textLabel.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize];
}


- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale
{
    CGFloat width = [UIFont jp_widthForText:patternAttribute.text andFontSize:[UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize * scale] andHeight:patternAttribute.textFontSize * scale] + 15 * scale;
    return CGSizeMake(width, patternAttribute.textFontSize * scale + 7 *scale);
}

- (void)setScale:(CGFloat)scale
{
    [super setScale:scale];
    self.textLabel.font = [UIFont fontWithName:self.patternAttribute.textFontName size:self.patternAttribute.textFontSize*scale];
}

@end
