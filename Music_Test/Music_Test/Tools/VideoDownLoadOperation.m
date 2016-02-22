//
//  VideoDownLoadOperation.m
//  Music_02
//
//  Created by 赵亚琴 on 15/10/2.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import "VideoDownLoadOperation.h"

#import "MusicModel.h"

@interface VideoDownLoadOperation () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

{
    // 用于判断一个任务是否正在下载
    BOOL _isDownLoading;
    
}

#pragma mark - 声明属性

@property (nonatomic, strong) MusicModel *model;

@property (nonatomic, strong) NSURLSession *currentSession;

// 用于可恢复的下载任务的数据
@property (nonatomic, strong) NSData *partialData;

// 可恢复的下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *task;



@end

@implementation VideoDownLoadOperation


#pragma mark - 实现方法
#pragma mark 暂停
- (void)downLoadPause
{
    NSLog(@"暂停");
    [self.task suspend];
}

#pragma mark 恢复
- (void)downLoadResume
{
    NSLog(@"恢复下载");
    [self.task resume];
}

- (instancetype)initWithDownLoadModel:(MusicModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}


//
- (void)main
{
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.currentSession = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:nil];
    self.currentSession.sessionDescription = self.model.mp3Url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.mp3Url]];
    self.task = [self.currentSession downloadTaskWithRequest:request];
    
    [self.task resume];
    _isDownLoading = YES;
    
    while (_isDownLoading) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate distantFuture]];
    }
    self.partialData = nil;
    
}

#pragma mark - delegate(task)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // 将临时文件剪切或者复制到caches文件夹
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *appenPath = [NSString stringWithFormat:@"/%@.mp4", self.model.ID];
    
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *file = [cache stringByAppendingString:appenPath];
    
    NSLog(@"11111111111%@", file);
    
    [manager moveItemAtURL:[NSURL URLWithString:location.path] toURL:[NSURL URLWithString:file] error:nil];
    
    _isDownLoading = NO;
    
    // 下载完成发送通知
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downLoadFinished" object:nil];
        self.model.isFinished = YES;
        
    });
    
    
    
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    // 文件以字节为单位
    //1、totalBytesExpectedToWrite 所需下载文件的总大小
    //2、totalBytesWritten 已经下载好部分的大小
    // 3、bytesWritten   当前（本次）下载的文件大小
    
    self.model.progressValue = bytesWritten * 1.0f / totalBytesExpectedToWrite;

    NSLog(@"%f", self.model.progressValue);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.updateBlock) {
            self.updateBlock(self.model);
        }
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%.f", fileOffset / (float)expectedTotalBytes);
}










@end
