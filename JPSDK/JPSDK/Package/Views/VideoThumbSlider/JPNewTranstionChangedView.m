//
//  JPNewTranstionChangedView.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/28.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewTranstionChangedView.h"
#import "JPTranstionsCollectionViewCell.h"
#import "JPTranstionTypeSelectButton.h"
#import "JPTranstionsModelManager.h"

@interface JPNewTranstionChangedView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UICollectionView * collecView;

@end


@implementation JPNewTranstionChangedView

//- (IBAction)changeTranstionTypeAction:(id)sender {
//    JPVideoTranstionType transtionType = JPVideoTranstionNone;
//    if (sender == self.slideButton) {
//        transtionType = JPVideoTranstionIncluded;
//    }else if (sender == self.gradentButton)
//    {
//        transtionType = JPVideoTranstionGradient;
//    }else if (sender == self.supositionButton)
//    {
//        transtionType = JPVideoTranstionSuperposition;
//    }
//    [self formatTransitionButtonWithType:transtionType];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(newTranstionChangedViewChangeTranstionType:withTranstionModel:)]) {
//        [self.delegate newTranstionChangedViewChangeTranstionType:transtionType withTranstionModel:_videoModel];
//    }
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _dataSource = [JPTranstionsModelManager getAllTranstionsModels];
    self.backgroundColor = [UIColor blackColor];
    [JPResourceBundle loadNibNamed:@"JPNewTranstionChangedView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
    _collectionViewLayout.itemSize = CGSizeMake(JP_SCREEN_WIDTH / 4.5, 60);
    [_collectionView registerNib:[UINib nibWithNibName:@"JPTranstionsCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:@"JPTranstionsCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.clipsToBounds = NO;
    self.collecView = self.collectionView;
}

- (void)setVideoModel:(JPVideoModel *)videoModel
{
    _videoModel = videoModel;
    [_collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPTranstionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPTranstionsCollectionViewCell" forIndexPath:indexPath];
    JPVideoTranstionsModel *model = _dataSource[indexPath.row];
    cell.transtionNameLabel.text = model.title;
    if (model.transtionIndex == _videoModel.transtionModel.transtionIndex) {
        cell.transtionImageView.image = JPImageWithName(model.onImageName);
    }else{
        cell.transtionImageView.image = JPImageWithName(model.offImageName);
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPVideoTranstionsModel *model = _dataSource[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(newTranstionChangedViewChangeTranstionModel:withTranstionModel:)]) {
        [self.delegate newTranstionChangedViewChangeTranstionModel:model withTranstionModel:_videoModel];
    }
}
@end
