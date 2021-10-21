//
//  JPPackageFilterCollectionViewCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/3.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageFilterCollectionViewCell.h"

@interface JPPackageFilterCollectionViewCell (){
    
}

@property (strong, nonatomic)  UIView *backgorundView;
@property (strong, nonatomic)  UIImageView *contentImageView;
@property (strong, nonatomic)  UILabel *filterNameLabel;
@property (strong, nonatomic)  UILabel *filterCNNameLabel;

@end

@implementation JPPackageFilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark -

- (void)setupUI {
    _backgorundView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_backgorundView];
    _backgorundView.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(50);

    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImageView.clipsToBounds = YES;
    [_backgorundView addSubview:_contentImageView];
    _contentImageView.sd_layout.topEqualToView(_backgorundView).leftEqualToView(_backgorundView).rightEqualToView(_backgorundView).bottomEqualToView(_backgorundView);
    
    _filterNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _filterNameLabel.font = [UIFont placardMTStdCondBoldFontWithSize:12];
    _filterNameLabel.textColor = [UIColor whiteColor];
    _filterNameLabel.textAlignment = NSTextAlignmentCenter;
    [_backgorundView addSubview:_filterNameLabel];
    _filterNameLabel.sd_layout.topEqualToView(_backgorundView).leftEqualToView(_backgorundView).rightEqualToView(_backgorundView).bottomEqualToView(_backgorundView);
    
    _filterCNNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _filterCNNameLabel.font = [UIFont pingFangFontWithSize:12];
    _filterCNNameLabel.textColor = [UIColor colorWithHex:0x545454];
    _filterCNNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_filterCNNameLabel];
    _filterCNNameLabel.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).bottomEqualToView(self.contentView).heightIs(13);
    
    _backgorundView.layer.masksToBounds = YES;
    _backgorundView.layer.cornerRadius = 3;
    _backgorundView.layer.borderWidth = 0.5;
    _backgorundView.layer.borderColor = [UIColor whiteColor].CGColor;
    _filterNameLabel.font = [UIFont placardMTStdCondBoldFontWithSize:12];
}

- (void)updateFilterModel:(JPFilterModel *)filterModel andIsSelect:(BOOL)isSelect
{
    self.selectFilterModel = filterModel;
    if (isSelect) {
        _backgorundView.layer.borderWidth = 1;
        _backgorundView.layer.borderColor = [UIColor appMainYellowColor].CGColor;
    }else{
        _backgorundView.layer.borderWidth = 0.5;
        _backgorundView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (void)setSelectFilterModel:(JPFilterModel *)selectFilterModel{
    _selectFilterModel = selectFilterModel;
    _filterNameLabel.text = selectFilterModel.filterName;
    _contentImageView.image = selectFilterModel.thumbImage;
    _filterCNNameLabel.text = selectFilterModel.filterCNName;
  
}

@end
