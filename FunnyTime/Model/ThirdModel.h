//
//  ThirdModel.h
//  FunnyTime
//
//  Created by qf1 on 16/1/8.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdModel : NSObject
{
    NSNumber *_id;
}

@property (nonatomic,copy) NSNumber *ID;
@property (nonatomic,copy) NSString *share_msg;
@property (nonatomic,copy) NSString *labels;
@property (nonatomic,copy) NSString *short_title;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSNumber *liked;
@property (nonatomic,copy) NSNumber *published_at;
@property (nonatomic,copy) NSNumber *updated_at;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSNumber *created_at;
@property (nonatomic,copy) NSString *content_url;
@property (nonatomic,copy) NSString *cover_image_url;
@property (nonatomic,copy) NSNumber *status;
@property (nonatomic,copy) NSNumber *likes_count;


/** 用字典数据初始化一个dataModel对象 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/** 用数组来生成模型数组返回 */
+ (NSArray *) myDataModelWithArray:(NSArray *)array;

@end

