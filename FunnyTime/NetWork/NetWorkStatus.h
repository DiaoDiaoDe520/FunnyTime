//
//  NetWorkStatus.h
//  MyLoveFreeProgram
//
//  Created by qf1 on 15/12/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    NetworkReachabilityStatusUnknown = -1,
    NetworkReachabilityStatusNotReachable,
    NetworkReachabilityStatusReachableViaWWAN,
    NetworkReachabilityStatusReachableViaWiFi
    
}ENUM_status;
@interface NetWorkStatus : NSObject

@property (nonatomic,assign) NSInteger status;

@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;

@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *cityId;

@property (nonatomic,strong) NSArray *localArr;

/**  单例  */
+ (NetWorkStatus *)NetWorkStatusDefault;

/** 判断网络状态 */
-(void)startNetWorkStateMonitor;

/** 获取当前网络是否可以进行网络数据下载 */
-(BOOL)getNetWorkState;

@end
