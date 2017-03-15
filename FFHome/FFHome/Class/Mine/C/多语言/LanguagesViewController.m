//
//  LanguagesViewController.m
//  FFHome
//
//  Created by 建新 on 17/3/15.
//  Copyright © 2017年 ff. All rights reserved.
//

#import "LanguagesViewController.h"

@interface LanguagesViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_settingTable;
    NSMutableArray *_contentList;
    NSMutableArray *_languagesType;
}

@end

@implementation LanguagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentList = [NSMutableArray arrayWithObjects:
                    @"中文简体",
                    @"中文繁体",
                    @"English"
                    , nil];
    _languagesType = [NSMutableArray arrayWithObjects:
                      @"zh-Hans",
                      @"zh-Hant",
                      @"en",
                      nil];
    
    [self initTable];
}

#pragma mark - 目录
- (void)initTable
{
    _settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    _settingTable.tableFooterView = [UIView new];
    [self.view addSubview:_settingTable];
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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_languagesType[indexPath.row] forKey:@"AppleLanguage"];
    [ud synchronize];
    
    [self resetRootVC];
    
}

- (void)resetRootVC
{
    
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
