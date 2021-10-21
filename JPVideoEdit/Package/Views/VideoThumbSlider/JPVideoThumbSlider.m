//
//  JPVideoThumbSlider.m
//  jper
//
//  Created by 藩 亜玲 on 2017/5/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPVideoThumbSlider.h"
#import "JPVideoThumbSliderCell.h"

#define VIDEO_THUMB_DURTION   CMTimeMake(4.f, 1)

@interface JPVideoThumbSlider ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView *collecView;
    NSMutableArray *dataArr;
    AVAssetImageGenerator *thumbImageGenerator;
    CMTime videoDuration;
    CMTime totalVideoDuration;

    UIView *trackView;
    UILabel *timeLb;
    UICollectionViewFlowLayout * layout;
    NSMutableArray *reallySourceImage;
    BOOL needScorll;
}

- (void)createUI;
- (void)generateThumImages;
- (void)culculateVideoCurrentTime:(CGFloat)offset;

@end

@implementation JPVideoThumbSlider

- (id)initWithFrame:(CGRect)frame withAsset:(AVAsset *)asset andVideoDuration:(CMTime)dur andTotalDuration:(CMTime)totalDuration{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];
        thumbImageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        thumbImageGenerator.appliesPreferredTrackTransform = YES;
        thumbImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        videoDuration = dur;
        totalVideoDuration = totalDuration;
        dataArr = [NSMutableArray array];
        reallySourceImage = [NSMutableArray array];
        _currentTime = kCMTimeZero;
        [self generateThumImages];

    }
    return self;
}

#pragma mark - 

- (void)createUI {
    @synchronized (self) {
        if (timeLb != nil) {
            return;
        }
        timeLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 12)];
        timeLb.font = [UIFont jp_placardMTStdCondBoldFontWithSize:12];
        timeLb.textColor = [UIColor jp_colorWithHexString:@"525252"];
        timeLb.textAlignment = NSTextAlignmentCenter;
        timeLb.text = @"00:00";
        [self addSubview:timeLb];
        timeLb.sd_layout.topEqualToView(self).leftEqualToView(self).rightEqualToView(self).heightIs(13);
        
        collecView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , self.width,self.height - 10)collectionViewLayout:layout];
        collecView.contentInset = UIEdgeInsetsMake(0, self.width/2, 0, self.width/2);
        collecView.delegate = self;
        collecView.backgroundColor = self.backgroundColor;
        collecView.dataSource = self;
        collecView.bounces = YES;
        collecView.showsHorizontalScrollIndicator = NO;
        collecView.showsVerticalScrollIndicator = NO;
        [collecView registerClass:[JPVideoThumbSliderCell class] forCellWithReuseIdentifier:@"JPVideoThumbSliderCell"];
        [self addSubview:collecView];
    
        collecView.sd_layout.topSpaceToView(timeLb, 12).leftEqualToView(self).rightEqualToView(self).bottomSpaceToView(self, 5);
        
        trackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, collecView.height + 10)];
        [self addSubview:trackView];
        trackView.sd_layout.centerXEqualToView(self).widthIs(10).heightIs(50).centerYEqualToView(collecView);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, trackView.height)];
        lineView.backgroundColor = [UIColor whiteColor];
        [trackView addSubview:lineView];
        lineView.sd_layout.centerXEqualToView(trackView).widthIs(1).topEqualToView(trackView).bottomEqualToView(trackView);
        
        [collecView reloadData];

    }
}

- (void)generateThumImages {
    if (!thumbImageGenerator) {
        return;
    }
    
        
        
    dispatch_queue_t aHQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    dispatch_async(aHQueue, ^{
        @autoreleasepool {

        self->thumbImageGenerator.maximumSize = CGSizeMake(10000, (40));
        CMTime startTime = kCMTimeZero;
        CMTime actualTime;
        NSError *error = nil;
        CGImageRef halfWayImage = [self->thumbImageGenerator copyCGImageAtTime:startTime actualTime: &actualTime error: &error];
        if (halfWayImage) {
            UIImage *thumbnail = [[UIImage alloc] initWithCGImage:halfWayImage];
            [self->dataArr addObject:thumbnail];
            [self->reallySourceImage addObject:thumbnail];
            CGImageRelease(halfWayImage);
            CGSize size = thumbnail.size;
            self->layout = [[UICollectionViewFlowLayout alloc]init];
            //设置布局方向为垂直流布局
            self->layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            self->layout.itemSize = size;
            self->layout.minimumInteritemSpacing = 0;
            CMTime duration = CMTimeMultiplyByFloat64(CMTimeMake(1, 30), size.width / 2.0);
            startTime = CMTimeAdd(startTime, duration);
            CMTime totalDuration = self->totalVideoDuration;
            while (CMTimeCompare(totalDuration, startTime) >= 0) {
                CGImageRef halfWayImage = [self->thumbImageGenerator copyCGImageAtTime:startTime actualTime: &actualTime error: &error];
                if (halfWayImage) {
                    UIImage *thumbnail = [[UIImage alloc] initWithCGImage:halfWayImage];
                    [self->dataArr addObject:thumbnail];
                    if (CMTimeCompare(self->videoDuration, startTime) >= 0) {
                        [self->reallySourceImage addObject:thumbnail];
                    }
                    if (self->dataArr.count * size.width >= JP_SCREEN_WIDTH / 2.0 && self->collecView == nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self createUI];
                        });
                    }else{
                        if (self->dataArr.count % 10 == 9) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (self->collecView == nil) {
                                    [self createUI];
                                }else{
                                    [self->collecView reloadData];
                                }
                            });
                        }
                    }
                    CGImageRelease(halfWayImage);
                }
                startTime = CMTimeAdd(startTime, duration);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->collecView == nil) {
                    [self createUI];
                }else{
                    [self->collecView reloadData];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(compositionAssetDidLoad:)]) {
                    [self.delegate compositionAssetDidLoad:self->dataArr];
                    
                }
            });
        }
        }
    });
}
- (void)scrollToTime:(CMTime)time
{
    if (needScorll == YES) {
        return;
    }
    _currentTime = time;
    Float64 duration = CMTimeGetSeconds(time);
    NSInteger reallyPixel = (NSInteger)floor(duration * 30) * 2;
    if (CMTimeCompare(time, videoDuration) >= 0) {
        reallyPixel = reallySourceImage.count * layout.itemSize.width;
    }
    [collecView setContentOffset:CGPointMake(reallyPixel - self.width / 2.0, 0) animated:NO];
      timeLb.text = [JPUtil formatSecond:CMTimeGetSeconds(time)];
}

- (void)culculateVideoCurrentTime:(CGFloat)offset {
    //scrollview拖拽的实际距离
    CGFloat actualDistance = self.width/2+offset;
    if (actualDistance < 0) {
        return;
    }
    NSInteger reallyPixel = (NSInteger)floor(actualDistance);
    CMTime currentVideoTime = CMTimeMultiply(CMTimeMake(1, 30), reallyPixel / 2);
    if (CMTimeCompare(kCMTimeZero, currentVideoTime) >= 0) {
        currentVideoTime = kCMTimeZero;
    }else if (CMTimeCompare(videoDuration, currentVideoTime) <= 0){
        currentVideoTime = videoDuration;
    }
    _currentTime = currentVideoTime;
    timeLb.text = [JPUtil formatSecond:CMTimeGetSeconds(currentVideoTime)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangedToTime:)]) {
            [self.delegate didChangedToTime:currentVideoTime];
    }
   
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [reallySourceImage count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPVideoThumbSliderCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"JPVideoThumbSliderCell" forIndexPath:indexPath];
    cell.imgView.image = (UIImage *)[reallySourceImage objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - UICollectionViewDelegateFlowLayout


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        needScorll = NO;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    needScorll = YES;
    [self culculateVideoCurrentTime:scrollView.contentOffset.x];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (needScorll == YES) {
        [self culculateVideoCurrentTime:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    needScorll = NO;
}

@end
