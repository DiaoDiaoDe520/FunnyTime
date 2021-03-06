//
//  Item.m
//  FunLive
//
//  Created by qf1 on 15/12/13.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "Item.h"

#import <objc/runtime.h>

@implementation Item

// 用字典数据初始化一个dataModel对象
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        NSArray * arr = [Item getPropertyName];
        for (int i = 0;  i < arr.count; i ++) {
//            特殊的属性赋值
            if ([arr[i] isEqualToString:@"recommend"]) {
                self.recommend = [[Recommend alloc] initWithDic:dic[@"recommend"]];
                continue;
            }
            
            [self setValue:dic[arr[i]] forKey:arr[i]];
        }
    }
    return self;
}


// 用类方法的字典数据初始化一个dataModel对象
+ (instancetype) myDataModelWithDictionary:(NSDictionary *)dic {
    return [[Item alloc] initWithDic:dic];
}


+ (NSArray *) myDataModelWithArray:(NSArray *)array {
    
    NSMutableArray * marr = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL *stop) {
        
        [marr addObject:[Item myDataModelWithDictionary:dic]];
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
