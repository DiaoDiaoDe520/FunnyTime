//
//  Item.h
//  FunLive
//
//  Created by qf1 on 15/12/13.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recommend.h"
@interface Item : NSObject
@property (nonatomic,copy) NSString *label;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,strong) Recommend *recommend;

/** 用字典数据初始化一个dataModel对象 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/** 用类方法的字典数据初始化一个dataModel对象 */
+ (instancetype) myDataModelWithDictionary:(NSDictionary *)dic;

/** 用数组来生成模型数组返回 */
+ (NSArray *) myDataModelWithArray:(NSArray *)array;

@end
