//
//  JPHotListTitleView.m
//  jper
//
//  Created by Monster_Lai on 2017/7/3.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPHotListTitleView.h"

@interface JPHotListTitleView ()

@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *hostLabel;

@end

@implementation JPHotListTitleView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
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
    [JPResourceBundle loadNibNamed:@"JPHotListTitleView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self);
    self.view.sd_layout.rightEqualToView(self);
    self.view.sd_layout.bottomEqualToView(self);
    self.view.sd_layout.leftEqualToView(self);
    self.backgroundColor = [UIColor clearColor];
    self.hostLabel.textColor = [UIColor jp_colorWithHexString:@"#c5c5c5"];
    
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    self.dateLabel.text = _dateStr;
}

@end
