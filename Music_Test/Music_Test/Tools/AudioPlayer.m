//
//  AudioPlayer.m
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import "AudioPlayer.h"

@interface AudioPlayer ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation AudioPlayer

- (instancetype)init
{
    if (self = [super init]) {
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}


- (void)prepareToPlayWithURL:(NSURL *)url {
    
    // 创建item
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    // 如果正在播放音乐移除观察者
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 替换item
    [self.player replaceCurrentItemWithPlayerItem:item];
    // 添加观察者
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
    
    
}


- (void)play {
    self.playStatus = isPlaying;
    [self.player play];
    
    if (self.timer) {
        return;
    }
    // 添加定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(playAction:) userInfo:nil repeats:YES];
//
//    self.timer = [NSTimer timerWithTimeInterval:.1 target:self selector:@selector(playAction) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

/**
 *  定时器的方法
 **/

- (void)playAction:(NSTimer *)timer {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(audioPlayerPlayTime:withPlayer:)]) {
        
        float time = self.player.currentTime.value / self.player.currentTime.timescale;
        
        [self.delegate audioPlayerPlayTime:time withPlayer:self];
    }
}

- (void)pause {
    
    if (self.playStatus == isPlaying) {
        
        [self.player pause];
        self.playStatus = isStop;
        // 销毁定时器
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

- (void)stop {
    if (self.playStatus == isPlaying) {
    
        [self.player pause];
        [self.player seekToTime:CMTimeMake(0, self.player.currentTime.timescale)completionHandler:^(BOOL finished) {
            self.playStatus = isStop;
        }];
    }
}
// 从指定时间开始播放
- (void)seekTotime:(NSInteger)time {
    if (self.playStatus == isPlaying) {
        [self.player pause];
        [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
            if (finished) {
                // 开始播放
                [self.player play];
            }
        }];
    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusFailed: {
                NSLog(@"失败");
                break;
            }
            case AVPlayerItemStatusReadyToPlay: {
                NSLog(@"准备播放");
                self.playStatus = isPrepare;
                [self play];
                break;
            }
            case AVPlayerItemStatusUnknown: {
                NSLog(@"未知");
                break;
            }
                
            default:
                break;
        }
        
    }
}

#pragma mark - 通知方法
- (void)playFinished:(NSNotification *)notification {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(audioPlayerPlayFinished:)]) {
        [self.delegate audioPlayerPlayFinished:self];
    }
}


#pragma mark - 懒加载
- (AVPlayer *)player
{
    if (!_player ) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static AudioPlayer *player = nil;
    dispatch_once(&onceToken, ^{
        player = [[AudioPlayer alloc] init];
    });
    return player;
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    self.timer = nil;
}

@end
