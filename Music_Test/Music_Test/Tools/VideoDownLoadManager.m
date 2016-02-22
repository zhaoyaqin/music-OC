//
//  VideoDownLoadManager.m
//  Music_02
//
//  Created by 赵亚琴 on 15/10/2.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import "VideoDownLoadManager.h"

#import "MusicModel.h"
#import "VideoDownLoadOperation.h"


@implementation VideoDownLoadManager


#pragma mark - 实现方法

// 单例
+ (VideoDownLoadManager *)shareInstance
{
    static dispatch_once_t onceToken;
    static VideoDownLoadManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[VideoDownLoadManager alloc] init];
        manager.httpOperationDict = [NSMutableDictionary dictionary];
//        manager.downVideoArray = [NSMutableArray array];
        
    });
    return manager;
    
}

#pragma mark 开始下载
- (void)startDownLoadVideoWithModel:(MusicModel *)model
{
    // 打印路径
    NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject);
    
    if (!self.downLoadQueue) {
        self.downLoadQueue = [[NSOperationQueue alloc] init];
        self.downLoadQueue.maxConcurrentOperationCount = 3;
    }
    
    VideoDownLoadOperation *ope = [[VideoDownLoadOperation alloc] initWithDownLoadModel:model];
    ope.updateBlock = ^(MusicModel *model) {
        
        NSLog(@"----------%f", model.progressValue);
    };
    
    
    [self.httpOperationDict setObject:ope forKey:model.mp3Url];
    [self.downLoadQueue addOperation:ope];
//    [self.downVideoArray addObject:model];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoDidStartDown" object:nil];
    

}

#pragma mark 暂停下载
- (void)downLoadPauseWithModel:(MusicModel *)model
{
    
    VideoDownLoadOperation *ope = [self.httpOperationDict objectForKey:model.mp3Url];
    if (!ope.isFinished) {
        [ope downLoadPause];
    }
}

#pragma mark 断点继续下载
- (void)downLoadResumeWithModel:(MusicModel *)model
{
    VideoDownLoadOperation *ope = [self.httpOperationDict objectForKey:model.mp3Url];
    if (!ope.isFinished) {
        [ope downLoadResume];
    }
}




@end
