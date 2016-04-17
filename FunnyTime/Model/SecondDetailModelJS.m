//
//  SecondDetailModelJS.m
//  FunnyTime
//
//  Created by qf1 on 15/12/24.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "SecondDetailModelJS.h"

@implementation SecondDetailModelJS

+(JSONKeyMapper *)keyMapper {

    NSDictionary *dic = @{@"regionId":@"regionId",@"headImg":@"headImg",@"brief":@"brief",@"body":@"body",@"subtitle":@"subtitle",@"price":@"price",@"detail":@"detail",@"albums":@"albums",@"tickets":@"tickets",@"lngLatitude":@"lngLatitude",@"name":@"name",@"phone":@"phone",@"trafficInfo":@"trafficInfo",@"fav":@"fav",@"districtName":@"districtName",@"openinghours":@"openinghours",@"suggestTime":@"suggestTime"};
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}

@end
