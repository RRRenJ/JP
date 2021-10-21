//
//  JPVideoInfoTableViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPVideoInfoTableViewCell.h"

@interface JPVideoInfoTableViewCell ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *videoNumLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIImageView *moveStatusImage;
@property (weak, nonatomic) IBOutlet UIView *moveView;
@property (nonatomic, weak) NSURL *url;
@property (nonatomic, assign) BOOL startMove;
@end

@implementation JPVideoInfoTableViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    _videoNumLabel.font = [UIFont fontWithName:@"PlacardMTStd-Cond" size:18];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 2.5;
    _contentImageView.layer.masksToBounds = YES;
    _contentImageView.layer.cornerRadius = 2.5;
    self.backgroundColor = [UIColor jp_colorWithHexString:@"101010"];
    self.contentView.backgroundColor = [UIColor jp_colorWithHexString:@"101010"];
//    _moveStatusImage.userInteractionEnabled = YES;
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanAction:)];
    leftPan.minimumNumberOfTouches = 1;
    leftPan.maximumNumberOfTouches = 5;
    [_moveView addGestureRecognizer:leftPan];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:_moveView];
    if (CGRectContainsPoint(_moveView.bounds, point)) {
        
        [self.layer removeAllAnimations];
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        theAnimation.duration=0.2;
        theAnimation.removedOnCompletion = NO;
        theAnimation.fillMode = kCAFillModeForwards;
        theAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        theAnimation.toValue = [NSNumber numberWithFloat:1.1];
        [self.layer addAnimation:theAnimation forKey:@"animateTransform"];
        
    }
    self.startMove = NO;

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:_moveView];
    if (CGRectContainsPoint(_moveView.bounds, point) &&  self.startMove == NO) {
        
        [self.layer removeAllAnimations];
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        theAnimation.duration=0.2;
        theAnimation.removedOnCompletion = NO;
        theAnimation.fillMode = kCAFillModeForwards;
        theAnimation.fromValue = [NSNumber numberWithFloat:1.1];
        theAnimation.toValue = [NSNumber numberWithFloat:1.0];
        [self.layer addAnimation:theAnimation forKey:@"animateTransform"];
        
    }
    self.startMove = NO;
}

- (void)leftPanAction:(UIPanGestureRecognizer *)pan
{
    self.startMove = YES;
    if (pan.state == UIGestureRecognizerStateBegan) {
        _moveStatusImage.image = JPImageWithName(@"move-hold");
        if (self.delegate) {
            [self.delegate videoInfoTableViewCellSelect:self andPan:pan];
        }
        [self.layer removeAllAnimations];
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        theAnimation.duration=0.01;
        theAnimation.removedOnCompletion = NO;
        theAnimation.fillMode = kCAFillModeForwards;
        theAnimation.fromValue = [NSNumber numberWithFloat:1.1];
        theAnimation.toValue = [NSNumber numberWithFloat:1.0];
        [self.layer addAnimation:theAnimation forKey:@"animateTransform"];
    }else if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (self.delegate) {
            [self.delegate videoInfoTableViewCellSelectLocationChange:self andPan:pan];
        }
    }else{
        _moveStatusImage.image = JPImageWithName(@"move");
        if (self.delegate) {
            [self.delegate videoInfoTableViewCellSelectLocationEnd:self andPan:pan];
        }
    }
}
- (void)addVideoAction
{
    if (self.delegate) {
        [self.delegate videoInfoTableViewCellShouldAddVideo:self];
    }
}

- (UILabel *)videoNumbersLabel
{
    return _videoNumLabel;
}
- (void)setModel:(JPVideoModel *)model
{
  

    _model = model;
    self.url = model.videoUrl;
    if (model.filterThumbImage) {
        _contentImageView.image = model.filterThumbImage;
    }else{
        __weak typeof(self) weakSelf = self;
        [model asyncGetThumbImageWithCompletion:^(UIImage *image, JPVideoModel *videoModel) {
            if ([weakSelf.url.path isEqualToString:model.videoUrl.path]) {
                weakSelf.contentImageView.image =  image;
            }
        }];
    }
}
- (IBAction)deleteVideoAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确定要删除本段视频？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是", nil];
    [alert show];
}
- (IBAction)editVideoAction:(id)sender {
    if (self.delegate) {
        [self.delegate videoInfoTableViewCellShouldEditVideo:self];
    }
}


- (UIView *)deleteView
{
    return _deleteButton;
}

- (UIView *)editView
{
    return _editButton;
}
- (void)setAddButton
{
}

- (void)hiddenStatusImageView
{
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        if (self.delegate) {
            [self.delegate videoInfoTableViewCellShouldDeleteVideo:self];
        }
    }
}

@end
