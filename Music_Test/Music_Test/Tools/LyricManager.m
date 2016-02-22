//
//  LyricManager.m
//  Music_Test
//
//  Created by 赵亚琴 on 16/1/4.
//  Copyright © 2016年 赵亚琴. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"

@interface LyricManager ()

@property (nonatomic, strong) NSMutableArray *allData;

@end

@implementation LyricManager



/**
 *  获取所有的歌词
 **/
- (void)getAllLyricWithStr:(NSString *)lyric {
#warning 清空数组
    [self.allData removeAllObjects];
    // 首先根据“\n”分割每一行歌词
    NSArray *lineLyric = [lyric componentsSeparatedByString:@"\n"];
    for (NSString *item in lineLyric) {
        
        NSArray *oneArray = [item componentsSeparatedByString:@"]"];
        NSString *time = oneArray.firstObject;
        // 根据：分割时间
        NSArray *timeArray = [time componentsSeparatedByString:@":"];

#warning 如果时间字符串小于1，则跳出
        // 计算总的时间,如果时间字符串小于1，则跳出
        if ([time length] < 1) {
            break;
        }
            NSString *m = timeArray.firstObject;
            NSString *s = timeArray.lastObject;
            
            float allTime = [[m substringFromIndex:1] floatValue] * 60 + [s floatValue];
            NSString *lyricStr = oneArray.lastObject;
            
            
            NSLog(@"--------%f  %@", allTime, lyricStr);
            
            // 初始化一个歌词模型
            LyricModel *model = [[LyricModel alloc] initWithTime:allTime lyric:lyricStr];
            [self.allData addObject:model];
        
        
        
    }
    
    
    
}
- (NSInteger)getIndexWithTime:(float)time {
    NSInteger index = -1;
    for (int i = 0; i < self.allData.count ; i++) {
#warning 判断播放时间和歌词时间，歌词时间大于播放时间需要显示前一句歌词
        if (time < [self.allData[i] allTime]) {
            index = i - 1 > 0 ? i - 1 : 0;
            break;
        } 
    }
    return index;
}


- (NSArray *)allLyric {
    return [self.allData copy];
}


- (NSMutableArray *)allData {
    if (!_allData) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static LyricManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[LyricManager alloc] init];
    });
    return manager;
}
@end
