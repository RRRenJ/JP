//
//  JPImgPickerViewController.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/7.
//  Copyright © 2017年 MuXiao. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import "JPImgPickerViewController.h"
#import "JPImgPickerViewCell.h"
#import "JPAlertView.h"
#import "JPUtil.h"

#define MAX_SELECTED_PICTURE_COUNT    9

@import Photos;


//Helper methods
@implementation NSIndexSet (Convenience)
- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}
@end

@implementation UICollectionView (Convenience)
- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
@end

@interface JPImgPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver> {
    NSMutableArray *selectedDataArr;
    NSMutableArray *selectedIndexPath;
    NSMutableArray *assetsArr;
    NSArray *collectionsFetchResults;
    JPAlertView *avauthAlertView;
}

@property (strong, nonatomic) NSMutableArray *assetsFetchResultsArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong) PHCachingImageManager *imageManager;
@property CGRect previousPreheatRect;
@property (strong) NSMutableArray *collectionsFetchResultsAssets;
@property (nonatomic, strong) NSMutableDictionary *imageDic;
- (void)updateCachedAssets;
- (void)resetCachedAssets;
- (void)getAllAlbums;
- (void)updateFetchResults;

@property (nonatomic, strong) ALAssetsLibrary *library;

- (void)createUI;

- (void)updateCollecView;

@end

static CGSize AssetGridThumbnailSize;

@implementation JPImgPickerViewController {
    CGFloat screenWidth;
    CGFloat screenHeight;
    UICollectionViewFlowLayout *portraitLayout;
    UICollectionViewFlowLayout *landscapeLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedDataArr = [NSMutableArray array];
    selectedIndexPath = [NSMutableArray array];
    assetsArr = [NSMutableArray array];
    _imageDic = [NSMutableDictionary dictionary];
    //创建导航栏
    [self createNavigatorViewWithHeight:JPShrinkNavigationHeight];
    if (_isSelectOneImage) {
        [self addPopButton];
    }else{
        [self addDismissButton];
    }
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//    if (ALAuthorizationStatusAuthorized != author) {
//        return;
//    }
    [self createUI];
    [self getAllAlbums];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [avauthAlertView removeFromSuperviewAndClearAutoLayoutSettings];
    BOOL show = [JPUtil showAlbumAuthorizationAlert];
    if (show) {
        if (!avauthAlertView) {
            NSString *str = @"让大家看看手机里的精美素材吧~请在「设置」-「隐私」-「照片」中打开未来拍客的本地图库获取权限";
            avauthAlertView = [[JPAlertView alloc] initWithTitle:str
                                                        andFrame:CGRectMake(0, 0, JP_SCREEN_WIDTH, JP_SCREEN_WIDTH)];
        }
        [self.view addSubview:avauthAlertView];
        avauthAlertView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(JP_SCREEN_WIDTH).heightIs(JP_SCREEN_WIDTH);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    if (self.imageManager) {
        [self resetCachedAssets];
    }
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - set methods

- (void)setAssetsFetchResultsArr:(NSMutableArray *)assetsFetchResultsArr {
    if (![assetsFetchResultsArr isEqualToArray:_assetsFetchResultsArr]) {
        _assetsFetchResultsArr = assetsFetchResultsArr;
        [self resetCachedAssets];
        [self.collectionView reloadData];
    }
}

#pragma mark - public methods

- (void)createUI {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, JP_SCREEN_HEIGHT - JPScreenFitFloat6(75), JP_SCREEN_WIDTH, JPScreenFitFloat6(75))];
    bottomView.backgroundColor = [UIColor jp_colorWithHexString:@"171819"];
    [self.view addSubview:bottomView];
    UIButton *comfirmBtn = [JPUtil createCustomButtonWithTittle:nil
                                                      withImage:JPImageWithName(@"ok")
                                                      withFrame:CGRectMake(0, (bottomView.height - JPScreenFitFloat6(40))/2, JPScreenFitFloat6(40), JPScreenFitFloat6(40))
                                                         target:self
                                                         action:@selector(comfirm:)];
    comfirmBtn.centerX = bottomView.centerX;
    [bottomView addSubview:comfirmBtn];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((JP_SCREEN_WIDTH - JPScreenFitFloat6(45))/4, (JP_SCREEN_WIDTH - JPScreenFitFloat6(45))/4);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(JPScreenFitFloat6(12.5), self.navagatorView.bottom + JPScreenFitFloat6(15) , JP_SCREEN_WIDTH - JPScreenFitFloat6(25),JP_SCREEN_HEIGHT - self.navagatorView.bottom - JPScreenFitFloat6(100)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.backgroundColor = self.view.backgroundColor;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[JPImgPickerViewCell class] forCellWithReuseIdentifier:@"JPImgPickerViewCell"];
    [self.view addSubview:_collectionView];
    CGFloat scale = [UIScreen mainScreen].scale;
    //NSLog(@"This is @%fx scale device", scale);
    AssetGridThumbnailSize = CGSizeMake(layout.itemSize.width * scale, layout.itemSize.height * scale);
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
}

- (void)updateCollecView {
    for (NSIndexPath *p in selectedIndexPath) {
        @autoreleasepool {
            JPImgPickerViewCell * cell = (JPImgPickerViewCell *)[_collectionView cellForItemAtIndexPath:p];
            PHAsset *asset = self.assetsFetchResultsArr[p.item];
            cell.txtLb.text = [NSString stringWithFormat:@"%lu",[selectedDataArr indexOfObject:asset] + 1];
        }
    }
}

- (void)getAllAlbums {
    PHFetchOptions *userAlbumsOptions = [PHFetchOptions new];
    userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:userAlbumsOptions];
    
    collectionsFetchResults = @[userAlbums];
    [self updateFetchResults];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)updateFetchResults {
    [assetsArr removeAllObjects];
    self.collectionsFetchResultsAssets = [NSMutableArray array];
    
    //Fetch PHAssetCollections:
    PHFetchResult *userCollections = [collectionsFetchResults objectAtIndex:0];
    
    //User albums:
    for(PHCollection *collection in userCollections)
    {
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            [self.collectionsFetchResultsAssets addObject:assetsFetchResult];
            for (int i = 0; i < assetsFetchResult.count; i++) {
                [assetsArr addObject:assetsFetchResult[i]];
            }
        }
    }
    
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    [self.collectionsFetchResultsAssets addObject:allPhotosResult];
    for (int i = 0; i < allPhotosResult.count; i++) {
        [assetsArr addObject:allPhotosResult[i]];
    }
    _assetsFetchResultsArr = [NSMutableArray arrayWithArray:[[assetsArr reverseObjectEnumerator] allObjects]];
    [_collectionView reloadData];
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *updatedCollectionsFetchResults = nil;
        
        for (PHFetchResult *collectionsFetchResult in self->collectionsFetchResults) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            if (changeDetails) {
                if (!updatedCollectionsFetchResults) {
                    updatedCollectionsFetchResults = [self->collectionsFetchResults mutableCopy];
                }
                [updatedCollectionsFetchResults replaceObjectAtIndex:[self->collectionsFetchResults indexOfObject:collectionsFetchResult] withObject:[changeDetails fetchResultAfterChanges]];
            }
        }
        
        // This only affects to changes in albums level (add/remove/edit album)
        if (updatedCollectionsFetchResults) {
            self->collectionsFetchResults = updatedCollectionsFetchResults;
        }
        
        // However, we want to update if photos are added, so the counts of items & thumbnails are updated too.
        // Maybe some checks could be done here , but for now is OKey.
        [self updateFetchResults];
        
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assetsFetchResultsArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPImgPickerViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPImgPickerViewCell" forIndexPath:indexPath];
    // Increment the cell's tag
    NSInteger currentTag = cell.tag + 1;
    cell.tag = currentTag;
    PHAsset *asset = self.assetsFetchResultsArr[indexPath.item];;
    if (_imageDic[indexPath]) {
        [cell.imgView setImage:_imageDic[indexPath]];
 
    }else{
        [self.imageManager requestImageForAsset:asset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFit
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      
                                      if (cell.tag == currentTag) {
                                          [cell.imgView setImage:result];
                                      }
                                      [self.imageDic setObject:result forKey:indexPath];
                                  }];
 
    }
    if (![selectedDataArr containsObject:asset]) {
        cell.isSelect = NO;
    } else {
        cell.isSelect = YES;
        cell.txtLb.text = [NSString stringWithFormat:@"%lu",[selectedDataArr indexOfObject:asset] + 1];
    }
    [cell setCellNeedsLayout];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JPImgPickerViewCell * cell = (JPImgPickerViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    PHAsset *asset = self.assetsFetchResultsArr[indexPath.item];
    [selectedDataArr removeAllObjects];
    [selectedIndexPath removeAllObjects];
    if (_isSelectOneImage) {
        [selectedDataArr addObject:asset];
        [selectedIndexPath addObject:indexPath];
        [_collectionView reloadData];
        return;
    }
    if (![selectedDataArr containsObject:asset]) {
        if (MAX_SELECTED_PICTURE_COUNT < [selectedDataArr count]) {
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%d张照片",MAX_SELECTED_PICTURE_COUNT] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];

            return;
        }
        [selectedDataArr addObject:asset];
        [selectedIndexPath addObject:indexPath];
        cell.txtLb.text = [NSString stringWithFormat:@"%ld",selectedDataArr.count];
    } else {
        [selectedDataArr removeObject:asset];
        [selectedIndexPath removeObject:indexPath];
        [self updateCollecView];
    }
    [cell changeMSelectedState];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((JP_SCREEN_WIDTH - JPScreenFitFloat6(45))/4, (JP_SCREEN_WIDTH - JPScreenFitFloat6(45))/4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, JPScreenFitFloat6(2.5), 0, JPScreenFitFloat6(2.5));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return JPScreenFitFloat6(5);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateCachedAssets];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets{
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets{
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths{
    if (indexPaths.count == 0) {
        return nil;
    }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResultsArr[indexPath.item];
        [assets addObject:asset];
    }
    return assets;
}

#pragma mark - actions

- (void)comfirm:(id)sender {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSIndexPath *p in selectedIndexPath) {
        @autoreleasepool {
            if (_isSelectOneImage) {
                [arr addObject:_imageDic[p]];
            }else{
                PHAsset *asset = self.assetsFetchResultsArr[p.item];
                JPPackagePatternAttribute *attribute = [[JPPackagePatternAttribute alloc] init];
                attribute.thumImageIfFromBundle = NO;
                NSString *imageName = [JPVideoUtil fileNameForDocumentImage];
                NSString *fullImagePath = [NSHomeDirectory() stringByAppendingPathComponent:imageName];
                UIImage *image = _imageDic[p];
                NSData *data = UIImagePNGRepresentation(image);
                if ([data writeToFile:fullImagePath atomically:YES]) {
                    attribute.thumPictureName = imageName;
                    attribute.thumImageIfFromBundle = NO;
                    attribute.pictureAssetID = asset.localIdentifier;
                    attribute.patternName = @"P10000";
                    attribute.patternType = JPPackagePatternTypePicture;
                    [arr addObject:attribute];
                }else{
                    [MBProgressHUD jp_showMessage:@"导出照片失败,请重试"];
                    return;
                }
            }
        }
    }
    if (self.imagePickerCompletion) {
        self.imagePickerCompletion(arr);
        if (self.isSelectOneImage) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:FINISHSELECTEDPICTURENOTIFICATION object:arr];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
