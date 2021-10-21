//
//  JPNewVideoThumbCollectionViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/25.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewVideoThumbCollectionViewCell.h"
#import "JPVideoThumbSliderCell.h"

@interface JPNewVideoThumbCollectionViewCell ()<UICollectionViewDataSource>
{
    BOOL isShowTranstions;
}
@property (weak, nonatomic) IBOutlet UIImageView *transtionTypeImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UIButton *transtionButton;



@end

@implementation JPNewVideoThumbCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[JPVideoThumbSliderCell class] forCellWithReuseIdentifier:@"JPVideoThumbSliderCell"];
    self.collectionView.layer.masksToBounds = YES;
    self.collectionView.layer.cornerRadius = 3;
    self.collectionView.clipsToBounds = YES;
}

- (void)setOffset:(CGFloat)offset
{
    [_collectionView setContentOffset:CGPointMake(offset, 0)];
 
}

- (void)setInfoModel:(JPThumbInfoModel *)infoModel
{
    _infoModel = infoModel;
    isShowTranstions = NO;
    if (_infoModel.thumbImageArr.count != _infoModel.videoModel.thumbImages.count) {
        _infoModel.thumbImageArr = infoModel.videoModel.thumbImages.copy;
    }
    _collectionViewLayout.itemSize = infoModel.imageSize;
    [_collectionView reloadData];
    [_collectionView setContentOffset:CGPointMake(_infoModel.startPoint, 0)];
    _transtionTypeImageView.image = JPImageWithName(infoModel.transtionModel.offImageName);
    __weak typeof(self) weakSelf = self;
    __weak typeof(infoModel) weakModel = infoModel;
    infoModel.videoModel.thumImageGetCompletion = ^{
        if (weakModel == weakSelf.infoModel) {
            weakModel.thumbImageArr = weakModel.videoModel.thumbImages;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        }
    };
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _infoModel.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPVideoThumbSliderCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPVideoThumbSliderCell" forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    if (_infoModel.videoModel.isReverse == YES) {
        index = (_infoModel.count - 1) - indexPath.row;
    }
    NSArray *thumImageArr = _infoModel.thumbImageArr;
    UIImage *image = nil;
    if (index >= thumImageArr.count) {
        image = nil;
    }else{
        image = thumImageArr[index];
    }
    cell.imgView.image = image;
    return cell;

}
- (IBAction)changeTheTransitionType:(id)sender {
    if (_isLast == NO && isShowTranstions == NO && self.delegate && [self.delegate respondsToSelector:@selector(changeVideoTranstionTypeWithInfoModel:)]) {
        isShowTranstions = YES;
        _transtionTypeImageView.image = JPImageWithName(_infoModel.transtionModel.selectImageName);
        [self.delegate changeVideoTranstionTypeWithInfoModel:_infoModel];
    }else if (_isLast == NO && isShowTranstions == YES && self.delegate && [self.delegate respondsToSelector:@selector(changeVideoTranstionTypeDisInfoModel:)])
    {
        isShowTranstions = NO;
        _transtionTypeImageView.image = JPImageWithName(_infoModel.transtionModel.offImageName);
        [self.delegate changeVideoTranstionTypeDisInfoModel:_infoModel];
    }else if (_isLast == YES && self.delegate && [self.delegate respondsToSelector:@selector(changeVideoTranstionTypeAddVideo)])
    {
        [self.delegate changeVideoTranstionTypeAddVideo];
    }
}

- (void)setTranstionModelSelect:(BOOL)select
{
    if (select == YES) {
        _transtionTypeImageView.image = JPImageWithName(_infoModel.transtionModel.selectImageName);
    }else{
        _transtionTypeImageView.image = JPImageWithName(_infoModel.transtionModel.offImageName);
    }
}

- (void)setIsLast:(BOOL)isLast
{
    _isLast = isLast;
//    _transtionTypeImageView.hidden = isLast;
//    _transtionButton.userInteractionEnabled = !isLast;
    if (_isLast == YES) {
        _transtionTypeImageView.image = JPImageWithName(@"add");
        self.addIV = _transtionTypeImageView;
    }
}


- (UIView *)backgroundClibView
{
    return _collectionView.superview;
}
- (UIButton *)buttonView
{
    return _transtionButton;
}




@end
