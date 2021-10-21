//
//  JPFiltersCollectionViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/3/21.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPFiltersCollectionViewCell.h"

@interface JPFiltersCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *filteredImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation JPFiltersCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectImageView.layer.cornerRadius = 22.5f;
    _selectImageView.layer.borderWidth = 1.5;
    _selectImageView.layer.borderColor = [UIColor jp_colorWithHexString:@"0091FF"].CGColor;
    
}

- (void)updateFilterModel:(JPFilterModel *)filterModel andIsSelect:(BOOL)isSelect
{
    self.curerntfilterModel = filterModel;
    _selectImageView.hidden = !isSelect;
}

- (void)setCurerntfilterModel:(JPFilterModel *)curerntfilterModel
{
    _curerntfilterModel = curerntfilterModel;
    _filteredImageView.image = curerntfilterModel.thumbImage;
}
@end
