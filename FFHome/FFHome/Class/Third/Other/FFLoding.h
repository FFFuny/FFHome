//
//  FFLoding.h
//  LodingImage
//
//  Created by LiuFei on 16/11/14.
//  Copyright © 2016年 jianxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFLoding : UIView

@property (strong, nonatomic) UIImageView *gifImg;
@property (strong, nonatomic) UIView *bview;
@property (strong, nonatomic) UIView *effectV;

@property (strong, nonatomic) UIView *tempV;

@property (assign, nonatomic) NSInteger second;

+ (void)showLodingInView:(UIView *)aView;
+ (void)hideLodingInView:(UIView *)aView;

@end
