//
//  AppDelegate.m
//  FunnyTime
//
//  Created by Even on 16/4/8.
//  Copyright © 2016年 Diaodiaode. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "WelcomePage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //    监听网络
    NetWorkStatus *network = [NetWorkStatus NetWorkStatusDefault];
    [network startNetWorkStateMonitor];
    
    //    分享
    //    [self shareWithShareSDK];
    
    
    
    //     屏幕适配
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if(SCREEN_HEIGHT > 480){
        
        myDelegate.autoSizeScaleX = SCREEN_WIDTH/320;
        
        myDelegate.autoSizeScaleY = SCREEN_HEIGHT/568;
        
    }else{
        
        myDelegate.autoSizeScaleX = 1.0;
        
        myDelegate.autoSizeScaleY = 1.0;
        
    }
    
    //
    // 延时执行
    [self performSelector:@selector(waittingJudgeNetworking) withObject:nil afterDelay:0.25];
    return YES;
}

#pragma mark - 欢迎页面
- (void)waittingJudgeNetworking {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"onceTime"];
    if (str == nil) {
        //
        
        WelcomePage *welcom = [[WelcomePage alloc] initWithArray:Welcome_PageArray];
        self.window.rootViewController = welcom;
    }
    else {
        //   设置tabBar的bar栏UI
        MyTabBarController * tabBar = [MyTabBarController shareTabController];
        self.window.rootViewController = tabBar;
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
