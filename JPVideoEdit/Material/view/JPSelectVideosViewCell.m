//
//  JPSelectVideosViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPSelectVideosViewCell.h"


@interface JPSelectVideosViewCell ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation JPSelectVideosViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentImageView.layer.masksToBounds = YES;
    self.contentImageView.layer.cornerRadius =  2;
    self.numberLabel.font = [UIFont jp_placardMTStdCondBoldFontWithSize:18];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius =  2;
}

- (void)setVideoIndex:(NSInteger)videoIndex
{
    _videoIndex = videoIndex;
    NSString *indexStr = [NSString stringWithFormat:@"%ld", videoIndex];
    if (indexStr.length == 1) {
        indexStr = [NSString stringWithFormat:@"0%ld", videoIndex];
    }
    _numberLabel.text = indexStr;
}
- (void)setVideoModel:(JPVideoModel *)videoModel
{
    _videoModel = videoModel;
    self.contentImageView.image = self.videoModel.originThumbImage;
}
- (IBAction)deleteAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确定删除本段视频？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        if (self.delegate) {
            [self.delegate selectVideosViewCellShouldDeleteVideoModel:self.videoModel];
        }
    }
}

@end
