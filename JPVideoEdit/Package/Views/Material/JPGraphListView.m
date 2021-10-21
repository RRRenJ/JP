//
//  JPGraphListView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPGraphListView.h"
#import "JPGraphCollectionViewCell.h"
#import "JPMaterialDownloader.h"
#import "UIImageView+JPScorllView.h"
@interface JPGraphListView ()<UICollectionViewDelegate,UICollectionViewDataSource,JPMaterialDownloaderDelegate,JPGraphCollectionViewCellDelegate> {
    UICollectionView *collectView;
    NSMutableArray *dataArr;
    NSString *_categoryId;
    JPMaterial *currentDownloadModel;
}

- (void)createUI;

- (void)getListData;

- (JPGraphCollectionViewCell *)getCurrentDownloadCell:(NSString *)uuid;

@end

@implementation JPGraphListView

- (id)initWithFrame:(CGRect)frame andCategoryId:(NSString *)categoryId {
    self = [super initWithFrame:frame];
    if (self) {
        dataArr = [NSMutableArray array];
        _categoryId = categoryId;
        [self getListData];
    }
    return self;
}

- (void)createUI {
    if (collectView) {
        return;
    }
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(JPScreenFitFloat6(60), JPScreenFitFloat6(60));
    layout.minimumInteritemSpacing = 0;
    collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectView.tag = noDisableVerticalScrollTag;
    collectView.delegate = self;
    collectView.backgroundColor = self.backgroundColor;
    collectView.dataSource = self;
    collectView.showsVerticalScrollIndicator = NO;
    collectView.showsHorizontalScrollIndicator = NO;
    collectView.scrollEnabled = YES;
    collectView.bounces = YES;
    collectView.indicatorStyle =  UIScrollViewIndicatorStyleWhite;
    [collectView registerClass:[JPGraphCollectionViewCell class] forCellWithReuseIdentifier:@"JPGraphCollectionViewCell"];
    [self addSubview:collectView];
    collectView.sd_layout.leftSpaceToView(self, 15).rightSpaceToView(self, 15).topEqualToView(self).bottomEqualToView(self);
    [collectView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectView flashScrollIndicators];
    });
}

- (void)getListData {
//    NSMutableDictionary *dic = @{@"service":@"App.Material_Pattern.Resource_lists",
//                                 @"id":_categoryId
//                                }.mutableCopy;
//    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response){
//        if (response.ret && 200 == [response.ret intValue]) {
//            if (response.data && [response.data isKindOfClass:[NSArray class]]) {
//                for (int i = 0; i < [response.data count]; i ++) {
//                    if ([[response.data objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
//                        @autoreleasepool {
//                            JPMaterial *material = [JPMaterial mj_objectWithKeyValues:[response.data objectAtIndex:i]];
//                            material.material_id = 1;
//                            [dataArr sgrAddObject:material];
//                            JPMaterial *m = [[JPMaterialDownloader shareInstance] getMaterialWithLocalPath:material.localPath];
//                            if (m) {
//                                material.materialStatus = m.materialStatus;
//                                material.downloadPro = m.downloadPro;
//                            } else {
//                                material.materialStatus = JPMaterialStatusUnknown;
//                            }
//                        }
//                    }
//                }
//            }
//        }
        [self createUI];
//    }failure:^(NSError *error){
        [self createUI];
//    } withErrorMsg:nil];
}

- (JPGraphCollectionViewCell *)getCurrentDownloadCell:(NSString *)uuid {
    for (int i = 0; i < [dataArr count]; i ++) {
        @autoreleasepool {
            JPMaterial *info = [dataArr objectAtIndex:i];
            if ([uuid isEqualToString:info.localPath]) {
                NSIndexPath *p = [NSIndexPath indexPathForRow:i inSection:0];
                JPGraphCollectionViewCell *cell = (JPGraphCollectionViewCell *)[collectView cellForItemAtIndexPath:p];
                return cell;
            }
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPMaterial *material = [dataArr objectAtIndex:indexPath.row];
    JPGraphCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPGraphCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    [cell loadDataWithResource:material];
    if (JPMaterialStatusDownloading == material.materialStatus || JPMaterialStatusWillDownload == material.materialStatus) {
        [cell showProgressView];
    } else {
        [cell hiddenProgressView];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JPMaterial *material = [dataArr objectAtIndex:indexPath.row];
    NSArray *arr = [[JPMaterialDownloader shareInstance] localMaterials];
    if ([[NSFileManager defaultManager] fileExistsAtPath:material.absoluteLocalPath]) {
        JPPackagePatternAttribute *attr = [[JPPackagePatternAttribute alloc] init];
        attr.patternType = JPPackagePatternTypeDownloadedPicture;
        attr.originImageName = material.baseFilePath;
        attr.patternName = material.name;
        attr.resource_id = [NSString stringWithFormat:@"%lld", material.mid];
        attr.thumImageUrlNameFromBundle = NO;
        attr.thumImageUrlName = material.icon;
        UIImage *img = [UIImage imageWithContentsOfFile:material.absoluteLocalPath];
        CGSize size = img.size;
        attr.originImgSize = CGSizeMake(size.width/2.0, size.height/2.0);
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedDownloadedGraphWithData:)]) {
            [self.delegate selectedDownloadedGraphWithData:attr];
        }
    }else if (![arr containsObject:material]){
        [[JPMaterialDownloader shareInstance] insertModelToDownload:material];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat f = (JP_SCREEN_WIDTH - JPScreenFitFloat6(60)*4 - 30)/8.f;
    return UIEdgeInsetsMake(f, f, f, f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (JP_SCREEN_WIDTH - JPScreenFitFloat6(60)*4 - 30)/8.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return (JP_SCREEN_WIDTH - JPScreenFitFloat6(60)*4 - 30)/8.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - JPMaterialDownloaderDelegate

- (void)mediaDownloaderUpdateProgressWithModel:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader progress:(CGFloat)progress andSpeed:(NSInteger)speed{
    currentDownloadModel = model;
    JPGraphCollectionViewCell *cell = [self getCurrentDownloadCell:model.localPath];
    [cell updateViewWithProgress:progress];
}

- (void)mediaDownloaderInsertMediaModelWillDownload:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader{
    currentDownloadModel = model;
    JPGraphCollectionViewCell *cell = [self getCurrentDownloadCell:model.localPath];
    [cell updateViewWithProgress:0];
}

- (void)mediaDownloaderDeleteMediaModel:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader{
    currentDownloadModel = nil;
    JPGraphCollectionViewCell *cell = [self getCurrentDownloadCell:model.localPath];
    [cell hiddenProgressView];
    [collectView reloadData];
}

- (void)mediaDownloaderMediaModelDidDownload:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader{
    currentDownloadModel = nil;
    JPGraphCollectionViewCell *cell = [self getCurrentDownloadCell:model.localPath];
    [cell hiddenProgressView];
    [collectView reloadData];
}

- (void)mediaDownloaderMediaModelFailedDownload:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader {
    currentDownloadModel = nil;
    JPGraphCollectionViewCell *cell = [self getCurrentDownloadCell:model.localPath];
    [cell hiddenProgressView];
    [collectView reloadData];
}

#pragma mark - JPGraphCollectionViewCellDelegate

- (void)toDownloadTheMdoel:(JPMaterial *)material andIndex:(NSInteger)index{
    NSArray *arr = [[JPMaterialDownloader shareInstance] localMaterials];
    if (![arr containsObject:material]) {
        [[JPMaterialDownloader shareInstance] insertModelToDownload:material];
    }
}

#pragma mark -

- (void)show {
    [JPMaterialDownloader shareInstance].delegate = self;
}

@end
