//
//  LyricModel.m
//  Music_Test
//
//  Created by 赵亚琴 on 16/1/4.
//  Copyright © 2016年 赵亚琴. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

- (instancetype)initWithTime:(float)allTime
               lyric:(NSString *)lyric {
    if (self = [super init]) {
        self.allTime = allTime;
        self.lyric = lyric;
    }
    return self;
}

@end
