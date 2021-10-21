//
//  JPMaterialCategory.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPMaterialCategory : NSObject
@property (nonatomic, strong) NSString *material_type_name;
@property (nonatomic, strong) NSString *material_type_icon;
@property (nonatomic, strong) NSString *material_type_unicon;
@property (nonatomic, strong) NSString *material_type_id;
@property (nonatomic, assign) NSInteger material_id;

@end
