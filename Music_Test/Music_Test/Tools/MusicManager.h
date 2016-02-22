//
//  MusicManager.h
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicManager : NSObject

// 保存所有的数据
@property (nonatomic, strong) NSArray *allDataArray;

/**
 *  根据url获取数据
 **/
- (void)loadDataWithURL:(NSURL *)url
              didFinish:(void(^)())finished;

+ (instancetype)shareInstance;

@end
