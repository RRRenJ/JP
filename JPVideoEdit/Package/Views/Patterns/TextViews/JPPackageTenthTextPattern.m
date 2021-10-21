//
//  JPPackageTenthTextPattern.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/9.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageTenthTextPattern.h"

@interface JPPackageTenthTextPattern()

@property (nonatomic, weak) IBOutlet UIView *textView;
@property (nonatomic, weak) IBOutlet UILabel *tittleLb;
@property (nonatomic, weak) IBOutlet UILabel *subTittle;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bgViewTopLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bgViewBottomLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tittleLbBottomLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tittleLbTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageWidth;

@end

@implementation JPPackageTenthTextPattern

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews{
    [JPResourceBundle loadNibNamed:@"JPPackageTenthTextPattern" owner:self options:nil];
    self.textView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textView];
    self.textView.sd_layout.topEqualToView(self).bottomEqualToView(self).leftEqualToView(self).rightEqualToView(self);
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute{
    [super setPatternAttribute:patternAttribute];
    self.tittleLb.text = patternAttribute.text;
    self.bgView.backgroundColor = patternAttribute.backgroundColor;
    self.tittleLb.textColor = patternAttribute.textColor;
    self.tittleLb.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize];
    self.subTittle.text = patternAttribute.subTitle;
    self.subTittle.textColor = patternAttribute.textColor;
    self.subTittle.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize - 2];
}


- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale{
    [self setPatternAttribute:patternAttribute];
    [self setScale:scale];
    [self.tittleLb sizeToFit];
    [self.subTittle sizeToFit];
    [self layoutIfNeeded];
    CGFloat width = self.tittleLb.width + 16 * scale + 4 * scale;
    CGFloat subWidth =self.subTittle.width + 4 * scale;
    CGFloat height = self.subTittle.height + self.tittleLb.height + 8 * scale +  + 10 * scale  + 3 * scale;
    CGFloat reallyWidth = MAX(width, subWidth);
    self.backImageWidth.constant = reallyWidth - 2 * scale;
    return CGSizeMake(reallyWidth, height);
}

- (void)setScale:(CGFloat)scale{
    [super setScale:scale];
    self.tittleLb.font = [UIFont fontWithName:self.patternAttribute.textFontName size:self.patternAttribute.textFontSize*scale];
    self.subTittle.font = [UIFont fontWithName:self.patternAttribute.textFontName size:(self.patternAttribute.textFontSize - 6)*scale];
    self.tittleLbTopLayoutConstraint.constant = 4*scale;
    self.tittleLbBottomLayoutConstraint.constant = 4*scale;
    self.bgViewBottomLayoutConstraint.constant = 3*scale;
    self.bgViewTopLayoutConstraint.constant = 5*scale;
}

@end
