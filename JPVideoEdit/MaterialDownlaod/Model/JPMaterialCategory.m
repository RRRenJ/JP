//
//  JPMaterialCategory.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPMaterialCategory.h"

@implementation JPMaterialCategory

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
               @"material_type_name"   : @[@"pattern_name", @"music_name"],
               @"material_type_id"     : @[@"pattern_id", @"music_id"],
               @"material_type_icon"   : @[@"pattern_icon", @"music_icon"],
               @"material_type_unicon" : @[@"pattern_unicon", @"music_icon"],
           };
}

@end
