//
//  JPLocalMediaCloudTableViewCell.m
//  jper
//
//  Created by FoundaoTEST on 2017/6/2.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPLocalMediaCloudTableViewCell.h"

@interface JPLocalMediaCloudTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoFrameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoSizeLabel;
@end

@implementation JPLocalMediaCloudTableViewCell


- (void)setMediaModel:(JPMediaModel *)mediaModel
{
    
    _mediaModel = mediaModel;
    if (_mediaModel.thumImage == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *videoUrl = [NSURL fileURLWithPath:mediaModel.videoLocalPath];
            self.mediaModel.thumImage = [JPVideoUtil getFirstImageWithVideoUrl:videoUrl];
            CGSize imageSize  = [JPVideoUtil getVideoSizeWithUrl:videoUrl];
            self.mediaModel.videoFrameSize = [NSString stringWithFormat:@"%.0f*%.0f", imageSize.width, imageSize.height];
            self.mediaModel.videoDurationStr = [NSString stringWithTimeInterval:_mediaModel.videoDuration];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSInteger bytes = [[fileManager attributesOfItemAtPath:mediaModel.videoLocalPath error:nil] fileSize] / 1000;
            if (bytes < 1000) {
                self.mediaModel.videoBytes = [NSString stringWithFormat:@"%ld KB", bytes];
            }else{
                self.mediaModel.videoBytes = [NSString stringWithFormat:@"%ld MB", bytes / 1000];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setMediaModel:mediaModel];
            });
        });
    }else{
        _thumbImageView.image = _mediaModel.thumImage;
        _videoTitleLabel.text = _mediaModel.title;
        _videoDurationLabel.text = _mediaModel.videoDurationStr;
        _videoSizeLabel.text = _mediaModel.videoBytes;
        _videoFrameLabel.text = _mediaModel.videoFrameSize;
 
    }
}


- (UIImageView *)plhoderImageView
{
    return _thumbImageView;
}
@end
