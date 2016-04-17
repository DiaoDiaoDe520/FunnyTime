//
//  NaviViewController.h
//  MovieProgram
//
//  Created by qf1 on 15/11/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavagationBarView.h"
@interface Common : UIViewController
@property (nonatomic,strong)  NavagationBarView * navigationBar;

/** 设置title的方法 */
- (void)transTitleLable:(NSString *)string;
@end
