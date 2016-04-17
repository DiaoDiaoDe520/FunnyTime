//
//  DataModel.h
//  NewAnalysisTest
//
//  Created by qf1 on 15/11/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//


#import "Item.h"
@interface APPDataModel : NSObject
{
    NSString * _id;
}

@property (nonatomic,copy) NSString *headImg;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *modified;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,strong) NSArray *imgs;
@property (nonatomic,copy) NSString *cityEnName;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,copy) NSString *fav;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *isTop;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *sname;


/** 用字典数据初始化一个dataModel对象 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/** 用类方法的字典/Users/qf1/Desktop/FunLive/FunLive/UI/FirstVC/ManyButton.h数据初始化一个dataModel对象 */
+ (instancetype) myDataModelWithDictionary:(NSDictionary *)dic;

/** 用数组来生成模型数组返回 */
+ (NSArray *) myDataModelWithArray:(NSArray *)array;

//获取propertyName的数组 */
+ (NSArray *)getPropertyName;

/** 打印属性名的定义 */
+(void)createModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName;

@end
