//
//  JPTextFontCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/5.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPTextFontCell.h"

@interface JPTextFontCell (){
    UIImageView *thumImgView;
}

@end

@implementation JPTextFontCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        thumImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        thumImgView.clipsToBounds = YES;
        thumImgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:thumImgView];
        thumImgView.sd_layout.topEqualToView(self.contentView).bottomEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
        
        thumImgView.layer.borderWidth = 0.5f;
        thumImgView.layer.borderColor = [UIColor jp_colorWithHexString:@"303132"].CGColor;
        thumImgView.layer.cornerRadius = 2.f;
    }
    return self;
}

#pragma mark - 

- (void)setCellNeedsLayout {
    if (_isSelect){
        thumImgView.layer.borderWidth = 1.f;
        thumImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        thumImgView.layer.borderWidth = 0.5f;
        thumImgView.layer.borderColor = [UIColor jp_colorWithHexString:@"303132"].CGColor;
        
    }
}

- (void)changeMSelectedState {
    _isSelect = !_isSelect;
    [self setCellNeedsLayout];
}

- (void)setModel:(JPFontModel *)model {
    thumImgView.image = model.thumImg;
}

@end
