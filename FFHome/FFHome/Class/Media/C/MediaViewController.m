//
//  MediaViewController.m
//  FFHome
//
//  Created by 建新 on 17/2/16.
//  Copyright © 2017年 ff. All rights reserved.
//

#import "MediaViewController.h"
#import "MovieViewController.h"

@interface MediaViewController ()

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initBtn];
}

- (void)initBtn
{
    UIButton *pushMovie = [[UIButton alloc] init];
    [pushMovie setTitle:@"视频播放" forState:UIControlStateNormal];
    [pushMovie setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pushMovie.titleLabel.font = Font(12);
    [pushMovie addTarget:self action:@selector(pushMovie) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushMovie];
    
    [pushMovie mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.view.mas_top).offset(30);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.mas_offset(100);
        make.height.mas_offset(30);
    }];
}

- (void)pushMovie
{
    MovieViewController *movie = [[MovieViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:movie];
    [self presentViewController:nav animated:YES completion:nil];
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
