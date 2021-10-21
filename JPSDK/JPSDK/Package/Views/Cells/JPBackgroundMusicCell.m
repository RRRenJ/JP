//
//  JPBackgroundMusicCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/17.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPBackgroundMusicCell.h"

@interface JPBackgroundMusicCell ()
- (void)setupUI;

@end

@implementation JPBackgroundMusicCell

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
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.borderWidth = 0;
    self.imgView.layer.borderColor = [UIColor jp_colorWithHexString:@"0091ff"].CGColor;
    self.imgView.layer.cornerRadius = 3;
    self.imgView.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.contentView, 0).heightIs(JPScreenFitFloat6(60)).widthEqualToHeight();
    
    self.txtLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.txtLb.textAlignment = NSTextAlignmentCenter;
    self.txtLb.font = [UIFont jp_pingFangWithSize:10];
    self.txtLb.textColor = [UIColor jp_colorWithHexString:@"c5c5c5"];
    [self.contentView addSubview:self.txtLb];
    self.txtLb.sd_layout.topSpaceToView(self.imgView, JPScreenFitFloat6(7)).centerXEqualToView(self.contentView).widthIs(JPScreenFitFloat6(60)).heightIs(11);
}

- (void)setCellNeedsLayout {
    if (_isSelect){
        self.imgView.layer.borderWidth = 1.5;
    }else{
        self.imgView.layer.borderWidth = 0;

    }
}

- (void)changeMSelectedState {
    _isSelect = !_isSelect;
    [self setCellNeedsLayout];
}

- (void)dealloc
{
    
}
@end
