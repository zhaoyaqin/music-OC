//
//  MusicModel.h
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic, copy) NSString *mp3Url;   // 音乐地址
@property (nonatomic, copy) NSString *ID;       // 应为id
@property (nonatomic, copy) NSString *name;     // 歌名
@property (nonatomic, copy) NSString *picUrl;   // 图片地址
@property (nonatomic, copy) NSString *blurPicUrl;   // 模糊图片地址
@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSString *singer;   // 歌手
@property (nonatomic, copy) NSString *duration; // 时间
@property (nonatomic, copy) NSString *artists_name; // 歌手名字
@property (nonatomic, copy) NSString *lyric;    // 歌词

@property (nonatomic, assign) float progressValue;
@property (nonatomic, assign) BOOL isFinished;

@end
