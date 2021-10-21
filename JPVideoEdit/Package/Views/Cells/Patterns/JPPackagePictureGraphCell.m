//
//  JPPackagePictureGraphCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackagePictureGraphCell.h"
#import "JPUtil.h"

@interface JPPackagePictureGraphCell()
- (void)setupUI;
@end

@implementation JPPackagePictureGraphCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark - public methods

- (void)setupUI{
    self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imgView.clipsToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleToFill;
    self.imgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imgView];
    self.imgView.sd_layout.topEqualToView(self.contentView).rightEqualToView(self.contentView).leftEqualToView(self.contentView).bottomEqualToView(self.contentView);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.imgView.bounds];
    CAShapeLayer *borderShape = [CAShapeLayer layer];
    borderShape.frame = self.imgView.bounds;
    borderShape.path = maskPath.CGPath;
    borderShape.strokeColor = [UIColor jp_colorWithHexString:@"303133"].CGColor;
    borderShape.fillColor = nil;
    borderShape.lineWidth = 0.5f;
    [self.imgView.layer addSublayer:borderShape];
    
    CGRect frame = CGRectMake(self.imgView.right, self.imgView.top, JPScreenFitFloat6(27), JPScreenFitFloat6(27));
    self.deleteBtn = [JPUtil createCustomButtonWithTittle:nil
                                                withImage:JPImageWithName(@"delete")
                                                withFrame:frame
                                                   target:self
                                                   action:@selector(delete:)];
    self.deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-4, 0, 0, 0);
    self.deleteBtn.hidden = YES;
    self.deleteBtn.enabled = NO;
    [self.contentView addSubview:self.deleteBtn];
    self.deleteBtn.sd_layout.widthIs(27).heightEqualToWidth().topEqualToView(self.imgView).leftSpaceToView(self.imgView,0);
}

#pragma mark - set methods

- (void)setShowDeleteBtn:(BOOL)showDeleteBtn {
    self.deleteBtn.hidden = !showDeleteBtn;
    self.deleteBtn.enabled = showDeleteBtn;
    if (showDeleteBtn) {
        self.imgView.sd_resetLayout.widthIs(42).heightEqualToWidth().centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,(self.width - 69)/2);
    } else {
        self.imgView.sd_resetLayout.widthIs(42).heightEqualToWidth().centerYEqualToView(self.contentView).centerXEqualToView(self.contentView);
    }
}

#pragma mark - ations

- (void)delete:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(deletePictureAtIndex:)]) {
        [self.delegate deletePictureAtIndex:(int)btn.tag];
    }
}

@end
