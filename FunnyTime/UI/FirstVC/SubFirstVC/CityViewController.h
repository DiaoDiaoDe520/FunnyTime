//
//  CityViewController.h
//  FunnyTime
//
//  Created by qf1 on 15/12/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityViewController : Common
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) CityModel *city;
@property (nonatomic,strong) NSString *titleLable;

//作为判断分组的数组
@property (nonatomic,strong) NSMutableArray *compareArr;

// 屏幕适配
@property float autoSizeScaleX;
@property float autoSizeScaleY;

- (void)saveData:(CityModel *)city;

@end
