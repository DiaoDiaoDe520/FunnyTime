//
//  FinalModel.h
//  FunnyTime
//
//  Created by qf1 on 15/12/19.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface FinalModel : JSONModel
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString<Optional> *content;
@property (nonatomic,strong) NSString<Optional> *headImg;
@property (nonatomic,strong) NSString<Optional> *label;
@property (nonatomic,strong) NSString<Optional> *cityEnName;
@property (nonatomic,strong) NSString<Optional> *cityName;
@property (nonatomic,strong) NSString<Optional> *lead;
//@property (nonatomic,copy) NSString<Optional> *address;
@property (nonatomic,strong) NSString<Optional> *fav;
//@property (nonatomic,strong) NSString<Optional> *cityId;
@property (nonatomic,strong) NSArray<Optional> *lngLatitude;
@property (nonatomic,strong) NSString<Optional> *name;
@property (nonatomic,strong) NSDictionary<Optional> *contact;

@property (nonatomic,strong) NSString<Optional> *myType;

@end
