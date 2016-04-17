//
//  ManyButton.h
//  ManyButtonPackaging
//
//  Created by qf1 on 15/12/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManyButton : UIView

/**** 设置多按钮的View **/
- (void)setManyButtonViewWithButtonImages:(NSArray *)images andButtonTitles:(NSArray *)titles andlineNum:(long)lineNum andTargert:(id)target andSEL:(SEL)sel andIsBackgoundImage:(BOOL)isBackgound;

@end
