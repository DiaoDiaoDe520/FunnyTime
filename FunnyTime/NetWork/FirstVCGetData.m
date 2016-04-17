//
//  FirstVCGetData.m
//  FunnyTime
//
//  Created by qf1 on 15/12/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "FirstVCGetData.h"
#import "EGOCache.h"
@interface FirstVCGetData ()

@end

@implementation FirstVCGetData

// **  获取显示数据的类方法 */
- (void)getDataFirstVCWithURL:(NSString *)urlString andMesBlock:(void(^)(NSArray *))mesBlock{
    
    self.mesBlock = mesBlock;
    
    self.sessionManager = [AFHTTPSessionManager manager];
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __weak FirstVCGetData *weakFirstData = self;
    
    [self.sessionManager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [[EGOCache globalCache] setPlist:responseObject forKey:@"firstVCData"];
        
        NSArray *dataArr = urlDic[@"data"][@"list"];
        if (urlDic != nil || dataArr.count != 0) {
            
            NSArray *modelArr = [APPDataModel myDataModelWithArray:dataArr];
            weakFirstData.mesBlock(modelArr);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FirstData数据获取错误:%@",error);
    }];
    
}

// ** 获取城市信息的类方法  */
- (void)getCityDataWithURL:(NSString *)urlString andCityBlock:(void(^)(NSDictionary *))cityBlock {
    self.sessionManager = [AFHTTPSessionManager manager];
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.cityBlock = cityBlock;
    __weak FirstVCGetData *weakFirstData = self;
    
    [self.sessionManager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        缓存
        [[EGOCache globalCache] setPlist:responseObject forKey:@"cityData"];
        
        if (urlDic != nil) {
            
            weakFirstData.cityBlock(urlDic[@"data"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FirstData获取city数据失败:%@",error);
    }];
    
}

- (void)secondVCGetButtonDataWithUrlStr:(NSString *)urlStr andReturn:(void(^)(NSArray *))block {
    
    self.sessionManager = [AFHTTPSessionManager manager];
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.mesBlock = block;
    __weak FirstVCGetData *weakSelf = self;
    [self.sessionManager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        缓存
        [[EGOCache globalCache] setPlist:responseObject forKey:@"secondbuttonData"];
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *tempArr = urlDic[@"data"][@"list"];
        weakSelf.mesBlock(tempArr);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)secondVCGetDetailDataWithUrlStr:(NSString *)urlStr andKey:key andFlash:(BOOL)isFlash andReturn:(void(^)(NSArray *,NSString *))block {
//    
    self.sessionManager = [AFHTTPSessionManager manager];
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.secondMesBlock = block;
    __weak FirstVCGetData *weakSelf = self;

    [self.sessionManager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (isFlash) { //  第一次加载保存
        [[EGOCache globalCache] setPlist:responseObject forKey:key];
        }
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSArray *tempArr = urlDic[@"data"][@"activities"];
        NSString *nextUrl = urlDic[@"data"][@"info"][@"next_url"];
//        [APPDataModel createModelWithDictionary:tempArr[3] modelName:@""];
        
        weakSelf.secondMesBlock(tempArr,nextUrl);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



@end
