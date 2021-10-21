//
//  JPMusicListsTableViewCell.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPMusicListsTableViewCell.h"
#import "JPVideoPublishProgressView.h"

@interface JPMusicListsTableViewCell () {
    JPVideoPublishProgressView *progressView;
    JPMaterial *_material;
}

@property (nonatomic, weak) IBOutlet UILabel *numberLb;
@property (nonatomic, weak) IBOutlet UILabel *nameLb;
@property (nonatomic, weak) IBOutlet UIButton *determineBtn;
@property (nonatomic, weak) IBOutlet UIButton *downloadBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *numberLbWidthLayoutConstraint;

@end

@implementation JPMusicListsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor blackColor];
    progressView = [[JPVideoPublishProgressView alloc] initWithFrame:CGRectMake(0, 0, 25, 25) withStartAngle:-M_PI endAngle:M_PI];
    [progressView updateViewWithProgress:0];
    [progressView hideProgerssLb];
    [progressView changeProgessColorWithColor:[UIColor jp_colorWithHexString:@"0091ff"] andTintColor:[UIColor jp_colorWithHexString:@"313131"]];
    progressView.hidden = YES;
    [self.contentView addSubview:progressView];
    progressView.sd_layout.rightSpaceToView(self.contentView, 15).heightIs(25).widthEqualToHeight().centerYEqualToView(self.contentView);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 

- (void)loadDataWithData:(JPMaterial *)material {
    _material = material;
    self.numberLbWidthLayoutConstraint.constant = material.indexWidth;
    self.numberLb.text = material.indexStr;
    self.nameLb.text = material.name;
    [self updateView];
}

- (void)updateView {
    self.nameLb.textColor = [UIColor whiteColor];
    if (_material.isSelected) {
        [self.determineBtn setImage:JPImageWithName(@"finish_small") forState:UIControlStateNormal];
        self.nameLb.textColor = [UIColor jp_colorWithHexString:@"0091ff"];
        self.downloadBtn.hidden = YES;
        self.downloadBtn.enabled = NO;
        self.determineBtn.hidden = NO;
        self.determineBtn.enabled = YES;
        progressView.hidden = YES;
    } else if(_material.materialStatus == JPMaterialStatusUnknown){
        self.downloadBtn.hidden = NO;
        self.downloadBtn.enabled = YES;
        self.determineBtn.hidden = YES;
        self.determineBtn.enabled = NO;
        progressView.hidden = YES;
    } else if (_material.materialStatus == JPMaterialStatusDownLoaded){
        [self.determineBtn setImage:JPImageWithName(@"circular-1") forState:UIControlStateNormal];
        self.downloadBtn.hidden = YES;
        self.downloadBtn.enabled = NO;
        self.determineBtn.hidden = NO;
        self.determineBtn.enabled = YES;
        progressView.hidden = YES;
    } else {
        self.downloadBtn.hidden = YES;
        self.downloadBtn.enabled = NO;
        self.determineBtn.hidden = YES;
        self.determineBtn.enabled = NO;
        progressView.hidden = NO;
    }
}

- (void)updateViewWithProgress:(double)progress {
    progressView.hidden = NO;
    [progressView updateViewWithProgress:progress];
}

#pragma mark - actions 

- (IBAction)download:(id)sender{
    [self updateView];
    self.downloadBtn.hidden = YES;
    self.downloadBtn.enabled = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(toDownloadTheMdoel:andIndex:)]) {
        [self.delegate toDownloadTheMdoel:_material andIndex:_index];
    }
}

- (IBAction)selected:(id)sender{
    _material.isSelected = !_material.isSelected;
    [self updateView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(toDownloadTheMdoel:andIndex:)]) {
        [self.delegate toSelectedTheMdoel:_material andIndex:_index];
    }
}

@end
