//
//  FinshViewController.m
//  FunnyTime
//
//  Created by qf1 on 15/12/19.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDKUI.h>

#import "FinshViewController.h"
#import "FinalModel.h"
#import "AppDelegate.h"
#import <math.h>
#import "EGOCache.h"




@interface FinshViewController ()

@property (nonatomic,strong) UIWebView *vewView;

@property (nonatomic,strong) NSURLSession *session;




#define CELL_HEIGHT (44*self.autoSizeScaleY)

@end


@implementation FinshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self creatUI];
    [self setControl];
    
  
}

#pragma mark - 创建UI
- (void)creatUI {

    
   [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    self.vewView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-19)];
    self.vewView.dataDetectorTypes = UIDataDetectorTypeAll;
//    self.vewView.scalesPageToFit = YES;
    self.vewView.backgroundColor = [UIColor colorWithRed:158/256.0 green:189/256.0 blue:96/256.0 alpha:1];
    
    [self.view addSubview:self.vewView];
    
}


- (void)setControl {
    
    UIButton *backButton = [QuickCreateView addButtonWithFrame:CGRectMake(12, 26, 60, 30) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"arrow180-1.png"] andSeletedImage:[UIImage imageNamed:@""] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(clickLeftButton) andAddToUIView:self.view];
    backButton.tag = 45;
    
    
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@""] andNomalImage:[UIImage imageNamed:@"arrow180-1.png"] andTitle:@"" andTitleColor:[UIColor colorWithRed:0.337 green:0.624 blue:0.906 alpha:1.000]];
    self.navigationBar.rightButton.frame = CGRectMake(CGRectGetMidX(self.navigationBar.rightButton.frame) -  18, 33, 24, 24);
    
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.navigationBar setRightBarButtonWithBackgoundImage:[UIImage imageNamed:@""] andNomalImage:[UIImage imageNamed:@"slike_1fav.png"] andTitle:@"" andTitleColor:nil];
    [self.navigationBar.rightButton setImage:[UIImage imageNamed:@"slike_2fav.png"] forState:UIControlStateSelected];
    [self.navigationBar.rightButton addTarget:self action:@selector(clickRighrButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //分享按钮
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(self.navigationBar.rightButton.frame.origin.x + 32, 33, 24, 24);
//    [button setImage:[UIImage imageNamed:@"shareimage.png"] forState:UIControlStateNormal];
//    [self.navigationBar addSubview:button];
//    
//    [button addTarget:self action:@selector(shareWithShareSDK) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)checkFav {

    
    if ([[EGOCache globalCache] hasCacheForKey:@"fav"]) {
        NSArray *finalModelArr = (NSArray *)[[EGOCache globalCache] plistForKey:@"fav"];
        
        NSArray *IDs = [finalModelArr valueForKey:@"id"];
        
        for (NSString *ID in IDs) {
            if ([self.final.id isEqualToString:ID]) {
                self.navigationBar.rightButton.selected = YES;
            }
        }
        
    }

}


- (void)clickLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

// 右边收藏按钮
- (void)clickRighrButton:(UIButton *)button {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    if (net.status != 0) {
        
    NSMutableArray *marr = [[NSMutableArray alloc] initWithCapacity:42];
    
    if ([[EGOCache globalCache] hasCacheForKey:@"fav"]) {
        NSArray *tempArr = (NSArray *)[[EGOCache globalCache] plistForKey:@"fav"];
        [marr addObjectsFromArray:tempArr];
        
    }
    
    self.final.myType = self.type;
    
    if (self.final != nil) {
        
        NSArray *arr = [FinalModel arrayOfDictionariesFromModels:@[self.final]];
        
        NSDictionary *modelDic = [arr firstObject];
        

    if (button.selected == NO) {
            [marr addObject:modelDic];
    }
    else {
        if (marr.count >= 1) {
        [marr removeObject:modelDic];
        }
    }
    
    }
    
    if (self.comefromsave == YES) {
        
        
        if (button.selected == YES) {
            [marr removeObject:self.dic];
        }
        else {
             [marr addObject:self.dic];
        }
    }
   

    
    [[EGOCache globalCache] setPlist:marr forKey:@"fav"];
    
    button.selected = !button.selected;
        
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络不可用，收藏失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
        }];
    
    }
    
}


#pragma mark - 分享
//- (void)shareWithShareSDK {
//
//    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"AppIcon76x76.png"]];
////    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"FunnyDay"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:self.shareUrlStr]
//                                          title:self.navigationBar.titleLable.text
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
//
//
//
//
//
//}



#pragma  mark - tableView的滚动代理

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (scrollView.contentOffset.y >= 10 || scrollView.contentOffset.y <= 135) {
//        self.navigationBar.alpha = (scrollView.contentOffset.y-10)/125.0;
//    }
//}




#pragma  mark -  获取去数据
- (void)getDataFormNet:(NSString *)urlStr {
    
    //    屏幕适配
    if(SCREEN_HEIGHT > 480){
        self.autoSizeScaleX = SCREEN_WIDTH/320;
        self.autoSizeScaleY = SCREEN_HEIGHT/568;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
    //    NSLog(@"%@",ID);
    self.session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    [request setHTTPMethod:@"GET"];
    
    __weak FinshViewController *weakSelf = self;
    
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        
        NSDictionary *tempDic = urlDic[@"data"];
        [mdic setValuesForKeysWithDictionary:tempDic];
        if (![tempDic.allKeys containsObject:@"id"]) {

            [mdic setValue:weakSelf.ID forKey:@"id"];
            
        }
      
        weakSelf.final = [[FinalModel alloc] initWithDictionary:mdic error:nil];
        
        if (weakSelf.final.id == nil) {
            weakSelf.final.id = weakSelf.ID;
        }
        
        
        NSString *contentHtmlStr = urlDic[@"data"][@"content"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentHtmlStr != nil) {
            [self checkFav];
            [self showWebWebView:contentHtmlStr];
            }
        });
        
    }];
    
    NSString *htmlStr = self.dic[@"content"];
    if (htmlStr != nil) {
        [self checkFav];
        [self showWebWebView:htmlStr];
    }
    
    
    
    [task resume];
}

- (void)showWebWebView:(NSString *)htmlStr {
    //        [weakSelf transTitleLable:weakSelf.final.label];
    self.navigationBar.titleLable.textColor = [UIColor blackColor];
    
    //        加载WebView内容
    NSString *contentHtmlStr = [NSString stringWithFormat:@"<head><style>img{max-width:300px !important;}</style></head>%@",htmlStr];
    
    [self.vewView loadHTMLString:contentHtmlStr baseURL:nil];

}


#pragma mark - tabbar的隐藏与显示
//tabbar收起
- (void)viewWillAppear:(BOOL)animated {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    if (net.status == 0) {
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络状态不可用" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        }];
    }
    
    MyTabBarController *tab = [MyTabBarController shareTabController];
    __weak MyTabBarController *weakTab = tab;
    [UIView animateWithDuration:0.65 animations:^{
        
        weakTab.bgImageView.alpha = 0;
    }];
}

//tabbar弹出
- (void)viewWillDisappear:(BOOL)animated {
//    判断tabBar是否需要弹起
    if (self.isShowTabBar) {
    MyTabBarController *tab = [MyTabBarController shareTabController];
    __weak MyTabBarController *weakTab = tab;
    
    [UIView animateWithDuration:0.65 animations:^{
        
        weakTab.bgImageView.alpha = 1;
        }];
    }
    
}

-(void)dealloc {
    //    移除视图
    [self.vewView removeFromSuperview];
    self.vewView = nil;
}


#pragma mark - webView

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [self.vewView stringByEvaluatingJavaScriptFromString:str];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
