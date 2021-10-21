//
//  JPAddAudioTrackMenu.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/17.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPMusicMenuView.h"
#import "UIImageView+WebCache.h"
#import "JPBackgroundMusicCell.h"
#import "JPMaterialCategory.h"
#import "TAPageControl.h"
#import "JPUtil.h"

@interface JPMusicMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView *collectView;
    NSMutableArray *dataArr;
    JPAudioModel *recordedAudioModel;
    CABasicAnimation* rotationAnimation;
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UIImageView *musicImageView;
@property (nonatomic, weak) IBOutlet UIButton *deleteBtn;
@property (nonatomic, weak) IBOutlet UILabel *musicNameLb;
@property (nonatomic, weak) IBOutlet UILabel *alertLb;
@property (nonatomic, weak) IBOutlet UILabel *originLb;
@property (nonatomic, weak) IBOutlet UILabel *volumeLb;
@property (nonatomic, weak) IBOutlet UILabel *musicDurLb;
@property (nonatomic, weak) IBOutlet UILabel *volumeDesLb;
@property (nonatomic, weak) IBOutlet UIView *bottomLineView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIView *volumeThumView;
@property (nonatomic, weak) IBOutlet UIView *volumeThumContentView;
@property (nonatomic, weak) IBOutlet UIView *volumeBgView;
@property (nonatomic, weak) IBOutlet UIView *descView;
@property (nonatomic, weak) IBOutlet UIView *volumeView;
@property (nonatomic, strong) UIView *volumeTackView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *musicNameLbWidthLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *musicImageViewWidthLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *musicImageViewHeightLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLineOriYLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *volumeThumViewLeftLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descViewTopLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descViewHeightLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *alertLbTopLayoutConstraint;

@property (nonatomic, strong) UICollectionView * collecView;
@property (nonatomic, strong) UIView * bottomCollecView;

@property (nonatomic, assign) BOOL dataLoad;

- (void)createUI;
- (IBAction)delete:(id)sender;
- (void)deleteMusic:(BOOL)delete;
- (void)getCategoryList;
- (void)updateUI;
@end

@implementation JPMusicMenuView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        dataArr = [NSMutableArray array];
        [self getCategoryList];
    }
    return self;
}

#pragma mark - public methods

- (void)getCategoryList {
    self.dataLoad = NO;
//    NSMutableDictionary *dic = @{@"service":@"App.Material_Music.Lists"}.mutableCopy;
//    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response){
//        if (response.ret && 200 == [response.ret intValue]) {
//            if (response.data && [response.data isKindOfClass:[NSArray class]]) {
//                for (int i = 0; i < [response.data count]; i ++) {
//                    if ([[response.data objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
//                        JPMaterialCategory *category = [JPMaterialCategory mj_objectWithKeyValues:[response.data objectAtIndex:i]];
//                        category.material_id = 2;
//                        [dataArr sgrAddObject:category];
//                    }
//                }
//            }
//        }
        [self createUI];
    
//    }failure:^(NSError *error){
//        [self createUI];
//        
//    } withErrorMsg:nil];
}

- (void)createUI {
    if ([self.delegate respondsToSelector:@selector(musicCollectionLoadData)]) {
        [self.delegate musicCollectionLoadData];
    }
    self.dataLoad = YES;
    [JPResourceBundle loadNibNamed:@"JPMusicMenuView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topSpaceToView(self, 0).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
    self.view.clipsToBounds = YES;
    self.bottomLineOriYLayoutConstraint.constant = JPScreenFitFloat6(120);
    self.musicImageViewWidthLayoutConstraint.constant = self.musicImageViewHeightLayoutConstraint.constant = JPScreenFitFloat6(201);
    
    self.alertLbTopLayoutConstraint.constant = (JPScreenFitFloat6(120) - 13)/2;
    
    _volumeThumViewLeftLayoutConstraint.constant = 121;
    _volumeThumContentView.transform = CGAffineTransformMakeScale(0.5 * 0.5 + 0.5, 0.5 * 0.5 + 0.5);
    _volumeLb.text = [NSString stringWithFormat:@"%d%%",(int)(0.5*100)];
    //隐藏音量调整
    self.volumeView.hidden = YES;
    /*隐藏音量调整
    self.volumeTackView = [[UIView alloc] initWithFrame:CGRectZero];
    self.volumeTackView.backgroundColor = [UIColor whiteColor];
    [self.volumeView addSubview:self.volumeTackView];
    [self.volumeView insertSubview:self.volumeTackView belowSubview:self.volumeThumView];
    self.volumeTackView.sd_layout.leftSpaceToView(self.volumeView, 60).rightSpaceToView(self.volumeThumView, -10).heightIs(1).centerYEqualToView(self.volumeBgView);
     */
    
    _volumeThumContentView.layer.masksToBounds = YES;
    _volumeThumContentView.layer.borderWidth = 1;
    _volumeThumContentView.layer.borderColor = [UIColor whiteColor].CGColor;
    _volumeThumContentView.layer.cornerRadius = 10;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.bottomLineOriYLayoutConstraint.constant = 115;
        self.musicImageViewWidthLayoutConstraint.constant = self.musicImageViewHeightLayoutConstraint.constant = 201;
    }

    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanAction:)];
    rightPan.minimumNumberOfTouches = 1;
    rightPan.maximumNumberOfTouches = 5;
    [_volumeThumView addGestureRecognizer:rightPan];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor clearColor];
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.showsHorizontalScrollIndicator = NO;
    collectView.showsVerticalScrollIndicator = NO;
    [collectView registerClass:[JPBackgroundMusicCell class] forCellWithReuseIdentifier:@"JPBackgroundMusicCell"];
    [self.bottomView addSubview:collectView];
    self.bottomView.clipsToBounds = NO;
    collectView.sd_layout.leftSpaceToView(self.bottomView, 0).rightSpaceToView(self.bottomView, 0).topSpaceToView(self.bottomView, JPScreenFitFloat6(7)).bottomEqualToView(self.bottomView);
    [self updateUI];
    self.bottomCollecView = self.bottomView;
    self.collecView = collectView;
    self.collecView.clipsToBounds = NO;
    self.clipsToBounds = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate  respondsToSelector:@selector(musicCollectionViewScrollViewDidScroll:)] && scrollView == collectView) {
        [self.delegate musicCollectionViewScrollViewDidScroll:collectView];
    }
}

- (void)startPlay
{
    if (self.superview != nil && _selectAudioModel) {
        if (!rotationAnimation) {
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 1.0;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = MAXFLOAT;
        }
        if (![[_musicImageView.layer animationKeys] containsObject:@"rotationAnimation"]) {
            [_musicImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        }
    }else{
        if ([[_musicImageView.layer animationKeys] containsObject:@"rotationAnimation"]) {
            [_musicImageView.layer removeAnimationForKey:@"rotationAnimation"];
        }
    }
}
- (void)endPlay
{
    if ([[_musicImageView.layer animationKeys] containsObject:@"rotationAnimation"]) {
        [_musicImageView.layer removeAnimationForKey:@"rotationAnimation"];
    }

}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArr count]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPBackgroundMusicCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPBackgroundMusicCell" forIndexPath:indexPath];
    if (0 == indexPath.row) {
        cell.imgView.image = JPImageWithName(@"itunes");
        cell.txtLb.text = @"iTunes";
    } else {
        JPMaterialCategory *music = [dataArr objectAtIndex:indexPath.row - 1];
        if (music.material_type_icon) {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:music.material_type_icon] placeholderImage:nil];
            cell.txtLb.text = music.material_type_name;
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        JPAudioModel *model = [[JPAudioModel alloc] init];
        model.isITunes = YES;
        model.fileName = @"";
        model.theme = @"";
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedBackgroundMusicModel:)]) {
            [self.delegate selectedBackgroundMusicModel:model];
        }
    } else {
        JPMaterialCategory *category = [dataArr objectAtIndex:indexPath.row - 1];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMaterialCategory:)]) {
            [self.delegate didSelectedMaterialCategory:category];
        }
    }
    if ([self.delegate respondsToSelector:@selector(musicCollectionViewItemDidSelected)]) {
        [self.delegate musicCollectionViewItemDidSelected];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(JPScreenFitFloat6(80), collectionView.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0.f, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

#pragma mark - actions

- (void)rightPanAction:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.volumeThumView];
        CGFloat consant = _volumeThumViewLeftLayoutConstraint.constant + point.x;
        if (consant < 11) {
            consant = 11;
        }
        if (consant > 11 + _volumeBgView.width) {
            consant = 11 + _volumeBgView.width;
        }
        [self updateFontWithConstant:consant - 11];
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self.volumeThumView];
    if (UIGestureRecognizerStateEnded == pan.state || UIGestureRecognizerStateCancelled == pan.state) {
        
    }
}

- (void)updateFontWithConstant:(CGFloat)constant{
    _volumeThumViewLeftLayoutConstraint.constant = constant + 11;
    CGFloat volume = constant / _volumeBgView.width;
    _volumeThumContentView.transform = CGAffineTransformMakeScale(volume * 0.5 + 0.5, volume * 0.5 + 0.5);
    _selectAudioModel.volume = volume;
    _volumeLb.text = [NSString stringWithFormat:@"%d%%",(int)(volume*100)];
}

- (void)dismiss {
    
}

- (void)deleteMusic:(BOOL)delete {
    _originLb.hidden = delete;
    _deleteBtn.hidden = delete;
    _deleteBtn.enabled = !delete;
    _musicNameLb.hidden = delete;
    _musicDurLb.hidden = delete;
    _alertLb.hidden = !delete;
    _volumeLb.hidden = delete;
    _volumeBgView.hidden = delete;
    _volumeTackView.hidden = delete;
    _volumeThumView.hidden = delete;
    _volumeDesLb.hidden = delete;
}

- (IBAction)delete:(id)sender {
    self.selectAudioModel = nil;
    self.descViewTopLayoutConstraint.constant = - self.descViewHeightLayoutConstraint.constant - self.descViewTopLayoutConstraint.constant;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finish){
        self.originLb.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.deleteBtn.enabled = NO;
        self.musicNameLb.hidden = YES;
        self.musicDurLb.hidden = YES;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteBackgroundMusic)]) {
        [self.delegate didDeleteBackgroundMusic];
    }
}

- (void)updateUI {
    if (!_selectAudioModel) {
        [self deleteMusic:YES];
        return;
    }
    [self deleteMusic:NO];
    _originLb.hidden = YES;
    if (self.descViewTopLayoutConstraint.constant < 0) {
        self.descViewTopLayoutConstraint.constant = 25;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }completion:^(BOOL finish){
            
        }];
    }
    if (_selectAudioModel.isITunes && _selectAudioModel.fileUrl) {
        _originLb.hidden = NO;
    } else {
        _originLb.hidden = YES;
    }
    _volumeThumViewLeftLayoutConstraint.constant = _selectAudioModel.volume*_volumeBgView.width + 11;
    _volumeThumContentView.transform = CGAffineTransformMakeScale(_selectAudioModel.volume * 0.5 + 0.5, _selectAudioModel.volume * 0.5 + 0.5);
    _volumeLb.text = [NSString stringWithFormat:@"%d%%",(int)(_selectAudioModel.volume*100)];
    _musicNameLb.text = _selectAudioModel.fileName;
    _musicNameLbWidthLayoutConstraint.constant = ceilf([JPUtil getStringSizeWith:_musicNameLb.font
                                                                andContainerSize:CGSizeMake(1000, 14)
                                                                       andString:_musicNameLb.text].width);
    _musicDurLb.text = [NSString stringWithTimeInterval:CMTimeGetSeconds(_selectAudioModel.durationTime)];
}

- (void)setSelectAudioModel:(JPAudioModel *)selectAudioModel{
    _selectAudioModel = selectAudioModel;
    [self updateUI];
}


@end
