//
//  SecondWebVC.h
//  FunnyTime
//
//  Created by qf1 on 15/12/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Common.h"

@interface SecondWebVC : Common

@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) NSString *shareUrl;
@property (nonatomic,strong) NSString *titleLable;
- (void)setWebHTMLStr:(NSString *)htmlStr;
@end
