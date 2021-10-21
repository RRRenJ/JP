//
//  JPGraphListView.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPGraphListViewDelegate <NSObject>

- (void)selectedDownloadedGraphWithData:(JPPackagePatternAttribute *)data;

@end

@interface JPGraphListView : UIView
@property (nonatomic, weak) id<JPGraphListViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andCategoryId:(NSString *)categoryId;
- (void)show;
@end
