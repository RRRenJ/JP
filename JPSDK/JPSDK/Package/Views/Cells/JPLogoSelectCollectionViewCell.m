//
//  JPLogoSelectCollectionViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPLogoSelectCollectionViewCell.h"

@interface JPLogoSelectCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation JPLogoSelectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = 2;
    self.logoImageView.layer.borderWidth = 1;
    self.logoImageView.layer.borderColor = [UIColor appMainYellowColor].CGColor;
}

- (void)setPatternAttribute:(JPPackagePatternAttribute *)patternAttribute
{
    _patternAttribute = patternAttribute;
    _logoImageView.image = patternAttribute.thumPicture;
}

- (void)changeMSelectedState {
    _isAddPicture = NO;
    _isSelected = !_isSelected;
    [self setCellNeedsLayout];
}

- (void)setCellNeedsLayout {
    if (_isAddPicture) {
        self.logoImageView.layer.borderWidth = 0;
        self.logoImageView.layer.cornerRadius = 0;
        self.logoImageView.layer.borderColor = [UIColor clearColor].CGColor;
        self.logoImageView.image = [UIImage imageNamed:@"add_picture"];
    }if(_isSelected){
        self.logoImageView.layer.cornerRadius = 2;
        self.logoImageView.layer.borderWidth = 1;
        self.logoImageView.layer.borderColor = [UIColor appMainYellowColor].CGColor;
    } else {
        self.logoImageView.layer.borderWidth = 1;
        self.logoImageView.layer.cornerRadius = 2;
        self.logoImageView.layer.borderColor = [UIColor colorWithHex:0x303030].CGColor;
    }
}

@end
