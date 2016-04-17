//
//  WelcomePage.m
//  启动视图UIScrollView的展示
//
//  Created by qf1 on 15/11/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WelcomePage.h"
#import "MyTabBarController.h"
#import "AppDelegate.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface WelcomePage ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIPageControl * pageControl;

@property (nonatomic,strong) UIScrollView *scrolView;
@end

@implementation WelcomePage

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        
        [self creatWellcomScrollView:array];
        
        [self creatPageControl:array];
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

//回主界面
- (void)backMainViewController:(id)type {
    
    MyTabBarController * tabBar = [[MyTabBarController alloc] init];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    delegate.window.rootViewController = tabBar;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"Next" forKey:@"onceTime"];
    [user synchronize];
    
}

- (void)creatWellcomScrollView:(NSArray *)pictureArr {
    
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.tag = 100;
    
    scrollView.tag = 10;
    
    scrollView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*pictureArr.count, SCREEN_HEIGHT);
    
    scrollView.bounces = NO;
    //    分页功能 默认设置为 NO
    scrollView.pagingEnabled = YES;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //   contentOffset 是根据contentSize来计算的
    scrollView.contentOffset = CGPointMake(0,0);
    
    //    添加滚动页的视图
    for (int i = 0; i < pictureArr.count; i++) {
        
        UIImageView * imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageVIew.image = [UIImage imageNamed: pictureArr[i]];
        
        if (i == pictureArr.count - 1 || i == 0) {
            imageVIew.userInteractionEnabled = YES;
            
            UIButton *myButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT - 95, 100, 40)];
            myButton.tag = i;
            myButton.backgroundColor = [UIColor clearColor];
            [myButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [myButton addTarget:self action:@selector(backMainViewController:)
             forControlEvents:UIControlEventTouchUpInside];
            [myButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.view addSubview:myButton];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backMainViewController:)];
             [imageVIew addGestureRecognizer:tap];
            
            UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backMainViewController:)];
            swipe.direction = UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
            [imageVIew addGestureRecognizer:swipe];
            
        }
        
        [scrollView addSubview:imageVIew];
        
        scrollView.delegate = self;
    }
    
}

//  结束滚动时候调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
}

//  结束拖拽的时候调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
    
}



- (void)creatPageControl:(NSArray *)arr {
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2,SCREEN_HEIGHT-80, 120, 60)];
    
    self.pageControl.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.pageControl];
    
    self.pageControl.numberOfPages = arr.count;
    
    self.pageControl.currentPage = 0;
    
    //    点的颜色
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    //    选中点的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    //    背景颜色
    self.pageControl.backgroundColor = [UIColor clearColor];
    
    [self.pageControl addTarget:self action:@selector(clickPageIndicator:) forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)clickPageIndicator:(UIPageControl *)pageControl {
    
    UIScrollView * scrol = (UIScrollView *)[self.view viewWithTag:10];
    
    //    动画
    [scrol scrollRectToVisible:CGRectMake(SCREEN_WIDTH*pageControl.currentPage, 0, SCREEN_WIDTH, SCREEN_HEIGHT) animated:YES];
    
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
