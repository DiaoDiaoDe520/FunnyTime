//
//  ThemeTableViewCell.h
//  FunnyTime
//
//  Created by qf1 on 15/12/23.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModelJS.h"
#import "ThemeViewController.h"

@interface ThemeTableViewCell : UITableViewCell


/** 设置themeCell */
- (void)setCellWithIndexW2Model:(ThemeModelJS *)model andtag:(int)tag andTargert:(ThemeViewController *)firstVC;




@end
