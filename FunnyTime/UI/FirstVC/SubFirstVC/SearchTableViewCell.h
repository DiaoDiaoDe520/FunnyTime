//
//  SearchTableViewCell.h
//  FunnyTime
//
//  Created by qf1 on 15/12/22.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModelJS.h"
@interface SearchTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;


- (void)setCellFromModel:(SearchModelJS *)model;

@end
