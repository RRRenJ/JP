//
//  JPSoundEffectTableViewCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPSoundEffectTableViewCell.h"

@interface JPSoundEffectTableViewCell ()<UIAlertViewDelegate>{
    JPAudioModel *_audioModel;
}

@property (nonatomic, weak) IBOutlet UILabel *timeLb;
@property (nonatomic, weak) IBOutlet UILabel *nameLb;
@property (nonatomic, weak) IBOutlet UIView *slideView;
@property (nonatomic, weak) IBOutlet UIView *slideThumView;
@property (nonatomic, weak) IBOutlet UIView *slideThumContentView;
@property (nonatomic, weak) IBOutlet UIButton *deleteBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *sliderThunmContentViewWidthLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *sliderThunmViewLeftLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *sliderThunmViewWidthLayoutConstraint;

@end

@implementation JPSoundEffectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor blackColor];
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeStartTime:)];
    panGes.minimumNumberOfTouches = 1;
    panGes.maximumNumberOfTouches = 5;
    [_slideThumView addGestureRecognizer:panGes];
    
    [JPUtil setViewRadius:_slideThumContentView byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(_sliderThunmContentViewWidthLayoutConstraint.constant/2, _sliderThunmContentViewWidthLayoutConstraint.constant/2)];
    
    _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(JPScreenFitFloat6(16) , 0, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 

- (void)changeStartTime:(UIPanGestureRecognizer *)pan{
    CGFloat start = CMTimeGetSeconds(_audioModel.startTime);
    CGFloat dur = CMTimeGetSeconds(_duration);
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(willChangeStartTimeWithTheModel:)]) {
            [self.delegate willChangeStartTimeWithTheModel:_audioModel];
        }
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:_slideThumView];
        CGFloat consant = _sliderThunmViewLeftLayoutConstraint.constant + point.x;
        CGFloat leftMax = _slideView.left - _sliderThunmViewWidthLayoutConstraint.constant/2.f;
        CGFloat rightMax = _slideView.right - _sliderThunmViewWidthLayoutConstraint.constant/2.f;
        if (consant < leftMax) {
            consant = leftMax;
        }
        if (consant > rightMax) {
            consant = rightMax;
        }
        _sliderThunmViewLeftLayoutConstraint.constant = consant;
        start = (_sliderThunmViewLeftLayoutConstraint.constant - leftMax)*dur/_slideView.width;
        _timeLb.text = [NSString stringWithFormat:@"%ds",(int)start];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeStartTimeWithTheModel:)]) {
            [self.delegate didChangeStartTimeWithTheModel:_audioModel];
        }
    }
    [pan setTranslation:CGPointMake(0, 0) inView:_slideThumView];
    if (UIGestureRecognizerStateEnded == pan.state || UIGestureRecognizerStateCancelled == pan.state) {
        CGFloat leftMax = _slideView.left - _sliderThunmViewWidthLayoutConstraint.constant/2.f;
        start = (_sliderThunmViewLeftLayoutConstraint.constant - leftMax)*dur/_slideView.width;
        _audioModel.startTime = CMTimeMake(start, 1);
        _timeLb.text = [NSString stringWithFormat:@"%ds",(int)start];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didEndChangeStartTimeWithTheModel:)]) {
            [self.delegate didEndChangeStartTimeWithTheModel:_audioModel];
        }
    }
}

- (void)loadViewWithDataSource:(JPAudioModel *)model {
    CGFloat leftMax = _slideView.left - _sliderThunmViewWidthLayoutConstraint.constant/2.f;
    _audioModel = model;
    _nameLb.text = model.fileName;
    _timeLb.text = [NSString stringWithFormat:@"%ds",(int)CMTimeGetSeconds(model.startTime)];
    CGFloat start = CMTimeGetSeconds(model.startTime);
    CGFloat dur = CMTimeGetSeconds(_duration);
    _sliderThunmViewLeftLayoutConstraint.constant = start/dur*_slideView.width+leftMax;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteTheAudioModel:)]) {
            [self.delegate deleteTheAudioModel:_audioModel];
        }
    }
}

#pragma mark - 

- (IBAction)delete:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willDeleteTheAudioModel:)]) {
        [self.delegate willDeleteTheAudioModel:_audioModel];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确定要删除？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是", nil];
    [alert show];
}

@end
