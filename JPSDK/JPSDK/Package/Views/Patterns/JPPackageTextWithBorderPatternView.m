//
//  JPPackageTextWithBorderPatternView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/21.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageTextWithBorderPatternView.h"

@interface JPPackageTextWithBorderPatternView() {
    JPPackagePatternAttribute * pattern;
    UILabel *contentLb;
    UIView *upLineView;
    UIView *downLineView;
    UIView *contentView;
}

- (void)createTextWithBoaderLinePattern;

- (void)createTextWithUpAndDownLinePattern;

- (void)createTextWithBorderLineAndVideoTittle;

@end

@implementation JPPackageTextWithBorderPatternView

- (id)initWithFrame:(CGRect)frame withGraphType:(JPPackagePatternAttribute *)patternAttribute {
    self = [super initWithFrame:frame];
    if (self) {
        pattern = patternAttribute;
        switch (patternAttribute.patternType) {
            case JPPackagePatternTypeTextWithBorderLine:
                [self createTextWithBoaderLinePattern];
                break;
            case JPPackagePatternTypeTextWithUpAndDownLine:
                [self createTextWithUpAndDownLinePattern];
                break;
            default:
                break;
        }
    }
    return self;
}

#pragma mark - public methods

- (void)createTextWithBoaderLinePattern {
    contentLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 11)];
    contentLb.font = [UIFont boldSystemFontOfSize:15];
    contentLb.textAlignment = NSTextAlignmentCenter;
    contentLb.textColor = pattern.textColor;
    contentLb.text = pattern.text;
    [self addSubview:contentLb];
    contentLb.sd_layout.topSpaceToView(self, 5).leftSpaceToView(self, 5).rightSpaceToView(self, 5).bottomSpaceToView(self, 5);
    contentLb.layer.borderColor = [UIColor jp_colorWithHexString:@"FEFEFE"].CGColor;
    contentLb.layer.borderWidth = 3.f;
}

- (void)createTextWithUpAndDownLinePattern {
    upLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 2)];
    upLineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:upLineView];
    upLineView.sd_layout.topSpaceToView(self, 3).leftSpaceToView(self, 3).rightSpaceToView(self, 3).heightIs(2);
    
    contentLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    contentLb.textColor = pattern.textColor;
    contentLb.font = [UIFont boldSystemFontOfSize:18];
    contentLb.textAlignment = NSTextAlignmentCenter;
    contentLb.text = pattern.text;
    [self addSubview:contentLb];
    contentLb.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 10).rightSpaceToView(self,10).bottomEqualToView(self);
    
    downLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 2)];
    downLineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:downLineView];
    downLineView.sd_layout.bottomSpaceToView(self, 3).leftEqualToView(upLineView).rightEqualToView(upLineView).heightIs(2);
    [self layoutIfNeeded];
}

- (void)createTextWithBorderLineAndVideoTittle {
    
}

#pragma mark - setter methods

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute{
    [super setPatternAttribute:patternAttribute];
    pattern = patternAttribute;
    switch (patternAttribute.patternType) {
        case JPPackagePatternTypeTextWithBorderLine:
            contentLb.textColor = pattern.textColor;
            contentLb.text = pattern.text;
            contentLb.font = [UIFont fontWithName:pattern.textFontName size:pattern.textFontSize];
            break;
        case JPPackagePatternTypeTextWithUpAndDownLine:
            contentLb.text = pattern.text;
            contentLb.textColor = pattern.textColor;
            contentLb.font = [UIFont fontWithName:pattern.textFontName size:pattern.textFontSize];
            break;
        default:
            break;
    }
    [self layoutIfNeeded];
}

- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale
{
    
    if (patternAttribute.patternType == JPPackagePatternTypeTextWithBorderLine) {
        CGFloat width = [UIFont jp_widthForText:patternAttribute.text andFontSize:[UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize * scale] andHeight:patternAttribute.textFontSize * scale] + 30 * scale + 10 * scale;
        return CGSizeMake(width, patternAttribute.textFontSize * scale + 14 *scale + 10 * scale);

    }
    {
        CGFloat width = [UIFont jp_widthForText:patternAttribute.text andFontSize:[UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize * scale] andHeight:patternAttribute.textFontSize * scale] + 30 * scale ;
        return CGSizeMake(width, patternAttribute.textFontSize * scale + 14 *scale + 10 * scale);
    }
    
    return CGSizeZero;
}

- (void)setScale:(CGFloat)scale{
    [super setScale:scale];
    switch (pattern.patternType) {
        case JPPackagePatternTypeTextWithBorderLine:
            contentLb.font = [UIFont fontWithName:pattern.textFontName size:pattern.textFontSize*scale];
            contentLb.sd_resetLayout.topSpaceToView(self, 5 * scale).leftSpaceToView(self, 5 * scale).rightSpaceToView(self, 5 * scale).bottomSpaceToView(self, 5  * scale);

            contentLb.layer.borderWidth = 3.f * self.scale;
            break;
        case JPPackagePatternTypeTextWithUpAndDownLine:
            contentLb.font = [UIFont fontWithName:pattern.textFontName size:pattern.textFontSize*scale];
            [upLineView removeFromSuperviewAndClearAutoLayoutSettings];
            [contentLb removeFromSuperviewAndClearAutoLayoutSettings];
            [downLineView removeFromSuperviewAndClearAutoLayoutSettings];
            
            [self addSubview:upLineView];
            upLineView.sd_layout.topSpaceToView(self, 3 * scale).leftSpaceToView(self, 3 * scale).rightSpaceToView(self, 3 * scale).heightIs(2 * scale);

            [self addSubview:contentLb];
            contentLb.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 10*self.scale).rightSpaceToView(self,10*self.scale).bottomEqualToView(self);

            [self addSubview:downLineView];
            downLineView.sd_layout.bottomSpaceToView(self, 3 * scale).leftEqualToView(upLineView).rightEqualToView(upLineView).heightIs(2 * self.scale);

            break;
            
        default:
            break;
    }
    [self layoutIfNeeded];
}

@end
