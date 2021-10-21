//
//  JPNewPatternMuneView.m
//  jper
//
//  Created by FoundaoTEST on 2017/8/1.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPNewPatternMuneView.h"
#import "JPNewPatternTableViewCell.h"
#import "JPPromptView.h"

@interface JPNewPatternMuneView ()<UITableViewDataSource, JPNewPatternTableViewCellDelegate, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *tipImgView;


@end

@implementation JPNewPatternMuneView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    [self setTittle:@"图案添加"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];

//    [addButton setImage:JPImageWithName(@"add-4") forState:UIControlStateNormal];
//    addButton.layer.masksToBounds = YES;
//    addButton.layer.borderWidth = 0.5;
//    addButton.layer.borderColor = [UIColor colorWithHex:0x1f1f1f].CGColor;

    [addButton setImage:JPImageWithName(@"tuan_ad") forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];
    self.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];
    [self addSubview:addButton];
    CGFloat bottom = JPTabbarHeightLineHeight;
    addButton.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, bottom).heightIs(41);
    [addButton addTarget:self action:@selector(addPackagePatternAction:) forControlEvents:UIControlEventTouchUpInside];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tittleView.bottom, self.width, self.height - self.tittleView.bottom - addButton.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.sd_layout.topSpaceToView(self.tittleView, 0).widthRatioToView(self, 1.0).rightEqualToView(self).bottomSpaceToView(addButton, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] init];
    _tableView.tableHeaderView = [[UITableViewHeaderFooterView alloc] init];
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_messageLabel];
    _messageLabel.sd_layout.topEqualToView(_tableView).bottomEqualToView(_tableView).rightEqualToView(_tableView).leftEqualToView(_tableView);
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont systemFontOfSize:12];
    _messageLabel.text = @"添加一个图案吧";
    
    _tipImgView = [[UIImageView alloc] init];
    _tipImgView.image = JPImageWithName(@"Prompt-add");
    _tipImgView.hidden = YES;
    [self addSubview:_tipImgView];
    _tipImgView.sd_layout.bottomSpaceToView(addButton, 5).centerXIs(self.centerX).widthIs(67).heightIs(37);
    if ([JPUtil getInfoFromUserDefaults:@"patternMuneView-add"] == nil) {
        _tipImgView.hidden = NO;
        
    }
}

- (void)addPackagePatternAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newPatternMuneViewWillAddPatternWith:)]) {
        [JPUtil saveIssueInfoToUserDefaults:@"patternMuneView-add" resouceName:@"patternMuneView-add"];
        _tipImgView.hidden = YES;
        [self.delegate newPatternMuneViewWillAddPatternWith:self];
    }
}

- (void)dismiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newPatternMuneViewWillDismissWith:) ]) {
        [self.delegate newPatternMuneViewWillDismissWith:self];
    }
}

- (void)setDataSource:(NSMutableArray<JPPackagePatternAttribute *> *)dataSource
{
    _dataSource = dataSource;
    [_tableView reloadData];
    if (_dataSource.count == 0) {
        _messageLabel.hidden = NO;
    }else{
        _messageLabel.hidden = YES;
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *newPatternId = @"newPatternId";
    JPNewPatternTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newPatternId];
    JPPackagePatternAttribute *attribute = _dataSource[indexPath.row];
    if (cell == nil) {
        cell = [[JPNewPatternTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newPatternId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    CGFloat total = CMTimeGetSeconds(_videoCompositionPlayer.recordInfo.totalVideoDuraion);
    CGFloat start = CMTimeGetSeconds(attribute.timeRange.start);
    CGFloat end = CMTimeGetSeconds(attribute.timeRange.duration) + CMTimeGetSeconds(attribute.timeRange.start);
    if (attribute.patternType == JPPackagePatternTypeWeekPicture) {
        start = 0;
        end = total;
    }
    [cell updateSliderWithMinValue:0.f
                       andMaxValue:total
                      andLeftValue:start
                     andRightVlaue:end];
    cell.atturbue = attribute;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JPPackagePatternAttribute *attribute = _dataSource[indexPath.row];
    
    [_videoCompositionPlayer scrollToWatchThumImageWithTime:attribute.timeRange.start withSticker:NO];

}

#pragma mark - JPNewPatternTableViewCellDelegate

- (void)rangeSliderValueDidChangeWithLeftValue:(CGFloat)left andRightValue:(CGFloat)right andAttrubute:(JPPackagePatternAttribute *)patternAttribute {
    
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(left, 24),CMTimeMakeWithSeconds(right - left, 24));
    CMTimeRange originTimeRang = patternAttribute.timeRange;
    patternAttribute.timeRange = timeRange;
    if (CMTimeCompare(originTimeRang.start, timeRange.start) == 0 && CMTimeCompare(originTimeRang.duration, timeRange.duration) != 0) {
        [_videoCompositionPlayer scrollToWatchThumImageWithTime:CMTimeAdd(timeRange.duration, timeRange.start) withSticker:NO];
    }else if(CMTimeCompare(originTimeRang.start, timeRange.start) != 0){
        [_videoCompositionPlayer scrollToWatchThumImageWithTime:timeRange.start withSticker:NO];
    }
}

- (void)rangeSliderValueDidEndChangeWithLeftValue:(CGFloat)left andRightValue:(CGFloat)right andAttrubute:(JPPackagePatternAttribute *)patternAttribute
{
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(left, 24),CMTimeMakeWithSeconds(right - left, 24));
    patternAttribute.timeRange = timeRange;
    [_videoCompositionPlayer scrollToWatchThumImageWithTime:timeRange.start withSticker:NO];
    
}
@end
