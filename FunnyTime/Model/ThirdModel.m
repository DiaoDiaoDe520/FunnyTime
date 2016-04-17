//
//  ThirdModel.m
//  FunnyTime
//
//  Created by qf1 on 16/1/8.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "ThirdModel.h"

@implementation ThirdModel

@synthesize ID = _id;

// 用字典数据初始化一个dataModel对象
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    

}




+ (NSArray *) myDataModelWithArray:(NSArray *)array {
    
    NSMutableArray * marr = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL *stop) {
        ThirdModel *model = [[ThirdModel alloc] initWithDic:dic];
        [marr addObject:model];
    }];
    
    return marr;
}



@end
