//
//  JPPackageSixthTextPattern.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/9.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageSixthTextPattern.h"

@interface JPPackageSixthTextPattern()

@property (nonatomic, weak) IBOutlet UIView *textView;
@property (nonatomic, weak) IBOutlet UILabel *tittleLb;
@property (nonatomic, weak) IBOutlet UILabel *subTittle;
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tittleLbTopLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tittleLbBottomLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lineViewLeftLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lineViewRightLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lineViewHeightLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lineViewBottomLayoutConstraint;


@end

@implementation JPPackageSixthTextPattern

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
    [JPResourceBundle loadNibNamed:@"JPPackageSixthTextPattern" owner:self options:nil];
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
    self.lineView.backgroundColor = patternAttribute.backgroundColor;
    self.tittleLb.textColor = patternAttribute.textColor;
    self.tittleLb.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize];
    self.subTittle.text = patternAttribute.subTitle;
    self.subTittle.textColor = patternAttribute.textColor;
    self.subTittle.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize - 6];
}


- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale{
    [self setScale:scale];
    [self layoutIfNeeded];
    CGFloat width = [UIFont jp_widthForText:patternAttribute.text andFontSize:[UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize * scale] andHeight:patternAttribute.textFontSize * scale] + 20 * scale;
    CGFloat subWidth = [UIFont jp_widthForText:patternAttribute.subTitle andFontSize:[UIFont fontWithName:patternAttribute.textFontName size:(patternAttribute.textFontSize - 6) * scale] andHeight:patternAttribute.textFontSize * scale] + 15 * scale;
    CGFloat height = self.subTittle.bottom + 5 * scale ;
    return CGSizeMake(MAX(width, subWidth), height);
}

- (void)setScale:(CGFloat)scale{
    [super setScale:scale];
    self.tittleLb.font = [UIFont fontWithName:self.patternAttribute.textFontName size:self.patternAttribute.textFontSize*scale];
    self.subTittle.font = [UIFont fontWithName:self.patternAttribute.textFontName size:(self.patternAttribute.textFontSize - 6)*scale];
    self.tittleLbTopLayoutConstraint.constant = 5*scale;
    self.tittleLbBottomLayoutConstraint.constant = 3*scale;
    self.lineViewLeftLayoutConstraint.constant = 5*scale;
    self.lineViewRightLayoutConstraint.constant = 5*scale;
    self.lineViewBottomLayoutConstraint.constant = 3*scale;
    self.lineViewHeightLayoutConstraint.constant = 2*scale;
}


@end
