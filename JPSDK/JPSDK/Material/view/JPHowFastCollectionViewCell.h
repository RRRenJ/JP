//
//  JPHowFastCollectionViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/5/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPHowFastCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
- (void)selected:(BOOL)selected;

@end
