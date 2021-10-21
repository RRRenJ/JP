//
//  JPLocalMediaCloudTableViewCell.h
//  jper
//
//  Created by FoundaoTEST on 2017/6/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JPMediaModel.h"

@interface JPLocalMediaCloudTableViewCell : UITableViewCell

@property (nonatomic, strong) JPMediaModel *mediaModel;
@property (nonatomic, strong)  UIImageView *plhoderImageView;
@end
