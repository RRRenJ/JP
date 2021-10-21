//
//  JPVideoSettingTableViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/3/28.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPVideoSettingTableViewCell.h"


@interface JPVideoSettingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (weak, nonatomic) IBOutlet UIButton *eightButton;
@property (nonatomic, strong) NSMutableArray *buttonArr;

@end

@implementation JPVideoSettingTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _buttonArr = [NSMutableArray array];
    [_buttonArr addObject:_threeButton];
    [_buttonArr addObject:_fiveButton];
    [_buttonArr addObject:_eightButton];
    _threeButton.tag = 3;
    _fiveButton.tag = 5;
    _eightButton.tag = 8;
    _threeButton.layer.borderWidth = 1;
    _threeButton.layer.cornerRadius = 12.5;
    _threeButton.layer.masksToBounds = YES;
    _threeButton.titleLabel.font = [UIFont EnglishContentFont];
    
    _fiveButton.layer.borderWidth = 1;
    _fiveButton.layer.cornerRadius = 12.5;
    _fiveButton.layer.masksToBounds = YES;
    _fiveButton.titleLabel.font = [UIFont EnglishContentFont];

    
    _eightButton.layer.borderWidth = 1;
    _eightButton.layer.cornerRadius = 12.5;
    _eightButton.layer.masksToBounds = YES;
    _eightButton.titleLabel.font = [UIFont EnglishContentFont];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSInteger total = [userDefaults integerForKey:JP_Video_Total_Number];
    total = total == 0 ? 5 : total;
    [self setSelectVideoNumber:total];
}

- (void)setSelectVideoNumber:(NSInteger)total
{
    for (UIButton *button in _buttonArr) {
        if (button.tag == total) {
            button.layer.borderColor = [UIColor jp_colorWithHexString:@"0091FF"].CGColor;
            [button setTitleColor:[UIColor jp_colorWithHexString:@"0091FF"] forState:UIControlStateNormal];
            
        }else{
            button.layer.borderColor = [UIColor jp_colorWithHexString:@"535353"].CGColor;
            [button setTitleColor:[UIColor jp_colorWithHexString:@"535353"] forState:UIControlStateNormal];

        }
    }
}

- (IBAction)selectSction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:button.tag forKey:JP_Video_Total_Number];
    [self setSelectVideoNumber:button.tag];
}


@end
