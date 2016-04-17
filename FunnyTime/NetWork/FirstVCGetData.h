//
//  FirstVCGetData.h
//  FunnyTime
//
//  Created by qf1 on 15/12/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstVCGetData : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic,copy) void(^mesBlock)(NSArray *);
@property (nonatomic,copy) void(^secondMesBlock)(NSArray *,NSString *);
@property (nonatomic,copy) void(^cityBlock)(NSDictionary *);

// **  获取显示数据的类方法 */
- (void)getDataFirstVCWithURL:(NSString *)urlString andMesBlock:(void(^)(NSArray *))mesBlock;

// ** 获取城市信息的类方法  */
- (void)getCityDataWithURL:(NSString *)urlString andCityBlock:(void(^)(NSDictionary *))cityBlock;


// ** 获取第二个页面的详情方法；
- (void)secondVCGetDetailDataWithUrlStr:(NSString *)urlStr andKey:key andFlash:(BOOL)isFlash andReturn:(void(^)(NSArray *,NSString *))block;

// ** 获取第二个页面按钮的方法 */
- (void)secondVCGetButtonDataWithUrlStr:(NSString *)urlStr andReturn:(void(^)(NSArray *))block;

@end
