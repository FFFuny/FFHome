//
//  MovieViewController.m
//  FFHome
//
//  Created by 建新 on 17/2/17.
//  Copyright © 2017年 ff. All rights reserved.
//

#import "MovieViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface MovieViewController ()
{
    BOOL isAllScreen;
}

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic,strong)AVPlayer *player; // 播放属性
@property(nonatomic,strong)AVPlayerItem *playerItem; // 播放属性
@property(nonatomic,assign)CGFloat width; // 坐标
@property(nonatomic,assign)CGFloat height; // 坐标
@property(nonatomic,strong)UISlider *slider; // 进度条
@property(nonatomic,strong)UILabel *currentTimeLabel; // 当前播放时间
@property (nonatomic, strong) UIButton *allScreen;  // 全屏按钮
@property(nonatomic,strong)UILabel *systemTimeLabel; // 系统时间
@property(nonatomic,strong)UIView *backView; // 上面一层Viewd
@property(nonatomic,assign)CGPoint startPoint;
@property(nonatomic,assign)CGFloat systemVolume;
@property(nonatomic,strong)UISlider *volumeViewSlider;
@property(nonatomic,strong)UIActivityIndicatorView *activity; // 系统菊花
@property(nonatomic,strong)UIProgressView *progress; // 缓冲条
@property(nonatomic,strong)UIView *topView;
@property (strong, nonatomic) UIView *bottomView;


@end

@implementation MovieViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    _width = [[UIScreen mainScreen]bounds].size.width;
    _height = [[UIScreen mainScreen]bounds].size.height;
    
    isAllScreen = NO;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _width/4*3+20)];
    bgView.backgroundColor = [UIColor blackColor];
    
    // 创建AVPlayer
//    NSURL *sourceMovieUrl = [NSURL fileURLWithPath:@"/Users/jianxin/Downloads/11111.mp4"];
//    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];
//    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"]];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    self.playerLayer.frame = CGRectMake(0, 20, _width, _width/4*3);
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [bgView.layer addSublayer:self.playerLayer];
    [self.view addSubview:bgView];
//    [self.view.layer addSublayer:self.playerLayer];
    [_player play];
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, _width, _width/4*3)];
    [self.view addSubview:_backView];
    _backView.backgroundColor = [UIColor clearColor];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _width, 30)];
    _topView.backgroundColor = [UIColor blackColor];
    _topView.alpha = 0.5;
    [_backView addSubview:_topView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _width/4*3-40, _width, 40)];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.5;
    _bottomView.userInteractionEnabled = YES;
    [_backView addSubview:_bottomView];
    
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    
    [self createProgress];
    [self createSlider];
    [self createCurrentTimeLabel];
    [self createButton];
    [self backButton];
    [self createTitle];
    [self createGesture];
    
    [self customVideoSlider];
    
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activity.center = _backView.center;
    [self.view addSubview:_activity];
    [_activity startAnimating];
    
    //    //延迟线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
//            _backView.alpha = 0;
            _topView.alpha = 0;
            _bottomView.alpha = 0;
        }];
        
    });
    
    //计时器
    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(Stack) userInfo:nil repeats:YES];
    //    self.modalPresentationCapturesStatusBarAppearance = YES;
    
}
#pragma mark - 横屏代码
- (BOOL)shouldAutorotate{
    return NO;
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
} //当前viewcontroller支持哪些转屏方向

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}
#pragma mark - 创建UISlider
- (void)createSlider
{
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(_width/8 + 10, 16, _width/2 - 20, 10)];
    self.slider.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:_slider];
    [_slider setThumbImage:[UIImage imageNamed:@"iconfont-yuan"] forState:UIControlStateNormal];
    [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumTrackTintColor = [UIColor colorWithRed:30 / 255.0 green:80 / 255.0 blue:100 / 255.0 alpha:1];
    
}

#pragma mark - slider滑动事件
- (void)progressSlider:(UISlider *)slider
{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay) {
        
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //    NSLog(@"%f", total);
        
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        //    NSLog(@"dragedSeconds:%ld",dragedSeconds);
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [_player pause];
        
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            
            [_player play];
            
        }];
        
    }
}
#pragma mark - 创建UIProgressView
- (void)createProgress
{
    self.progress = [[UIProgressView alloc]initWithFrame:CGRectMake(_width/8 + 15, 20, _width/2 - 20, 10)];
    self.progress.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:_progress];
}
#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        //        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progress setProgress:timeInterval / totalDuration animated:NO];
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
- (void)customVideoSlider {
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    [self.slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}








#pragma mark - 创建播放时间
- (void)createCurrentTimeLabel
{
    self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.progress.frame) + 10, 0, 80, 40)];
    [_bottomView addSubview:_currentTimeLabel];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    //    _currentTimeLabel.backgroundColor = [UIColor blueColor];
    _currentTimeLabel.font = [UIFont systemFontOfSize:12];
    _currentTimeLabel.text = @"00:00/00:00";
    
    self.allScreen = [[UIButton alloc] initWithFrame:CGRectMake(_width - 40, 0, 40, 40)];
    [_allScreen setImage:[UIImage imageNamed:@"icon-shipin-fangda"] forState:UIControlStateNormal];
    [_allScreen setImage:[UIImage imageNamed:@"icon-shipin-suoxiao"] forState:UIControlStateSelected];
    [_allScreen addTarget:self action:@selector(allScreen:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_allScreen];
    
    
}

- (void)allScreen:(UIButton *)sender
{
    if (isAllScreen) {
        
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDel.isHalfScreen = YES;
        isAllScreen = NO;
        
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait]  forKey:@"orientation"];//这句话是防止手动先把设备置为横屏,导致下面的语句失效.
        [UIView animateWithDuration:0.5 animations:^{
            
            //        self.playerLayer.frame
            self.playerLayer.frame= CGRectMake(0, 20, _width, _width/4*3);
            self.backView.frame = CGRectMake(0, 20, _width, _width/4*3);
//            self.backView.backgroundColor = [UIColor clearColor];
            self.bottomView.frame = CGRectMake(0, _width/4*3 - 40, _width, 40);

            // 进度条
            self.progress.frame = CGRectMake(_width/8 + 15, 20, _width/2 - 20, 10);
            // 滑块
            self.slider.frame = CGRectMake(_width/8 + 10, 16, _width/2 - 20, 10);
            // 时间
            self.currentTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.progress.frame) + 10, 0, 80, 40);
            // 全屏
            self.allScreen.frame = CGRectMake(_width - 40, 0, 40, 40);
            
        } completion:^(BOOL finished) {
        }];
    } else {
        
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDel.isHalfScreen = NO;
        isAllScreen = YES;
        
        [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait]  forKey:@"orientation"];//这句话是防止手动先把设备置为横屏,导致下面的语句失效.
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        [UIView animateWithDuration:0.5 animations:^{
            
            //        self.playerLayer.frame
            self.playerLayer.frame= CGRectMake(0, 0, _height, _width);
            self.backView.frame = CGRectMake(0, 20, _height, _width - 20);
            self.backView.backgroundColor = [UIColor clearColor];
            self.bottomView.frame = CGRectMake(0, _width - 40 - 20, _height, 40);

            // 进度条
            self.progress.frame = CGRectMake(_width/8 + 15, 20, _height - 40 - 150, 10);
            // 滑块
            self.slider.frame = CGRectMake(_width/8 + 10, 16, _height - 40 - 150, 10);
            // 时间
            self.currentTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.progress.frame) + 10, 0, 80, 40);
            // 全屏
            self.allScreen.frame = CGRectMake(_height - 40, 0, 40, 40);
        } completion:^(BOOL finished) {
        }];
    }
    
}



#pragma mark - 计时器事件
- (void)Stack
{
    if (_playerItem.duration.timescale != 0) {
        
        _slider.maximumValue = 1;//音乐总共时长
        _slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
        
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        //    NSLog(@"%d",_playerItem.duration.timescale);
        //    NSLog(@"%lld",_playerItem.duration.value/1000 / 60);
        
        //duration 总时长
        
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", proMin, proSec, durMin, durSec];
    }
    if (_player.status == AVPlayerStatusReadyToPlay) {
        [_activity stopAnimating];
    } else {
        [_activity startAnimating];
    }
    
}
#pragma mark - 播放和下一首按钮
- (void)createButton
{
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(15, 10, 20, 20);
    [_bottomView addSubview:startButton];
    if (_player.rate == 1.0) {
        
        [startButton setBackgroundImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateNormal];
    } else {
        [startButton setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
        
    }
    [startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    nextButton.frame = CGRectMake(60, _width/4*3-40 + 10, 25, 20);
//    [self.backView addSubview:nextButton];
//    [nextButton setBackgroundImage:[UIImage imageNamed:@"nextPlayer"] forState:UIControlStateNormal];
    
    
}
#pragma mark - 播放暂停按钮方法
- (void)startAction:(UIButton *)button
{
    if (button.selected) {
        [_player play];
        [button setBackgroundImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateNormal];
        
    } else {
        [_player pause];
        [button setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
        
    }
    button.selected =!button.selected;
    
}
#pragma mark - 返回按钮方法
- (void)backButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 5, 20, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_topView addSubview:button];
    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [[UIApplication sharedApplication].keyWindow addSubview:button];
}
#pragma mark - 创建标题
- (void)createTitle
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, _width - 80, 30)];
    [_topView addSubview:label];
    label.text = @"无奋斗不青春";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
}
#pragma mark - 创建手势
- (void)createGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_backView addGestureRecognizer:tap];
    
    
    
    //获取系统音量
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    _systemVolume = _volumeViewSlider.value;
    
    
}
#pragma mark - 轻拍方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_topView.alpha == 0.5) {
        [UIView animateWithDuration:0.5 animations:^{
            
            _topView.alpha = 0;
            _bottomView.alpha = 0;
        }];
    } else if (_topView.alpha == 0){
        [UIView animateWithDuration:0.5 animations:^{
            
            _topView.alpha = 0.5;
            _bottomView.alpha = 0.5;
        }];
    }
    if (_topView.alpha == 0.5) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.5 animations:^{
                
                _topView.alpha = 0;
                _bottomView.alpha = 0;
            }];
            
        });
        
    }
}
#pragma mark - 滑动调整音量大小
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(event.allTouches.count == 1){
        //保存当前触摸的位置
        CGPoint point = [[touches anyObject] locationInView:self.view];
        _startPoint = point;
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(event.allTouches.count == 1){
        //计算位移
        CGPoint point = [[touches anyObject] locationInView:self.view];
        //        float dx = point.x - startPoint.x;
        float dy = point.y - _startPoint.y;
        int index = (int)dy;
        if(index>0){
            if(index%5==0){//每10个像素声音减一格
                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>0.1){
                    _systemVolume = _systemVolume-0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else{
            if(index%5==0){//每10个像素声音增加一格
                NSLog(@"+x ==%d",index);
                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>=0 && _systemVolume<1){
                    _systemVolume = _systemVolume+0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        //亮度调节
        //        [UIScreen mainScreen].brightness = (float) dx/self.view.bounds.size.width;
    }
}


- (void)moviePlayDidEnd:(id)sender
{
    //    [_player pause];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
}
- (void)backButtonAction
{
    [_player pause];
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
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
