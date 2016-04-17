//
//  FinshViewController.h
//  FunnyTime
//
//  Created by qf1 on 15/12/19.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "Common.h"
#import "FinalModel.h"
@interface FinshViewController : Common
//防止tabBar显示出来
@property (nonatomic,assign) BOOL isShowTabBar;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) FinalModel *final;
@property (nonatomic,assign) BOOL comefromsave;
@property (nonatomic,strong) NSDictionary *dic;

@property (nonatomic,strong) NSString *shareUrlStr;

- (void)getDataFormNet:(NSString *)urlStr;
- (void)showWebWebView:(NSString *)htmlStr;
// 屏幕适配
@property float autoSizeScaleX;
@property float autoSizeScaleY;

@end
