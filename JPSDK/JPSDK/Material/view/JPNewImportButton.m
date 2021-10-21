//
//  JPNewImportButton.m
//  jper
//
//  Created by FoundaoTEST on 2017/9/5.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewImportButton.h"

@interface JPNewImportButton ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *noImprotView;
@property (weak, nonatomic) IBOutlet UIView *hasImportView;
@property (weak, nonatomic) IBOutlet UIView *numberBackView;
@property (weak, nonatomic) IBOutlet UILabel *numberButtoon;

@end



@implementation JPNewImportButton

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
    [JPResourceBundle loadNibNamed:@"JPNewImportButton" owner:self options:nil];
    [self addSubview:self.view];
    self.view.sd_layout.topEqualToView(self).rightEqualToView(self).bottomEqualToView(self).leftEqualToView(self);
    self.hasImportView.hidden = YES;
    self.noImprotView.hidden = NO;
    self.numberBackView.layer.masksToBounds = YES;
    self.numberBackView.layer.cornerRadius = 7.5;
}

- (void)setupNumber:(NSInteger)number
{
    if (number == 0) {
        self.hasImportView.hidden = YES;
        self.noImprotView.hidden = NO;
    }else{
        self.hasImportView.hidden = NO;
        self.noImprotView.hidden = YES;
        self.numberButtoon.text = [NSString stringWithFormat:@"%ld", number];
    }
}
@end
