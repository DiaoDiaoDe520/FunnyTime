//
//  FirstViewController.h
//  FramePackaging
//
//  Created by qf1 on 15/12/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface FirstViewController : Common

@property (nonatomic,strong) NSString *cityId;

- (void)clickDetailImage:(UITapGestureRecognizer *)tapGes;

- (void)turnToTheMapView:(UITapGestureRecognizer *)tap;
@end
