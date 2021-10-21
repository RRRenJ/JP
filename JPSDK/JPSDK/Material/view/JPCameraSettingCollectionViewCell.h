//
//  JPCameraSettingCollectionViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/4/10.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPCameraSettingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (nonatomic, copy) NSString *  name;

- (void)selected:(BOOL)selected;

@end
