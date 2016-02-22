//
//  NetworkManager.m
//  Music_02
//
//  Created by 赵亚琴 on 15/10/2.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

// 单例
+ (NetworkManager *)shareInstance
{
    static NetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[NetworkManager alloc] init];
            
        }
    });
    return manager;
}

- (NSURL *)markURLForString:(NSString *)str
{
    NSURL *result;
    NSString *trimmedStr;
    NSRange schemeMarkRnge;
    NSString *scheme;
    
    assert(str != nil);
    result = nil;
    
    // 取出空白
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedStr != nil && trimmedStr.length != 0) {
        schemeMarkRnge = [trimmedStr rangeOfString:@"://"];
    }
    
    if (schemeMarkRnge.location == NSNotFound) {
        result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
    } else {
        scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkRnge.location)];
        assert(scheme != nil);
        if ([scheme compare:@"http" options:NSCaseInsensitiveSearch] == NSOrderedSame || [scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            result = [NSURL URLWithString:trimmedStr];
        } else {
            
        }
    }
    return result;
    
    
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
    NSString *result;
    NSString *result1;
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
    
    result1 = [NSString stringWithFormat:@"%@", uuidStr];
    
    NSLog(@"-----------%@", result1);
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
    
}













@end
