//
//  JPTranstionsModelManager.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPTranstionsModelManager.h"

static NSArray *JPTranstionsModelsArr = nil;

@implementation JPTranstionsModelManager

+ (NSArray<JPVideoTranstionsModel *> *)getAllTranstionsModels
{
    if (JPTranstionsModelsArr != nil) {
        return JPTranstionsModelsArr;
    }
    NSMutableArray<JPVideoTranstionsModel *> *dadaSource = [NSMutableArray array];
    
    for (int index = 0; index <= 20; index++) {
        JPVideoTranstionsModel *transtionModel = [[JPVideoTranstionsModel alloc] init];
        transtionModel.transtionIndex = index;
        transtionModel.selectImageName = [NSString stringWithFormat:@"transtionIcon%d-on", index];
        transtionModel.offImageName = [NSString stringWithFormat:@"transtionIcon%d", index];
        transtionModel.onImageName = [NSString stringWithFormat:@"transtionIcon%d-on", index];
        transtionModel.transtionGlslFileName = [NSString stringWithFormat:@"transtion%d", index];
        switch (transtionModel.transtionIndex) {
            case 0:
                transtionModel.title = @"无转场";
                [dadaSource addObject:transtionModel];
                break;
            case 1:
                transtionModel.title = @"叠加";
                break;
            case 2:
                transtionModel.title = @"渐变";
                [dadaSource addObject:transtionModel];
                break;
            case 3:
                transtionModel.title = @"划入";
                [dadaSource addObject:transtionModel];
                break;
            case 19:
                transtionModel.title = @"优雅";
                [dadaSource insertObject:transtionModel atIndex:1];
                break;
            case 11:
                transtionModel.title = @"时针";
                [dadaSource insertObject:transtionModel atIndex:3];
                break;
            case 7:
                transtionModel.title = @"圆圈";
                [dadaSource addObject:transtionModel];
                break;
            case 17:
                transtionModel.title = @"溶解";
                [dadaSource addObject:transtionModel];
                break;
            default:
                break;
        }
    }
    JPTranstionsModelsArr = dadaSource;
    return dadaSource;
}

@end
