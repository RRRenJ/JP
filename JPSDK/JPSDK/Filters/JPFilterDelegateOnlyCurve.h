//
//  JPFilterDelegateOnlyCurve.h
//  jper
//
//  Created by FoundaoTEST on 2017/8/31.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPFilterDelegateNormal.h"

@interface JPFilterDelegateOnlyCurve : JPFilterDelegateNormal
- (instancetype)initWithShaderContentPaths:(NSArray<NSString *> *)shaderPaths andCurveName:(NSString *)imageName;

@end
