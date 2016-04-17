//
//  FinshViewController.m
//  FunnyTime
//
//  Created by qf1 on 15/12/19.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "SubThirdViewController.h"
#import "AppDelegate.h"
#import <math.h>
@interface SubThirdViewController ()

@property (nonatomic,strong) UIWebView *vewView;

@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) PartyJSModel *final;
@property (nonatomic,strong) NSString *detailStr;
@property (nonatomic,strong) UIScrollView *scrolView;
#define CELL_HEIGHT (44*self.autoSizeScaleY)


@end


@implementation SubThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self setControl];
    
    
}

#pragma mark - 创建UI
- (void)creatUI {
    
    
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    
    self.vewView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    self.vewView.dataDetectorTypes = UIDataDetectorTypeAll;
    //    self.vewView.scalesPageToFit = YES;
    self.vewView.backgroundColor = [UIColor colorWithRed:158/256.0 green:189/256.0 blue:96/256.0 alpha:1];
    self.vewView.userInteractionEnabled = YES;
    [self.view addSubview:self.vewView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWebView)];
    [self.vewView addGestureRecognizer:tap];
    
    
    
//    scrolView
    self.scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake (SCREEN_WIDTH-120-20, 65, 130, 210)];
    self.scrolView.backgroundColor = [UIColor colorWithRed:158/256.0 green:189/256.0 blue:96/256.0 alpha:1];
    self.scrolView.layer.cornerRadius = 16;
    self.scrolView.hidden = YES;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(2, 0, self.scrolView.bounds.size.width, self.scrolView.bounds.size.height)];
    textView.editable = NO;
    textView.selectable = NO;
    textView.tag = 22;
    textView.backgroundColor = [UIColor clearColor];
    
    [self performSelector:@selector(setdetailMse) withObject:nil afterDelay:1.25];
    
    [self.scrolView addSubview:textView];
    [self.view addSubview:self.scrolView];
    
    
}
//赋值
- (void)setdetailMse {
    
    UITextView *text = (UITextView *)[self.scrolView viewWithTag:22];
    text.text = self.detailStr;

}


- (void)setControl {
    
    UIButton *backButton = [QuickCreateView addButtonWithFrame:CGRectMake(12, 26, 60, 30) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"arrow180-1.png"] andSeletedImage:[UIImage imageNamed:@""] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(clickLeftButton:) andAddToUIView:self.view];
    backButton.tag = 45;
    
    
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@""] andNomalImage:[UIImage imageNamed:@"arrow180-1.png"] andTitle:@"" andTitleColor:[UIColor colorWithRed:0.337 green:0.624 blue:0.906 alpha:1.000]];
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.navigationBar setRightBarButtonWithBackgoundImage:[UIImage imageNamed:@""] andNomalImage:[UIImage imageNamed:@"classification_2"] andTitle:@"" andTitleColor:[UIColor clearColor]];
    self.navigationBar.rightButton.selected = NO;
    [self.navigationBar.rightButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 点击WebView
- (void)tapWebView {

    self.scrolView.hidden = YES;
    self.navigationBar.rightButton.selected = NO;
}

//navigationBarButton
- (void)clickLeftButton:(UIButton *)button {
    
    if (button == self.navigationBar.rightButton ) {
        self.scrolView.hidden = button.selected;
        self.navigationBar.rightButton.selected = !button.selected;
        
    }
    else {
    [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma  mark -  获取去数据
- (void)getFinalDetailVCDataFormNet:(NSString *)urlStr {
    
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
    
    __weak SubThirdViewController *weakSelf = self;
    
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
       weakSelf.detailStr = urlDic[@"data"][@"fee"][@"detail"];
        
        
        //        加载WebView内容
        NSString *htmlStr = [NSString stringWithFormat:@"<head><style>img{max-width:%dpx !important;}</style></head>%@",(int)(SCREEN_WIDTH-10),urlDic[@"data"][@"content"]];
        
//        NSLog(@"%@",htmlStr);
        [weakSelf.vewView loadHTMLString:htmlStr baseURL:nil];
        
    }];
    
    [task resume];
}



#pragma mark - tabbar的隐藏与显示
//tabbar收起
- (void)viewWillAppear:(BOOL)animated {
    
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


#pragma mark - webView

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '60%'";
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
