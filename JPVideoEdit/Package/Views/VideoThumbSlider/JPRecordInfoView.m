//
//  JPRecordInfoView.m
//  jper
//
//  Created by FoundaoTEST on 2017/5/15.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPRecordInfoView.h"

@interface JPRecordInfoView (){
    CGFloat maxLength;
    JPVideoRecordInfo *recordInfo;
}
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *imageBackView;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation JPRecordInfoView

- (instancetype)initWithAudioModel:(JPAudioModel *)audioModel
                      andMaxLength:(CGFloat)w
                     andRecordInfo:(JPVideoRecordInfo *)info
{
   
    if (self = [self initWithFrame:[self calculateFrameWithAudioModel:audioModel andMaxLength:w andRecordInfo:info]]) {
        self.audioModel = audioModel;
        [self createSubviews];
    }
    return self;
    
}

- (CGRect)calculateFrameWithAudioModel:(JPAudioModel *)audioModel
                          andMaxLength:(CGFloat)w
                         andRecordInfo:(JPVideoRecordInfo *)info
{
    maxLength = w;
    recordInfo = info;
    Float64 videoDuration = CMTimeGetSeconds(recordInfo.totalVideoDuraion);
    Float64 duration = CMTimeGetSeconds(audioModel.durationTime);
    CGFloat pixelPerSecends = maxLength/videoDuration;
    Float64 start = CMTimeGetSeconds(audioModel.startTime);
    NSInteger reallyPixel = (NSInteger)floor(start * pixelPerSecends);
    
    NSInteger durationPixel = (NSInteger)floor(duration * pixelPerSecends);
    CMTime dur = CMTimeAdd(audioModel.durationTime, audioModel.startTime);
    if (0 >= CMTimeCompare(recordInfo.totalVideoDuraion, CMTimeAdd(dur, CMTimeMake(1, 3)))) {
        durationPixel = maxLength - reallyPixel;
    }
    return CGRectMake(reallyPixel, 0, durationPixel, 75);
}

- (void)createSubviews
{
    self.imageArray = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 12.5, self.width, 50)];
    self.backView.backgroundColor = [[UIColor jp_colorWithHexString:@"101010"] colorWithAlphaComponent:0.4];
    [self addSubview:self.backView];
    UIView *imageBcakView = [[UIView alloc] initWithFrame:CGRectMake(6, 0, self.backView.width - 12, 50)];
    imageBcakView.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:imageBcakView];
    imageBcakView.clipsToBounds = YES;
    imageBcakView.sd_layout.rightSpaceToView(self.backView, 6).topEqualToView(self.backView).bottomEqualToView(self.backView).leftSpaceToView(self.backView, 6);
    self.imageBackView = imageBcakView;
    CGFloat imageWidth = self.width - 12;
    if (imageWidth < 0) {
        return;
    }else
    {
        NSInteger count = (NSInteger)ceil(imageWidth / 100.0f);
        for (NSInteger index = 0; index < count; index ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100 * index, (50 - 12.5) / 2.0, 100, 12.5)];
            imageView.image = JPImageWithName(@"voiceline");
            [imageBcakView addSubview:imageView];
            [self.imageArray addObject:imageView];
        }
    }
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, self.width, 16)];
    self.timeLabel.textColor = [UIColor jp_colorWithHexString:@"787878"];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:12];
    [self addSubview:self.timeLabel];
    self.timeLabel.sd_layout.topSpaceToView(self, 63).bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
    self.isSelect = NO;
    self.timeLabel.text = [NSString stringWithFormat:@"%lds", (NSInteger)ceil(CMTimeGetSeconds(self.audioModel.durationTime))];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheSelf)];
    [self.backView addGestureRecognizer:tap];
    self.backView.layer.borderColor = [UIColor jp_colorWithHexString:@"0091FF"].CGColor;
}

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (_isSelect == NO) {
        self.backView.layer.borderWidth = 0;
    }else{
        self.backView.layer.borderWidth = 1.5;
        self.backView.layer.borderColor = [UIColor jp_colorWithHexString:@"0091FF"].CGColor;
    }
}

- (void)tapTheSelf
{
    self.isSelect = !_isSelect;
    if (self.delegate) {
        if (self.isSelect) {
            [self.delegate recordInfoViewNeedSelect:self];
        }else{
            [self.delegate recordInfoViewNeddDeselect:self];
        }
    }
}
- (void)updateFrameWithMaxLength:(CGFloat)w andRecordInfo:(JPVideoRecordInfo *)info
{
    if (CMTimeCompare(self.audioModel.durationTime, kCMTimeZero) <= 0) {
        [info deleteAudioFile:self.audioModel];
        self.width = 0;
        return;
    }
    self.frame = [self calculateFrameWithAudioModel:self.audioModel andMaxLength:w andRecordInfo:info];
    self.backView.frame = CGRectMake(0, 12.5, self.width, 50);
    self.timeLabel.text = [NSString stringWithFormat:@"%lds", (NSInteger)ceil(CMTimeGetSeconds(self.audioModel.durationTime))];
    CGFloat imageWidth = self.width - 12;
    NSMutableArray *deleImageArr = [NSMutableArray array];
    for (UIImageView *imageView in self.imageArray) {
        if (imageView.left > imageWidth) {
            [deleImageArr addObject:imageView];
        }
    }
    [self.imageArray removeObjectsInArray:deleImageArr];
    
}
@end
