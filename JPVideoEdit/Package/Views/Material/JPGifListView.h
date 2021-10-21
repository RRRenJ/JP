//
//  JPGifListView.h
//  jper
//
//  Created by FoundaoTEST on 2017/11/14.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JPJPGifListViewDelegate <NSObject>

- (void)selectedGifGraphWithData:(JPPackagePatternAttribute *)data;

@end
@interface JPGifListView : UIView
@property (nonatomic, weak) id<JPJPGifListViewDelegate>delegate;
- (void)show;
- (void)dismiss;
@end
