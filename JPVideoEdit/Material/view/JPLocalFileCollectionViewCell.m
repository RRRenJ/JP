//
//  JPLocalFileCollectionViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPLocalFileCollectionViewCell.h"

@interface JPLocalFileCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *frameImageView;
@property (weak, nonatomic) IBOutlet UILabel *selectNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIView *invalidView;

@end

@implementation JPLocalFileCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectNumberLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:36];
    _selectView.layer.borderWidth = 2;
    _selectNumberLabel.textAlignment = NSTextAlignmentCenter;
    _selectView.layer.borderColor = [UIColor jp_colorWithHexString:@"0091FF"].CGColor;
    _contentImageView.layer.borderWidth = 0.5;
    _contentImageView.layer.borderColor = [UIColor jp_colorWithHexString:@"303030"].CGColor;
    _timeLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:10];;
    self.index = 0;
}

- (void)setFileModel:(JPLocalFileModel *)fileModel
{
    _fileModel = fileModel;
    _selectView.hidden = !_fileModel.isSelect;
    _selectNumberLabel.hidden = !_fileModel.isSelect;
    _selectNumberLabel.text = [NSString stringWithFormat:@"0%ld", (long)_fileModel.selectIndex];
    _invalidView.hidden = !(_fileModel.isSelect == NO && _fileModel.isInvalid == YES);
    _contentImageView.image = fileModel.thumImage;
    if (fileModel.aspectRatio == JPVideoAspectRatio1X1) {
        _frameImageView.image = JPImageWithName(@"1to1_aspect_ratio");
    }else if (fileModel.aspectRatio == JPVideoAspectRatio16X9)
    {
        _frameImageView.image = JPImageWithName(@"16to9_aspect_ratio");
    }else if (fileModel.aspectRatio == JPVideoAspectRatio9X16){
        _frameImageView.image = JPImageWithName(@"9to16_aspect_ratio");
        
    }else{
        _frameImageView.image = JPImageWithName(@"4to3_aspect_ratio");
        
    }

    if (fileModel.type == JPAssetTypePhoto) {
        _timeLabel.hidden = YES;
        return;
    }
    _timeLabel.hidden = NO;
    _frameImageView.hidden = NO;
    _timeLabel.text = [NSString stringWithTimeInterval:fileModel.duration];
}

- (void)loadSourceWith:(JPLocalFileModel *)model {
    _fileModel = model;
    _frameImageView.hidden = YES;
    _selectView.hidden = !_fileModel.isSelect;
    _selectNumberLabel.hidden = !_fileModel.isSelect;
    _selectNumberLabel.text = [NSString stringWithFormat:@"0%ld", (long)_fileModel.selectIndex];
    _contentImageView.image = model.thumImage;
    if (0 != model.duration && _fileModel.type != JPAssetTypePhoto) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithTimeInterval:model.duration];
        if (_fileModel.aspectRatio == JPVideoAspectRatio1X1) {
            _frameImageView.image = JPImageWithName(@"square-on");
        }else if (_fileModel.aspectRatio == JPVideoAspectRatio16X9)
        {
            _frameImageView.image = JPImageWithName(@"transverse-on");
        }else if (_fileModel.aspectRatio == JPVideoAspectRatio9X16){
            _frameImageView.image = JPImageWithName(@"vertical-on");
            
        }else{
            _frameImageView.image = JPImageWithName(@"4to3-on");
            
        }
        _frameImageView.hidden=NO;
    } else {
        _timeLabel.hidden = YES;
        _frameImageView.hidden = YES;
    }
}

- (void)setIsAddVideo:(BOOL)isAddVideo
{
    _isAddVideo = isAddVideo;    
}

- (IBAction)delete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteTheItemWithIndex:)]) {
        [self.delegate deleteTheItemWithIndex:self.index];
    }
}


@end

