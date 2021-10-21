//
//  JPFontModel.h
//  jper
//
//  Created by 藩 亜玲 on 2017/6/5.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPFontModel : NSObject

@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) UIImage *thumImg;

+ (NSString *)getFontNameWithType:(JPTextFontType)type;

@end
