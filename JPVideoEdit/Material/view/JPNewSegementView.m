//
//  JPNewSegementView.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewSegementView.h"

@interface JPNewSegementView ()
@property (nonatomic, strong) NSMutableArray <UIButton *>* segementButtons;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JPNewSegementView

- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
    for (UIButton *button in _segementButtons) {
        [button removeFromSuperview];
    }
    [_segementButtons removeAllObjects];
    [_lineView removeFromSuperview];
    _cureenrIndex = 0;
    _segementButtons = [NSMutableArray array];
    CGFloat totalWidth = JP_SCREEN_WIDTH - 30;
    CGFloat originX = 15;
    CGFloat simpleWidth = totalWidth / titles.count;
    for (NSInteger index = 0; index < titles.count; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX, 0, simpleWidth, self.height);
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:titles[index] forState:UIControlStateNormal];
        button.tag = index;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:button];
        [_segementButtons addObject:button];
        [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        originX = button.right;
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15 + (simpleWidth - 20) / 2.0, self.height - 1, 20, 1)];
    _lineView.backgroundColor = [UIColor jp_colorWithHexString:@"0091FF"];
    [self addSubview:_lineView];
}

- (void)didSelectButton:(UIButton *)button
{
    _cureenrIndex = button.tag;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.left = 15 + button.width * button.tag + (button.width - 20) / 2.0;
    }];
}


- (void)setCureenrIndex:(NSInteger)cureenrIndex
{
    UIButton *button = _segementButtons[cureenrIndex];
    [self didSelectButton:button];
}


- (void)setCurrentIndex:(NSInteger)index{
    _cureenrIndex = index;
    UIButton *button = _segementButtons[index];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.left = 15 + button.width * button.tag + (button.width - 20) / 2.0;
    }];
}
@end
