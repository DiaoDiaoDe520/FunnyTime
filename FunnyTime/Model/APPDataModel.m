//
//  DataModel.m
//  NewAnalysisTest
//
//  Created by qf1 on 15/11/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "APPDataModel.h"
#import <objc/runtime.h>
@implementation APPDataModel

@synthesize ID = _id;

// 用字典数据初始化一个dataModel对象
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
//        初始化数组
        self.items = [NSMutableArray array];
        NSArray * arr = [APPDataModel getPropertyName];
        for (int i = 0;  i < arr.count; i ++) {
//            特殊的属性赋值
            if ([arr[i] isEqualToString:@"items"]) {
//                赋值成Iten对象
                [self.items addObject:[Item myDataModelWithArray:dic[arr[i]]]];
                continue;
            }
            else if ([arr[i] isEqualToString:@"imgs"]) {
//                赋值成图片数组
                self.imgs = dic[arr[i]];
                continue;
            }
//            普通属性赋值
            [self setValue:dic[arr[i]] forKey:arr[i]];
        }
    }
    return self;
}


// 用类方法的字典数据初始化一个dataModel对象
+ (instancetype) myDataModelWithDictionary:(NSDictionary *)dic {
    return [[APPDataModel alloc] initWithDic:dic];
}


+ (NSArray *) myDataModelWithArray:(NSArray *)array {
    
    NSMutableArray * marr = [NSMutableArray array];

    [array enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL *stop) {
        
        [marr addObject:[APPDataModel myDataModelWithDictionary:dic]];
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
