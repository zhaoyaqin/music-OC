//
//  LyricManager.h
//  Music_Test
//
//  Created by 赵亚琴 on 16/1/4.
//  Copyright © 2016年 赵亚琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject

@property (nonatomic, strong) NSArray *allLyric;

/**
 *  获取所有的歌词
 **/
- (void)getAllLyricWithStr:(NSString *)lyric;
/**
 *  根据时间获取歌词的下标
 **/
- (NSInteger)getIndexWithTime:(float)time;

+ (instancetype)shareInstance;

@end
