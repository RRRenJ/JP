//
//  JPPackageMenuAttributePhotoCollectionViewCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/3/29.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageMenuAttributePhotoCell.h"
#import "JPHorizontalCollectionViewLayout.h"
#import "JPLogoSelectCollectionViewCell.h"
#import "JPImgPickerViewController.h"
@interface JPPackageMenuAttributePhotoCell()<UICollectionViewDelegate, UICollectionViewDataSource>
- (void)setupUI;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation JPPackageMenuAttributePhotoCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _dataArr = [NSMutableArray array];
        [self setupUI];
    }
    
    return self;
}

#pragma mark - public methods

- (void)setupUI{
    self.textLb = [[UILabel alloc] initWithFrame:CGRectMake(0, (6), (50), (13))];
    self.textLb.font = [UIFont contentFont];
    self.textLb.textColor = [UIColor jp_colorWithHexString:@"777777"];
    [self.contentView addSubview:self.textLb];
    self.textLb.text = @"添加图标";
    self.textLb.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).heightIs(25).widthIs(100);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:backView];
    backView.sd_layout.topSpaceToView(self.textLb, 3).leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 0).heightIs(35);
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [backView addSubview:_logoImageView];
    _logoImageView.sd_layout.leftEqualToView(backView);
    _logoImageView.sd_layout.topEqualToView(backView);
    _logoImageView.sd_layout.bottomEqualToView(backView);
    _logoImageView.sd_layout.widthEqualToHeight();
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(50, 35);
    //设置布局方向为垂直流布局
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , JP_SCREEN_WIDTH ,self.height - 80) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = self.backgroundColor;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"JPLogoSelectCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:@"JPLogoSelectCollectionViewCell"];
    [backView addSubview:_collectionView];
    _collectionView.sd_layout.leftSpaceToView(_logoImageView, 15).topEqualToView(backView).bottomEqualToView(backView).rightEqualToView(backView);
}

- (void)setPatternInteractiveView:(JPPatternInteractiveView *)patternInteractiveView
{
    _patternInteractiveView = patternInteractiveView;
    _logoImageView.image = patternInteractiveView.patternAttribute.logoImage;
    if (patternInteractiveView.patternAttribute.logoImage == nil) {
       _logoImageView.image = JPImageWithName(@"loginIcon");
    }
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JPLogoSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPLogoSelectCollectionViewCell" forIndexPath:indexPath];
    if ([_dataArr count] == indexPath.row){
        cell.isAddPicture = YES;
        cell.isSelected = NO;
        cell.patternAttribute = nil;
    }else {
        JPPackagePatternAttribute *model = _dataArr[indexPath.row];
        cell.isAddPicture = NO;
        if([model.thumPicture isEqual:_logoImageView.image]){
            cell.isSelected = YES;
        } else {
            cell.isSelected = NO;
        }
        cell.patternAttribute = model;
    }
    [cell setCellNeedsLayout];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JPLogoSelectCollectionViewCell *cell = (JPLogoSelectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([_dataArr count] == indexPath.row) {
        JPImgPickerViewController *pickerVC = [[JPImgPickerViewController alloc] init];
        __weak typeof(self) weakself = self;
        pickerVC.imagePickerCompletion = ^(NSArray *imageArr) {
            [weakself.dataArr addObjectsFromArray:imageArr];
            [weakself.collectionView reloadData];
        };
        pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [[JPUtil currentViewController] presentViewController:pickerVC animated:YES completion:nil];
    }else{
        [cell changeMSelectedState];
        JPPackagePatternAttribute *model = _dataArr[indexPath.row];
        _logoImageView.image = model.thumPicture;
        _patternInteractiveView.patternAttribute.logoImageFilePath = model.thumPictureName;
        _patternInteractiveView.patternAttribute.logoImageIfFromBundle = model.thumImageIfFromBundle;
        [_patternInteractiveView updateContent];
        [collectionView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataArr count] != indexPath.row) {
        JPLogoSelectCollectionViewCell *cell = (JPLogoSelectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell changeMSelectedState];
        [collectionView reloadData];
    }
}
@end
