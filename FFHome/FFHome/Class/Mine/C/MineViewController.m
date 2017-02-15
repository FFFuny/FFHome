//
//  MineViewController.m
//  FFHome
//
//  Created by LiuFei on 2017/2/12.
//  Copyright © 2017年 ff. All rights reserved.
//

#import "MineViewController.h"

#define cellID @"cellID"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_settingTable;
    NSMutableArray *_titleArray;
    NSMutableArray *_contentArray;
    UISwitch *_switchView;
}
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    _titleArray = [NSMutableArray arrayWithObjects:@"指纹解锁", nil];
    _switchView = [[UISwitch alloc] init];

    [self initTableview];
}


#pragma mark - 目录
/**
 初始化列表
 */
- (void)initTableview
{
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    headImg.image = [UIImage imageNamed:@"750"];
    
    _settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    _settingTable.tableHeaderView = headImg;
    _settingTable.tableFooterView = [UIView new];
    [self.view addSubview:_settingTable];
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _titleArray[indexPath.row];
    if (indexPath.row == 0) {
        
        [_switchView addTarget:self action:@selector(onOrOff:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = _switchView;
        BOOL isFinger = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFinger"];
        if (isFinger) {
            
            [_switchView setOn:YES];
        } else {
            
            [_switchView setOn:NO];
        }


    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onOrOff:(UISwitch *)sender
{
    if ([sender isOn]) {
        
        NSLog(@"是");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFinger"];
        if ([CurrentSystemVersion floatValue] < 8.0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持指纹登录" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"点击取消");
            }]];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                NSLog(@"点击确认");
//            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            LAContext *ctx = [[LAContext alloc] init];
            if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
                
                // 识别代码部分
                [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
                    
                    if (success) {
                        
                        NSLog(@"成功");
                    } else {
                        
                        NSLog(@"取消");
                        if (error.code == LAErrorUserFallback) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                // 密码验证
                            });
                        } else if (error.code == LAErrorUserCancel) {
                            
                            NSLog(@"取消2");
                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFinger"];
                            [_settingTable reloadData];
                        }
                    }
                }];
            }
        }
    } else {
        
        NSLog(@"否");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFinger"];

    }
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
