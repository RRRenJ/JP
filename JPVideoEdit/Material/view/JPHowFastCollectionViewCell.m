//
//  JPHowFastCollectionViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/5/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPHowFastCollectionViewCell.h"

@implementation JPHowFastCollectionViewCell


- (void)selected:(BOOL)selected{
    if (selected) {
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 2;
        self.contentView.backgroundColor = [UIColor jp_colorWithHexString:@"3e3e3e"];
    }else{
        self.contentView.layer.masksToBounds = NO;
        self.contentView.layer.cornerRadius = 0;
        self.contentView.backgroundColor = [UIColor jp_colorWithHexString:@"232323"];
    }
    
}

@end
