//
//  NetworkManager.h
//  Music_02
//
//  Created by 赵亚琴 on 15/10/2.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject


// 单例
+ (NetworkManager *)shareInstance;

- (NSURL *)markURLForString:(NSString *)str;

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix;


@end
