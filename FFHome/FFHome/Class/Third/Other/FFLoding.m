//
//  FFLoding.m
//  LodingImage
//
//  Created by LiuFei on 16/11/14.
//  Copyright © 2016年 jianxin. All rights reserved.
//

#import "FFLoding.h"

@interface FFLoding ()



@end

@implementation FFLoding

@synthesize gifImg;
@synthesize effectV;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        effectV = [[UIView alloc] initWithFrame:frame];
        effectV.alpha = 0.5;
        effectV.backgroundColor = [UIColor grayColor];
        
        _bview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _bview.center = self.center;
        _bview.layer.cornerRadius = 10.0f;
        _bview.backgroundColor = [UIColor whiteColor];
        
        gifImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 30, 120, 120)];
        
        NSMutableArray *imgs = [NSMutableArray array];
        for (int i = 0; i < 14; i ++) {
            
            NSString *str = [NSString stringWithFormat:@"loding%d", i + 1];
            UIImage *image = [UIImage imageNamed:str];
            [imgs addObject:image];
        }
        
        NSLog(@"bview.frame = %@", _bview);
//        gifImg.center = _bview.center;
        gifImg.animationImages = imgs;
        gifImg.animationDuration = 5;
        gifImg.animationRepeatCount = 0;
        [_bview addSubview:gifImg];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(gifImg.frame), CGRectGetMaxY(gifImg.frame), CGRectGetWidth(gifImg.frame), 30)];
        label.text = @"小妙正在努力加载中...";
        label.font = [UIFont systemFontOfSize:12];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_bview addSubview:label];
    }
    return self;
}

+ (void)showLodingInView:(UIView *)aView
{
    if (aView == nil) {
        
        aView = [[UIApplication sharedApplication].windows lastObject];
    }
    
    FFLoding *fview = [[FFLoding alloc] initWithFrame:aView.bounds];
    
    [aView addSubview:fview];
    
    [fview showLoding:aView];
    
}

- (void)timer
{
    _second ++;
    
    if (_second == 20) {// 请求超过20秒自动消失
        
        FFLoding *fview = [FFLoding myLoading:_tempV];
        if (fview) {
            
            [fview hideLoding:_tempV];
            [fview removeFromSuperview];
        }
    }
}

+ (void)hideLodingInView:(UIView *)aView
{
    if (aView == nil) {
        
        aView = [[UIApplication sharedApplication].windows lastObject];
    }
    FFLoding *fview = [FFLoding myLoading:aView];
    if (fview) {
        
        [fview hideLoding:aView];
        [fview removeFromSuperview];
        
    }
}

+ (FFLoding *)myLoading:(UIView *)aView
{
    for (UIView *v in aView.subviews) {
        
        if ([v isKindOfClass:[FFLoding class]]) {
            
            return (FFLoding *)v;
        }
    }
    return nil;
}

- (void)showLoding:(UIView *)aview
{
    _tempV = aview;
    [gifImg startAnimating];
    [aview addSubview:effectV];
    [aview addSubview:_bview];
//    [[UIApplication sharedApplication].keyWindow addSubview:effectV];
//    [effectV bringSubviewToFront:aview];
//    [[UIApplication sharedApplication].keyWindow addSubview:_bview];
//    [_bview bringSubviewToFront:aview];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    
}

- (void)hideLoding:(UIView *)aview
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _bview.alpha = 0;
        effectV.alpha = 0;
    } completion:^(BOOL finished) {
        
        [gifImg stopAnimating];
        [_bview removeFromSuperview];
        [effectV removeFromSuperview];
    }];
    
}

@end
