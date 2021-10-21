//
//  JPMaterialTypeCollectionCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPMaterialTypeCollectionCell.h"

@interface JPMaterialTypeCollectionCell ()

@property (nonatomic, strong) UILabel * titleLb;

@end

@implementation JPMaterialTypeCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.top.mas_equalTo(12);
            make.centerX.mas_equalTo(0);
        }];
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}


- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (_isSelect) {
        self.titleLb.textColor =  [UIColor jp_colorWithHexString:@"0091ff"];
        self.titleLb.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    }else{
        self.titleLb.textColor = UIColor.whiteColor;
        _titleLb.font = [UIFont systemFontOfSize:12];
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    if (_title.length > 4) {
        self.titleLb.text = [_title substringToIndex:4];
    }else{
        self.titleLb.text = _title;
    }
    if (self.isCustom) {
        [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 25));
            make.top.mas_equalTo(12);
            make.centerX.mas_equalTo(0);
        }];
    }else{
        [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.top.mas_equalTo(12);
            make.centerX.mas_equalTo(0);
        }];
    }
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = UIColor.whiteColor;
        _titleLb.font = [UIFont systemFontOfSize:12];
    }
    return _titleLb;
}

@end
