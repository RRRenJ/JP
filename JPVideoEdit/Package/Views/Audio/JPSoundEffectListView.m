//
//  JPSoundEffectListView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/26.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPSoundEffectListView.h"
#import "JPMusicListsTableViewCell.h"
#import "JPSoundEffect.h"
#import "JPMaterialDownloader.h"
#import "JPSoundEffectListSectionHeaderView.h"
#import "JPMaterial.h"
#import "JPUtil.h"

@interface JPSoundEffectListView ()<UITableViewDelegate,UITableViewDataSource,JPMaterialDownloaderDelegate,JPMusicListsTableViewCellDelegate>{
    UITableView *tbView;
    NSMutableArray *dataArr;
}
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *backBt;
@property (nonatomic, weak) IBOutlet UIView *topView;

- (void)getDataList;
- (JPMusicListsTableViewCell *)getCurrentDownloadCell:(NSString *)uuid;

@end
@implementation JPSoundEffectListView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [JPResourceBundle loadNibNamed:@"JPSoundEffectListView" owner:self options:nil];
        [self addSubview:self.contentView];
        self.contentView.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).bottomEqualToView(self);
        
        self.backgroundColor = [UIColor blackColor];
        dataArr = [NSMutableArray array];
        
        tbView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tbView.contentSize = CGSizeMake(tbView.width, tbView.height);
        tbView.backgroundColor = [UIColor blackColor];
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.showsVerticalScrollIndicator = NO;
        tbView.showsHorizontalScrollIndicator = NO;
        tbView.delegate = self;
        tbView.dataSource = self;
        [self.contentView addSubview:tbView];
        tbView.sd_layout.topSpaceToView(self.topView, 0).bottomEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
        [tbView registerNib:[UINib nibWithNibName:@"JPMusicListsTableViewCell" bundle:JPResourceBundle] forCellReuseIdentifier:@"JPMusicListsTableViewCell"];
        [self.backBt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)show{
    [JPMaterialDownloader shareInstance].delegate = self;
}

- (void)getDataList {
//    self.userInteractionEnabled = NO;
//    NSMutableDictionary *dic = @{@"service":@"App.Material_Sound.Lists"}.mutableCopy;
//    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response){
//        if (response.ret && 200 == [response.ret intValue]) {
//            if (response.data && [response.data isKindOfClass:[NSArray class]]) {
//                if (![response.data count]) {
//                    [tbView reloadData];
//                    self.userInteractionEnabled = YES;
//                    return ;
//                }
//                [dataArr removeAllObjects];
//                for (int i = 0; i < [response.data count]; i ++) {
//                    if ([[response.data objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
//                        JPSoundEffect *effect = [JPSoundEffect mj_objectWithKeyValues:[response.data objectAtIndex:i]];
//                        effect.material_id = 3;
//                        if (effect.lists && [effect.lists isKindOfClass:[NSArray class]]) {
//                            for (int j = 0; j < [effect.lists count];j++) {
//                                JPMaterial *materail = [JPMaterial mj_objectWithKeyValues:[effect.lists objectAtIndex:j]];
//                                materail.material_id = 3;
//                                NSString *index = @"";
//                                if ((j + 1) < 10) {
//                                    index = [NSString stringWithFormat:@"0%d",j + 1];
//                                } else {
//                                    index = [NSString stringWithFormat:@"%d",j + 1];
//                                }
//                                materail.indexStr = index;
//                                [effect.lists replaceObjectAtIndex:j withObject:materail];
//                                JPMaterial *m = [[JPMaterialDownloader shareInstance] getMaterialWithLocalPath:materail.localPath];
//                                if (m) {
//                                    materail.materialStatus = m.materialStatus;
//                                    materail.downloadPro = m.downloadPro;
//                                } else {
//                                    materail.materialStatus = JPMaterialStatusUnknown;
//                                }
//                            }
//                        }
//                        
//                        [dataArr addObject:effect];
//                    }
//                }
//                [tbView reloadData];
//                self.userInteractionEnabled = YES;
//            }
//        }
//    }failure:^(NSError *error){
//        self.userInteractionEnabled = YES;
//    } withErrorMsg:nil];
}

#pragma mark -

- (JPMusicListsTableViewCell *)getCurrentDownloadCell:(NSString *)uuid {
    for (int i = 0; i < [dataArr count]; i ++) {
        @autoreleasepool {
            JPSoundEffect *effect = [dataArr objectAtIndex:i];
            for (int j=0; j <[effect.lists count];j++ ) {
                JPMaterial *info = [effect.lists objectAtIndex:j];
                if ([uuid isEqualToString:info.localPath]) {
                    NSIndexPath *p = [NSIndexPath indexPathForRow:j inSection:i];
                    JPMusicListsTableViewCell *cell = (JPMusicListsTableViewCell *)[tbView cellForRowAtIndexPath:p];
                    return cell;
                }
            }
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 62;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPSoundEffect *effect = [dataArr objectAtIndex:section];
    static NSString *viewIdentfier = @"JPSoundEffectListSectionHeaderView";
    JPSoundEffectListSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    if(!headerView){
        headerView = [[JPSoundEffectListSectionHeaderView alloc] initWithReuseIdentifier:viewIdentfier];
        headerView.contentView.backgroundColor = [UIColor blackColor];
    }
    headerView.tittleLb.text = effect.material_type_name;
    return headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JPSoundEffect *effect = [dataArr objectAtIndex:section];
    return [effect.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPSoundEffect *effect = [dataArr objectAtIndex:indexPath.section];
    JPMaterial *material = [effect.lists objectAtIndex:indexPath.row];
    JPMusicListsTableViewCell *cell = (JPMusicListsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"JPMusicListsTableViewCell"];
//    if ([material.localPath isEqualToString:[[_audioModel.fileUrl absoluteString] lastPathComponent]]) {
//        material.isSelected = YES;
//    } else {
        material.isSelected = NO;
//    }
    [cell loadDataWithData:material];
    cell.delegate = self;
    cell.index = indexPath.row;
    return cell;
}

#pragma mark - JPMaterialDownloaderDelegate

- (void)mediaDownloaderUpdateProgressWithModel:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader progress:(CGFloat)progress andSpeed:(NSInteger)speed{
    JPMusicListsTableViewCell *cell = [self getCurrentDownloadCell:model.localPath];
    [cell updateViewWithProgress:progress];
}

- (void)mediaDownloaderInsertMediaModelWillDownload:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader{
    JPMusicListsTableViewCell *cell = [self getCurrentDownloadCell:model.localPath];
    [cell updateViewWithProgress:0];
}

- (void)mediaDownloaderDeleteMediaModel:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader{
    JPMusicListsTableViewCell *cell = [self getCurrentDownloadCell:model.localPath];
    [cell updateView];
    [tbView reloadData];
}

- (void)mediaDownloaderMediaModelDidDownload:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader{
    JPMusicListsTableViewCell *cell = [self getCurrentDownloadCell:model.localPath];
    [cell updateView];
    [tbView reloadData];
}

#pragma mark - JPMusicListsTableViewCellDelegate

- (void)toDownloadTheMdoel:(JPMaterial *)material andIndex:(NSInteger)index {
    NSArray *arr = [[JPMaterialDownloader shareInstance] localMaterials];
    if (![arr containsObject:material]) {
        [[JPMaterialDownloader shareInstance] insertModelToDownload:material];
    }
}

- (void)toSelectedTheMdoel:(JPMaterial *)material andIndex:(NSInteger)index{
    JPAudioModel *audioModel = [[JPAudioModel alloc] init];
    audioModel.isITunes = NO;
    audioModel.startTime = kCMTimeZero;
    audioModel.isBundle = NO;
    audioModel.baseFilePath = material.baseFilePath;
    audioModel.fileName = material.name;
    audioModel.resource_id = [NSString stringWithFormat:@"%lld", material.mid];
    audioModel.durationTime = [JPVideoUtil getVideoDurationWithSourcePath:audioModel.fileUrl];
    audioModel.clipTimeRange = CMTimeRangeMake(audioModel.startTime, audioModel.durationTime);
    if (0 >= CMTimeCompare(audioModel.durationTime, kCMTimeZero)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"文件出错啦。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(soundEffectListViewSelectedMusic:)]) {
        [self.delegate soundEffectListViewSelectedMusic:audioModel];
    }
    [self back:nil];
}

#pragma mark - 

- (void)back:(UIButton *)sender{
    [JPMaterialDownloader shareInstance].delegate = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(soundEffectListViewWillPop:)]) {
        [self.delegate soundEffectListViewWillPop:self];
    }
}

@end
