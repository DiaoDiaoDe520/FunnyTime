//
//  ThemeModelJS.h
//  FunnyTime
//
//  Created by qf1 on 15/12/23.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ThemeModelJS : JSONModel

@property (nonatomic,copy) NSString<Optional> *expired;
@property (nonatomic,copy) NSString<Optional> *address;
@property (nonatomic,copy) NSArray<Optional> *priceRange;
@property (nonatomic,copy) NSString<Optional> *productExists;
@property (nonatomic,copy) NSArray<Optional> *lngLatitude;
@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *price;
@property (nonatomic,copy) NSString<Optional> *district;
@property (nonatomic,copy) NSString<Optional> *headImg;
@property (nonatomic,copy) NSString<Optional> *fav;
@property (nonatomic,copy) NSString<Optional> *name;

@end
