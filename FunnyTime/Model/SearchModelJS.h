//
//  SearchModelJS.h
//  FunnyTime
//
//  Created by qf1 on 15/12/22.
//  Copyright © 2015年 qianfeng. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface SearchModelJS : NSObject

{
    NSString *_id;
}
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *score;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *headImg;
@property (nonatomic,strong) NSArray *lngLatitude;
@property (nonatomic,strong) NSString *district;

/** 用字典数据初始化一个dataModel对象 */
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
