//
//  JPNewFilterCollectionViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewFilterCollectionViewCell.h"

@interface JPNewFilterCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backgorundView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;


@end

@implementation JPNewFilterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setIsPage:(BOOL)isPage
{
    _isPage = isPage;
}

- (void)updateFilterSelectModel:(JPFilterModel *)model andIsSelect:(BOOL)isSelect
{
    self.selectFilterModel = model;
    if (isSelect) {
        _contentImageView.image = nil;
        _selectImageView.hidden = NO;
        _filterNameLabel.textColor = [UIColor whiteColor];
        _backgorundView.backgroundColor = _isPage == YES ? [UIColor jp_colorWithHexString:@"181818"] : [UIColor clearColor] ;
        _filterNameLabel.backgroundColor = _isPage == YES ? [UIColor clearColor] : [UIColor clearColor];
    }else{
        _contentImageView.image = model.thumbImage;
        _selectImageView.hidden = YES;
        _backgorundView.backgroundColor = _isPage == YES ? [UIColor clearColor] : [UIColor clearColor];
        _filterNameLabel.textColor = [UIColor jp_colorWithHexString:@"838383"];
        _filterNameLabel.backgroundColor =  [UIColor clearColor];
    }
}

- (void)setSelectFilterModel:(JPFilterModel *)selectFilterModel
{
    _selectFilterModel = selectFilterModel;
    _filterNameLabel.text = selectFilterModel.filterCNName;
   
}

@end
