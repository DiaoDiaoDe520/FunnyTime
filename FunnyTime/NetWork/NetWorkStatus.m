//
//  NetWorkStatus.m
//  MyLoveFreeProgram
//
//  Created by qf1 on 15/12/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NetWorkStatus.h"
#import "AFNetworking.h"



static NetWorkStatus * networkstatus = nil;

@interface NetWorkStatus ()

@property (nonatomic,assign) BOOL isConnect;


@end

@implementation NetWorkStatus

- (instancetype)init
{
    if (networkstatus == nil) {
        networkstatus = [super init];
    }
    return networkstatus;
}


#pragma mark - 判断网络状态
-(void)startNetWorkStateMonitor{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"www.taobao.com"]];
    
    [manager.requestSerializer setValue:@"value" forHTTPHeaderField:@"key"];
    
    //调用reachability来判断网络是否可用
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            [NSThread mainThread];
            
            NSLog(@"目前网络不可用");
            self.status = NetworkReachabilityStatusNotReachable;
            self.isConnect = NO;
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            [NSThread mainThread];
            
            NSLog(@"当前是移动（3G）网络");
            self.status = NetworkReachabilityStatusReachableViaWWAN;
            self.isConnect = YES;
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            
            [NSThread mainThread];
            
            NSLog(@"当前是wifi网络");
            self.status = NetworkReachabilityStatusReachableViaWiFi;
            self.isConnect = YES;
        }
    }];
    
    //必须要把这个监听打开
    [manager.reachabilityManager startMonitoring];
}
#pragma mark - 返回是否可以网络获取数据
-(BOOL)getNetWorkState {
    return self.isConnect;
}

#pragma mark - 单例的设置
+ (NetWorkStatus *)NetWorkStatusDefault {
    
    if (networkstatus == nil) {
        networkstatus = [[NetWorkStatus alloc] init];
    }
    return networkstatus;
}

+ (instancetype)alloc {

    if (networkstatus == nil) {
        networkstatus = [super alloc];
    }
    return networkstatus;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (networkstatus == nil) {
        networkstatus = [super allocWithZone:zone];
    }
    return networkstatus;
}

-(id)copy {
    return networkstatus;
}


@end
