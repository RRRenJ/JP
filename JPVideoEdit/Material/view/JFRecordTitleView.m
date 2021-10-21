//
//  JFRecordTitleView.m
//  jper
//
//  Created by FoundaoTEST on 2017/3/21.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JFRecordTitleView.h"
@interface JFRecordTitleView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *stepLb;

@end

@implementation JFRecordTitleView
- (IBAction)clickTheNavigationTitile:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordTitleViewNeedShowStep)]) {
        [self.delegate recordTitleViewNeedShowStep];
    }
}

 -(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
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
    [JPResourceBundle loadNibNamed:@"JFRecordTitleView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self);
    self.view.sd_layout.rightEqualToView(self);
    self.view.sd_layout.bottomEqualToView(self);
    self.view.sd_layout.leftEqualToView(self);
    self.backgroundColor = [UIColor clearColor];

}

- (void)setStep:(JPVideoEditStep)step
{
    _step = step;
    _stepLb.text = [NSString stringWithFormat:@"0%ld",(long)step];
}
@end
