//
//  MyToolBar.m
//  QQ
//
//  Created by qf1 on 15/11/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MyToolBar.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation MyToolBar
//对象方法初始化
- (instancetype)initWithBackImage:(UIImage *)backImage andFirstButtonImage:(UIImage *)firstImage andSecondButtonimage:(UIImage *)SecondImage andThreeButtonImage:(UIImage *)threeImage andViewController:(UIViewController *)vc {
    self = [super init];
    if (self) {
        [self setMyToolBarBackImage:backImage andFirstButtonImage:firstImage andSecondButtonimage:SecondImage andThreeButtonImage:threeImage andViewController:vc];
    }
    return self;
}
//类方法创建
+ (instancetype)setMyToolBarWithBackImage:(UIImage *)backImage andFirstButtonImage:(UIImage *)firstImage andSecondButtonimage:(UIImage *)SecondImage andThreeButtonImage:(UIImage *)threeImage andViewController:(UIViewController *)vc {
    
    return [[MyToolBar alloc] initWithBackImage:backImage andFirstButtonImage:firstImage andSecondButtonimage:SecondImage andThreeButtonImage:threeImage andViewController:vc];
}

- (void)setMyToolBarBackImage:(UIImage *)backImage andFirstButtonImage:(UIImage *)firstImage andSecondButtonimage:(UIImage *)SecondImage andThreeButtonImage:(UIImage *)threeImage andViewController:(UIViewController *)vc {
    
    self.barStyle = UIBarStyleBlack;
    self.frame = CGRectMake(0, 64, SCREEN_WIDTH, 36);
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 36);
    imageView.image = [backImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:imageView];
    
    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstButton setImage:firstImage forState:UIControlStateNormal];
    [self.firstButton addTarget:vc action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.firstButton setTitle:@"主题分类" forState:UIControlStateNormal];
    self.firstButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.firstButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -36, 0, 0)];
    [self.firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -126)];
    self.firstButton.selected = NO;
    UIView *view = [QuickCreateView addViewWithFrame:CGRectMake(1, 30, (SCREEN_WIDTH-6)/3, 3) andBackgroundColor:[UIColor redColor] andAddToUIView:self.firstButton];
    view.hidden = NO;
    view.tag = 30;
    self.firstButton.titleLabel.textColor = [UIColor blackColor];
    self.firstButton.frame = CGRectMake(1, 3, (SCREEN_WIDTH-6)/3, 30);
    self.firstButton.tag = 1;
    [self addSubview:self.firstButton];
    

    self.secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondButton setImage:SecondImage forState:UIControlStateNormal];
    [self.secondButton addTarget:vc action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.secondButton.frame = CGRectMake(((SCREEN_WIDTH-6)/3)+3, 3, (SCREEN_WIDTH-6)/3, 30);
    self.secondButton.tag = 2;
    [self addSubview:self.secondButton];
    
    [self.secondButton setTitle:@"当前位置" forState:UIControlStateNormal];
    self.secondButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.secondButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -36, 0, 0)];
    [self.secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -126)];
    self.secondButton.selected = NO;
    UIView *secondButtonview = [QuickCreateView addViewWithFrame:CGRectMake(1, 30, (SCREEN_WIDTH-6)/3, 3) andBackgroundColor:[UIColor redColor] andAddToUIView:self.secondButton];
    secondButtonview.tag = 30;
    secondButtonview.hidden = YES;
    
    
    self.threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.threeButton setImage:threeImage forState:UIControlStateNormal];
    [self.threeButton addTarget:vc action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.threeButton.frame = CGRectMake(((SCREEN_WIDTH-6)/3)*2+5, 3, (SCREEN_WIDTH-6)/3, 30);
    self.threeButton.tag = 3;
    [self addSubview:self.threeButton];
    
    
    [self.threeButton setTitle:@"选择排序" forState:UIControlStateNormal];
    self.threeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.threeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -36, 0, 0)];
    [self.threeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -126)];
    self.threeButton.selected = NO;
    UIView *threeButtonview = [QuickCreateView addViewWithFrame:CGRectMake(1, 30, (SCREEN_WIDTH-6)/3, 3) andBackgroundColor:[UIColor redColor] andAddToUIView:self.threeButton];
    threeButtonview.tag = 30;
    threeButtonview.hidden = YES;
    
    
}




@end
