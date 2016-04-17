//
//  FinshViewController.h
//  FunnyTime
//
//  Created by qf1 on 15/12/19.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "Common.h"

@interface secondDetailViewController : Common
//防止tabBar显示出来
@property (nonatomic,assign) BOOL isShowTabBar;
- (void)getDataFormNet:(NSString *)urlStr;

// 屏幕适配
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@end
