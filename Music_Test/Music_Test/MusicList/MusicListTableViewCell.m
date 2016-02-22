//
//  MusicListTableViewCell.m
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import "MusicListTableViewCell.h"

@implementation MusicListTableViewCell

- (void)setModel:(MusicModel *)model
{
    [self.MyImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"mymusci"]];
    // 设置圆角
    self.MyImageView.layer.masksToBounds = YES;
    self.MyImageView.layer.cornerRadius = 35;
    
    self.musicName.text = model.name;
    self.singerName.text = model.singer;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews {
//    
//}

@end
