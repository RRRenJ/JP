//
//  JPFilterCollectionView.h
//  jper
//
//  Created by FoundaoTEST on 2017/3/24.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JPFilterCollectionViewDelegate <NSObject>
- (void)changeTheSelectfilter:(JPFilterModel *)filter;
@end

@interface JPFilterCollectionView : UIView
@property (nonatomic, readonly) JPFilterModel* currentSelectModel;
@property(nonatomic, weak) id<JPFilterCollectionViewDelegate> delegate;
- (void)reloadSelectFilterModel:(JPFilterModel *)filterModel;
@end
