//
//  JPPackageEighthTextPattern.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/9.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageEighthTextPattern.h"

@interface JPPackageEighthTextPattern()

@property (nonatomic, weak) IBOutlet UIView *textView;
@property (nonatomic, weak) IBOutlet UILabel *tittleLb;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewOriginX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelOriginX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;

@end

@implementation JPPackageEighthTextPattern

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
    [JPResourceBundle loadNibNamed:@"JPPackageEighthTextPattern" owner:self options:nil];
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
    self.tittleLb.textColor = patternAttribute.textColor;
    self.tittleLb.font = [UIFont fontWithName:patternAttribute.textFontName size:patternAttribute.textFontSize];
    self.imgView.image = patternAttribute.logoImage;
}


- (CGSize)getMyReallySizeWithPackagePatternAttribute:(JPPackagePatternAttribute *)patternAttribute andScale:(CGFloat)scale{
    [self setPatternAttribute:patternAttribute];
    [self setScale:scale];
    [self.tittleLb sizeToFit];
    [self layoutIfNeeded];
    return CGSizeMake(self.tittleLb.width + 10 * scale + self.tittleLb.height + 5 * scale + 10 * scale,self.tittleLb.height + 20 * scale);
}

- (void)setScale:(CGFloat)scale{
    [super setScale:scale];
    self.tittleLb.font = [UIFont fontWithName:self.patternAttribute.textFontName size:self.patternAttribute.textFontSize*scale];
    self.titleLabelOriginX.constant = 6 * scale;
    self.imageViewTop.constant = 10 * scale;
    self.imageViewBottom.constant = 10 * scale;
    self.imageViewOriginX.constant = 5 * scale;
}

@end
