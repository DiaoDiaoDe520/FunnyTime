//
//  SecondTableViewCell.h
//  FunnyTime
//
//  Created by qf1 on 15/12/27.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondDetaliData.h"
@interface SecondTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *starTime;


@property (weak, nonatomic) IBOutlet UILabel *adress;

@property (weak, nonatomic) IBOutlet UILabel *price;


@property (weak, nonatomic) IBOutlet UILabel *notitag;




- (void)setCellMessageWith:(SecondDetaliData *)detailModel;







@end
