//
//  MovieViewController.h
//  FunnyTime
//
//  Created by qf1 on 16/1/5.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "Common.h"
#import "SecondDetaliData.h"
@interface MovieViewController : Common
// 屏幕适配
@property float autoSizeScaleX;
@property float autoSizeScaleY;

@property (nonatomic,strong) NSString *shareUrl;
@property (nonatomic,strong) NSString *movieUrl;

- (void) setUIWithModel:(SecondDetaliData *)model;
@end
