//
//  SearchTableViewCell.m
//  FunnyTime
//
//  Created by qf1 on 15/12/22.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)setCellFromModel:(SearchModelJS *)model {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",model.headImg];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];
    
    self.nameLable.text = model.name;
//    self.subNameLable.text = model.district;
   
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
