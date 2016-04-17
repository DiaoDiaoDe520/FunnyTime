//
//  MyToolBar.h
//  QQ
//
//  Created by qf1 on 15/11/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeViewController.h"
@interface MyToolBar : UIToolbar

@property (nonatomic,strong) UIButton * firstButton;
@property (nonatomic,strong) UIButton * secondButton;
@property (nonatomic,strong) UIButton * threeButton;
@property (nonatomic,strong)  UITextView * textView;

- (instancetype)initWithBackImage:(UIImage *)backImage andFirstButtonImage:(UIImage *)firstImage andSecondButtonimage:(UIImage *)SecondImage andThreeButtonImage:(UIImage *)threeImage andViewController:(UIViewController *)vc;

+ (instancetype)setMyToolBarWithBackImage:(UIImage *)backImage andFirstButtonImage:(UIImage *)firstImage andSecondButtonimage:(UIImage *)SecondImage andThreeButtonImage:(UIImage *)threeImage andViewController:(UIViewController *)vc;

@end
