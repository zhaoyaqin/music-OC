//
//  AudioPlayer.h
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AudioPlayer;

@protocol AudioPlayerDelegate <NSObject>

@optional
/**
 *  播放进度
 **/
- (void)audioPlayerPlayTime:(float)time
                 withPlayer:(AudioPlayer *)player;
/**
 *  播放完成
 **/
- (void)audioPlayerPlayFinished:(AudioPlayer *)player;


@end

typedef enum : NSUInteger {
    isPlaying,
    isPrepare,
    isStop,
    
} PlayStatus;

@interface AudioPlayer : NSObject

@property (nonatomic, assign) PlayStatus playStatus;
// 声明代理属性
@property (nonatomic, assign) id <AudioPlayerDelegate> delegate;



#pragma mark - 声明方法
/**
 *  准备播放
 **/
- (void)prepareToPlayWithURL:(NSURL *)url;
/**
*  播放
**/

- (void)play;
/**
*  暂停
**/
- (void)pause;
/**
 *  停止
 **/
- (void)stop;
/**
 *  从指定时间开始播放
 **/
- (void)seekTotime:(NSInteger)time;

+ (instancetype)shareInstance;



@end
