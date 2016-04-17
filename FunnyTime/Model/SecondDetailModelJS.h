//
//  SecondDetailModelJS.h
//  FunnyTime
//
//  Created by qf1 on 15/12/24.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface SecondDetailModelJS : JSONModel

@property (nonatomic,strong) NSString<Optional> *regionId;
@property (nonatomic,strong) NSString<Optional> *headImg;
@property (nonatomic,strong) NSString<Optional> *brief;
@property (nonatomic,strong) NSArray<Optional> *body;
@property (nonatomic,strong) NSString<Optional> *subtitle;
@property (nonatomic,strong) NSString<Optional> *price;
@property (nonatomic,strong) NSString<Optional> *detail;
@property (nonatomic,strong) NSArray<Optional> *albums;
@property (nonatomic,strong) NSDictionary<Optional> *tickets;
@property (nonatomic,strong) NSArray<Optional> *lngLatitude;
@property (nonatomic,strong) NSString<Optional> *name;
@property (nonatomic,strong) NSString<Optional> *phone;
@property (nonatomic,strong) NSDictionary<Optional> *trafficInfo;
@property (nonatomic,strong) NSString<Optional> *fav;
@property (nonatomic,strong) NSString<Optional> *districtName;
@property (nonatomic,strong) NSDictionary<Optional> *openinghours;
@property (nonatomic,strong) NSString<Optional> *suggestTime;


@end
