//
//  StarView.m
//  MyLoveFreeInTimeTest
//
//  Created by qf1 on 15/12/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "StarView.h"

@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 65, 23)];
    if (self) {
        [self setStarView];
    }
    return self;
}

- (void)setStarView {
    
   UIImageView * backView = [[UIImageView alloc]init];
    backView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    backView.backgroundColor = [UIColor clearColor];
    backView.image = [UIImage imageNamed:@"StarsBackground.png"];
    backView.userInteractionEnabled = NO;
    backView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:backView];
    
    self.myView = [[UIView alloc]initWithFrame:self.frame];
    self.myView.backgroundColor = [UIColor clearColor];
    self.myView.clipsToBounds = YES;
    
    [self addSubview:self.myView];
    
     UIImageView * topView = [[UIImageView alloc]init];
    topView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    topView.backgroundColor = [UIColor clearColor];
    topView.image = [UIImage imageNamed:@"StarsForeground"];
    topView.userInteractionEnabled = NO;
    topView.contentMode = UIViewContentModeScaleAspectFit;
    [self.myView addSubview:topView];
    
}

@end
