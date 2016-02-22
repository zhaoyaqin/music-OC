//
//  MusicManager.m
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import "MusicManager.h"

@interface MusicManager ()

@property (nonatomic, strong) NSMutableArray *allMusic;

@end

@implementation MusicManager



- (void)loadDataWithURL:(NSURL *)url
              didFinish:(void(^)())finished {
    // 使用多线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 获取数据
        NSArray *array = [NSArray arrayWithContentsOfURL:url];
        for (NSDictionary *item in array) {
            MusicModel *model = [MusicModel new];
            [model setValuesForKeysWithDictionary:item];
            [self.allMusic addObject:model];
        }
        
        // 回调主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            finished();
        });
    });
}
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static MusicManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[MusicManager alloc] init];
    });
    return manager;
    
}

- (NSMutableArray *)allMusic
{
    if (!_allMusic) {
        _allMusic = [NSMutableArray array];
    }
    return _allMusic;
}

- (NSArray *)allDataArray
{
    return [self.allMusic copy];
}



@end
