//
//  JPAudioMenuView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPSoundEffectMenuView.h"
#import "JPSoundEffectTableViewCell.h"
#import "JPSoundEffect.h"

@interface JPSoundEffectMenuView ()<UITableViewDelegate,UITableViewDataSource,JPSoundEffectTableViewCellDelegate> {
    UITableView *tbView;
    NSMutableArray *dataArr;
    UILabel *messageLabel;
    CMTime duration;
}
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (nonatomic, weak) JPVideoCompositionPlayer *compositionPlayer;
@end

@implementation JPSoundEffectMenuView

- (instancetype)initWithFrame:(CGRect)frame andCompositionPlayer:(JPVideoCompositionPlayer *)compositionPlayere {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [JPResourceBundle loadNibNamed:@"JPSoundEffectMenuView" owner:self options:nil];
        [self addSubview:self.contentView];
        self.contentView.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).bottomEqualToView(self);
        self.backgroundColor = [UIColor blackColor];
        dataArr = [NSMutableArray array];
        _compositionPlayer = compositionPlayere;
        duration = [_compositionPlayer videoDuration];
        _bottomHeight.constant = 40 + JPTabbarHeightLineHeight;
        //列表
        tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, JP_SCREEN_WIDTH, self.height - _bottomViewHeightLayoutConstraint.constant) style:UITableViewStylePlain];
        [tbView registerNib:[UINib nibWithNibName:@"JPSoundEffectTableViewCell" bundle:JPResourceBundle] forCellReuseIdentifier:@"JPSoundEffectTableViewCell"];
        tbView.contentSize = CGSizeMake(tbView.width, tbView.height);
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.delegate = self;
        tbView.backgroundColor = self.backgroundColor;
        tbView.dataSource = self;
        tbView.bounces = YES;
        tbView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:tbView];
        tbView.sd_layout.topEqualToView(self.contentView).bottomSpaceToView(self.bottomView, 0).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
        messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:messageLabel];
        messageLabel.sd_layout.topEqualToView(tbView).bottomEqualToView(tbView).rightEqualToView(tbView).leftEqualToView(tbView);
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:12];
        messageLabel.text = @"添加一个音效吧";
    }
    return self;
}

- (void)addMusic:(JPAudioModel *)model {
    [_recordInfo addSoundEffectFile:model];
    [dataArr sgrAddObject:model];
    [tbView reloadData];
    if (dataArr.count == 0) {
        messageLabel.hidden = NO;
    }else{
        messageLabel.hidden = YES;
    }
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer seekToTime:model.startTime];
    [_compositionPlayer startPlaying];
}

- (void)updateViews {
    [dataArr removeAllObjects];
    duration = _recordInfo.totalVideoDuraion;
    NSMutableArray *deleteAudioArr = [NSMutableArray array];
    CMTimeRange range = CMTimeRangeMake(kCMTimeZero, _recordInfo.totalVideoDuraion);
    for (int i = 0; i < [_recordInfo.soundEffectSource count]; i ++) {
        @autoreleasepool {
            JPAudioModel *model = (JPAudioModel *)[_recordInfo.soundEffectSource objectAtIndex:i];
            if (CMTimeRangeContainsTime(range, model.startTime)) {
                if ((0 > CMTimeCompare(CMTimeSubtract(_recordInfo.totalVideoDuraion, model.startTime), model.durationTime))) {
                    model.durationTime = CMTimeSubtract(_recordInfo.totalVideoDuraion, model.startTime);
                    model.clipTimeRange = CMTimeRangeMake(model.startTime, model.durationTime);
                    if (CMTimeCompare(model.durationTime, kCMTimeZero) <= 0) {
                        [deleteAudioArr addObject:model];
                        continue;
                    }
                }
            } else{
                [deleteAudioArr addObject:model];
                continue;
            }
            if (CMTimeCompare(model.durationTime, kCMTimeZero)> 0) {
                [dataArr addObject:model];
            }
        }
    }
    if (dataArr.count == 0) {
        messageLabel.hidden = NO;
    }else{
        messageLabel.hidden = YES;
    }
    [tbView reloadData];
    [_recordInfo removeSoundEffectFilesWithArr:deleteAudioArr];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer seekToTime:kCMTimeZero];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPAudioModel *model = [dataArr objectAtIndex:indexPath.row];
    JPSoundEffectTableViewCell *cell = (JPSoundEffectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"JPSoundEffectTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.duration = duration;
    [cell loadViewWithDataSource:model];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JPScreenFitFloat6(60);
}

#pragma mark - JPSoundEffectTableViewCellDelegate

- (void)willDeleteTheAudioModel:(JPAudioModel *)model{
    [_compositionPlayer pauseToPlay];
}

- (void)deleteTheAudioModel:(JPAudioModel *)model {
    if ([dataArr containsObject:model]) {
        [_recordInfo deleteSoundEffectFile:model];
        [dataArr removeObject:model];
        [tbView reloadData];
        if (dataArr.count == 0) {
            messageLabel.hidden = NO;
        }else{
            messageLabel.hidden = YES;
        }
        [_compositionPlayer setRecordInfo:_recordInfo];
        [_compositionPlayer seekToTime:kCMTimeZero];
        [_compositionPlayer startPlaying];
    }
}

- (void)didChangeStartTimeWithTheModel:(JPAudioModel *)model {
    [_compositionPlayer scrollToWatchThumImageWithTime:model.startTime withSticker:NO];
}

- (void)didEndChangeStartTimeWithTheModel:(JPAudioModel *)model{
    model.clipTimeRange = CMTimeRangeMake(model.startTime, model.durationTime);
    int index = (int)[[_recordInfo soundEffectSource] indexOfObject:model];
    [_recordInfo repelaceSoundEffectFileWithModel:model atIndex:index];
//    NSMutableArray *deleteArr = [NSMutableArray array];
//    NSMutableArray *addArr = [NSMutableArray array];
//    NSMutableArray *deleteAudioArr = [NSMutableArray array];
//    for (JPAudioModel *m in dataArr) {
//        if (CMTimeRangeContainsTime(model.clipTimeRange, m.startTime) && CMTimeRangeContainsTime(model.clipTimeRange, CMTimeAdd(m.startTime, m.durationTime))) {
//            [deleteArr addObject:m];
//            continue;
//        }
//    }
//    [_recordInfo removeAudioFilesWithArr:deleteAudioArr];
//    [_recordInfo addAudioFile:model];
//    [dataArr removeObjectsInArray:deleteArr];
//    [dataArr addObjectsFromArray:addArr];
//    [tbView reloadData];
    [_compositionPlayer setRecordInfo:_recordInfo];
    [_compositionPlayer seekToTime:kCMTimeZero];
    [_compositionPlayer startPlaying];
}

- (void)willChangeStartTimeWithTheModel:(JPAudioModel *)model{
    [_compositionPlayer pauseToPlay];
}

#pragma mark - 

- (IBAction)soundList:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSoundEffectListView)]) {
        [self.delegate showSoundEffectListView];
    }
}

@end
