//
//  JPPackageViewCache.h
//  jper
//
//  Created by FoundaoTEST on 2017/4/13.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPPackagePictureGraphView.h"
#import "JPPackageTextNoneGraphView.h"
#import "JPPackageGraphPatternView.h"
#import "JPJPPackageTextWithPingyinGraphView.h"

@class JPPackageViewCache;

@protocol JPPackageViewCacheDelegate <NSObject>

- (void)packageViewCacheRemoveViewModel:(JPPackagePatternAttribute *)viewModels withViewCache:(JPPackageViewCache *)cache;
- (void)packageViewCacheIsGlobal:(JPPackagePatternAttribute *)viewModels withViewCache:(JPPackageViewCache *)cache;
- (void)packageViewCacheWillEditTheView:(JPPatternInteractiveView *)view withViewCache:(JPPackageViewCache *)cache;
- (void)packageViewCacheWillInputTheView:(JPPatternInteractiveView *)view withViewCache:(JPPackageViewCache *)cache;
- (void)packageViewCacheWillMove:(JPPatternInteractiveView *)view withViewCache:(JPPackageViewCache *)cache;
- (void)packageViewCacheEndMove:(JPPatternInteractiveView *)view withViewCache:(JPPackageViewCache *)cache;
@end

@interface JPPackageViewCache : NSObject

@property (nonatomic, weak) id<JPPackageViewCacheDelegate>delegate;
- (JPPatternInteractiveView *)addCacheFromViewModel:(JPPackagePatternAttribute *)viewModel withSuperView:(UIView *)superView;
@property (nonatomic, assign) CGFloat scale;
- (void)willApearSomeViewWithViewModels:(NSArray *)viewModels withSuperView:(UIView *)superView;
- (void)willDisAllView;
- (void)editButtonShowBeHide;
- (UIImage *)getImageWithModel:(JPPackagePatternAttribute *)model;
@end
