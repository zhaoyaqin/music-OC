//
//  MusicPlayViewController.m
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "LyricManager.h"
#import "LyricModel.h"
#import "VideoDownLoadManager.h"

static NSString *identifier = @"cell";

@interface MusicPlayViewController () <AudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate>

// 播放时间
@property (weak, nonatomic) IBOutlet UILabel *playTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;

// 进度条
@property (weak, nonatomic) IBOutlet UISlider *playSlider;

// 歌词列表
@property (weak, nonatomic) IBOutlet UITableView *lyricList;

// 播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playButton;

// 图片
@property (weak, nonatomic) IBOutlet UIImageView *musicImage;

@property (nonatomic, strong) AVPlayerItem *item;

@property (nonatomic, strong) MusicModel *currentModel;
@property (nonatomic, assign) NSInteger currentIndex;


// 下载
@property (nonatomic, strong) VideoDownLoadManager *downLoadManager;

@end

@implementation MusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置圆角
    self.musicImage.layer.cornerRadius = 40;
    self.musicImage.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
    
    self.playTime.text = [NSString stringWithFormat:@"%d:%d", 00, 00];
    self.playSlider.minimumValue = 0;
    // 设置代理
    [AudioPlayer shareInstance].delegate = self;
    // 给进度条添加方法
    [self.playSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    // 歌词
    [self.lyricList registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.lyricList.delegate = self;
    self.lyricList.dataSource = self;
    self.lyricList.backgroundColor = [UIColor clearColor];
    
    // 赋初值，不然点击的第一行过来直接return
    self.currentIndex = -1;
    
    [self addSubview];
    
    
}

- (void)addSubview {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"0"];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:self.currentModel.blurPicUrl]];
    [self.view insertSubview:imageView atIndex:0];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blur];
    view.backgroundColor = [UIColor clearColor];
    view.alpha = 1;
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100);
    //    view.frame = self.lyricList.bounds;
    //    [self.lyricList addSubview:view];
    view.userInteractionEnabled = NO;
    [imageView addSubview:view];

    
}

#pragma mark - 进度条绑定方法
- (void)sliderAction:(UISlider *)slider {
    
    [[AudioPlayer shareInstance] seekTotime:slider.value];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    // 判断是不是当前播放的音乐
    if (self.currentIndex == self.index) {
        return;
    }
    self.currentIndex = self.index;

    [self playMusic];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [self lock];
}


#pragma mark - 音乐播放器代理方法
- (void)audioPlayerPlayTime:(float)time withPlayer:(AudioPlayer *)player {
//    NSLog(@"%ld", time);
    self.playSlider.value = time;
    self.playTime.text = [self changeTime:[NSString stringWithFormat:@"%f", time * 1000]];
//    self.totalTime.text = [self changeTime:[NSString stringWithFormat:@"%f", ([self.currentModel.duration floatValue] / 1000] - time];
    
    self.musicImage.transform = CGAffineTransformRotate(self.musicImage.transform, M_PI / 180);
    
    // 歌词滚动
    NSInteger index = [[LyricManager shareInstance] getIndexWithTime:time];
    if (index == -1) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.lyricList selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    
}

- (void)audioPlayerPlayFinished:(AudioPlayer *)player {
    // 调用下一曲的方法
    [self next:nil];
}


- (MusicModel *)currentModel {
    
    self.index = self.currentIndex;
    return [MusicManager shareInstance].allDataArray[self.currentIndex];
}



/**
 *      播放音乐
 **/
- (void)playMusic {
    // 播放器
    //
    [[AudioPlayer shareInstance] prepareToPlayWithURL:[NSURL URLWithString:self.currentModel.mp3Url]];
    
    // 获取歌词
    [[LyricManager shareInstance] getAllLyricWithStr:self.currentModel.lyric];
    
    [self.lyricList reloadData];
    
    // 更新页面
    [self updateUI];

}
/**
 *  更新UI
 **/
- (void)updateUI {
    // 更改时间
    self.totalTime.text = [self changeTime:self.currentModel.duration];
    
//    NSLog(@"%@", self.currentModel.duration);
    
    // 更改图片
    [self.musicImage sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl] placeholderImage:[UIImage imageNamed:@""]];
    // 更改进度条
    self.playSlider.maximumValue = [self.currentModel.duration integerValue] / 1000;

    
    
}

- (NSString *)changeTime:(NSString *)time {
    // 先转换成整型
    NSInteger times = [time integerValue];
    NSInteger m = (times / 1000) / 60;
    NSInteger s = (times / 1000) % 60;
    return [NSString stringWithFormat:@"%ld:%ld", m, s];
    
    
}

#pragma mark 上一曲
- (IBAction)upMusic:(id)sender {
    
    if (self.currentIndex != 0) {
        self.currentIndex--;
    } else {
        self.currentIndex = [MusicManager shareInstance].allDataArray.count - 1;
    }
    
    [self playMusic];
    
}
#pragma mark 下一曲
- (IBAction)next:(id)sender {
    
    if (self.currentIndex == [MusicManager shareInstance].allDataArray.count - 1) {
        self.currentIndex = 0;
    } else {
        self.currentIndex++;
    }
    
    [self playMusic];
}


#pragma mark 播放
- (IBAction)play:(id)sender {
    
    if ([AudioPlayer shareInstance].playStatus == isPlaying) {
        // 停止
        [[AudioPlayer shareInstance] pause];
//        [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else {
        // 播放
        [[AudioPlayer shareInstance] play];
//        [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];


    }
    
    // 锁屏
    [self lock];
    
}

/**
 *  返回
 **/
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LyricManager shareInstance].allLyric.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    LyricModel *model = [LyricManager shareInstance].allLyric[indexPath.row];
    cell.textLabel.text = model.lyric;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = backgroundView;
    
    return cell;
}

#pragma mark - 单例控制器
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static MusicPlayViewController *playVC = nil;
    dispatch_once(&onceToken, ^{
        playVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"play"];
        
    });
    return playVC;
}

-(VideoDownLoadManager *)downLoadManager {
    if (!_downLoadManager) {
        _downLoadManager = [VideoDownLoadManager shareInstance];
    }
    return _downLoadManager;
}

#pragma mark - 下载
- (IBAction)downLoad:(id)sender {
    NSLog(@"下载");
    [self.downLoadManager startDownLoadVideoWithModel:self.currentModel];
}

#pragma mark - 已下载
- (IBAction)finishedLoad:(id)sender {
    
}



/*------- 试图控制器添加远程控制事件并音频播放进行控制-------*/

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    NSLog(@"%li, %li", (long)event.type, (long)event.subtype );
    
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay: {
                NSLog(@"播放");
                break;
            }
            case UIEventSubtypeRemoteControlPause: {
                NSLog(@"暂停");
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack: {
                NSLog(@"next");
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack: {
                NSLog(@"previous");
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingForward: {
                NSLog(@"begin seek forward");
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingBackward: {
                NSLog(@"backward");
                break;
            }
            case UIEventSubtypeRemoteControlEndSeekingBackward: {
                NSLog(@"end seek backword");
                break;
            }
                
            default:
                break;
        }
        [self updateUI];
    }

}

#pragma mark - 锁屏状态
// // 在锁屏界面显示歌曲信息(实时换图片MPMediaItemArtwork可以达到实时换歌词的目的)

- (void)lock {
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"0"]];
        [songInfo setObject:@"Audio Title" forKey:MPMediaItemPropertyTitle]; // 歌曲名
        [songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist]; // 歌手名
        [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork]; // 专辑图片设置
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
