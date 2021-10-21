//
//  JPPackageViewCache.m
//  jper
//
//  Created by FoundaoTEST on 2017/4/13.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPackageViewCache.h"
#import "JPPackageTextAndBackgroudView.h"
#import "JPTextWithBorderInteractiveView.h"
#import "JPTextWithUpBorderInteractiveView.h"
#import "JPPackageHollowOutInteractiveView.h"
#import "JPPackageSixthTextPatternInteractiveView.h"
#import "JPPackageSeventhTextPatternInteractiveView.h"
#import "JPPackageEighthTextPatternInteractiveView.h"
#import "JPPackageNinthTextPatternInteractiveView.h"
#import "JPPackageTenthTextPatternInteractiveView.h"
#import "JPGifPatternInteractiveView.h"
@interface JPPackageViewCache ()<JPPatternInteractiveViewDelegate>
@property (nonatomic, strong) NSMutableArray *cacheViewArr;
@end

@implementation JPPackageViewCache

- (instancetype)init
{
    if (self = [super init]) {
        _cacheViewArr = [NSMutableArray array];
    }
    return self;
}
- (JPPatternInteractiveView *)addCacheFromViewModel:(JPPackagePatternAttribute *)viewModel withSuperView:(UIView *)superView
{
    JPPatternInteractiveView *view;
    for (JPPatternInteractiveView *subview in _cacheViewArr) {
        if (subview.patternAttribute.patternType == viewModel.patternType && subview.isHidden == YES) {
            view = subview;
            break;
        }
        if (view == nil && subview.patternAttribute.patternType == JPPackagePatternTypeWeekPicture && view.patternAttribute.patternType == JPPackagePatternTypeWeekPicture) {
            view = subview;
            break;
        }
    }
    if (!view) {
        switch (viewModel.patternType) {
            case JPPackagePatternTypeDownloadedPicture:
            case JPPackagePatternTypeWeekPicture:
                view = [[JPPackagePictureGraphView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 50;
                break;
                
            case JPPackagePatternTypeHollowOutPicture:
                view = [[JPPackageHollowOutInteractiveView alloc] initWithFrame:viewModel.frame];
                ((JPPackageHollowOutInteractiveView *)view).patternAttribute = viewModel;
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 80;
                view.minHeight = 60;
                break;
            case JPPackagePatternTypeTextWithUpAndDownLine:
                view = [[JPTextWithUpBorderInteractiveView alloc] initWithFrame:viewModel.frame];
                ((JPTextWithUpBorderInteractiveView *)view).patternAttribute = viewModel;
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 60;
                view.minHeight = 80;
                break;
                
            case JPPackagePatternTypeTextWithBorderLine:
                view = [[JPTextWithBorderInteractiveView alloc] initWithFrame:viewModel.frame];
                ((JPTextWithBorderInteractiveView *)view).patternAttribute = viewModel;
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 65;
                view.minHeight = 65;
                break;
            case JPPackagePatternTypeDate:
                view = [[JPPackageGraphPatternView alloc] initWithFrame:viewModel.frame];
                ((JPPackageGraphPatternView *)view).patternAttribute = viewModel;
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 38;
                view.minHeight = 50;
                break;
            case JPPackagePatternTypePosition:
                view = [[JPPackageGraphPatternView alloc] initWithFrame:viewModel.frame];
                ((JPPackageGraphPatternView *)view).patternAttribute = viewModel;
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 44;
                break;
            case JPPackagePatternTypeWeather:
                view = [[JPPackageGraphPatternView alloc] initWithFrame:viewModel.frame];
                ((JPPackageGraphPatternView *)view).patternAttribute = viewModel;
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 145;
                view.minHeight = 110;
                break;
            case JPPackagePatternTypePicture:
                view = [[JPPackagePictureGraphView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 50;
                break;
            case JPPackagePatternTypeTextWithNone:
                view = [[JPPackageTextNoneGraphView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 42;
                view.minHeight = 42;
                break;
            case JPPackagePatternTypeTextWithPinyin:
                view = [[JPJPPackageTextWithPingyinGraphView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 58;
                view.minHeight = 58;
                break;
            case JPPackagePatternTypeTextWithBackgroundColor:
                view = [[JPPackageTextAndBackgroudView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 50;
                break;
            case JPPackagePatternTypeSixthTextPattern:
                view = [[JPPackageSixthTextPatternInteractiveView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 150;
                break;
            case JPPackagePatternTypeSeventhTextPattern:
                view = [[JPPackageSeventhTextPatternInteractiveView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 50;
                break;
            case JPPackagePatternTypeEighthTextPattern:
                view = [[JPPackageEighthTextPatternInteractiveView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 50;
                break;
            case JPPackagePatternTypeNinthTextPattern:
                view = [[JPPackageNinthTextPatternInteractiveView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 50;
                break;
            case JPPackagePatternTypeTenthTextPattern:
                view = [[JPPackageTenthTextPatternInteractiveView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 50;
                break;
            case JPPackagePatternTypeGifPattern:
                view = [[JPGifPatternInteractiveView alloc] initWithFrame:viewModel.frame];
                [superView addSubview:view];
                [_cacheViewArr addObject:view];
                view.preventsDeleting = YES;
                view.delegate = self;
                view.minWidth = 50;
                view.minHeight = 50;
                break;
            default:
                break;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWillEdit:)];
        [view addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWillInput:)];
        doubleTap.numberOfTapsRequired = 2;
        [view addGestureRecognizer:doubleTap];
    }
    view.hidden = NO;
    [view setFrame:viewModel.frame];
    [view showEditingHandles];
    view.apearTimeRange = viewModel.timeRange;
    view.patternAttribute = viewModel;
    //    view.scale = 1.0;
    return view;
}

- (void)viewWillEdit:(UITapGestureRecognizer *)tap
{
    if (self.delegate) {
        [self.delegate packageViewCacheWillEditTheView:(JPPatternInteractiveView *)tap.view withViewCache:self];
    }
}

- (void)viewWillInput:(UITapGestureRecognizer *)ges {
    if (self.delegate) {
        [self.delegate packageViewCacheWillInputTheView:(JPPatternInteractiveView *)ges.view withViewCache:self];
    }
}

- (void)willApearSomeViewWithViewModels:(NSArray *)viewModels withSuperView:(UIView *)superView
{
    
    for (JPPackagePatternAttribute *viewModel in viewModels) {
        if (viewModel.patternType == JPPackagePatternTypeWeekPicture) {
            continue;
        }
        JPPatternInteractiveView *view;
        for (JPPatternInteractiveView *subview in _cacheViewArr) {
            if (subview.patternAttribute.patternType == viewModel.patternType && subview.isHidden == YES) {
                view = subview;
                break;
            }
        }
        if (view == nil) {
            [self addCacheFromViewModel:viewModel withSuperView:superView];
            continue;
        }
        view.hidden = NO;
        [view setFrame:viewModel.frame];
        view.apearTimeRange = viewModel.timeRange;
        [view showEditingHandles];
        view.patternAttribute = viewModel;
    }
    
}
- (void)willDisAllView
{
    for (JPPatternInteractiveView *subview in _cacheViewArr) {
        if (subview.patternAttribute.patternType == JPPackagePatternTypeWeekPicture) {
            continue;
        }
        subview.apearTimeRange = kCMTimeRangeZero;
        subview.hidden = YES;
    }
}

- (void)editButtonShowBeHide
{
    for (JPPatternInteractiveView *subview in _cacheViewArr) {
        [subview hideEditingHandles];
        //        superView = subview.superview;
        //        subview.frame = CGRectMake(subview.left * self.rate + 13 * (self.rate - 1), subview.top * self.rate + 13 * (self.rate - 1), (subview.width - 26) * self.rate + 26, (subview.height - 26) * self.rate + 26);
        //        subview.scale = self.rate;
    }
}
#pragma mark JPPatternInteractiveViewDelegate

- (void)patternInteractiveViewDidClose:(JPPatternInteractiveView *)sticker
{
    sticker.hidden = YES;
    if (self.delegate) {
        [self.delegate packageViewCacheRemoveViewModel:sticker.patternAttribute withViewCache:self];
    }
}

- (void)patternInteractiveViewWillMove:(JPPatternInteractiveView *)sticker {
    if (self.delegate) {
        [self.delegate packageViewCacheWillMove:sticker withViewCache:self];
    }
}

- (void)dealloc
{
    
}

- (void)patternInteractiveViewEndMove:(JPPatternInteractiveView *)sticker{
    if (self.delegate) {
        [self.delegate packageViewCacheEndMove:sticker withViewCache:self];
    }
}

- (UIImage *)getImageWithModel:(JPPackagePatternAttribute *)model
{
    if (model.patternType == JPPackagePatternTypeWeekPicture || model.patternType == JPPackagePatternTypeHollowOutPicture || model.patternType == JPPackagePatternTypePicture || model.patternType == JPPackagePatternTypeDownloadedPicture) {
        return model.originImage;
    }
    JPPatternInteractiveView *view;
    for (JPPatternInteractiveView *subview in _cacheViewArr) {
        if (subview.patternAttribute.patternType == model.patternType && subview.isHidden == YES) {
            view = subview;
            break;
        }
    }
    view.patternAttribute = model;
    CGSize size = [view.contentView getMyReallySizeWithPackagePatternAttribute:model andScale:self.scale];
    [view setFrame: CGRectMake(0, 0, size.width  + 26, size.height  + 26)];
    [view layoutIfNeeded];
    view.scale = self.scale;
    view.apearTimeRange = model.timeRange;
    [view showEditingHandles];
    view.contentView.layer.contentsScale = [UIScreen mainScreen].scale;
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(view.contentView.bounds.size, NO,0);
        [view.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        view.scale = 1.0;
        [view layoutIfNeeded];
        return image;
    }
    
}
@end
