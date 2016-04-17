//
//  DetailViewController.h
//  FunnyTime
//
//  Created by qf1 on 15/12/18.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "Common.h"
#import "IndexW2Model.h"
@interface DetailViewController : Common

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) APPDataModel *model;

//tableView
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
//scrollView
@property (nonatomic,strong) UIScrollView *myScrolView;
@property (nonatomic,strong) UIPageControl *pageControl;

// 屏幕适配
@property float autoSizeScaleX;
@property float autoSizeScaleY;

- (instancetype)initWithId:(NSString *)ID;
@end
