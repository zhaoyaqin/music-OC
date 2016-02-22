//
//  LyricModel.h
//  Music_Test
//
//  Created by 赵亚琴 on 16/1/4.
//  Copyright © 2016年 赵亚琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

// 时间
@property (nonatomic, assign) float allTime;
// 歌词
@property (nonatomic, copy) NSString *lyric;
// 便利构造器
- (instancetype)initWithTime:(float)allTime
               lyric:(NSString *)lyric;

@end
