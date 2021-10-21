//
//  JPVideoRecordProgressView.m
//  jper
//
//  Created by FoundaoTEST on 2017/3/28.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPVideoRecordProgressView.h"

@interface JPVideoRecordProgressView ()
@property (nonatomic, strong) NSMutableArray *totalViewArray;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *totalProgressView;
@end
@implementation JPVideoRecordProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor jp_colorWithHexString:@"ffffff" alpha:0.2];
    _totalViewArray = [NSMutableArray array];
}

- (void)setRecordInfo:(JPVideoRecordInfo *)recordInfo
{
    _recordInfo = recordInfo;
    for (NSDictionary *viewInfo in _totalViewArray) {
        UIView *backView = [viewInfo objectForKey:@"view"];
        [backView removeFromSuperview];
    }
    [_totalViewArray removeAllObjects];
    NSInteger index = _totalViewArray.count;
    for (JPVideoModel *model in _recordInfo.videoSource) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic sgrSetObject:model forKey:@"model"];
        [dic sgrSetObject:model.videoUrl.path forKey:@"urlPath"];
        [_totalViewArray addObject:dic];
    }
    [self addVideoWhthIndex:index];
}

- (void)changeProgress:(CGFloat)progress
{
    if (_totalProgressView == nil) {
        for (NSDictionary *viewInfo in _totalViewArray) {
            UIView *backView = [viewInfo objectForKey:@"view"];
            [backView removeFromSuperview];
        }
        [_totalViewArray removeAllObjects];
        _totalProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
        _totalProgressView.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
        [self addSubview:_totalProgressView];
    }
    _totalProgressView.width = self.width * progress;
}

- (void)addVideoWhthIndex:(NSInteger)index
{
    CGFloat originX = -2;
    if (index != 0) {
        NSMutableDictionary *dic = _totalViewArray[index - 1];
        UIView *view = dic[@"view"];
        originX = view.right;
    }
    if (_totalViewArray.count > index) {
        NSMutableDictionary *dic = _totalViewArray[index];
        JPVideoModel *model = dic[@"model"];
        CGFloat width = CMTimeGetSeconds(model.timeRange.duration) / 300.f * (JP_SCREEN_WIDTH + 2);
        if (width <= 3) {
            width = 3;
        }
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(originX, 0, 3, 3)];
        //backView.backgroundColor = [UIColor whiteColor];
        backView.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        //view.backgroundColor = model.sourceType == JPVideoSourceCamera ? [UIColor appMainYellowColor] : [UIColor colorWithHex:0xf0770b];
        view.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
        [backView addSubview:view];
        view.sd_layout.topEqualToView(backView).rightEqualToView(backView).bottomEqualToView(backView).leftSpaceToView(backView, 0);
        [self addSubview:backView];
        [dic sgrSetObject:backView forKey:@"view"];
        backView.width = width;
        [self addVideoWhthIndex:index + 1];
    }
}


- (void)updateProgressWithDic:(NSDictionary *)dic
{
    NSInteger index = [_totalViewArray indexOfObject:dic];
    UIView *view = dic[@"view"];
    CGFloat width = view.width;
    [view removeFromSuperviewAndClearAutoLayoutSettings];
    [_totalViewArray removeObjectAtIndex:index];
    if (_totalViewArray.count > index) {
        for (; index < _totalViewArray.count; index++) {
            NSDictionary *dic = _totalViewArray[index];
            UIView *view = dic[@"view"];
            view.left = view.left - width;
        }
    }
}

- (void)becomeAddViewWithVideoSourceType:(JPVideoSourceType)sourceType
{
    CGFloat originX = -2;
    NSMutableDictionary *dic = _totalViewArray.lastObject;
    if (dic) {
        UIView *view = dic[@"view"];
        originX = view.right;
    }
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(originX, 0, 4, self.height)];
    _progressView.backgroundColor = [UIColor whiteColor];
    _progressView.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    //view.backgroundColor = sourceType == JPVideoSourceCamera ? [UIColor appMainYellowColor] : [UIColor colorWithHex:0xf0770b];
    view.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
    [_progressView addSubview:view];
    view.sd_layout.topEqualToView(_progressView).rightEqualToView(_progressView).bottomEqualToView(_progressView).leftSpaceToView(_progressView, 0);
    [self addSubview:_progressView];
}

- (void)updateViewWidthWithDuration:(CMTime)duration
{
    CGFloat width = CMTimeGetSeconds(duration) / 300.f * (JP_SCREEN_WIDTH + 2);
    if (width <= 3) {
        width = 3;
    }
    _progressView.width = width;
}

-(void)endUpdateViewWithVideoModel:(JPVideoModel *)videoModel
{
    if (videoModel == nil) {
        [_progressView removeFromSuperview];
        _progressView = nil;
        return;
    }
    if (videoModel.sourceType == JPVideoSourceCamera) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic sgrSetObject:videoModel forKey:@"model"];
        [dic sgrSetObject:videoModel.videoUrl.path forKey:@"urlPath"];
        [_totalViewArray addObject:dic];
        CGFloat width = CMTimeGetSeconds(videoModel.videoTime) / 300.f * (JP_SCREEN_WIDTH + 2);
        if (width <= 3) {
            width = 3;
        }
        [dic sgrSetObject:_progressView forKey:@"view"];
        _progressView = nil;
        if ([JPUtil getInfoFromUserDefaults:@"record--info--first"] == nil) {
            self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 225, 20)];
            self.messageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            self.messageLabel.text = [NSString stringWithFormat:@"你已经录制了%ld秒,总共可以录制5分钟", (NSInteger)CMTimeGetSeconds(videoModel.videoTime)];
            self.messageLabel.alpha = 0.0;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.font = [UIFont systemFontOfSize:10];
            self.messageLabel.textColor = [UIColor whiteColor];
            self.messageLabel.layer.cornerRadius = 10;
            self.messageLabel.layer.masksToBounds = YES;
            [self.superview addSubview:self.messageLabel];
            self.messageLabel.sd_layout.centerXEqualToView(self).bottomSpaceToView(self, 4).widthIs(225).heightIs(20);
            [UIView animateWithDuration:0.2 animations:^{
                self.messageLabel.alpha = 1.0;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        self.messageLabel.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        
                        [self.messageLabel removeFromSuperviewAndClearAutoLayoutSettings];
                        self.messageLabel = nil;
                    }];
                    
                    
                });
                
            }];
            [JPUtil saveIssueInfoToUserDefaults:@"record--info--first" resouceName:@"record--info--first"];
        }
        return;
    }
  }
@end
