//
//  DetailModel.h
//  FunnyTime
//
//  Created by qf1 on 15/12/19.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
{
    NSString *_id;
}

@property (nonatomic,copy) NSString *headImg;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSNumber *modified;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSString *cityEnName;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSNumber *type;
@property (nonatomic,copy) NSString *items;
@property (nonatomic,copy) NSNumber *fav;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSNumber *isTop;
@property (nonatomic,copy) NSNumber *cityId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *sname;

@end
