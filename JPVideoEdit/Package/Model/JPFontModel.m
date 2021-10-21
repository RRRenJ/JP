//
//  JPFontModel.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/5.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPFontModel.h"

@implementation JPFontModel

+ (NSString *)getFontNameWithType:(JPTextFontType)type {
    NSString *name = @"";
    switch (type) {
        case JPTextFontTypePingFang:
            name = @"PingFangSC-Regular";
            break;
        case JPTextFontTypeXindi:
            name = @"SentyTEA-4800";
            break;
        case JPTextFontTypeXiSong:
            name = @"习宋体";
            break;
        case JPTextFontTypePlacardMTStdCond:
            name = @"PlacardMTStd-Cond";
            break;
        case JPTextFontTypeTrajanPro:
            name = @"TrajanPro-Bold";
            break;
        case JPTextFontTypeArista:
            name = @"Arista2.0";
            break;
        default:
            name = @"PingFangSC-Regular";
            break;
    }
    return name;
}

@end
