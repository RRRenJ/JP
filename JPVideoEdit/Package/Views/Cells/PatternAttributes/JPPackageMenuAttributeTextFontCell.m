//
//  JPPackageMenuAttributeTextFontCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/5.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageMenuAttributeTextFontCell.h"
#import "JPTextFontCell.h"
#import "JPFontModel.h"

@interface JPPackageMenuAttributeTextFontCell()<UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView *collecView;
    NSArray *dataArr;
}

- (NSArray *)getAllFontsName;

@end

@implementation JPPackageMenuAttributeTextFontCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];
        dataArr = [self getAllFontsName];
        
        UILabel *textLb = [[UILabel alloc] initWithFrame:CGRectMake(0, (6), (50), (13))];
        textLb.font = [UIFont contentFont];
        textLb.textColor = [UIColor jp_colorWithHexString:@"777777"];
        textLb.text = @"字体";
        [self.contentView addSubview:textLb];
        textLb.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 8).heightIs(13).widthIs(100);
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(35, 35);
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , JP_SCREEN_WIDTH ,self.height - 80) collectionViewLayout:layout];
        collecView.delegate = self;
        collecView.dataSource = self;
        collecView.bounces = YES;
        collecView.backgroundColor = self.contentView.backgroundColor;
        collecView.showsHorizontalScrollIndicator = NO;
        collecView.showsVerticalScrollIndicator = NO;
        [collecView registerClass:[JPTextFontCell class] forCellWithReuseIdentifier:@"JPTextFontCell"];
        [self.contentView addSubview:collecView];
        [collecView reloadData];
        collecView.sd_layout.topSpaceToView(textLb, 10).leftSpaceToView(self.contentView, 1).rightSpaceToView(self.contentView, 1).heightIs(35);
    }
    return self;
}

- (void)setPatternInteractiveView:(JPPatternInteractiveView *)patternInteractiveView
{
    _patternInteractiveView = patternInteractiveView;
    [collecView reloadData];
}

#pragma mark - 

- (NSArray *)getAllFontsName {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i<6; i++) {
        JPFontModel *model = [[JPFontModel alloc] init];
        NSString * imageName = [NSString stringWithFormat:@"fonts0%d",i+1];
        model.thumImg = JPImageWithName(imageName);
        switch (i) {
            case 0:
                model.fontName = @"PingFangSC-Regular";
                break;
            case 1:
                model.fontName = @"SentyTEA-4800";
                break;
            case 2:
                model.fontName = @"习宋体";
                break;
            case 3:
                model.fontName = @"PlacardMTStd-Cond";
                break;
            case 4:
                model.fontName = @"TrajanPro-Bold";
                break;
            case 5:
                model.fontName = @"Arista2.0";
                break;
            default:
                break;
        }
        [arr addObject:model];
    }
    return arr;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPFontModel *model = [dataArr objectAtIndex:indexPath.row];
    JPTextFontCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPTextFontCell" forIndexPath:indexPath];
    cell.model = model;
    if ([model.fontName isEqualToString:_patternInteractiveView.patternAttribute.textFontName]) {
        cell.isSelect = YES;
    } else {
        cell.isSelect = NO;
    }
    [cell setCellNeedsLayout];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JPFontModel *model = [dataArr objectAtIndex:indexPath.row];
    JPTextFontCell *cell = (JPTextFontCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelect = YES;
    _patternInteractiveView.patternAttribute.textFontName = model.fontName;
    [_patternInteractiveView updateContent];
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    JPTextFontCell *cell = (JPTextFontCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelect = YES;
    [collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 14.f, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 28.f;
}

@end
