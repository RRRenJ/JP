//
//  JPSoundEffectListSectionHeaderView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPSoundEffectListSectionHeaderView.h"

@interface JPSoundEffectListSectionHeaderView ()

@property (nonatomic, weak) IBOutlet UIView *view;

@end

@implementation JPSoundEffectListSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [JPResourceBundle loadNibNamed:@"JPSoundEffectListSectionHeaderView" owner:self options:nil];
        [self.contentView addSubview:self.view];
        self.view.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).topEqualToView(self.contentView).bottomEqualToView(self.contentView);
    }
    return self;
}

@end
