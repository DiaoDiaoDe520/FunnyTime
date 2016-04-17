//
//  CollectViewController.h
//  FunnyTime
//
//  Created by qf1 on 15/12/26.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectViewController : UIViewController
// 屏幕适配
@property float autoSizeScaleX;
@property float autoSizeScaleY;

- (void)getDataMethod:(NSString *)cityId;
@end
