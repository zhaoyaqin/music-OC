//
//  MusicListTableViewCell.h
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *MyImageView;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;

@property (nonatomic, strong) MusicModel *model;

@end
