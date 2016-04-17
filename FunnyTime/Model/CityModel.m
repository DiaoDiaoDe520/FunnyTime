//
//  CityModel.m
//  FunLive
//
//  Created by qf1 on 15/12/14.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "CityModel.h"
#import "Prosion.h"
#import "IndexWhatModel.h"
#import "IndexW2Model.h"
#import <objc/runtime.h>

@implementation CityModel


// 用字典数据初始化一个dataModel对象
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        NSArray * arr = [CityModel getPropertyName];
        
        for (int i = 0;  i < arr.count; i ++) {
            if ([arr[i] isEqualToString:@"openCity"]) {
                self.openCity = [[NSMutableArray alloc] initWithArray:[Prosion myDataModelWithDictionary:dic[arr[i]]]];
            }
            else if ([arr[i] isEqualToString:@"indexWhat"]) {
                self.indexWhat = [[NSMutableArray alloc] initWithArray:[IndexW2Model myDataModelWithArray:dic[arr[i]]]];
            }
            else if ([arr[i] isEqualToString:@"indexBanner"]) {
                self.indexBanner = [[NSMutableArray alloc] initWithArray:[IndexWhatModel myDataModelWithArray:dic[arr[i]]]];
            }
            else {
            [self setValue:dic[arr[i]] forKey:arr[i]];
            }
        }
    }
    return self;
}


// 用类方法的字典数据初始化一个dataModel对象
+ (instancetype) myDataModelWithDictionary:(NSDictionary *)dic {
    return [[CityModel alloc] initWithDic:dic];
}


+ (NSArray *) myDataModelWithArray:(NSArray *)array {
    
    NSMutableArray * marr = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL *stop) {
        
        [marr addObject:[CityModel myDataModelWithDictionary:dic]];
    }];
    
    return marr;
}


//获取propertyName的数组
+ (NSArray *)getPropertyName {
    
    NSMutableArray * marr = [[NSMutableArray alloc] init];
    unsigned int count;
    Ivar * ivar = class_copyIvarList(self, &count);
    
    for (int i = 0;  i < count; i ++) {
        const char * p;
        p = ivar_getName(ivar[i]);
        
        NSString * name = [NSString stringWithUTF8String:p+1];
        
        [marr addObject:name];
    }
    
    return marr;
    
}

//代码创建model类
+(void)createModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName
{
    printf("\n@interface %s :NSObject\n",modelName.UTF8String);
    for (NSString *key in dict) {
        NSString *type = ([dict[key] isKindOfClass:[NSNumber class]])?@"NSNumber":@"NSString";
        printf("@property (nonatomic,copy) %s *%s;\n",type.UTF8String,key.UTF8String);
    }
    printf("@end\n");
    
}



@end
