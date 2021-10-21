//
//  JPCameraSettingView.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPCameraSettingView.h"
#import "JPCameraSettingCollectionViewCell.h"
#import "JPHowFastCollectionViewCell.h"

static NSString *JPCameraSettingViewIdentifier = @"JPCameraSettingViewIdentifier";
static NSString *JPHowFastViewIdentifier = @"JPHowFastViewIdentifier";



@interface JPVideoFrameModel : NSObject
@property (nonatomic) JPVideoAspectRatio aspectRatio;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *selectImageName;
@property (nonatomic, strong) NSString *disableImageName;

@end

@implementation JPVideoFrameModel

+ (NSArray<JPVideoFrameModel *>*)getAllFrameModel
{
    NSMutableArray *daraArr = [NSMutableArray array];
    for (NSInteger index = 1; index <= 5; index ++) {
        JPVideoFrameModel *model = [[JPVideoFrameModel alloc] init];
        model.aspectRatio = index;
        switch (model.aspectRatio) {
            case JPVideoAspectRatio1X1:
                model.name = @"1:1";
                model.imageName = @"1:1_nm";
                model.selectImageName = @"1:1_hl";
                model.disableImageName = @"1:1_nm";//gray
                [daraArr addObject:model];
                break;
            case JPVideoAspectRatio16X9:
                model.name = @"16:9";
                model.imageName = @"16:9_nm";
                model.selectImageName = @"16:9_hl";
                model.disableImageName = @"16:9_nm";
                [daraArr addObject:model];
                break;
            case JPVideoAspectRatio9X16:
                model.name = @"9:16";
                model.imageName = @"9:16_nm";
                model.selectImageName = @"9:16_hl";
                model.disableImageName = @"vertical-grey";
                break;
            case JPVideoAspectRatio4X3:
                model.name = @"4:3";
                model.imageName = @"4:3_nm";
                model.selectImageName = @"4:3_hl";
                model.disableImageName = @"4:3_nm";
                [daraArr addObject:model];
                break;
            case JPVideoAspectRatioCircular:
                model.name = @"圆";
                model.imageName = @"circular-off";
                model.selectImageName = @"circular-on";
                model.disableImageName = @"circular-grey";
                break;

            default:
                break;
        }
        
    }
    return [daraArr copy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"--%@---%d", NSStringFromClass([self class]), self.aspectRatio];
}

@end

@interface JPVideoFastModel : NSObject
@property (nonatomic) JPVideoHowFast fastType;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;

@end

@implementation JPVideoFastModel

+ (NSArray<JPVideoFastModel *>*)getAllFastModel
{
    NSMutableArray *daraArr = [NSMutableArray array];
    for (NSInteger index = 0; index < 3; index ++) {
        JPVideoFastModel *model = [[JPVideoFastModel alloc] init];
        model.fastType = index;
        switch (model.fastType) {
            case JPVideoHowFastSlow:
                model.imageName = @"speed_slow";
                model.title = @"慢速";
                break;
            case JPVideoHowFastNormal:
                model.imageName = @"speed_normal";
                model.title = @"正常";
                break;
            case JPVideoHowFastFast:
                model.imageName = @"speed_fast";
                model.title = @"快速";
                break;
            default:
                break;
        }
        if (model.fastType == JPVideoHowFastSlow) {
            [daraArr insertObject:model atIndex:0];
        }else{
            [daraArr addObject:model];
        }
        
    }
    return [daraArr copy];
}


@end

@interface JPCameraSettingView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *lightButton;
@property (weak, nonatomic) IBOutlet UIButton *frameButton;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isFront;
@property (nonatomic, assign) BOOL isCurrentFrame;
@property (nonatomic, assign) BOOL isOpenLight;
@property (nonatomic, strong) NSMutableArray *howFastArr;
@property (weak, nonatomic) IBOutlet UIButton *howFastButton;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) BOOL isOpenFilters;
@property (nonatomic, weak) JPVideoFastModel *selectFastModel;
@property (nonatomic, weak) JPVideoFrameModel *selectFrameModel;

@end
@implementation JPCameraSettingView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _viewWidth = (JP_SCREEN_WIDTH - 30);
    _isOpenLight = NO;
    _isFront = NO;
    _isOpenFilters = NO;
    [JPResourceBundle loadNibNamed:@"JPCameraSettingView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    self.view.sd_layout.topEqualToView(self).bottomEqualToView(self).topEqualToView(self).rightEqualToView(self);
    self.collectionView.backgroundColor = [UIColor jp_colorWithHexString:@"ffffff" alpha:0.13];
    self.collectionView.layer.cornerRadius = 2;
    self.collectionView.layer.masksToBounds = YES;
    _dataArr = [[JPVideoFrameModel getAllFrameModel] mutableCopy];
    _howFastArr = [[JPVideoFastModel getAllFastModel] mutableCopy];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"JPCameraSettingCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:JPCameraSettingViewIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JPHowFastCollectionViewCell" bundle:JPResourceBundle] forCellWithReuseIdentifier:JPHowFastViewIdentifier];

    _collectionViewFlowLayout.itemSize = CGSizeMake(86 , 30);
    [self.howFastButton jp_layoutButtonWithEdgeInsetsStyle:JPButtonEdgeInsetsStyleTop imageTitleSpace:6];
    [self.cameraButton jp_layoutButtonWithEdgeInsetsStyle:JPButtonEdgeInsetsStyleTop imageTitleSpace:6];
    [self.filterButton  jp_layoutButtonWithEdgeInsetsStyle:JPButtonEdgeInsetsStyleTop imageTitleSpace:6];
    [self.lightButton jp_layoutButtonWithEdgeInsetsStyle:JPButtonEdgeInsetsStyleTop imageTitleSpace:6];
    [self.frameButton jp_layoutButtonWithEdgeInsetsStyle:JPButtonEdgeInsetsStyleTop imageTitleSpace:6];
}


- (void)startFilters
{
    [self changeFilterAction:nil];
}
- (IBAction)changeFilterAction:(id)sender {
    _isOpenFilters = !_isOpenFilters;
    if (self.delegate) {
        [self.delegate cameraSettingViewDidChangeFilter:_isOpenFilters];
    }
    _filterButton.selected = _isOpenFilters;

}


- (void)takeBackFilters
{
    if (_isOpenFilters == YES) {
        _isOpenFilters = NO;
        if (self.delegate) {
            [self.delegate cameraSettingViewDidChangeFilter:_isOpenFilters];
        }
        _filterButton.selected = _isOpenFilters;
    }
}

- (IBAction)switchCameraSession:(id)sender {
    [self takeBackFilters];
    if (_isOpenLight == YES) {
        [self switchLight:nil];
    }
    _isFront = !_isFront;
    _cameraButton.selected = _isFront;
    self.lightButton.enabled = !_isFront;
    
    if (self.delegate) {
        [self.delegate cameraSettingViewDidChangeCameraSession];
    }
}
- (IBAction)switchLight:(id)sender {
    if (_isFront == YES) {
        return;
    }
    [self takeBackFilters];
    _isOpenLight = !_isOpenLight;
    self.lightButton.enabled = YES;
    self.lightButton.selected = _isOpenLight;
    [self.delegate cameraSettingViewDidChangeOpenLight:_isOpenLight];
}

- (IBAction)changeVideoFrame:(id)sender {
    [self takeBackFilters];
    self.isCurrentFrame = YES;
    _collectionViewFlowLayout.itemSize = CGSizeMake(86 , 34);

    [self.collectionView reloadData];
    
    [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraSettingViewWillChangeVideoFrame)]) {
        [self.delegate cameraSettingViewWillChangeVideoFrame];
    }
}
- (void)hasRecord
{
    JPVideoFrameModel *videoFastModel = _selectFrameModel ? _selectFrameModel : _dataArr.firstObject;
    _frameButton.enabled = NO;
    [_frameButton setImage:JPImageWithName(videoFastModel.disableImageName) forState:UIControlStateNormal];
//    _filterButton.enabled = NO;
//    [_filterButton setImage:JPImageWithName(@"Filter-grey") forState:UIControlStateNormal];
    _isOpenFilters = NO;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)startRecord
{
    JPVideoFrameModel *videoFastModel = _selectFrameModel ? _selectFrameModel : _dataArr.firstObject;
    _frameButton.enabled = YES;
    [_frameButton setImage:JPImageWithName(videoFastModel.selectImageName) forState:UIControlStateNormal];
    _filterButton.enabled = YES;
    _filterButton.selected = NO;
    _isOpenFilters = NO;
}
- (IBAction)howFastTypeChange:(id)sender {
    [self takeBackFilters];
    self.isCurrentFrame = NO;
    _collectionViewFlowLayout.itemSize = CGSizeMake(86 , 34);
    [self.collectionView reloadData];
    [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraSettingViewWillChangeVideoHowFast)]) {
        [self.delegate cameraSettingViewWillChangeVideoHowFast];
    }
}

#pragma mark UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _isCurrentFrame ? _dataArr.count : _howFastArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (_isCurrentFrame) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:JPCameraSettingViewIdentifier forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:JPHowFastViewIdentifier forIndexPath:indexPath];
    }
    id model = _isCurrentFrame ? _dataArr[indexPath.row] : _howFastArr[indexPath.row];
    if (!_isCurrentFrame) {
        JPHowFastCollectionViewCell *howFastCell = (JPHowFastCollectionViewCell *)cell;

        JPVideoFastModel *fastModel = (JPVideoFastModel *)model;
        howFastCell.textLabel.text = fastModel.title;
        if (_selectFastModel == nil){
            if (indexPath.row == 1){
                howFastCell.textLabel.textColor = [UIColor jp_colorWithHexString:@"0091FF"];
                [howFastCell selected:YES];
            }else{
                howFastCell.textLabel.textColor = [UIColor jp_colorWithHexString:@"ffffff"];
                [howFastCell selected:NO];
            }
        }else{
            if(_selectFastModel.fastType == fastModel.fastType) {
                howFastCell.textLabel.textColor = [UIColor jp_colorWithHexString:@"0091FF"];
                [howFastCell selected:YES];
            }else{
                howFastCell.textLabel.textColor = [UIColor jp_colorWithHexString:@"ffffff"];
                [howFastCell selected:NO];
            }
        }
       
    }else{
        JPCameraSettingCollectionViewCell *cameraCell = (JPCameraSettingCollectionViewCell *)cell;
        JPVideoFrameModel *frameModel = (JPVideoFrameModel *)model;
        cameraCell.name = frameModel.name;
//        cameraCell.contentImageView.image = JPImageWithName(frameModel.imageName);
        if ((_selectFrameModel == nil && indexPath.row == 0) || (_selectFrameModel.aspectRatio == frameModel.aspectRatio)) {
            [cameraCell selected:YES];
//            cameraCell.contentImageView.image = JPImageWithName(frameModel.selectImageName);
        }else{
            [cameraCell selected:NO];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id model = _isCurrentFrame ? _dataArr[indexPath.row] : _howFastArr[indexPath.row];
    if ([model isKindOfClass:[JPVideoFastModel class]]) {
        JPVideoFastModel *fastModel = (JPVideoFastModel *)model;
        if (self.delegate && [self.delegate respondsToSelector:@selector(cameraSettingViewDidChangeVideoHowFast:)]) {
            _cameraButton.enabled = !(fastModel.fastType == JPVideoHowFastSlow);
            [self.delegate cameraSettingViewDidChangeVideoHowFast:fastModel.fastType];
        }
        [_howFastButton setImage:JPImageWithName(fastModel.imageName) forState:UIControlStateNormal];
        _selectFastModel = fastModel;
    }else{
        JPVideoFrameModel *frameModel = (JPVideoFrameModel *)model;
        if (self.delegate) {
            [self.delegate cameraSettingViewDidChangeVideoFrame:frameModel.aspectRatio];
        }
        [_frameButton setImage:JPImageWithName(frameModel.selectImageName) forState:UIControlStateNormal];
        _selectFrameModel = frameModel;
    }
    [self.collectionView reloadData];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)setSupportSlow:(BOOL)supportSlow
{
    _supportSlow = supportSlow;
    _howFastArr = [JPVideoFastModel getAllFastModel].mutableCopy;
    if (_supportSlow == NO) {
        [_howFastArr removeObjectAtIndex:2];
    }
    _collectionViewFlowLayout.itemSize = CGSizeMake(_viewWidth / _howFastArr.count , 34);
    [self.collectionView reloadData];
}
- (void)setRecordInfo:(JPVideoRecordInfo *)recordInfo
{
    _recordInfo = recordInfo;
    NSInteger selecIndex = 0;
    for (NSInteger index = 0; index < _dataArr.count; index ++) {
        JPVideoFrameModel *model = _dataArr[index];
        if (model.aspectRatio == recordInfo.aspectRatio) {
            selecIndex = index;
            [_frameButton setImage:JPImageWithName(model.selectImageName) forState:UIControlStateNormal];
            _selectFrameModel = model;
            break;
        }
    }
    [_collectionView reloadData];
}

- (void)settingCameraViewBeRecording
{
    _filterButton.enabled = YES;
    _filterButton.selected = NO;
}

@end
