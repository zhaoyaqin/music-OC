//
//  MusicListTableViewController.m
//  Music_Test
//
//  Created by 赵亚琴 on 15/12/31.
//  Copyright © 2015年 赵亚琴. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicListTableViewCell.h"
#import "MusicPlayViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

static NSString *identifier = @"cell";

@interface MusicListTableViewController () <NSURLSessionDownloadDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) MusicManager *manager;

@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) MBProgressHUD *progress;


@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[[UIApplication sharedApplication].delegate window] addSubview:self.animationView];
    
    self.progress = [[MBProgressHUD alloc] initWithView:self.tableView];
    self.progress.mode = MBProgressHUDModeIndeterminate;
//    self.progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//    self.progress.labelText = @"不要着急哦！";
    [self.progress show:YES];
//    [self.tableView addSubview:self.progress];
//    NSString *url = @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist";
//    NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:kURL]];
//    
//    for (NSDictionary *item in array) {
//        MusicModel *model = [MusicModel new];
//        [model setValuesForKeysWithDictionary:item];
////        [self.allDataArray addObject:model];
//    }
//    self.animationView.image = [UIImage imageNamed:@"1"];
    
    
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    
    [self.manager loadDataWithURL:[NSURL URLWithString:kURL] didFinish:^{
        
        [self.tableView reloadData];
        [self.progress hide:YES];
        
        [self.animationView removeFromSuperview];
////        [self.label removeFromSuperview];
//        
//        [self.timer invalidate];
//        self.timer = nil;
    }];
//    self.allDataArray = self.manager.allDataArray;
    
//    NSLog(@"%@", self.allDataArray);
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.tableView reloadData];
    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:kURL]];
//    
//    [task resume];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
//{
//    NSLog(@"----%@", data);
//    NSError *error;
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJapaneseEUCStringEncoding error:&error];
//    
//    NSLog(@"%@", error);
//    
//    NSLog(@"%@", array);
//}

#pragma mark - 懒加载
- (NSArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (MusicManager *)manager {
    if (!_manager) {
        _manager = [MusicManager shareInstance];
    }
    return _manager;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.allDataArray.count;
//    return self.allDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier     forIndexPath:indexPath];
    
    // Configure the cell...
    
//    cell.model = self.allDataArray[indexPath.row];
    cell.model = self.manager.allDataArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取控制器
//    MusicPlayViewController *playVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"play"];
    
    MusicPlayViewController *playVC = [MusicPlayViewController shareInstance];
    // 传值
    playVC.index = indexPath.row;
    
    UINavigationController *playNC = [[UINavigationController alloc] initWithRootViewController:playVC];
    
    [self presentViewController:playNC animated:YES completion:nil];
}

- (void)timerAction:(NSTimer *)timer {
    self.animationView.transform = CGAffineTransformRotate(self.animationView.transform, M_2_PI / 180.0);
    
}

- (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _animationView.center = self.tableView.center;
        
        
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i < 9; i++) {
            NSString *name = [NSString stringWithFormat:@"%d", i];
            UIImage *image = [UIImage imageNamed:name];
            [images addObject:image];
        }
        NSLog(@"%@", images);
        //    [self.imageView setImage:[UIImage imageNamed:@"1"]];
        _animationView.animationImages = images;
        _animationView.animationDuration = 1.0;
        _animationView.animationRepeatCount = 0;
        // 开始动画
        [_animationView startAnimating];
       
        
//        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//        _label.center = self.tableView.center;
//        _label.text = @"不要着急哦！";
//        [[[UIApplication sharedApplication].delegate window] addSubview:_animationView];
//        [[[UIApplication sharedApplication].delegate window] addSubview:_label];
//        [_animationView addSubview:label];
        
    }
    return _animationView;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
