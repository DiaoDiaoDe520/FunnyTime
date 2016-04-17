//
//  FirstTableViewCell.h
//  FunLive
//
//  Created by qf1 on 15/12/13.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface FirstTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *myImageView;
@property (nonatomic,strong) UIImageView *placeImageView;
@property (nonatomic,strong) UIImageView *collectImageView;

@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *spaceLable;
@property (nonatomic,strong) UILabel *collectLable;

/** Cell赋值 */
- (void)setControlWithAppDataModel:(Item *)item andTag:(long)tag andTarget:(id)target;
@end
