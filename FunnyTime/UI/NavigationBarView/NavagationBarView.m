//
//  NavagationBarView.m
//  NEWS
//
//  Created by qf1 on 15/11/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NavagationBarView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation NavagationBarView
- (instancetype)initWithNavigationBarWithBackImage:(UIImage *)image andLeftButtonImage:(UIImage *)leftImage andSeletedLeftImage:(UIImage *)seletedImage andRightImage:(UIImage *)rightImage andSeletedRightImage:(UIImage *)seletedImageR angLogeImageName:(NSString *)name andBackColor:(UIColor *)backColor andBarColor:(UIColor *)barColor andTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        
        self = [self setNavigationBarWithColor:backColor BackImage:image andLeftButtonImage:leftImage andSeletedLeftImage:seletedImage andRightImage:rightImage andSeletedRightImage:seletedImageR angLogeImageName:name andTitle:title andBarColor:barColor];
    }
    return self;
}


- (id)setNavigationBarWithColor:(UIColor *)color BackImage:(UIImage *)image andLeftButtonImage:(UIImage *)leftImage andSeletedLeftImage:(UIImage *)seletedImage andRightImage:(UIImage *)rightImage andSeletedRightImage:(UIImage *)seletedImageR angLogeImageName:(NSString *)name andTitle:(NSString *)title andBarColor:(UIColor *)barColor {
    
//    状态栏设置
#if STATUS_BAR
    
    UIView * barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    barView.backgroundColor = barColor;
    [self addSubview:barView];
    
#endif
    
//    背景颜色 导航栏左右两边按钮设置
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.backgroundColor = color;
    [self setImage:image];
    self.contentMode = UIViewContentModeScaleToFill;
    self.userInteractionEnabled = YES;
    self.tag = 123;
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(12, 26, 60, 30);
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.leftButton.backgroundColor = [UIColor clearColor];
    
    [self.leftButton setImage:leftImage forState:UIControlStateNormal];
    [self.leftButton setImage:seletedImage forState:UIControlStateHighlighted];
    [self addSubview:self.leftButton];
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(SCREEN_WIDTH-64, 26, 52, 30);
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightButton.backgroundColor = [UIColor clearColor];
    
    [self.rightButton setImage:rightImage forState:UIControlStateNormal];
    [self.rightButton setImage:seletedImageR forState:UIControlStateHighlighted];
    [self addSubview:self.rightButton];
    
//    如果有图片传入就不设置标题，否则设置标题
    if ([name isEqualToString:@""]) {
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.frame = CGRectMake((SCREEN_WIDTH-200)/2, 22, 200, 40);
        
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.textColor = [UIColor blackColor];
        self.titleLable.text = title;
        self.titleLable.textAlignment = NSTextAlignmentCenter;
//        self.titleLable.font = [UIFont systemFontOfSize:24];
        self.titleLable.font = [UIFont boldSystemFontOfSize:17];
//        title颜色设置
        
        [self addSubview:self.titleLable];
        
    }
    else {
        self.logeImageView = [[UIImageView alloc] init];
        self.logeImageView.image = [UIImage imageNamed:name];
        self.logeImageView.frame = CGRectMake((SCREEN_WIDTH-48)/2, 20, 48, 44);
        self.logeImageView.contentMode = UIViewContentModeScaleAspectFit,
        self.logeImageView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.logeImageView];
    }
    return self;
}
// 左边按钮设置
- (void)setLeftBarButtonWithBackgoundImage:(UIImage *)backgoundImage andNomalImage:(UIImage *)image andTitle:(NSString *)title andTitleColor:(UIColor *)textColor {
    
    self.leftButton.hidden = NO;
    [self.leftButton setBackgroundImage:backgoundImage forState:UIControlStateNormal];
    [self.leftButton setImage:image forState:UIControlStateNormal];
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)setLeftBarButtonImageEdge:(UIEdgeInsets)imageEdge andTitleEdge:(UIEdgeInsets)titleEdge {
    [self.leftButton setImageEdgeInsets:imageEdge];
    [self.leftButton setTitleEdgeInsets:titleEdge];
}

- (void)setLeftBarButtonSize:(CGSize)size {
    self.leftButton.frame = CGRectMake(self.leftButton.frame.origin.x, self.leftButton.frame.origin.y, size.width, size.height);
}

- (void)setLeftBarButtonPoint:(CGPoint)origin {
    self.rightButton.frame = CGRectMake(origin.x, origin.y, self.rightButton.frame.size.width, self.rightButton.frame.size.height);
}

// 右边按钮设置
- (void)setRightBarButtonWithBackgoundImage:(UIImage *)backgoundImage andNomalImage:(UIImage *)image andTitle:(NSString *)title andTitleColor:(UIColor *)textColor {

    self.rightButton.hidden = NO;
    [self.rightButton setBackgroundImage:backgoundImage forState:UIControlStateNormal];
    [self.rightButton setImage:image forState:UIControlStateNormal];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setTitleColor:textColor forState:UIControlStateNormal];

}
- (void)setRightBarButtonImageEdge:(UIEdgeInsets)imageEdge andTitleEdge:(UIEdgeInsets)titleEdge {
    [self.rightButton setImageEdgeInsets:imageEdge];
    [self.rightButton setTitleEdgeInsets:titleEdge];
}

- (void)setRightBarButtonSize:(CGSize)size {
    self.rightButton.frame = CGRectMake(self.rightButton.frame.origin.x, self.rightButton.frame.origin.y, size.width, size.height);
}

- (void)setRightBarButtonPoint:(CGPoint)origin {
    self.rightButton.frame = CGRectMake(origin.x, origin.y, self.rightButton.frame.size.width, self.rightButton.frame.size.height);
}



@end
