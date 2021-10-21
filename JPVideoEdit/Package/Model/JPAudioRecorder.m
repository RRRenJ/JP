//
//  JPAudioRecorder.m
//  jper
//
//  Created by 藩 亜玲 on 2017/4/17.
//  Copyright © 2017年 MuXiao. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "JPAudioRecorder.h"

@interface JPAudioRecorder ()<AVAudioRecorderDelegate> {
    JPAudioModel *model;
}

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

- (BOOL)hasHeadset;
- (BOOL)hasMicphone;
- (void)resetOutputTarget;
- (BOOL)checkAndPrepareCategoryForRecording;

@end

@implementation JPAudioRecorder

- (id)initWithAudioModel:(JPAudioModel *)audioModel
{
    self = [super init];
    if (self) {
        model = audioModel;
        if ([[NSFileManager defaultManager] fileExistsAtPath:audioModel.fileUrl.absoluteString]) {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:audioModel.fileUrl.absoluteString error:nil];
        }
        
//        NSDictionary *recordSetting = @{AVFormatIDKey:[NSNumber numberWithInt:kAudioFormatLinearPCM],
//                                        AVLinearPCMBitDepthKey:@(16),
//                                        AVSampleRateKey : @(48000),
//                                        AVNumberOfChannelsKey:@(1),
//                                        AVEncoderAudioQualityKey:[NSNumber numberWithInt:AVAudioQualityLow]
//                                        };
        NSDictionary *recordSetting = @{AVFormatIDKey:[NSNumber numberWithInt:kAudioFormatMPEG4AAC],
                                        AVNumberOfChannelsKey:@(1)
        };
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioModel.fileUrl settings:recordSetting error:nil];
        _audioRecorder.delegate = self;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        [_audioRecorder prepareToRecord];
    }
    return self;
}


- (void)startToRecord{
    if (![_audioRecorder isRecording]) {
        model.durationTime = kCMTimeZero;
        [_audioRecorder record];
    }
}

- (BOOL)isRecording{
    return [_audioRecorder isRecording];
}

- (void)pauseRecord{
    if ([_audioRecorder isRecording]) {
        [_audioRecorder pause];
    }
}

- (void)resumRecord {
    if (![_audioRecorder isRecording]) {
        [_audioRecorder record];
    }
}

- (void)stopRecord{
    if ([_audioRecorder isRecording]) {
        [_audioRecorder stop];
    }
}

- (void)releaseRecorder {
    if ([_audioRecorder isRecording]) {
        [_audioRecorder stop];
    }
    _audioRecorder = nil;
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishRecording:audioModel:successfully:)]) {
        model.durationTime = [JPVideoUtil getVideoDurationWithSourcePath:model.fileUrl];
        [self.delegate didFinishRecording:self audioModel:model successfully:flag];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(encodeErrorDidOccur:audioModel:withError:)]) {
        [self.delegate encodeErrorDidOccur:self audioModel:model withError:error];
    }
}

#pragma mark - private methods

- (BOOL)hasMicphone {
    return [[AVAudioSession sharedInstance] isInputAvailable];
}
- (BOOL)hasHeadset {
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    if((route == NULL) || (CFStringGetLength(route) == 0)){
        // Silent Mode LOG(@"AudioRoute: SILENT, do nothing!");
    } else {
        NSString* routeStr = (__bridge NSString*)route;
        NSLog(@"AudioRoute: %@", routeStr);
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        if (headphoneRange.location != NSNotFound) {
            return YES;
        } else if(headsetRange.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}
- (void)resetOutputTarget {
    BOOL hasHeadset = [self hasHeadset];
    NSLog (@"Will Set output target is_headset = %@ .", hasHeadset ? @"YES" : @"NO");
    UInt32 audioRouteOverride = hasHeadset ? kAudioSessionOverrideAudioRoute_None:kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    [self hasHeadset];
}

- (BOOL)checkAndPrepareCategoryForRecording {
    BOOL hasMicphone = [self hasMicphone];
    NSLog(@"Will Set category for recording! hasMicophone = %@", hasMicphone?@"YES":@"NO");
    if (hasMicphone) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    }
    [self resetOutputTarget];
    return hasMicphone;
}

- (void)dealloc
{
    
}

@end
