//
//  JPImgPickerViewCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/7.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPImgPickerViewCell.h"
#import "JPUtil.h"

@interface JPImgPickerViewCell() {
    CAShapeLayer *selectedborderShape;
    CAShapeLayer *unselectedborderShape;
}
- (void)setupUI;
- (void)createSelectedShapeLayer;
- (void)createUnselectedShapeLayer;
@end

@implementation JPImgPickerViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark - public methods

- (void)setupUI{
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.imgView.clipsToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imgView];

    self.txtLb = [[UILabel alloc] initWithFrame:CGRectMake(self.width - JPScreenFitFloat6(22), JPScreenFitFloat6(4), JPScreenFitFloat6(18), JPScreenFitFloat6(18))];
    self.txtLb.textAlignment = NSTextAlignmentCenter;
    self.txtLb.font = [UIFont EnglishContentFont];
    self.txtLb.backgroundColor = [UIColor jp_colorWithHexString:@"0091ff"];
    self.txtLb.textColor = [UIColor jp_colorWithHexString:@"535353"];
    [JPUtil setViewRadius:self.txtLb byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(JPScreenFitFloat6(18)/2, JPScreenFitFloat6(18)/2)];
    [self.contentView addSubview:self.txtLb];
}

- (void)createSelectedShapeLayer {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.imgView.bounds];
    selectedborderShape = [CAShapeLayer layer];
    selectedborderShape.frame = self.imgView.bounds;
    selectedborderShape.path = maskPath.CGPath;
    selectedborderShape.strokeColor = [UIColor jp_colorWithHexString:@"0091ff"].CGColor;
    selectedborderShape.fillColor = nil;
    selectedborderShape.lineWidth = JPScreenFitFloat6(2);
}

- (void)createUnselectedShapeLayer {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.imgView.bounds];
    unselectedborderShape = [CAShapeLayer layer];
    unselectedborderShape.frame = self.imgView.bounds;
    unselectedborderShape.path = maskPath.CGPath;
    unselectedborderShape.strokeColor = [UIColor jp_colorWithHexString:@"303030"].CGColor;
    unselectedborderShape.fillColor = nil;
    unselectedborderShape.lineWidth = JPScreenFitFloat6(0.5);
}

- (void)setCellNeedsLayout {
    if (_isSelect){
        if (!selectedborderShape) {
            [self createSelectedShapeLayer];
        }
        [unselectedborderShape removeFromSuperlayer];
        [self.imgView.layer addSublayer:selectedborderShape];
        self.txtLb.hidden = NO;
    }else{
        if (!unselectedborderShape) {
            [self createUnselectedShapeLayer];
        }
        [selectedborderShape removeFromSuperlayer];
        [self.imgView.layer addSublayer:unselectedborderShape];
        self.txtLb.hidden = YES;
    }
}

- (void)changeMSelectedState {
    _isSelect = !_isSelect;
    [self setCellNeedsLayout];
}

@end
