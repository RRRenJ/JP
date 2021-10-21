//
//  JPPackageMenuBaseView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/3.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageMenuBaseView.h"

@implementation JPPackageMenuBaseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _tittleView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tittleView];
        _tittleView.sd_layout.topEqualToView(self).leftEqualToView(self).rightEqualToView(self).heightIs(40.5);
        _tittleView.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];

        _tittleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _tittleLb.font = [UIFont jp_pingFangWithSize:12];
        _tittleLb.textColor = [UIColor jp_colorWithHexString:@"545454"];
        _tittleLb.textAlignment = NSTextAlignmentCenter;
        [_tittleView addSubview:_tittleLb];
        _tittleLb.sd_layout.leftEqualToView(_tittleView).rightEqualToView(_tittleView).centerYEqualToView(_tittleView).heightIs(13);
        
        self.confirmBt = [JPUtil createCustomButtonWithTittle:@"确定"
                                                          withImage:nil
                                                          withFrame:CGRectZero
                                                             target:self
                                                             action:@selector(dismiss)];
        [self.confirmBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmBt.titleLabel.font = [UIFont jp_pingFangWithSize:12.f];
        [_tittleView addSubview:self.confirmBt];
        self.confirmBt.sd_layout.topEqualToView(_tittleView).rightEqualToView(_tittleView).widthIs(JPScreenFitFloat6(47)).bottomSpaceToView(_tittleView, 0.5);
        
        UIView *linView = [[UIView alloc] initWithFrame:CGRectZero];
        linView.backgroundColor = [UIColor jp_colorWithHexString:@"1e1f20"];
        [_tittleView addSubview:linView];
        linView.sd_layout.bottomEqualToView(_tittleView).leftSpaceToView(_tittleView, 0).rightSpaceToView(_tittleView, 0).heightIs(0.5);
    }
    return self;
}

#pragma mark - actions

- (void)setTittle:(NSString *)t {
    _tittleLb.text = t;
}

- (void)dismiss {
    
}

@end
