//
//  JPCameraSettingCollectionViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPCameraSettingCollectionViewCell.h"

@interface JPCameraSettingCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@end

@implementation JPCameraSettingCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)selected:(BOOL)selected{
    if (selected) {

        self.nameLb.textColor = [UIColor jp_colorWithHexString:@"0091FF"];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 2;
        self.contentView.backgroundColor = [UIColor jp_colorWithHexString:@"3e3e3e"];
    }else{
        self.nameLb.textColor = [UIColor jp_colorWithHexString:@"ffffff"];
        self.contentView.layer.masksToBounds = NO;
        self.contentView.layer.cornerRadius = 0;
        self.contentView.backgroundColor = [UIColor jp_colorWithHexString:@"232323"];
    }
    
}
- (void)setName:(NSString *)name{
    _name = name;
    self.nameLb.text = _name;
}

@end
