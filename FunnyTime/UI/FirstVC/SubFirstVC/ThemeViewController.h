//
//  SearchViewController.h
//  FunnyTime
//
//  Created by qf1 on 15/12/22.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexW2Model.h"
@interface ThemeViewController : Common
@property (nonatomic,assign) BOOL isShowTabBar;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSMutableArray *indexModels;
-(void)clickButton:(UIButton *)button;
- (instancetype)initWithID:(NSString *)cityID;

//cell的地图图片
- (void)tapMapImage:(UITapGestureRecognizer *)tap;
@end
