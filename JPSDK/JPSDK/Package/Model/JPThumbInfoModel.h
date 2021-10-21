//
//  JPThumbInfoModel.h
//  jper
//
//  Created by FoundaoTEST on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPThumbInfoModel : NSObject
@property (nonatomic, assign) BOOL isLast;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat transtionPlaceWidth;
@property (nonatomic, assign) CMTime totalDuration;
@property (nonatomic, assign) CMTime videoDuration;
@property (nonatomic, assign) CMTime reallyDuration;
@property (nonatomic, weak) JPVideoModel *videoModel;
@property (nonatomic, strong) NSArray *thumbImageArr;
@property (nonatomic, assign) CGFloat contentOffset;
@property (nonatomic, strong) JPVideoTranstionsModel * transtionModel;
@property (nonatomic, assign, readonly) CGSize imageSize;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign, readonly) NSInteger imageStartIndex;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) CMTime startTime;
@property (nonatomic, assign) CGFloat startPoint;

@end
