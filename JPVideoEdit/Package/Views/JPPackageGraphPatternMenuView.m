//
//  JPJPPackageGraphPatternMenuView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageGraphPatternMenuView.h"
#import "JPMaterialTypeCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "JPMaterialDownloader.h"
#import "JPUtil.h"
#import "JPGraphListView.h"
#import "JPLocalGraphList.h"
#import "JPMaterialCategory.h"

#import "JPLocalTextView.h"
#import "JPHotGraphList.h"
#import "JPGifListView.h"
@interface JPPackageGraphPatternMenuView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JPLocalGraphListDelegate,JPGraphListViewDelegate, JPJPLocalTextViewDelegate,JPHotGraphListDelegate, JPJPGifListViewDelegate>{
    UICollectionView *collecView;
    NSMutableArray *dataArr;
    UIScrollView *src;
    NSIndexPath *selectedPath;
    JPLocalGraphList *localListView;
    JPLocalTextView *localTextView;
    JPHotGraphList *hotListView;
    JPGifListView *gifListView;
    int currrentPage;
}

- (void)createUI;
- (void)getCategoryData;
- (void)switchToPage:(int)page;

@end

@implementation JPPackageGraphPatternMenuView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        dataArr = [NSMutableArray array];
        [self getCategoryData];
    }
    return self;
}

- (void)dealloc {

}


#pragma mark - public methods

- (void)getCategoryData {
    [self createUI];
//    NSMutableDictionary *dic = @{@"service":@"App.Material_Pattern.Lists"}.mutableCopy;
//    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response){
//        if (response.ret && 200 == [response.ret intValue]) {
//            if (response.data && [response.data isKindOfClass:[NSArray class]]) {
//                for (int i = 0; i < [response.data count]; i ++) {
//                    if ([[response.data objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
//                        JPMaterialCategory *category = [JPMaterialCategory mj_objectWithKeyValues:[response.data objectAtIndex:i]];
//                        category.material_id = 1;
//                        [dataArr sgrAddObject:category];
//                    }
//                }
//            }
//        }
//
//    }failure:^(NSError *error){
//        [self createUI];
//    } withErrorMsg:nil];
}

- (void)switchToPage:(int)page {
    currrentPage = page;
    selectedPath = [NSIndexPath indexPathForRow:page inSection:0];
    [collecView reloadData];
    if (page == 3) {
        [gifListView show];
    }else{
        [gifListView dismiss];
    }
    if (currrentPage > 3) {
        UIView *view = [src viewWithTag:currrentPage + 995];
        if (view && [view isKindOfClass:[JPGraphListView class]]) {
            JPGraphListView *v = (JPGraphListView *)view;
            [v show];
        }
    }
}

- (void)createUI {
    if (collecView) {
        return;
    }
    
    self.tittleView.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];
    self.tittleView.sd_layout.topEqualToView(self).leftEqualToView(self).rightEqualToView(self).heightIs(65);
    self.confirmBt.sd_layout.topSpaceToView(self.tittleView, 19).rightSpaceToView(self.tittleView, 15).widthIs(55).bottomSpaceToView(self.tittleView, 18);
    self.confirmBt.layer.cornerRadius = 2;
    self.confirmBt.layer.masksToBounds = YES;
    self.confirmBt.backgroundColor = [UIColor jp_colorWithHexString:@"#4E4E4E"];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(JPScreenFitFloat6(60), 64);
    layout.minimumInteritemSpacing = 0;

    collecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , JP_SCREEN_WIDTH ,0) collectionViewLayout:layout];
    collecView.delegate = self;
    collecView.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];
    collecView.dataSource = self;
    collecView.scrollEnabled = YES;
    collecView.showsHorizontalScrollIndicator = NO;
    collecView.showsVerticalScrollIndicator = NO;
    [collecView registerClass:[JPMaterialTypeCollectionCell class] forCellWithReuseIdentifier:@"JPMaterialTypeCollectionCell"];
    [self.tittleView addSubview:collecView];
    
    collecView.sd_layout.bottomSpaceToView(self.tittleView, 1).leftEqualToView(self.tittleView).rightSpaceToView(self.tittleView, 70).topSpaceToView(self.tittleView, 0);
    
    src = [[UIScrollView alloc] initWithFrame:CGRectZero];
    src.pagingEnabled = YES;
    src.delegate = self;
    src.showsVerticalScrollIndicator = NO;
    src.showsHorizontalScrollIndicator = NO;
    src.bounces = NO;
    src.contentSize = CGSizeMake(self.width*([dataArr count] + 4), self.height - self.tittleView.height - 10);
    [self addSubview:src];
    src.sd_layout.topSpaceToView(self.tittleView, 10).bottomEqualToView(self).leftEqualToView(self).rightEqualToView(self);
    hotListView = [[JPHotGraphList alloc] initWithFrame:CGRectZero];
    hotListView.delegate = self;
    [src addSubview:hotListView];
    hotListView.sd_layout.topEqualToView(src).bottomEqualToView(src).leftEqualToView(src).widthRatioToView(src, 1.0);
    hotListView.selectHotAttribute = _selectHotPatternAttribute;
    localListView = [[JPLocalGraphList alloc] initWithFrame:CGRectZero];
    localListView.delegate = self;
    [src addSubview:localListView];
    localListView.sd_layout.topEqualToView(src).bottomEqualToView(src).leftSpaceToView(src, JP_SCREEN_WIDTH).widthRatioToView(src, 1.0);
    
    localTextView = [[JPLocalTextView alloc] initWithFrame:CGRectZero];
    localTextView.delegate = self;
    [src addSubview:localTextView];
    localTextView.sd_layout.topEqualToView(src).bottomEqualToView(src).leftSpaceToView(src, JP_SCREEN_WIDTH * 2).widthRatioToView(src, 1.0);
    gifListView  = [[JPGifListView alloc] initWithFrame:CGRectZero];
    [src addSubview:gifListView];
    gifListView.sd_layout.topEqualToView(src).bottomEqualToView(src).leftSpaceToView(src, JP_SCREEN_WIDTH * 3).widthRatioToView(src, 1.0);
    gifListView.delegate = self;
    
    for (int i = 0; i< [dataArr count]; i++) {
        @autoreleasepool {
            JPMaterialCategory *category = [dataArr objectAtIndex:i];
            JPGraphListView *graphListView = [[JPGraphListView alloc] initWithFrame:CGRectZero andCategoryId:category.material_type_id];
            graphListView.delegate = self;
            graphListView.tag = i + 999;
            [src addSubview:graphListView];
            graphListView.sd_layout.topEqualToView(src).bottomEqualToView(src).leftSpaceToView(src, (i + 4)*self.width).widthRatioToView(src, 1.0);
        }
    }
}


- (void)selectedGifGraphWithData:(JPPackagePatternAttribute *)data
{
    if ([self.delegate respondsToSelector:@selector(selectedGraphWithData:)]) {
        [self.delegate selectedGraphWithData:data];
    }
}

- (void)setSelectHotPatternAttribute:(JPPackagePatternAttribute *)selectHotPatternAttribute
{
    _selectHotPatternAttribute = selectHotPatternAttribute;
    hotListView.selectHotAttribute = selectHotPatternAttribute;
}

- (void)setRecordInfo:(JPVideoRecordInfo *)recordInfo
{
    _recordInfo = recordInfo;
    hotListView.recordInfo = _recordInfo;
}

- (void)setCurrentTime:(CMTime)currentTime
{
    _currentTime = currentTime;
    hotListView.currentTime = currentTime;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArr count]+4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPMaterialTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPMaterialTypeCollectionCell" forIndexPath:indexPath];
    if (0 == indexPath.row) {
        cell.isCustom = NO;
        cell.title = @"封面";
        if ([selectedPath isEqual:indexPath] || !selectedPath) {
            cell.imgView.image = JPImageWithName(@"icon_huo_hl");
            cell.isSelect = YES;
        } else {
            cell.imgView.image = JPImageWithName(@"icon_huo_nm");
            cell.isSelect = NO;
        }
    }else if (1 == indexPath.row) {
        cell.isCustom = NO;
        cell.title = @"文字";
        if ([selectedPath isEqual:indexPath]) {
            cell.imgView.image = JPImageWithName(@"icon_star_hl");
            cell.isSelect = YES;
        } else {
            cell.imgView.image = JPImageWithName(@"icon_star_nm");
            cell.isSelect = NO;
        }
    }else if(2 == indexPath.row){
        cell.isCustom = NO;
        cell.title = @"标题";
        if ([selectedPath isEqual:indexPath]) {
            cell.imgView.image = JPImageWithName(@"icon_a_hl");
            cell.isSelect = YES;
        } else {
            cell.imgView.image = JPImageWithName(@"icon_a_nm");
            cell.isSelect = NO;
        }
    }else if (3 == indexPath.row){
        cell.isCustom = NO;
        cell.title = @"动感";
        if ([selectedPath isEqual:indexPath]) {
            cell.imgView.image = JPImageWithName(@"icon_yuan_hl");
            cell.isSelect = YES;
        } else {
            cell.imgView.image = JPImageWithName(@"icon_yuan_nm");
            cell.isSelect = NO;
        }
    }else {
        cell.isCustom = YES;
        JPMaterialCategory *category = [dataArr objectAtIndex:indexPath.row - 4];
        cell.title = category.material_type_name;
        if ([selectedPath isEqual:indexPath]) {
            if (category.material_type_icon) {
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:category.material_type_icon] placeholderImage:nil];
            }
        } else {
            if (category.material_type_unicon) {
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:category.material_type_unicon] placeholderImage:nil];
            }
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (currrentPage != indexPath.row) {
        [self switchToPage:(int)indexPath.row];
        [src setContentOffset:CGPointMake(self.width*indexPath.row, 0) animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([scrollView isEqual:src]) {
        if(!decelerate){
            int page = (int)src.contentOffset.x/src.width;
            [self switchToPage:page];
            [collecView  scrollToItemAtIndexPath:selectedPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:src]) {
        int page = (int)src.contentOffset.x/src.width;
         [self switchToPage:page];
        [collecView  scrollToItemAtIndexPath:selectedPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark JPJPLocalTextViewDelegate
- (void)localTextViewSelectedGraphWithData:(JPPackagePatternAttribute *)data
{
    if ([self.delegate respondsToSelector:@selector(selectedGraphWithData:)]) {
        [self.delegate selectedGraphWithData:data];
    }
}

#pragma mark - JPLocalGraphListDelegate

- (void)toPicturePickerView {
    if ([self.delegate respondsToSelector:@selector(toPicturePickerView)]) {
        [self.delegate toPicturePickerView];
    }
}

- (void)selectedGraphWithData:(JPPackagePatternAttribute *)data{
    if ([self.delegate respondsToSelector:@selector(selectedGraphWithData:)]) {
        [self.delegate selectedGraphWithData:data];
    }
}

#pragma mark - JPGraphListViewDelegate

- (void)selectedDownloadedGraphWithData:(JPPackagePatternAttribute *)data{
    if ([self.delegate respondsToSelector:@selector(selectedGraphWithData:)]) {
        [self.delegate selectedGraphWithData:data];
    }
}


#pragma mark - JPHotGraphListDelegate

- (void)selectedHotGraphWithData:(JPPackagePatternAttribute *)data{
    if ([self.delegate respondsToSelector:@selector(selectedGraphWithData:)]) {
        [self.delegate selectedGraphWithData:data];
    }
}

- (void)deleteHotGraphWithData:(JPPackagePatternAttribute *)data{
    if ([self.delegate respondsToSelector:@selector(deleteGraphWithData:)]) {
        [self.delegate deleteGraphWithData:data];
    }
}

#pragma mark - actions

- (void)dismiss {
    [JPMaterialDownloader shareInstance].delegate = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(hide)]) {
        [self.delegate hide];
    }
    [gifListView dismiss];
}

- (void)show
{
    if (currrentPage == 3) {
        [gifListView show];
    }
}

@end
