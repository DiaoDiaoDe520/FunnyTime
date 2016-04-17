//
//  PartyJSModel.h
//  FunnyTime
//
//  Created by qf1 on 15/12/22.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface PartyJSModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *dest;
@property (nonatomic,copy) NSString<Optional> *name;
@property (nonatomic,copy) NSString<Optional> *expired;
@property (nonatomic,copy) NSString<Optional> *productExists;
@property (nonatomic,copy) NSArray<Optional> *priceRange;
@property (nonatomic,copy) NSString<Optional> *price;
@property (nonatomic,copy) NSString<Optional> *endTime;
@property (nonatomic,copy) NSString<Optional> *fav;
@property (nonatomic,copy) NSString<Optional> *duration;
@property (nonatomic,copy) NSString<Optional> *startTime;
@property (nonatomic,copy) NSArray<Optional> *lngLatitude;
@property (nonatomic,copy) NSString<Optional> *headImg;

@end
