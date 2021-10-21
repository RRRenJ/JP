//
//  JPSoundEffect.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPMaterial.h"

@interface JPSoundEffect : NSObject
@property (nonatomic, assign) long long material_type_id;
@property (nonatomic, strong) NSString *material_type_name;
@property (nonatomic, strong) NSString *material_type_icon;
@property (nonatomic, strong) NSString *material_type_unicon;
@property (nonatomic, assign) long long material_id;
@property (nonatomic, strong) NSMutableArray <JPMaterial *>*lists;

@end
