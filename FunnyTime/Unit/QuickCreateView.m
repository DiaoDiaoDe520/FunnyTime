//
//  QuickCreateView.m
//  test
//
//  Created by Jarvan on 15/9/2.
//  Copyright (c) 2015年 Even. All rights reserved.
//
#import "QuickCreateView.h"

@implementation QuickCreateView

/** 快速创建标题按键*/
+ (UIButton *)addButtonWithFrame:(CGRect)frame title:(NSString *)title tag:(int)tag target:(id)target action:(SEL)action andAddToUIView:(UIView *)superView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    
    return button;
}

/** 快速创建图片按键*/
+ (UIButton *)addButtonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image bgImage:(UIImage *)bgImage tag:(int)tag target:(id)target action:(SEL)action andAddToUIView:(UIView *)superView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    [superView addSubview:button];
    
    return button;
}

/** 快速创标签*/
+ (UILabel *)addLableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color andAddToUIView:(UIView *)superView {
    
    UILabel *lable = [[UILabel alloc] init];
    lable.frame = frame;
    lable.text = text;
    lable.textColor = color;
//        lable.textAlignment = NSTextAlignmentCenter;
        lable.backgroundColor = [UIColor clearColor];
    [superView addSubview:lable];
    
    return lable;
}

//在创建UIView工场方法中手动创建一个UIView并赋值
+(UIView *)addViewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andAddToUIView:(UIView *)superView {
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    view.backgroundColor = bgColor;
    [superView addSubview:view];
    
    return view;
    
}

//快速创建文字按钮
+(UIButton *)addButtonWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andText:(NSString *)text andTextColor:(UIColor *)textColor andTextFont:(CGFloat)textFont andTarget:(id)target andSelector:(SEL)selector andAddToUIView:(UIView *)superView {
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    
    button.backgroundColor = bgColor;
    
    [button setTitle:text forState:UIControlStateNormal];
    
    [button setTitleColor:textColor forState:UIControlStateNormal];
    
    [button addTarget:target action:selector    forControlEvents:UIControlEventTouchUpInside];
    
    button.titleLabel.font = [UIFont systemFontOfSize:textFont];
    [superView addSubview:button];
    
    return button;
    
}

//快速创建图片按钮
+(UIButton *)addButtonWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andImage:(UIImage *)image andSeletedImage:(UIImage *)seletedimage andBackgroundImage:(UIImage *)bgImage andTarget:(id)target andSelector:(SEL)selector andAddToUIView:(UIView *)superView {
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    
    button.backgroundColor = bgColor;
    
    [button setImage:image forState:UIControlStateNormal];
    
    [button setImage:seletedimage forState:UIControlStateSelected];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    [superView addSubview:button];
    
    return button;
    
}

//快速创建标签
+(UILabel *)addLabelWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andText:(NSString*)text andTextFont:(double)font andTextAlignment:(NSTextAlignment)textAlignment andAddToUIView:(UIView *)superView {
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.backgroundColor = bgColor;
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = textAlignment;
    [superView addSubview:label];
    
    return label;
}

//快速创建imageView
+(UIImageView *)addImageVierWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andBackgroundImage:(UIImage *)Image andUsInterfaceEnable:(BOOL)UsInterfaceEnable andContextMode:(UIViewContentMode)contentMode andAddToUIView:(UIView *)superView {
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = frame;
    imageView.backgroundColor = bgColor;
    imageView.image = Image;
    imageView.userInteractionEnabled = UsInterfaceEnable;
    imageView.contentMode = contentMode;
    [superView addSubview:imageView];
    
    return imageView;
}


@end
