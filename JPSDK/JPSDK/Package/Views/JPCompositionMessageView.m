//
//  JPCompositionMessageView.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPCompositionMessageView.h"

@interface JPCompositionMessageView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pasueButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabelOne;
@property (weak, nonatomic) IBOutlet UIView *tipViewOne;

@end

@implementation JPCompositionMessageView

- (IBAction)startCompositionAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(compositionMessageViewWillComposition)]) {
        [self.delegate compositionMessageViewWillComposition];
    }
    [self dismiss];
}

- (IBAction)waitAMoment:(id)sender {
    [self dismiss];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createsubviews];
    }
    return self;
}

- (void)createsubviews
{
    self.backgroundColor = [UIColor clearColor];
    [JPResourceBundle loadNibNamed:@"JPCompositionMessageView" owner:self options:nil];
    [self addSubview:self.view];
    self.alpha = 0;
    self.view.sd_layout.topEqualToView(self).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
    self.pasueButton.layer.masksToBounds = YES;
    self.pasueButton.layer.cornerRadius = 15;
    self.startButton.layer.masksToBounds = YES;
    self.startButton.layer.cornerRadius = 15;
    self.startButton.layer.borderWidth = 1;
    self.startButton.layer.borderColor = [UIColor whiteColor].CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plhoders:)];
    [self addGestureRecognizer:tap];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为10
    [paragraphStyle setLineSpacing:JPScreenFitFloat6(10)];
    NSString *str = @"进入下一步就要开始合成视频了, 可以再调整一下你的视频哦";
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    // 设置Label要显示的text
    [_tipLabel  setAttributedText:setString];
    
    _tipLabel.font = [UIFont systemFontOfSize:JPScreenFitFloat6(12)];
    
    _tipView.layer.masksToBounds = YES;
    _tipView.layer.cornerRadius = 1.5;
    _tipViewOne.layer.masksToBounds = YES;
    _tipViewOne.layer.cornerRadius = 1.5;
    
    paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为10
    [paragraphStyle setLineSpacing:JPScreenFitFloat6(10)];
    str = @"合成完毕后,我们会在手机本地和云端为你保存视频";
    setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    // 设置Label要显示的text
    [_tipLabelOne  setAttributedText:setString];
    
    _tipLabelOne.font = [UIFont systemFontOfSize:JPScreenFitFloat6(12)];
}

- (void)plhoders:(UITapGestureRecognizer *)tap
{
    
}
- (void)show
{
   [UIView animateWithDuration:0.5 animations:^{
       
       self.alpha = 1.0;
   }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
