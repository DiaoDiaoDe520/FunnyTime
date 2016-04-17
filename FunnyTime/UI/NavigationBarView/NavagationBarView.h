//
//  NavagationBarView.h
//  NEWS
//
//  Created by qf1 on 15/11/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavagationBarView : UIImageView

@property (nonatomic,strong) UIButton * leftButton;
@property (nonatomic,strong) UIButton * rightButton;
@property (nonatomic,strong) UIImageView * logeImageView;
@property (nonatomic,strong) UILabel * titleLable;

/** 设置自定义导航栏 */
- (instancetype)initWithNavigationBarWithBackImage:(UIImage *)image andLeftButtonImage:(UIImage *)leftImage andSeletedLeftImage:(UIImage *)seletedImage andRightImage:(UIImage *)rightImage andSeletedRightImage:(UIImage *)seletedImageR angLogeImageName:(NSString *)name andBackColor:(UIColor *)backColor andBarColor:(UIColor *)barColor andTitle:(NSString *)title;

/** 设置左边按钮 */
- (void)setLeftBarButtonWithBackgoundImage:(UIImage *)backgoundImage andNomalImage:(UIImage *)image andTitle:(NSString *)title andTitleColor:(UIColor *)textColor;

/** 设置左边按钮的图片文字偏移 */
- (void)setLeftBarButtonImageEdge:(UIEdgeInsets)imageEdge andTitleEdge:(UIEdgeInsets)titleEdge;

/** 设置左边按钮大小 */
- (void)setLeftBarButtonSize:(CGSize)size;

/** 设置左边按钮位置 */
- (void)setLeftBarButtonPoint:(CGPoint)origin;

/** 设置右边按钮 */
- (void)setRightBarButtonWithBackgoundImage:(UIImage *)backgoundImage andNomalImage:(UIImage *)image andTitle:(NSString *)title andTitleColor:(UIColor *)textColor;

/** 右边按钮的图片文字偏移 */
- (void)setRightBarButtonImageEdge:(UIEdgeInsets)imageEdge andTitleEdge:(UIEdgeInsets)titleEdge;

/** 设置右边按钮大小 */
- (void)setRightBarButtonSize:(CGSize)size;

/** 设置右边按钮位置 */
- (void)setRightBarButtonPoint:(CGPoint)origin;

@end
