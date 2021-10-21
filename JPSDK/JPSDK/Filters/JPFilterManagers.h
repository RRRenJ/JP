//
//  JPFilterManagers.h
//  jper
//
//  Created by FoundaoTEST on 2017/8/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPFilterManagers : NSObject<JPVideoRecordInfoFilterManager>

+ (NSArray *)getFiltersArr;
- (id<JPGeneralFilterDelegate>)filterManagerGeneralImageFilterDelegeteWithFilterType:(NSInteger)filterType;

@end
