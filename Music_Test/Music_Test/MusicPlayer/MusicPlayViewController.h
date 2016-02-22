//
//  MusicPlayViewController.h
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayViewController : UIViewController

// 接收传值
@property (nonatomic, assign) NSInteger index;


+ (instancetype)shareInstance;

@end
