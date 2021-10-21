//
//  JPVideoThumbSliderCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/5/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPVideoThumbSliderCell.h"

@interface JPVideoThumbSliderCell()
- (void)setupUI;
@end

@implementation JPVideoThumbSliderCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    [self.contentView addSubview:self.imgView];
    self.imgView.sd_layout.topEqualToView(self.contentView).bottomEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    self.imgView.backgroundColor = [UIColor blackColor];
}

@end
