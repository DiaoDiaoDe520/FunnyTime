//
//  ThirdWebViewController.h
//  FunnyTime
//
//  Created by qf1 on 16/1/8.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "Common.h"

@interface ThirdWebViewController : Common

- (void)getDataFormNetWith:(NSString *)urlStr;
- (void)setWebHTMLStr:(NSMutableString *)htmlStr;
@end
