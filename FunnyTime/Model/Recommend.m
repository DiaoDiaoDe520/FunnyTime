//
//  Calegaty.m
//  NewOne
//
//  Created by qf1 on 15/12/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Recommend.h"

@implementation Recommend

@synthesize ID = _id;

/** 用字典数据初始化一个dataModel对象 */
- (instancetype)initWithDic:(NSDictionary *)dic {

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

/** 用类方法的字典数据初始化一个dataModel对象 */
+ (instancetype) myDataModelWithDictionary:(NSDictionary *)dic {
    return [[Recommend alloc] initWithDic:dic];
}

/** 用数组来生成模型数组返回 */
+ (NSArray *) myDataModelWithArray:(NSArray *)array {
    NSMutableArray * mArr = [NSMutableArray array];
    
    for (NSDictionary * d in array) {
        
        [mArr addObject:[[Recommend alloc] initWithDic:d]];
    }
    return mArr;
}



@end
