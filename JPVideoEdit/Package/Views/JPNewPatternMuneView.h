//
//  JPNewPatternMuneView.h
//  jper
//
//  Created by FoundaoTEST on 2017/8/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPackageMenuBaseView.h"

@class JPNewPatternMuneView;
@protocol JPNewPatternMuneViewDelegate <NSObject>

- (void)newPatternMuneViewWillDismissWith:(JPNewPatternMuneView *)muneView;
- (void)newPatternMuneViewWillAddPatternWith:(JPNewPatternMuneView *)muneView;

@end
@interface JPNewPatternMuneView : JPPackageMenuBaseView
@property (nonatomic, weak) id<JPNewPatternMuneViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray <JPPackagePatternAttribute *>* dataSource;
@property (nonatomic, weak) JPVideoCompositionPlayer *videoCompositionPlayer;
@end
