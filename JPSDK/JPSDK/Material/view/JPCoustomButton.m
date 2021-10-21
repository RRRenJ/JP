//
//  JPCoustomButton.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/5.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPCoustomButton.h"

@interface JPCoustomButton ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *bottomLabel;
@end

@implementation JPCoustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_topImageView];
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topImageView.top = 0;
    _topImageView.right = 0;
    _topImageView.width = 30;
    _topImageView.height = 30;
    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_bottomLabel];
    _bottomLabel.top = 46;
    _bottomLabel.right = 0;
    _bottomLabel.width = 30;
    _bottomLabel.height = 14;
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    _bottomLabel.textColor = [UIColor jp_colorWithHexString:@"515151"];
    _bottomLabel.font = [UIFont contentFont];
}

- (void)setImage:(UIImage *)image andContentTitle:(NSString *)title
{
    _topImageView.image = image;
    _bottomLabel.text = title;
}
@end
