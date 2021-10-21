//
//  JPRecordAudioThumCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/8/16.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPRecordAudioThumCell.h"

@interface JPRecordAudioThumCell()
- (void)setupUI;
@end

@implementation JPRecordAudioThumCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 50)];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    [self.contentView addSubview:self.imgView];
    self.imgView.sd_layout.topEqualToView(self.contentView).heightIs(50).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
}

@end
