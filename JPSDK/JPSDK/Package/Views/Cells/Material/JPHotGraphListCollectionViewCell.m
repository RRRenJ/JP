//
//  JPHotGraphListCollectionViewCell.m
//  jper
//
//  Created by Monster_lai on 2017/7/27.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPHotGraphListCollectionViewCell.h"

@interface JPHotGraphListCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *thumLb;

@end

@implementation JPHotGraphListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenFitFloat6(100), ScreenFitFloat6(100))];
    [self.contentView addSubview:_imgView];
    _imgView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .widthIs(ScreenFitFloat6(100))
    .heightIs(ScreenFitFloat6(100));
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgView.frame) + ScreenFitFloat6(15), ScreenFitFloat6(100), ScreenFitFloat6(20))];
    _titleLabel.font = [UIFont pingFangFontWithSize:ScreenFitFloat6(12)];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#787878"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont pingFangFontWithSize:ScreenFitFloat6(12)];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.sd_layout
    .topSpaceToView(_imgView, ScreenFitFloat6(15))
    .leftSpaceToView(self.contentView, 0)
    .widthIs(ScreenFitFloat6(100))
    .heightIs(ScreenFitFloat6(20));
    
    _thumLb = [[UILabel alloc] initWithFrame:CGRectZero];
    _thumLb.font = [UIFont placardMTStdCondBoldFontWithSize:18];
    _thumLb.textAlignment = NSTextAlignmentCenter;
    _thumLb.textColor = [UIColor colorWithHex:0x787878];
    _thumLb.text = @"NONE";
    _thumLb.hidden= YES;
    [self.contentView addSubview:_thumLb];
    _thumLb.sd_layout.centerYEqualToView(_imgView).leftEqualToView(_imgView).rightEqualToView(_imgView).heightIs(20);
}

- (void)setModel:(JPPackagePatternAttribute *)model {
    _model = model;
    _imgView.image = _model.thumPicture;
    _titleLabel.text = _model.text;
    if (_model.thumPicture) {
        _thumLb.hidden = YES;
    } else {
        _thumLb.hidden = NO;
    }
}

- (void)setCellNeedsLayout {
    if (_isSelect){
        self.imgView.layer.borderWidth = 2;
        self.imgView.layer.borderColor = [UIColor appMainYellowColor].CGColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    }else{
        self.imgView.layer.borderWidth = 0;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#787878"];
        if (!_model.thumPicture) {
            self.imgView.layer.borderWidth = 0.5;
            self.imgView.layer.borderColor = [UIColor colorWithHex:0x313131].CGColor;
        }
    }
}

- (void)changeMSelectedState {
    _isSelect = !_isSelect;
    [self setCellNeedsLayout];
}

@end
