//
//  FirstTableViewCell.m
//  FunLive
//
//  Created by qf1 on 15/12/13.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "FirstTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstTableViewCell ()



@end


@implementation FirstTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatControl];
    }
    return self;
}

- (void)creatControl {
    
    self.myImageView = [[UIImageView alloc] init];
    [self addSubview:self.myImageView];
    
    self.placeImageView = [[UIImageView alloc] init];
    [self addSubview:self.placeImageView];
    
    self.collectImageView = [[UIImageView alloc] init];
    [self addSubview:self.collectImageView];
    
    self.titleLable = [[UILabel alloc] init];
    [self addSubview:self.titleLable];
    
    self.spaceLable = [[UILabel alloc] init];
    [self addSubview:self.spaceLable];
    
    self.collectLable = [[UILabel alloc] init];
    [self addSubview:self.collectLable];
    
}

- (void)setControlWithAppDataModel:(Item *)item andTag:(long)tag andTarget:(id)target {
    
    AppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
    CGFloat x = myDelegate.autoSizeScaleX;
    CGFloat y = myDelegate.autoSizeScaleY;
    
    NSString *strImageUrl = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",item.img];
    self.myImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 166*y);
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];
    
    
    self.placeImageView.frame = CGRectMake(10*x, 200*y, 30*x, 30*y);
    self.placeImageView.userInteractionEnabled = YES;
    self.placeImageView.tag = 700 + tag;
    
//    添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(turnToTheMapView:)];
    [self.placeImageView addGestureRecognizer:tap];
    
    [self.placeImageView setImage:[UIImage imageNamed:@"map_1"]];
    
    self.collectImageView.frame = CGRectMake(100*x, 200*y, 30*x, 30*y);
    [self.collectImageView setImage:[UIImage imageNamed:@"slike_1"]];
    
    self.spaceLable.frame = CGRectMake(40*x, 204*y, 64*x, 24*y);
    self.spaceLable.font = [UIFont systemFontOfSize:13];
    self.spaceLable.textColor = [UIColor lightGrayColor];
    
    
    self.collectLable.frame = CGRectMake(130*x, 204*y, 64*x, 24*y);
    self.collectLable.font = [UIFont systemFontOfSize:13];
    self.collectLable.textColor = [UIColor lightGrayColor];
    NSString *favStr = [NSString stringWithFormat:@"%@",[item.recommend valueForKey:@"fav"]];
    self.collectLable.text = favStr;
    
    self.titleLable.frame = CGRectMake(14*x, 180*y, SCREEN_WIDTH-30, 24);
    self.titleLable.font = [UIFont systemFontOfSize:15];
    self.titleLable.text = item.name;
    
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    CGFloat point_x = net.latitude;
    CGFloat point_y = net.longitude;
    
    Recommend *recommend = item.recommend;
    
    NSArray *latArr = recommend.lnglat;
    
    CGFloat point_x1 = [[latArr lastObject] floatValue];
    CGFloat point_y1 = [[latArr firstObject] floatValue];
    
//    计算距离
//    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude: point_y longitude: point_x];
//    
//    CLLocation *loc2 =[[CLLocation alloc] initWithLatitude: point_y1 longitude: point_x1];
//    
//    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
//    
    
    double distance = [FirstTableViewCell distanceBetweenOrderBy:point_x :point_x1 :point_y :point_y1];
    
    NSString *space = [NSString stringWithFormat:@"%.2fkm",distance/1000];
    
    if (distance/1000 >= 100) {
        space = [NSString stringWithFormat:@"%dkm",(int)distance/1000];
    }
    if (net.latitude == 0) {
        space = @"距离未知";
    }
    
    self.spaceLable.text = space;
    
}

+(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2{
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //km  返回
    //     return  distance*1000;
    //返回 m
    return   distance;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
