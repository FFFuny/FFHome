//
//  ViewController.m
//  FFHome
//
//  Created by LiuFei on 2017/2/12.
//  Copyright © 2017年 ff. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "MineViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
{
    HomeViewController *home;
    MineViewController *mine;
}

@property (nonatomic, assign) CGPoint beginLocation;
@property (nonatomic, strong) PininterestLikeMenu *menu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BOOL isFinger = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFinger"];
    if (isFinger) {
        
        LAContext *ctx = [[LAContext alloc] init];
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
            
            // 识别代码部分
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
                
                if (success) {
                    
                    NSLog(@"成功");
                    home = [[HomeViewController alloc] init];
                    [self.view addSubview:home.view];
                    
                    mine = [[MineViewController alloc] init];
                    [self.view addSubview:mine.view];
                    
                    [self.view bringSubviewToFront:home.view];
                    
                    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(popPininterestMenu:)];
                    gesture.delegate = self;
                    [self.view addGestureRecognizer:gesture];

                } else {
                    
                    NSLog(@"取消");
                    if (error.code == LAErrorUserFallback) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            // 密码验证
                        });
                    } else if (error.code == LAErrorUserCancel) {
                        
                        NSLog(@"取消2");
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFinger"];
                    }
                }
            }];
        }
    } else {
        
        home = [[HomeViewController alloc] init];
        [self.view addSubview:home.view];
        
        mine = [[MineViewController alloc] init];
        [self.view addSubview:mine.view];
        
        [self.view bringSubviewToFront:home.view];
        
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(popPininterestMenu:)];
        gesture.delegate = self;
        [self.view addGestureRecognizer:gesture];

    }
    
}


- (void)showMenu
{
    if (!self.menu) {
        PininterestLikeMenuItem *item0 = [[PininterestLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"center"]
                                                                           selctedImage:[UIImage imageNamed:@"center-highlighted"]
                                                                          selectedBlock:^(void) {
                                                                              
                                                                              [self.view bringSubviewToFront:home.view];
//                                                                              [self performSelectorOnMainThread:@selector(showView) withObject:nil waitUntilDone:YES];
                                                                              NSLog(@"item 0 selected");
                                                                          }];
        PininterestLikeMenuItem *item1 = [[PininterestLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"center"]
                                                                           selctedImage:[UIImage imageNamed:@"center-highlighted"]
                                                                          selectedBlock:^(void) {
                                                                              [self.view bringSubviewToFront:mine.view];            NSLog(@"item 1 selected");
                                                                          }];
        
        NSArray *subMenus = @[item0, item1];
        
        self.menu = [[PininterestLikeMenu alloc] initWithSubMenus:subMenus withStartPoint:self.beginLocation];
    }
    
    [self.menu show];
    
}

//- (void)showView
//{
//    [self.view bringSubviewToFront:musicVC.view];
//}

- (void)popPininterestMenu:(UIGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.view.window];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.beginLocation = location;
        [self showMenu];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [self.menu updataLocation:location];
    }
    else{
        self.beginLocation = CGPointZero;
        [self.menu finished:location];
        self.menu = nil;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
