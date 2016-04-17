//
//  City.h
//  FunLive
//
//  Created by qf1 on 15/12/14.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
{
    NSString * _id;
}

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *isHot;
@property (nonatomic,strong) NSString *city;

/** 用字典数据初始化一个dataModel对象 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/** 用类方法的字典数据初始化一个dataModel对象 */
+ (instancetype) myDataModelWithDictionary:(NSDictionary *)dic;

/** 用数组来生成模型数组返回 */
+ (NSArray *) myDataModelWithArray:(NSArray *)array;

//获取propertyName的数组 */
+ (NSArray *)getPropertyName;

/** 打印属性名的定义 */
+(void)createModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName;
@end
