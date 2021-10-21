//
//  JPPackageMenuBaseView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/6/3.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPPackageMenuBaseView;

@interface JPPackageMenuBaseView : UIView

@property (nonatomic, strong) UIView *tittleView;

@property (nonatomic, strong) UILabel *tittleLb;

@property (nonatomic, strong) UIButton *confirmBt;

- (void)dismiss;

- (void)setTittle:(NSString *)t;

@end
