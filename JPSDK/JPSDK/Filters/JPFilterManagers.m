//
//  JPFilterManagers.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/18.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPFilterManagers.h"
#import "JPFiltersAttributeModel.h"
#import "JPFilterDelegateNormal.h"
#import "JPFilterDelegateOnlyCurve.h"
#import "JPFilterDelegateColorBalance.h"
static NSArray *JPFiltersArr = nil;

@implementation JPFilterManagers
+ (NSArray *)getFiltersArr{
    if (JPFiltersArr == nil) {
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSInteger index = 1; index <= 10; index ++) {
            JPFilterModel *filterModel = [[JPFilterModel alloc] init];
            NSString *numbers = [NSString stringWithFormat:@"0%ld", (long)(index)];
            if ((index) >= 10) {
                numbers = [NSString stringWithFormat:@"%ld", (long)(index)];
            }
            if (index > 0) {
                filterModel.thumbImageName = [NSString stringWithFormat:@"%ld-filter", index];
            }
            filterModel.filterNumberString = numbers;
            filterModel.filterType = index - 1;
            switch (filterModel.filterType) {
                case 0:
                    filterModel.filterName = @"ORIGINAL";
                    filterModel.filterCNName = @"原画";
                    break;
                case 1:
                    filterModel.filterName = @"VITALITY";
                    filterModel.filterCNName = @"元气";
                    break;
                case 2:
                    filterModel.filterName = @"GREEN";
                    filterModel.filterCNName = @"绿光";
                    break;
                case 3:
                    filterModel.filterName = @"FADED";
                    filterModel.filterCNName = @"褪色";
                    break;
                case 4:
                    filterModel.filterName = @"FRESH";
                    filterModel.filterCNName = @"清新";
                    break;
                case 5:
                    filterModel.filterName = @"JAPANESE WAVE";
                    filterModel.filterCNName = @"日系";
                    break;
                case 6:
                    filterModel.filterName = @"WHITE-SKINNED";
                    filterModel.filterCNName = @"白皙";
                    break;
                case 7:
                    filterModel.filterName = @"MONOCHROME";
                    filterModel.filterCNName = @"黑白";
                    break;
                case 8:
                    filterModel.filterName = @"BLUEBERRY";
                    filterModel.filterCNName = @"蓝莓";
                    break;
                case 9:
                    filterModel.filterName = @"SAKURA";
                    filterModel.filterCNName = @"樱花";
                    break;
                default:
                    break;
            }
            [dataArr addObject:filterModel];
        }
        JPFiltersArr = dataArr;
    }
    return JPFiltersArr;
}

- (id<JPGeneralFilterDelegate>)filterManagerGeneralImageFilterDelegeteWithFilterType:(NSInteger)filterType
{
    JPFilterDelegateNormal *normal = nil;
    switch (filterType) {
        case 1:
            normal = [[JPFilterDelegateOnlyCurve alloc] initWithShaderContentPaths:@[@"filterSweetWordsHeader", @"funcationStart", @"curveAdjust",@"hueAdujs",@"saturation",@"founcationEnd"] andCurveName:@"2-filter-RGB"];
            break;
        case 2:
            normal = [[JPFilterDelegateOnlyCurve alloc] initWithShaderContentPaths:@[@"filterGreenHeader", @"funcationStart", @"curveAdjust",@"hueAdujs",@"saturation",@"founcationEnd"] andCurveName:@"3-filter-RGB"];
            break;
        case 3:
            normal = [[JPFilterDelegateOnlyCurve alloc] initWithShaderContentPaths:@[@"filterElapseHeader", @"funcationStart",@"saturation", @"curveAdjust",@"founcationEnd"] andCurveName:@"4-filter-RGB"];
            break;
        case 4:
            normal = [[JPFilterDelegateOnlyCurve alloc] initWithShaderContentPaths:@[@"filterMidSummerHeader", @"funcationStart", @"curveAdjust",@"hueAdujs",@"saturation",@"founcationEnd"] andCurveName:@"5-filter-RGB"];
            break;
        case 5:
            normal = [[JPFilterDelegateOnlyCurve alloc] initWithShaderContentPaths:@[@"filterPromontoryHeader", @"funcationStart", @"curveAdjust",@"hueAdujs",@"saturation",@"founcationEnd"] andCurveName:@"6-filter-RGB"];
            break;
        case 6:
            normal = [[JPFilterDelegateOnlyCurve alloc] initWithShaderContentPaths:@[@"filterAfterRaningHeader", @"funcationStart", @"curveAdjust",@"hueAdujs",@"saturation",@"founcationEnd"] andCurveName:@"7-filter-RGB"];
            break;
        case 7:
            normal = [[JPFilterDelegateOnlyCurve alloc] initWithShaderContentPaths:@[@"filterModernHeader", @"funcationStart", @"curveAdjust",@"saturation",@"founcationEnd"] andCurveName:@"8-filter-RGB"];
            break;
        case 8:
            normal = [[JPFilterDelegateColorBalance alloc] initWithShaderContentPaths:@[@"filterBlueBerryHeader",@"filterColorBalanceFouncation", @"funcationStart", @"curveAdjust",@"saturation",@"filterBlueBerryColor",@"founcationEnd"] andCurveName:@"9-filter-RGB"];
            break;
        case 9:
            normal = [[JPFilterDelegateColorBalance alloc] initWithShaderContentPaths:@[@"filterSakuraHeader",@"filterColorBalanceFouncation", @"funcationStart", @"curveAdjust",@"filterSakuraColor",@"founcationEnd"] andCurveName:@"10-filter-RGB"];
            break;
        default:
            normal = [[JPFilterDelegateNormal alloc] init];
            break;
    }
    return normal;
}

@end
