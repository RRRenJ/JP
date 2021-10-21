//
//  JPPhotoEditMune.m
//  jper
//
//  Created by FoundaoTEST on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPhotoEditMune.h"

@interface JPPhotoEditMune ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *beSmallButton;
@property (weak, nonatomic) IBOutlet UIButton *beBigButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation JPPhotoEditMune

- (IBAction)becomeSmallAction:(id)sender {
    if (_videoModel.photoTransionType == JPPhotoModelTranstionBigToSmall) {
        _videoModel.photoTransionType = JPPhotoModelTranstionNormal;
    }else{
        _videoModel.photoTransionType = JPPhotoModelTranstionBigToSmall;
    }
    [self setVideoModel:_videoModel];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditMuneWillEditVideoPhotoAnimationTypeWithModel:)]) {
        [self.delegate photoEditMuneWillEditVideoPhotoAnimationTypeWithModel:_videoModel];
    }
}
- (IBAction)becomeBigAction:(id)sender {
    if (_videoModel.photoTransionType == JPPhotoModelTranstionSmallToBig) {
        _videoModel.photoTransionType = JPPhotoModelTranstionNormal;
    }else{
        _videoModel.photoTransionType = JPPhotoModelTranstionSmallToBig;
    }
    [self setVideoModel:_videoModel];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditMuneWillEditVideoPhotoAnimationTypeWithModel:)]) {
        [self.delegate photoEditMuneWillEditVideoPhotoAnimationTypeWithModel:_videoModel];
    }
}
- (IBAction)deleteAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditMuneWillDelegateThisVideo:)]) {
        [self.delegate photoEditMuneWillDelegateThisVideo:_videoModel];
    }
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
    self.backgroundColor = [UIColor blackColor];
    [[NSBundle mainBundle] loadNibNamed:@"JPPhotoEditMune" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
}


- (void)setVideoModel:(JPVideoModel *)videoModel
{
    [self.beBigButton setImage:[UIImage imageNamed:@"enlarge-off"] forState:UIControlStateNormal];
    [self.beSmallButton setImage:[UIImage imageNamed:@"narrow-off"] forState:UIControlStateNormal];
    _videoModel = videoModel;
    if (_videoModel.photoTransionType == JPPhotoModelTranstionBigToSmall) {
        [self.beSmallButton setImage:[UIImage imageNamed:@"narrow-on"] forState:UIControlStateNormal];
    }else if (_videoModel.photoTransionType == JPPhotoModelTranstionSmallToBig)
    {
        [self.beBigButton setImage:[UIImage imageNamed:@"enlarge-on"] forState:UIControlStateNormal];

    }
}
@end
