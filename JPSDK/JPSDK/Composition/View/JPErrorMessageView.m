//
//  JPErrorMessageView.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/8.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPErrorMessageView.h"

@interface JPErrorMessageView ()
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (strong, nonatomic) IBOutlet UIButton *retryBtn;
@property (nonatomic, strong) CALayer *bgLayer;

@end

@implementation JPErrorMessageView

- (instancetype)initWithErrorType:(JPErrorMessageViewType)errorType
{
    if (self = [self initWithFrame:CGRectMake(0, 0, JP_SCREEN_WIDTH, JP_SCREEN_HEIGHT)]) {
        [JPResourceBundle loadNibNamed:@"JPErrorMessageView" owner:self options:nil];
        [self addSubview:self.view];
        
        self.view.sd_layout
        .centerXEqualToView(self)
        .centerYEqualToView(self)
        .widthRatioToView(self, 0.56)
        .heightRatioToView(self, 0.38);
        
        _bgLayer = [CALayer layer];
        _bgLayer.frame = CGRectMake((JP_SCREEN_WIDTH*0.44)/2 - 2, (JP_SCREEN_HEIGHT*0.62)/2 - 2, JP_SCREEN_WIDTH*0.56+4, JP_SCREEN_HEIGHT*0.38+4);
        _bgLayer.backgroundColor = [UIColor blackColor].CGColor;
        _bgLayer.shadowColor = [UIColor jp_colorWithHexString:@"ffffff"].CGColor;
        _bgLayer.shadowOffset = CGSizeMake(0, 0);
        _bgLayer.shadowOpacity = 0.5;
        _bgLayer.shadowRadius = 4;
        _bgLayer.cornerRadius = 4;
        [self.layer insertSublayer:_bgLayer atIndex:0];
        self.bgLayer.hidden = YES;
        
        self.retryBtn.layer.cornerRadius = 15.0f;
        
        _errorType = errorType;
        if (errorType == JPErrorMessageViewTypeNetwork) {
            _errorTitleLabel.text = @"找不到网络了～";
            _errorMessageLabel.text = @"";
            _logoImageView.image = JPImageWithName(@"no_network");
            _retryBtn.hidden = NO;
        }else if(errorType == JPErrorMessageViewTypeComposition){
            _errorTitleLabel.text = @"合成失败";
            _errorMessageLabel.text = @"视频合成失败";
            _logoImageView.image = JPImageWithName(@"no_network");
            _retryBtn.hidden = YES;
        }else{
            _errorTitleLabel.text = @"存储空间不足500M";
            _errorMessageLabel.text = @"请先清理手机的内存空间";
            _logoImageView.image = JPImageWithName(@"no_network");
            _retryBtn.hidden = YES;
        }
        self.view.layer.masksToBounds = YES;
        self.view.layer.cornerRadius =4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.view.alpha = 0.0;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self show];
        }
    return self;
}

- (void)show
{
    [UIView animateWithDuration:0.10 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.view.alpha = 1.0;
        self.bgLayer.hidden = NO;
        self.view.transform = CGAffineTransformMakeScale(0.7, 0.7);
        
        self.bgLayer.transform =  CATransform3DMakeScale(0.7, 0.7, 1);
        [UIView animateWithDuration:0.15 animations:^{
            self.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.bgLayer.transform =  CATransform3DMakeScale(1.1, 1.1, 1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                self.bgLayer.transform =  CATransform3DMakeScale(1.0, 1.0, 1);
            } completion:^(BOOL finished) {
            }];
            
        }];
    }];

}

- (void)dismiss
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.05 animations:^{
        
        self.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.bgLayer.transform =  CATransform3DMakeScale(1.1, 1.1, 1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.view.transform = CGAffineTransformMakeScale(0.7, 0.7);
            self.bgLayer.transform =  CATransform3DMakeScale(0.7, 0.7, 1);
        } completion:^(BOOL finished) {
            self.view.alpha = 0.0;
            self.bgLayer.hidden = YES;
            [UIView animateWithDuration:0.1 animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(errorViewWillDismiss:)]) {
                    [self.delegate errorViewWillDismiss:self];
                }
                [self removeFromSuperview];
            }];
        }];
    }];

}

- (IBAction)retryAction:(id)sender {
    [self dismiss];
}


@end
