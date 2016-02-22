//
//  VideoDownLoadOperation.h
//  Music_02
//
//  Created by 赵亚琴 on 15/10/2.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;

//#import "NetworkManager.h"

// block
typedef void(^VideoUpdateBlock)(MusicModel *);


@interface VideoDownLoadOperation : NSOperation

#pragma mark - 声明属性
@property (nonatomic, copy) VideoUpdateBlock updateBlock;


#pragma mark - 声明方法
#pragma mark 暂停
- (void)downLoadPause;

#pragma mark 恢复
- (void)downLoadResume;

- (instancetype)initWithDownLoadModel:(MusicModel *)model;





@end
