//
//  JPNewTranstionChangedView.h
//  jper
//
//  Created by FoundaoTEST on 2017/7/28.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPNewTranstionChangedViewDelegate <NSObject>

- (void)newTranstionChangedViewChangeTranstionModel:(JPVideoTranstionsModel *)transtionModel withTranstionModel:(JPVideoModel *)videoModel;

@end

@interface JPNewTranstionChangedView : UIView

@property (nonatomic, strong, readonly) UICollectionView * collecView;

@property (nonatomic, weak) id<JPNewTranstionChangedViewDelegate>delegate;
@property (nonatomic, weak) JPVideoModel *videoModel;

@end
