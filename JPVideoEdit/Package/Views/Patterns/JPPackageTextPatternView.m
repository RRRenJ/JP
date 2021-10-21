//
//  JPPackagePatternView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageTextPatternView.h"

@interface JPPackageTextPatternView() {
    JPPackagePatternAttribute * pattern;
    UILabel *contentLb;
    UILabel *pinyinLb;
    UIView *contentView;
}

- (void)createTextPattern;
- (void)createTextPatternWithPinyin;
@property (strong, nonatomic) IBOutlet UIView *pingyinView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingyinContsntLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelOriginY;

@end

@implementation JPPackageTextPatternView

- (id)initWithFrame:(CGRect)frame withGraphType:(JPPackagePatternAttribute *)patternAttribute{
    self.clipsToBounds = YES;
    self = [super initWithFrame:frame];
    if (self) {
        pattern = patternAttribute;
        if (pattern.patternType == JPPackagePatternTypeTextWithNone) {
            [self createTextPattern];
        } else {
            [self createTextPatternWithPinyin];
        }
    }
    return self;
}

#pragma mark - public methods

- (void)createTextPattern {
    contentLb = [[UILabel alloc] initWithFrame:self.bounds];
    contentLb.font =  [UIFont fontWithName:pattern.textFontName size:pattern.textFontSize];;
    contentLb.textColor = pattern.textColor;
    contentLb.text = pattern.text;
    contentLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLb];
    contentLb.sd_layout.topEqualToView(self).bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
}

- (void)setScale:(CGFloat)scale
{
    [super setScale:scale];
    if (self.patternAttribute.patternType == JPPackagePatternTypeTextWithPinyin) {
        self.titleLabel.font = [UIFont fontWithName:self.patternAttribute.textFontName size:self.patternAttribute.textFontSize * scale];
        self.pingyinContsntLabel.font = [UIFont fontWithName:self.patternAttribute.textFontName size:(self.patternAttribute.textFontSize - 6) * scale];
        self.titleLabelOriginY.constant = 5 * scale;
    }else{
        contentLb.font = [UIFont fontWithName:pattern.textFontName size:pattern.textFontSize*scale];
 
    }
//    pinyinLb.font = [UIFont fontWithName:pattern.textFontName size:(pattern.textFontSize - 6)*scale];
//    if (pattern.patternType == JPPackagePatternTypeTextWithPinyin) {
//        [pinyinLb removeFromSuperviewAndClearAutoLayoutSettings];
//        [contentLb removeFromSuperviewAndClearAutoLayoutSettings];
//        [self addSubview:contentLb];
//        contentLb.sd_layout.topSpaceToView(self, 3 * scale).widthRatioToView(self, 1.0).heightIs(pattern.textFontSize * scale).centerXEqualToView(self);
//        [self addSubview:pinyinLb];
//        pinyinLb.sd_layout.topSpaceToView(contentLb, 5 * scale).widthRatioToView(self, 1.0).heightIs( (pattern.textFontSize - 6) * scale).centerXEqualToView(self);
//
//    }
 
    
}
- (void)createTextPatternWithPinyin {
  

    [JPResourceBundle loadNibNamed:@"JPPackageTextPatternView" owner:self options:nil];
    [self addSubview:self.pingyinView];
    self.pingyinView.sd_layout.topEqualToView(self).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
    self.titleLabel.textColor = pattern.textColor;
    self.titleLabel.text = pattern.text;
    self.pingyinContsntLabel.text = [NSString jp_chineseToPinyin:self.titleLabel.text];
}

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    [super setPatternAttribute:patternAttribute];
    pattern = patternAttribute;
    if (patternAttribute.patternType == JPPackagePatternTypeTextWithPinyin) {
        self.titleLabel.textColor = patternAttribute.textColor;
        self.titleLabel.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize];
        self.titleLabel.text = patternAttribute.text;
        self.pingyinContsntLabel.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize - 6];
        self.pingyinContsntLabel.textColor = patternAttribute.textColor;
        self.pingyinContsntLabel.text = [NSString jp_chineseToPinyin:patternAttribute.text];
    }else{
        contentLb.textColor = pattern.textColor;
        contentLb.text = pattern.text;
        contentLb.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize];

    }
}


- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale
{
    if (patternAttribute.patternType == JPPackagePatternTypeTextWithNone) {
        CGFloat width = [UIFont jp_widthForText:patternAttribute.text andFontSize:[UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize * scale] andHeight:patternAttribute.textFontSize * scale] + 15 * scale;
        return CGSizeMake(width, patternAttribute.textFontSize * scale + 7 *scale);
    }else{
        [self setPatternAttribute:patternAttribute];
        [self setScale:scale];
        [self.titleLabel sizeToFit];
        [self.pingyinContsntLabel sizeToFit];
        [self layoutIfNeeded];
        CGFloat width1 = self.titleLabel.width + 15 * scale;
        CGFloat width2 = self.pingyinContsntLabel.width + 15 * scale;
        CGFloat height =self.pingyinContsntLabel.bottom + 5 * scale ;
        CGFloat width = width1 > width2 ? width1 : width2;
        return CGSizeMake(width, height);

    }
    return CGSizeZero;
}

@end
