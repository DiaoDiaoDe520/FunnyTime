//
//  ThemeTableViewCell.m
//  FunnyTime
//
//  Created by qf1 on 15/12/23.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "ThemeTableViewCell.h"

@interface ThemeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *whereLable;
@property (weak, nonatomic) IBOutlet UILabel *loveLable;
@property (weak, nonatomic) IBOutlet UIImageView *map;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;


@end


@implementation ThemeTableViewCell

- (void)setCellWithIndexW2Model:(ThemeModelJS *)model andtag:(int)tag andTargert:(ThemeViewController *)firstVC {
    
    
    NSString *headImageStr = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",model.headImg];
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"quesheng"]];
    
    self.titleLable.text = model.name;
    self.whereLable.text = model.address;
    self.loveLable.text = model.fav;
    self.map.userInteractionEnabled = YES;
    self.map.tag = tag + 400;
    
    [self.map setImage:[UIImage imageNamed:@"locationte.png"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:firstVC action:@selector(tapMapImage:)];
    [self.map addGestureRecognizer:tap];
    
    
    NSString *priceStr = [NSString stringWithFormat:@"¥ %@",model.price];
    if ([model.price isEqualToString:@"0"]) {
        priceStr = @"Free";
    }
    self.priceLable.text = priceStr;
    

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
