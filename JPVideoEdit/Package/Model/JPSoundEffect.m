//
//  JPSoundEffect.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPSoundEffect.h"

@implementation JPSoundEffect

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
               @"material_type_icon"   : @"sound_icon",
               @"material_type_unicon" : @"sound_icon",
               @"material_type_id"     : @"sound_id",
               @"material_type_name"   : @"sound_name",
           };
}

@end
