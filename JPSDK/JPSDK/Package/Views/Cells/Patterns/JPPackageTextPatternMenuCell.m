//
//  JPPackagePatternMenuCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageTextPatternMenuCell.h"
#import "JPPackageTextWithBorderPatternView.h"
#import "JPPackageTextPatternView.h"
@interface JPPackageTextPatternMenuCell() {
    UIImageView *imgView;
}


@end

@implementation JPPackageTextPatternMenuCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        imgView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imgView];
        imgView.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    }
    
    return self;
}

#pragma mark -

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute{
    _patternAttribute = patternAttribute;
    imgView.image = _patternAttribute.thumPicture;
    imgView.sd_resetLayout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView).widthIs(_patternAttribute.thumPicture.size.width).heightIs(_patternAttribute.thumPicture.size.height);
}

@end
