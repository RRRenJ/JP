//
//  PKBackAlertView.m
//  jper
//
//  Created by RRRenJ on 2020/8/5.
//  Copyright © 2020 MuXiao. All rights reserved.
//

#import "PKBackAlertView.h"


@interface PKBackAlertView ()

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UILabel * subtitleLb;

@property (nonatomic, strong) UIButton * comfirmBt;

@property (nonatomic, strong) UIButton * cancelBt;

@end

@implementation PKBackAlertView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupViews];
        [self addActions];
    }
    return self;
}



- (void)setupViews{
    self.frame = CGRectMake(0, 0, JP_SCREEN_WIDTH, JP_SCREEN_HEIGHT);
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.subtitleLb];
    [self.contentView addSubview:self.comfirmBt];
    [self.contentView addSubview:self.cancelBt];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(282, 150));
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(0);
    }];
    [self.subtitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_offset(3);
        make.height.mas_equalTo(17);
    }];
    [self.comfirmBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(108, 30));
        make.bottom.mas_equalTo(-30);
    }];
    [self.cancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-26);
        make.size.mas_equalTo(CGSizeMake(108, 30));
        make.bottom.mas_equalTo(-30);
    }];
}

- (void)addActions{
    
}

- (void)show{
    [[JPUtil currentViewController].view addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)comfirmBtClicked{
    if (self.comfirmBlock) {
        self.comfirmBlock();
    }
}

- (void)cancelBtClicked{
    [self hide];
}

#pragma mark - set


#pragma mark - get
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor jp_colorWithHexString:@"#262626"];
        _contentView.layer.cornerRadius = 7;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.text = @"当前编辑效果不会被保存";
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

- (UILabel *)subtitleLb{
    if (!_subtitleLb) {
        _subtitleLb = [[UILabel alloc]init];
        _subtitleLb.text = @"是否放弃？";
        _subtitleLb.textColor = [UIColor colorWithWhite:1 alpha:0.82];
        _subtitleLb.font = [UIFont systemFontOfSize:12];
        _subtitleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _subtitleLb;
}

- (UIButton *)comfirmBt{
    if (!_comfirmBt) {
        _comfirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfirmBt setTitle:@"确定" forState:UIControlStateNormal];
        [_comfirmBt setTitleColor:[UIColor jp_colorWithHexString:@"#0091FF"] forState:UIControlStateNormal];
        _comfirmBt.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _comfirmBt.layer.masksToBounds = YES;
        _comfirmBt.layer.cornerRadius = 15;
        _comfirmBt.layer.borderWidth = 1;
        _comfirmBt.layer.borderColor = [UIColor jp_colorWithHexString:@"#0091FF"].CGColor;
        _comfirmBt.backgroundColor = UIColor.clearColor;
        [_comfirmBt addTarget:self action:@selector(comfirmBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmBt;
}

- (UIButton *)cancelBt{
    if (!_cancelBt) {
        _cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBt setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBt.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _cancelBt.layer.masksToBounds = YES;
        _cancelBt.layer.cornerRadius = 15;
        _cancelBt.backgroundColor = [UIColor jp_colorWithHexString:@"#0091FF"];
        [_cancelBt addTarget:self action:@selector(cancelBtClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBt;
}


@end

