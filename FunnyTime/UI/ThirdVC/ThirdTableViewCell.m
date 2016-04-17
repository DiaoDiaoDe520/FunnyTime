//
//  ThirdTableViewCell.m
//  FunnyTime
//
//  Created by qf1 on 15/12/22.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "ThirdTableViewCell.h"

@interface ThirdTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *favLable;

@property (weak, nonatomic) IBOutlet UIView *blackView;

@end

@implementation ThirdTableViewCell



- (void)setCellWith:(ThirdModel *)model {
    self.backgroundColor = Theme_color;
    self.blackView.layer.cornerRadius = 10;
    self.blackView.clipsToBounds = YES;
    
    self.myImageView.layer.cornerRadius = 8;
    self.myImageView.clipsToBounds = YES;
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];
    
    self.titleLable.text = model.title;
    
    
    self.favLable.text = [NSString stringWithFormat:@"%@",model.likes_count];
    
    


   
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
