//
//  HomeViewController.m
//  FFHome
//
//  Created by LiuFei on 2017/2/12.
//  Copyright © 2017年 ff. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UITextFieldDelegate>
{
    UIView *_navView;
    UIScrollView *_bgScroll;
    UILabel *_changeLabel;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _bgScroll = [[UIScrollView alloc] init];
    _bgScroll.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 2);
    _bgScroll.backgroundColor = COLOR(239, 239, 239);
    [self.view addSubview:_bgScroll];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_bgScroll addGestureRecognizer:tap];
    
    [_bgScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.view).offset(64);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [self initNavView];
    [self initWithUILabel];
    [self initWithUITextField];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)initNavView
{
    _navView = [[UIView alloc] init];
    _navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navView];
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.text = @"控件";
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


#pragma mark - UILabel文字大小自适应
/**
 初始化视图
 */
- (void)initWithUILabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.text = @"UILabel文字大小自适应:";
    label.font = Font(12);
    [_bgScroll addSubview:label];
    
    _changeLabel = [[UILabel alloc] init];
    _changeLabel.text = @"点击改变文字大小适配宽度";
    _changeLabel.textColor = [UIColor blackColor];
    _changeLabel.adjustsFontSizeToFitWidth = YES;
    _changeLabel.backgroundColor = [UIColor yellowColor];
    [_bgScroll addSubview:_changeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSize:)];
    _changeLabel.userInteractionEnabled = YES;
    [_changeLabel addGestureRecognizer:tap];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(_bgScroll.mas_top).offset(20);
        make.left.equalTo(_bgScroll.mas_left).offset(20);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    [_changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(_bgScroll.mas_top).offset(20);
        make.left.equalTo(label.mas_right).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)changeSize:(UITapGestureRecognizer *)tap
{
    NSArray *arr = @[@"点击改变文字大小适配宽度", @"四个文字", @"这么多个文字啊我的天呐", @"你的月亮我的心", @"好"];
    NSInteger n = arc4random() % arr.count;
    _changeLabel.text = arr[n];
}

#pragma mark - UITextField限制输入数字
- (void)initWithUITextField
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.text = @"UITextField限制输入0-100:";
    label.font = Font(12);
    [_bgScroll addSubview:label];
    
    UITextField *tField = [[UITextField alloc] init];
    tField.textColor = [UIColor blackColor];
    tField.delegate = self;
    tField.keyboardType = UIKeyboardTypeNumberPad;
    tField.layer.borderWidth = 1;
    tField.tag = 100;
    [_bgScroll addSubview:tField];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor blackColor];
    label2.text = @"UITextField限制输入小数(xxxxxx.xx):";
    label2.font = Font(12);
    label2.numberOfLines = 0;
    [_bgScroll addSubview:label2];
    
    UITextField *tField2 = [[UITextField alloc] init];
    tField2.textColor = [UIColor blackColor];
    tField2.delegate = self;
    tField2.keyboardType = UIKeyboardTypeDecimalPad;
    tField2.layer.borderWidth = 1;
    tField2.tag = 101;
    [_bgScroll addSubview:tField2];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(_changeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(40);
    }];

    [tField mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(_changeLabel.mas_bottom).offset(10);
        make.left.equalTo(label.mas_right).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(_bgScroll.mas_left).offset(20);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(40);
    }];
    
    [tField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(label2.mas_right).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 100) {
        
        if (textField.text.length == 1) {
            
            // 第一个字符是0时, 第二个不能再输入0
            unichar str = [textField.text characterAtIndex:0];
            if (str == '0' && [string isEqualToString:@"0"]) {// 0xx
                
                return NO;
            }
            
            // 第一个字符是1时, 第二个字符也是0时, 第三个字符也必须是0
            if (str == '1' && [string isEqualToString:@"0"]) {// 10x
                
                return YES;
            } else {
                
                if (str != '0' && str != '1') {// 1xx或0xx
                    
                    return YES;
                } else {
                    
                    if (str == '1') {
                        
                        return YES;
                    } else {
                        
                        if ([string isEqualToString:@""]) {
                            
                            return YES;
                        } else {
                            
                            return NO;
                        }
                    }
                    
                    
                }
                
            }
            
            // 已输入两个字符后
        } else if (textField.text.length == 2) {
            
            // 取第一个字符
            unichar str = [textField.text characterAtIndex:0];
            // 取第二个字符
            unichar str2 = [textField.text characterAtIndex:1];
            if (str == '1' && [string isEqualToString:@"0"]) {// 输入的数是:10x
                
                if (str2 == '0' && [string isEqualToString:@"0"]) {// 输入的是:100
                    
                    
                    return YES;
                } else {
                    
                    if (str2 != '0') {// 输入的是:11,12...
                        
                        return NO;
                    } else {
                        
                        return YES;
                    }
                    
                }
            } else {
                
                if ([string isEqualToString:@""]) {// 两个字符时删除个位数
                    
                    return YES;
                } else {
                    
                    return NO;
                }
                
            }
            
        } else if (textField.text.length == 3) {
            if ([string isEqualToString:@""]) {
                return YES;
            } else {
                return NO;
            }
        }
        
        if (textField.text.length > 2) {// 最多输入三个数
            
            return range.location < 3;
        }
    } else if (textField.tag == 101) {
        
        // 当前输入的字符是'.'
        if ([string isEqualToString:@"."]) {
            
            // 已输入的字符串中已经包含了'.'或者""
            if ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""]) {
                
                return NO;
            } else {
                
                return YES;
            }
        } else {// 当前输入的不是'.'
            
            // 第一个字符是0时, 第二个不能再输入0
            if (textField.text.length == 1) {
                
                unichar str = [textField.text characterAtIndex:0];
                if (str == '0' && [string isEqualToString:@"0"]) {
                    
                    return NO;
                }
                
                if (str != '0' && str != '1') {// 1xx或0xx
                    
                    return YES;
                } else {
                    
                    if (str == '1') {
                        
                        return YES;
                    } else {
                        
                        if ([string isEqualToString:@""]) {
                            
                            return YES;
                        } else {
                            
                            return NO;
                        }
                    }
                    
                    
                }
            }
            
            // 已输入的字符串中包含'.'
            if ([textField.text rangeOfString:@"."].location != NSNotFound) {
                
                NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
                [str insertString:string atIndex:range.location];
                
                if (str.length >= [str rangeOfString:@"."].location + 4) {
                    
                    return NO;
                }
                NSLog(@"str.length = %ld, str = %@, string.location = %ld", str.length, string, range.location);
                
                
            } else {
                
                if (textField.text.length > 5) {
                    
                    return range.location < 6;
                }
            }
            
            
        }
    }
    
    return YES;
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
