//
//  FourViewController.m
//  FramePackaging
//
//  Created by qf1 on 15/12/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SecondWebVC.h"
@interface SecondWebVC ()

@end

@implementation SecondWebVC

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
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT+30)];
    self.webView.scrollView.bounces = NO;
    
    [self.view addSubview:self.webView];
    
    //    设置分割线
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    
}

- (void)setWebHTMLStr:(NSString *)htmlStr {
    
    
    NSURLRequest *re = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:htmlStr]];
    
    [self.webView loadRequest:re];
    

}

-(void)clickLeftButton {

    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)viewWillAppear:(BOOL)animated {
    
    MyTabBarController *tabVC = [MyTabBarController shareTabController];
    tabVC.bgImageView.alpha = 0;
    
}



//移除webView
- (void)viewWillDisappear:(BOOL)animated {

    [self.webView removeFromSuperview];
    self.webView = nil;

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
