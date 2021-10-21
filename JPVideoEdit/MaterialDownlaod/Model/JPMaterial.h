//
//  JPMaterial.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface JPMaterial : NSObject
@property (nonatomic, assign) long long materialId;
@property (nonatomic, assign) NSTimeInterval createDate;
@property (nonatomic, assign) long long indexWidth;
@property (nonatomic, strong) NSString *indexStr;
@property (nonatomic, strong) NSString *resource_name;
@property (nonatomic, assign) long long mid;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) NSString *absoluteLocalPath;
- (NSString *)baseFilePath;
@property (nonatomic, assign) long long material_type_id;
@property (nonatomic, assign) long long material_id;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) JPMaterialStatus materialStatus;
@property (nonatomic, assign) float downloadPro;
+ (void)loadAllMusicFromDBWithCompoletion:(void(^)(NSArray <JPMaterial *> *))completion;
+ (void)loadAllGraphFromDBWithCompoletion:(void(^)(NSArray <JPMaterial *> *))completion;
+ (void)loadAllMaterialFromDBWithCompoletion:(void(^)(NSArray <JPMaterial *> *))completion;
+ (void)createMaterialTable;
- (void)insertToDB;
- (void)updateToDB;
- (void)deleteFromDb;

@end
