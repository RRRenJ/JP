//
//  JPSelectVideosView.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPSelectVideosViewDelegate <NSObject>

- (void)selectVideosViewShouldDeleteVideoModel:(JPVideoModel *)videoModel;

@end

@interface JPSelectVideosView : UIView
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) id<JPSelectVideosViewDelegate>delegate;

@end
