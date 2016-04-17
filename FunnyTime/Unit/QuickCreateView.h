//
//  QuickCreateView.h
//  test
//
//  Created by Jarvan on 15/9/2.
//  Copyright (c) 2015年 Even. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickCreateView : UIView

/**(UIButton) 创建系统按键－简单－  */
+ (UIButton *)addButtonWithFrame:(CGRect)frame
                                 title:(NSString *)title
                                   tag:(int)tag
                                target:(id)target
                                action:(SEL)action
                        andAddToUIView:(UIView *)superView;

/**(UIButton *) 创建图片按键－简单－  */
+ (UIButton *)addButtonWithFrame:(CGRect)frame
                                 title:(NSString *)title
                                 image:(UIImage *)image
                               bgImage:(UIImage *)bgImage
                                   tag:(int)tag
                                target:(id)target
                                action:(SEL)action
                        andAddToUIView:(UIView *)superView;

/**(UILable *) 创建标签－简单－  */
+ (UILabel *)addLableWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)color
                andAddToUIView:(UIView *)superView;

/**(UIView *) 创建视图－简单－  */
+(UIView *)addViewWithFrame:(CGRect)frame
         andBackgroundColor:(UIColor *)bgColor
             andAddToUIView:(UIView *)superView;

/**(UIButton *) 创建系统按键  */
+(UIButton *)addButtonWithFrame:(CGRect)frame
                  andBackgroundColor:(UIColor *)bgColor
                             andText:(NSString *)text
                        andTextColor:(UIColor *)textColor
                         andTextFont:(CGFloat)textFont
                           andTarget:(id)target
                         andSelector:(SEL)selector
                      andAddToUIView:(UIView *)superView;

/**(UIBUtton *) 创建图片按键  */
+(UIButton *)addButtonWithFrame:(CGRect)frame
             andBackgroundColor:(UIColor *)bgColor
                       andImage:(UIImage *)image
                andSeletedImage:(UIImage *)seletedimage
             andBackgroundImage:(UIImage *)bgImage
                      andTarget:(id)target andSelector:(SEL)selector
                 andAddToUIView:(UIView *)superView;

/**(UILable *) 创建标签  */
+(UILabel *)addLabelWithFrame:(CGRect)frame
           andBackgroundColor:(UIColor *)bgColor
                      andText:(NSString*)text
                  andTextFont:(double)font
             andTextAlignment:(NSTextAlignment)textAlignment
               andAddToUIView:(UIView *)superView;

/**(UIImageView *) 创建图片视图  */
+(UIImageView *)addImageVierWithFrame:(CGRect)frame
                   andBackgroundColor:(UIColor *)bgColor
                   andBackgroundImage:(UIImage *)Image
                 andUsInterfaceEnable:(BOOL)UsInterfaceEnable
                       andContextMode:(UIViewContentMode)contentMode
                       andAddToUIView:(UIView *)superView;

@end
