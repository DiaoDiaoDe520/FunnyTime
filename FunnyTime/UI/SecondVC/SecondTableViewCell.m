//
//  SecondTableViewCell.m
//  FunnyTime
//
//  Created by qf1 on 15/12/27.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "SecondTableViewCell.h"

@implementation SecondTableViewCell

- (void)setCellMessageWith:(SecondDetaliData *)detailModel {
    NSDictionary *media = [detailModel.medias firstObject];
    
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:media[@"url"]] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];
    
    self.titleLable.text = detailModel.title;
    self.starTime.text = detailModel.time_str;
    
    self.adress.text = detailModel.address;
    self.price.text = detailModel.price;
    
    self.notitag.text = detailModel.tag;

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
