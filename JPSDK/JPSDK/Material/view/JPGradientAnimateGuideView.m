//
//  JPGradientAnimateGuideView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/8/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPGradientAnimateGuideView.h"
#import "JPGradualLineView.h"

@interface JPGradientAnimateGuideView ()<JPGadualLineViewDelegate>
@property (nonatomic, strong) JPGradualLineView *gradualLineView;
@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UILabel *guideTextLb;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *roundView;
@end

@implementation JPGradientAnimateGuideView

- (id)initWithFrame:(CGRect)frame andText:(NSString *)str {
    self = [super initWithFrame:frame];
    if (self) {
        [JPResourceBundle loadNibNamed:@"JPGradientAnimateGuideView" owner:self options:nil];
        [self addSubview:self.view];
        self.view.sd_layout.topEqualToView(self).bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
        _guideTextLb.alpha = 0.f;
        _guideTextLb.text = str;
        _gradualLineView = [[JPGradualLineView alloc] initWithFrame:CGRectMake((self.width - 2)/2, 20, 2, self.height - 20 )];
        _gradualLineView.delegate = self;
        [self.view addSubview:_gradualLineView];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andText:(NSString *)str andIsActive:(BOOL)isActive
{
    if (isActive == NO) {
        return [self initWithFrame:frame andText:str];
    }else{
        frame.origin.y = frame.origin.y - 10;
        frame.size.height = frame.size.height + 10  + 55;
        self = [super initWithFrame:frame];
        if (self) {
            [JPResourceBundle loadNibNamed:@"JPGradientAnimateGuideView" owner:self options:nil];
            [self addSubview:self.view];
            self.view.sd_layout.topEqualToView(self).bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
            _guideTextLb.alpha = 0.f;
            _guideTextLb.text = str;
            _roundView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 6)/2, 23, 6, 6)];
            _roundView.backgroundColor = [UIColor jp_colorWithHexString:@"f40949"];
            _roundView.layer.cornerRadius = 3;
            _roundView.layer.masksToBounds = YES;
            [self.view addSubview:_roundView];
            _gradualLineView = [[JPGradualLineView alloc] initWithFrame:CGRectMake((self.width - 2)/2, 27, 2, self.height - 27 - 52) andIsActive:isActive];
            _gradualLineView.delegate = self;
            [self.view addSubview:_gradualLineView];
            _imageView = [[UIImageView alloc] initWithImage:JPImageWithName(@"redcycle")];
            _imageView.frame = CGRectMake((self.width - 50) / 2.0, self.height - 50, 50, 50);
            [self.view addSubview:_imageView];
        }
        return self;
    }
}

- (void)startAnimation {
    [_gradualLineView startAnimation];
}

#pragma mark - JPGadualLineViewDelegate

- (void)animationDidStop{
    [UIView animateWithDuration:0.5 animations:^{
        _guideTextLb.alpha = 1.f;
    }];
}

@end
