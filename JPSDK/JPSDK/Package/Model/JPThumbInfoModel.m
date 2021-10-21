//
//  JPThumbInfoModel.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPThumbInfoModel.h"
#import "JPTranstionsModelManager.h"

@implementation JPThumbInfoModel

//@property (nonatomic, assign, readonly) CGFloat width;
//@property (nonatomic, assign, readonly) CMTime videoDuration;
//@property (nonatomic, assign, readonly) CMTime reallyDuration;
//@property (nonatomic, weak) JPVideoModel *videoModel;
//@property (nonatomic, strong, readonly) NSArray *thumbImageArr;
//@property (nonatomic, assign) CGFloat contentOffset;
//@property (nonatomic, readonly) JPVideoTranstionType transtionType;
//@property (nonatomic, assign, readonly) CGSize imageSize;
//@property (nonatomic, assign, readonly) NSInteger count;
//@property (nonatomic, assign, readonly) NSInteger imageStartIndex;
//@property (nonatomic, assign) BOOL isSelect;
//@property (nonatomic, assign, readonly) CMTime startTime;

- (void)setVideoModel:(JPVideoModel *)videoModel
{
    _videoModel = videoModel;
    _startTime = videoModel.videoStartTime;
    _totalDuration = _videoModel.videoTime;
    _videoDuration = videoModel.timeRange.duration;
    _reallyDuration = CMTimeMultiplyByFloat64(_videoDuration, videoModel.radios);
    if (_isLast == YES) {
        _reallyDuration = CMTimeSubtract(_reallyDuration, JPVideoEndTransitionTime);
    }else if (videoModel.transtionType != 0)
    {
        _reallyDuration = CMTimeSubtract(_reallyDuration,JPVideoTranstionTime);
    }
    _transtionModel = videoModel.transtionModel;
    if (_transtionModel == nil) {
        _transtionModel = [JPTranstionsModelManager getAllTranstionsModels].firstObject;
    }
    Float64 duration = CMTimeGetSeconds(_videoDuration);
    NSInteger reallyPixel = (NSInteger)floor(duration * 30) * 2;
    _width = reallyPixel;
    _imageSize = videoModel.imageSize;
    duration = CMTimeGetSeconds(_totalDuration);
    reallyPixel = (NSInteger)floor(duration * 30) * 2;
    _count = ceil(reallyPixel / _imageSize.width);
    duration = CMTimeGetSeconds(_videoModel.timeRange.start);
    reallyPixel = (NSInteger)floor(duration * 30) * 2;
    _startPoint = reallyPixel;
    _imageStartIndex = floor((CGFloat)reallyPixel / _imageSize.width);
    _transtionPlaceWidth = 60;
    _thumbImageArr = videoModel.thumbImages.copy;
}

- (NSArray *)thumbImageArr
{
    return _thumbImageArr;
}

@end
