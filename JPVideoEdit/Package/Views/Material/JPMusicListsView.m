//
//  JPMusicListsView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/7/12.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPMusicListsView.h"
#import "JPMusicListsTableViewCell.h"
#import "JPMaterialDownloader.h"
#import "JPMaterial.h"
#import "JPUtil.h"

@interface JPMusicListsView ()<UITableViewDelegate,UITableViewDataSource,JPMaterialDownloaderDelegate,JPMusicListsTableViewCellDelegate>{
    UITableView *tbView;
    NSMutableArray *dataArr;
    UILabel *tittleLb;
    JPMaterialCategory *_category;
}

- (void)createUI;
- (void)getListsData;
- (JPMusicListsTableViewCell *)getCurrentDownloadCell:(NSString *)uuid;

@end

@implementation JPMusicListsView

- (id)initWithFrame:(CGRect)frame andCategory:(JPMaterialCategory *)category {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _category = category;
        dataArr = [NSMutableArray array];
        [self getListsData];
    }
    return self;
}

#pragma mark -

- (void)show {
    [JPMaterialDownloader shareInstance].delegate = self;
}

#pragma mark - 

- (void)getListsData {
//    NSMutableDictionary *dic = @{@"service":@"App.Material_Music.Resource_lists",
//                                 @"id":_category.material_type_id
//                                 }.mutableCopy;
//    [JPService requestWithURLString:API_HOST parameters:dic type:JPHttpRequestTypePost success:^(JPResultBase *response){
//        if (response.ret && 200 == [response.ret intValue]) {
//            if (response.data && [response.data isKindOfClass:[NSArray class]]) {
//                for (int i = 0; i < [response.data count]; i ++) {
//                    if ([[response.data objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
//                        JPMaterial *material = [JPMaterial mj_objectWithKeyValues:[response.data objectAtIndex:i]];
//                        NSString *index = @"";
//                        if ((i + 1) < 10) {
//                            index = [NSString stringWithFormat:@"0%d",i + 1];
//                        } else {
//                            index = [NSString stringWithFormat:@"%d",i + 1];
//                        }
//                        material.indexStr = index;
//                        material.material_id = 2;
//                        [dataArr sgrAddObject:material];
//                        JPMaterial *m = [[JPMaterialDownloader shareInstance] getMaterialWithLocalPath:material.localPath];
//                        if (m) {
//                            material.materialStatus = m.materialStatus;
//                            material.downloadPro = m.downloadPro;
//                        } else {
//                            material.materialStatus = JPMaterialStatusUnknown;
//                        }
//                    }
//                }
//            }
//        }
//        [self createUI];
//    }failure:^(NSError *error){
//        [self createUI];
//    } withErrorMsg:nil];
}

- (JPMusicListsTableViewCell *)getCurrentDownloadCell:(NSString *)uuid {
    for (int i = 0; i < [dataArr count]; i ++) {
        @autoreleasepool {
            JPMaterial *info = [dataArr objectAtIndex:i];
            if ([uuid isEqualToString:info.localPath]) {
                NSIndexPath *p = [NSIndexPath indexPathForRow:i inSection:0];
                JPMusicListsTableViewCell *cell = (JPMusicListsTableViewCell *)[tbView cellForRowAtIndexPath:p];
                cell.index = i;
                return cell;
            }
        }
    }
    return nil;
}

- (void)createUI{
    if (tbView) {
        return;
    }
    tittleLb = [[UILabel alloc] initWithFrame:CGRectZero];
    tittleLb.font = [UIFont jp_pingFangWithSize:12];
    tittleLb.text = _category.material_type_name;
    tittleLb.textColor = [UIColor jp_colorWithHexString:@"545454"];
    tittleLb.textAlignment = NSTextAlignmentCenter;
    tittleLb.backgroundColor = [UIColor jp_colorWithHexString:@"0e0e0e"];
    [self addSubview:tittleLb];
    tittleLb.sd_layout.leftEqualToView(self).topEqualToView(self).rightEqualToView(self).heightIs(40);

    UIButton *backBtn = [JPUtil createCustomButtonWithTittle:@"返回"
                                                   withImage:nil
                                                   withFrame:CGRectZero
                                                      target:self
                                                      action:@selector(back:)];
    backBtn.titleLabel.font = [UIFont jp_pingFangWithSize:12];
    [self addSubview:backBtn];
    backBtn.sd_layout.leftEqualToView(self).topEqualToView(self).widthIs(JPScreenFitFloat6(52)).heightIs(40);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor jp_colorWithHexString:@"1f1f1f"];
    [self addSubview:lineView];
    lineView.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(backBtn, 0).heightIs(0.5);
    
    CGRect frame = CGRectMake(0, lineView.bottom + 10, self.width, self.height - lineView.bottom - 10);
    tbView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tbView.contentSize = CGSizeMake(tbView.width, tbView.height);
    tbView.backgroundColor = self.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.showsVerticalScrollIndicator = NO;
    tbView.showsHorizontalScrollIndicator = NO;
    tbView.delegate = self;
    tbView.dataSource = self;
    [self addSubview:tbView];
    tbView.sd_layout.topSpaceToView(lineView, 10).bottomEqualToView(self).leftEqualToView(self).rightEqualToView(self);
    [tbView registerNib:[UINib nibWithNibName:@"JPMusicListsTableViewCell" bundle:JPResourceBundle] forCellReuseIdentifier:@"JPMusicListsTableViewCell"];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPMaterial *material = [dataArr objectAtIndex:indexPath.row];
    JPMusicListsTableViewCell *cell = (JPMusicListsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"JPMusicListsTableViewCell"];
    cell.delegate = self;
    if ([material.localPath isEqualToString:[[_audioModel.fileUrl absoluteString] lastPathComponent]]) {
        material.isSelected = YES;
    } else {
        material.isSelected = NO;
        if (material.materialStatus == JPMaterialStatusUnknown) {
            if ([self.delegate respondsToSelector:@selector(firstMusicUnDownload)]) {
                [self.delegate firstMusicUnDownload];
            }
            
        }else if (material.materialStatus == JPMaterialStatusDownLoaded){
            if ([self.delegate respondsToSelector:@selector(firstMusicDownloaded)]) {
                [self.delegate firstMusicDownloaded];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(firstMusicDownloading)]) {
                [self.delegate firstMusicDownloading];
            }
        }
    }
    [cell loadDataWithData:material];
    
    
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
    if ([self.delegate respondsToSelector:@selector(firstMusicDownloading)]) {
        [self.delegate firstMusicDownloading];
    }
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

- (void)mediaDownloaderMediaModelFailedDownload:(JPMaterial *)model withDownLoader:(JPMaterialDownloader *)downLoader {
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
    audioModel.isBundle = NO;
    audioModel.baseFilePath = material.baseFilePath;
    audioModel.fileName = material.name;
    audioModel.resource_id = [NSString stringWithFormat:@"%lld", material.mid];
    audioModel.durationTime = [JPVideoUtil getVideoDurationWithSourcePath:audioModel.fileUrl];
    if (0 >= CMTimeCompare(audioModel.durationTime, kCMTimeZero)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                   message:@"文件出错啦。"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    _audioModel = audioModel;
    [tbView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedMusic:)]) {
        [self.delegate selectedMusic:audioModel];
    }
}

#pragma mark - actions

- (void)back:(id)sender {
    [JPMaterialDownloader shareInstance].delegate = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(willPop:)]) {
        [self.delegate willPop:self];
    }
}

@end
