//
//  JPPackageClipsThumbViewCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/5.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageClipsThumbViewCell.h"

@interface JPPackageClipsThumbViewCell() {
    CAShapeLayer *borderShape;
}
- (void)setupUI;
- (void)createShapeLayer;
@end

@implementation JPPackageClipsThumbViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark - public methods

- (void)setupUI{
    self.txtLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width - 3, 13)];
    self.txtLb.textAlignment = NSTextAlignmentCenter;
    self.txtLb.font = [UIFont EnglishContentFont];
    self.txtLb.textColor = [UIColor jp_colorWithHexString:@"535353"];
    [self.contentView addSubview:self.txtLb];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 40, self.width - 3, 40)];
    self.imgView.clipsToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imgView];
    
}

- (void)createShapeLayer {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(JPScreenFitFloat6(2), JPScreenFitFloat6(2))];
    borderShape = [CAShapeLayer layer];
    borderShape.frame = self.imgView.bounds;
    borderShape.path = maskPath.CGPath;
    borderShape.strokeColor = [UIColor jp_colorWithHexString:@"0091ff"].CGColor;
    borderShape.fillColor = nil;
    borderShape.lineWidth = JPScreenFitFloat6(1.5);
}

- (void)setCellNeedsLayout {
    if (_isSelect){
        if (!borderShape) {
            [self createShapeLayer];
        }
        [self.imgView.layer addSublayer:borderShape];
        self.txtLb.textColor = [UIColor jp_colorWithHexString:@"0091ff"];
    }else{
        [borderShape removeFromSuperlayer];
        self.txtLb.textColor = [UIColor jp_colorWithHexString:@"535353"];
    }
}

- (void)changeMSelectedState {
    _isSelect = !_isSelect;
    [self setCellNeedsLayout];
}

@end
