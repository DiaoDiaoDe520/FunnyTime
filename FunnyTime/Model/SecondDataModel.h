//
//  SecondDataModel.h
//  FunnyTime
//
//  Created by qf1 on 15/12/27.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface SecondDataModel : JSONModel

@property (nonatomic,strong) NSString *pk;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *api_url;

@end
