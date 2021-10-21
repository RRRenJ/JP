//
//  JPGraphCollectionViewCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/11.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPGraphCollectionViewCell.h"
#import "JPVideoPublishProgressView.h"
#import "UIImageView+WebCache.h"
#import "JPUtil.h"

@interface JPGraphCollectionViewCell (){
    UIImageView *thumImgView;
    UIImageView *downloadBtn;
    JPVideoPublishProgressView *downloadProView;
    JPMaterial *material;
}

- (void)createUI;

@end

@implementation JPGraphCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - 

- (void)createUI {
    thumImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    thumImgView.contentMode = UIViewContentModeScaleAspectFit;
    thumImgView.clipsToBounds = YES;
    [self.contentView addSubview:thumImgView];
    thumImgView.sd_layout.topEqualToView(self.contentView).bottomEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    
    downloadProView = [[JPVideoPublishProgressView alloc] initWithFrame:CGRectMake(0, 0, 15, 15) withStartAngle:-M_PI endAngle:M_PI];
    [downloadProView updateViewWithProgress:0];
    [downloadProView hideProgerssLb];
    [downloadProView changeProgessColorWithColor:[UIColor jp_colorWithHexString:@"313131"] andTintColor:[UIColor jp_colorWithHexString:@"0091ff"]];
    downloadProView.hidden = YES;
    [self.contentView addSubview:downloadProView];
    downloadProView.sd_layout.bottomEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(15).widthEqualToHeight();
    
    
    
    downloadBtn = [[UIImageView alloc] initWithFrame:CGRectZero];
    downloadBtn.image = JPImageWithName(@"graph_download");
    [self.contentView addSubview:downloadBtn];
    downloadBtn.sd_layout.bottomEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(15).widthEqualToHeight();
}

- (void)loadDataWithResource:(JPMaterial *)info {
    material = info;
    if (info.icon) {
        [thumImgView sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:nil];
    }
    downloadBtn.hidden = JPMaterialStatusUnknown != material.materialStatus;
}

- (void)updateViewWithProgress:(double)progress {
    downloadProView.hidden = NO;
    downloadBtn.hidden = YES;
    [downloadProView updateViewWithProgress:progress];
}

- (void)hiddenProgressView {
    downloadProView.hidden = YES;
}

- (void)showProgressView {
    downloadBtn.hidden = YES;
    downloadProView.hidden = NO;
}


#pragma mark - actions

- (void)download:(id)sender {
    downloadBtn.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(toDownloadTheMdoel:andIndex:)]) {
        [self.delegate toDownloadTheMdoel:material andIndex:_index];
    }
}

@end
