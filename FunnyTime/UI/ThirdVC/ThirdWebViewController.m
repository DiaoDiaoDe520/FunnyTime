//
//  FourViewController.m
//  FramePackaging
//
//  Created by qf1 on 15/12/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ThirdWebViewController.h"

@interface ThirdWebViewController ()

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic,strong) NSString *shareUrl;
@property (nonatomic,strong) NSString *shortTitle;

@end

@implementation ThirdWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createMainUI];
}

#pragma mark - 创建主UI
- (void)createMainUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@"arrow180-1.png"] andNomalImage:[UIImage imageNamed:@""] andTitle:@"" andTitleColor:[UIColor blueColor]];
    [self.navigationBar setLeftBarButtonSize:CGSizeMake(45, 24)];
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.backgroundColor = [UIColor colorWithRed:158/256.0 green:189/256.0 blue:96/256.0 alpha:0.25];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT+10)];
    self.webView.scrollView.bounces = NO;
    
    [self.view addSubview:self.webView];
    
    //    设置分割线
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    
}

- (void)setWebHTMLStr:(NSString *)htmlStr {
    
    
//    NSURLRequest *re = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:htmlStr]];
//    
//    [self.webView loadRequest:re];
    
    [self.webView loadHTMLString:htmlStr baseURL:nil];
    
    
}

- (void)getDataFormNetWith:(NSString *)urlStr {
    
    self.manager = [AFHTTPSessionManager manager];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak ThirdWebViewController *weakSelf = self;
    [self.manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *urldic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *tempDic = urldic[@"data"];
        
        NSMutableString *mHtmlStr = [[NSMutableString alloc] initWithString:tempDic[@"content_html"]];
        NSString *tempStr = tempDic[@"short_title"];
        weakSelf.shortTitle = tempDic[@"title"];
        weakSelf.shareUrl = tempDic[@"content_url"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [mHtmlStr replaceOccurrencesOfString:@"<span>查看详情</span>" withString:tempStr options:NSCaseInsensitiveSearch range: NSMakeRange(0, mHtmlStr.length)];
            
            [mHtmlStr replaceOccurrencesOfString:@"href=\"http://guozhoumo" withString:@"" options:NSCaseInsensitiveSearch range: NSMakeRange(0, mHtmlStr.length)];
            
            
            
            
            [self setWebHTMLStr:mHtmlStr];
        });
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];


}


-(void)clickLeftButton {
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)viewWillAppear:(BOOL)animated {
    MyTabBarController *tabVC = [MyTabBarController shareTabController];
    tabVC.bgImageView.alpha = 0;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    MyTabBarController *tabVC = [MyTabBarController shareTabController];
    tabVC.bgImageView.alpha = 1;
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
