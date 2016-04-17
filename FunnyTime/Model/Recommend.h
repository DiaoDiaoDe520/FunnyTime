//
//  Calegaty.h
//  NewOne
//
//  Created by qf1 on 15/12/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recommend : NSObject
{
    NSString * _id;
}

@property (nonatomic,copy) NSNumber *expired;
@property (nonatomic,copy) NSArray *lnglat;
@property (nonatomic,copy) NSString *district;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *label;
@property (nonatomic,copy) NSNumber *fav;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *priceRange;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *startTime;


/** 用字典数据初始化一个dataModel对象 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/** 用类方法的字典数据初始化一个dataModel对象 */
+ (instancetype) myDataModelWithDictionary:(NSDictionary *)dic;

/** 用数组来生成模型数组返回 */
+ (NSArray *) myDataModelWithArray:(NSArray *)array;


@end
