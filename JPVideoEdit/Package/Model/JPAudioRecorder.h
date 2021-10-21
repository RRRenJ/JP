//
//  JPAudioRecorder.h
//  jper
//
//  Created by 藩 亜玲 on 2017/4/17.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPAudioRecordingProgressView.h"

@class JPAudioRecorder;
@protocol JPAudioRecorderDelegate <NSObject>

- (void)didFinishRecording:(JPAudioRecorder *)recorder audioModel:(JPAudioModel *)model successfully:(BOOL)flag;

- (void)encodeErrorDidOccur:(JPAudioRecorder *)recorder audioModel:(JPAudioModel *)model withError:(NSError *)error;
@end

@interface JPAudioRecorder : NSObject

@property (nonatomic, weak) id<JPAudioRecorderDelegate>delegate;

- (id)initWithAudioModel:(JPAudioModel *)audioModel;

- (void)startToRecord;

- (BOOL)isRecording;

- (void)pauseRecord;

- (void)resumRecord;

- (void)stopRecord;

- (void)releaseRecorder;

@end
