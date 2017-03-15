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
    UIView *_navView;

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
    
    [self initNavView];
    [self initTable];
}

- (void)initNavView
{
    _navView = [[UIView alloc] init];
    _navView.backgroundColor = COLOR(239, 239, 239);
    [self.view addSubview:_navView];
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.text = NSLocalizedString(@"media_title", nil);
    navTitle.font = Font(12);
    navTitle.textColor = [UIColor blackColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:navTitle];
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.mas_equalTo(0);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(64);
    }];
    
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(_navView.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH / 3);
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - 目录
- (void)initTable
{
    _menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    _menuTable.tableFooterView = [UIView new];
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
    [FFLoding showLodingInView:_menuTable];
    [self performSelector:@selector(hideFF) withObject:nil afterDelay:3.0f];
}

#pragma mark - 隐藏加载动画
- (void)hideFF
{
    [FFLoding hideLodingInView:_menuTable];
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
