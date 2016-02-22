//
//  VideoDownLoadManager.h
//  Music_02
//
//  Created by 赵亚琴 on 15/10/2.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;

@interface VideoDownLoadManager : NSObject

@property (nonatomic, strong) NSOperationQueue *downLoadQueue;

// 用来保存创建的下载管理类，方便以后管理
@property (nonatomic, strong) NSMutableDictionary *httpOperationDict;

//@property (nonatomic, strong) NSMutableArray *downVideoArray;

#pragma mark - 声明方法

// 单例
+ (VideoDownLoadManager *)shareInstance;

#pragma mark 开始下载
- (void)startDownLoadVideoWithModel:(MusicModel *)model;


#pragma mark 暂停下载
- (void)downLoadPauseWithModel:(MusicModel *)model;

#pragma mark 断点继续下载
- (void)downLoadResumeWithModel:(MusicModel *)model;

@end
