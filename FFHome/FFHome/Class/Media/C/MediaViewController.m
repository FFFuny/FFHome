//
//  MediaViewController.m
//  FFHome
//
//  Created by 建新 on 17/2/16.
//  Copyright © 2017年 ff. All rights reserved.
//

#import "MediaViewController.h"
#import "MovieViewController.h"

@interface MediaViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_contentList;
    UITableView *_menuTable;
}

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _contentList = [NSMutableArray arrayWithObjects:
                    @"视频播放",
                    @"音乐播放",
                    @"加载提示",
                    nil];
    
    [self initTable];
}

#pragma mark - 目录
- (void)initTable
{
    _menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20) style:UITableViewStylePlain];
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    [self.view addSubview:_menuTable];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = _contentList[indexPath.row];
    cell.textLabel.textColor = COLOR(79, 79, 79);
    cell.textLabel.font = Font(12);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        if ([self respondsToSelector:@selector(pushMovie)]) {
            
            [self pushMovie];
        }
    } else if (indexPath.row == 1) {
        
        if ([self respondsToSelector:@selector(pushMusic)]) {
            
            [self pushMusic];
        }
    } else if (indexPath.row == 2) {
        
        if ([self respondsToSelector:@selector(ffLoading)]) {
            
            [self ffLoading];
        }
    }
}

#pragma mark - 视频播放
- (void)pushMovie
{
    MovieViewController *movie = [[MovieViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:movie];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 音乐播放
- (void)pushMusic
{
    
}

#pragma mark - 加载中动画...
- (void)ffLoading
{
    [FFLoding showLodingInView:self.view];
    [self performSelector:@selector(hideFF) withObject:nil afterDelay:3.0f];
}

#pragma mark - 隐藏加载动画
- (void)hideFF
{
    [FFLoding hideLodingInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
