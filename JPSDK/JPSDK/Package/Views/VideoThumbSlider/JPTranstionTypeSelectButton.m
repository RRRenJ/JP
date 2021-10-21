//
//  JPTranstionTypeSelectButton.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/28.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPTranstionTypeSelectButton.h"

@interface JPTranstionTypeSelectButton ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *transtionTypeImageView;

@property (weak, nonatomic) IBOutlet UILabel *transtionTypeLabel;

@end

@implementation JPTranstionTypeSelectButton


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor clearColor];
    [JPResourceBundle loadNibNamed:@"JPTranstionTypeSelectButton" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
}


- (void)setTranstionName:(NSString *)name imageName:(NSString *)imageName andLabelColor:(UIColor *)color
{
    _transtionTypeLabel.text = name;
    _transtionTypeImageView.image = [UIImage imageNamed:imageName inBundle:JPResourceBundle compatibleWithTraitCollection:nil];
    _transtionTypeLabel.textColor = color;
}
@end
