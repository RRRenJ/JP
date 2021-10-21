//
//  JPMusicListsTableViewCell.h
//  jper
//
//  Created by 藩 亜玲 on 2017/7/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPMaterial.h"

@protocol JPMusicListsTableViewCellDelegate <NSObject>

- (void)toDownloadTheMdoel:(JPMaterial *)material andIndex:(NSInteger)index;
- (void)toSelectedTheMdoel:(JPMaterial *)material andIndex:(NSInteger)index;
@end

@interface JPMusicListsTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<JPMusicListsTableViewCellDelegate>delegate;
- (void)loadDataWithData:(JPMaterial *)material;
- (void)updateView;
- (void)updateViewWithProgress:(double)progress;

@end
