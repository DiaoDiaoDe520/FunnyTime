//
//  SecondViewController.m
//  FramePackaging
//
//  Created by qf1 on 15/12/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SecondViewController.h"
#import "SecondDataModel.h"
#import "FirstVCGetData.h"
#import "SecondDetaliData.h"
#import "SecondTableViewCell.h"
#import "ManyButton.h"
#import "SecondWebVC.h"
#import "JHRefresh.h"
#import "MovieViewController.h"


@interface SecondViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) UISearchBar *searBar;
@property (nonatomic,strong) UIScrollView *buttonScrollView;
@property (nonatomic,strong) UIScrollView *myScrolView;
@property (nonatomic,strong) NSMutableArray *ButtonTitleArr;
@property (nonatomic,strong) NSString *nextUrl;

@property (nonatomic,strong) UIImageView *backgoundImageView;

//标志当前现实第几个tableVIew
@property (nonatomic,assign) int countTableView;
@property (nonatomic,strong) NSMutableArray *tableViewArray;
@property (nonatomic,strong) NSMutableArray *allDataArray;
@property (nonatomic,strong) NSMutableArray *buttonDictionAtt;

@property (nonatomic,strong) NSString *cityname;

@property (nonatomic,assign) int count;
@property (nonatomic,strong) FirstVCGetData *getData;

//标志需要重新请求数据
@property (nonatomic,assign) BOOL isFirstTime;

//下次刷新的url数组
@property (nonatomic,strong) NSMutableArray *urlArray;

#define CELL_HEIGHT (SCREEN_WIDTH/320)*360

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allDataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 6; i++) {
        NSMutableArray *marr = [NSMutableArray array];
        [self.allDataArray addObject:marr];
    }
    
    self.urlArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    self.buttonDictionAtt = [NSMutableArray array];
    self.tableViewArray = [NSMutableArray array];
    
    self.countTableView = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUI];
    

}

#pragma mark - 第一次获取数据
- (void)getFirstData {

    /*********************************************************/
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    NSString *chineseStr;
    if (self.cityname != nil) {
        chineseStr = [self.cityname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else {
        chineseStr = [net.cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    //    获取数据
    NSString *urlStr = [NSString stringWithFormat:@"http://act.myzaker.com/?c=activity_list&p=0&size=10&category=10000&_appid=iphone&_bsize=640_1136&_dev=iPhone%@2C9.2&_idfa=CDF6CC1A-DD2A-446A-8E3F-FEDF04F852A9&_mac=&_udid=86D02864-8E57-4E3B-88B7-2409B8A644BE&_uid=1051165&_utoken=zm8255f61b2768077d1451198476cf6d73&_v=2.0&_version=2.0&category=10000&city=%@&lat=%f&lng=%f",@"%",chineseStr,net.latitude,net.longitude];
    
    [self getSecondVCDataWithFirstUrl:urlStr andisfirst:YES];
    [self getDataWithCityName];

}

#pragma mark - 创建界面
- (void)creatUI {
    
    self.dataArray = [NSMutableArray array];
    self.ButtonTitleArr = [NSMutableArray array];
    self.count = 0;
    
    //    屏幕适配
    if(SCREEN_HEIGHT > 480){
        self.autoSizeScaleX = SCREEN_WIDTH/320;
        self.autoSizeScaleY = SCREEN_HEIGHT/568;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
    
    self.buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    self.buttonScrollView.showsHorizontalScrollIndicator = NO;
    self.buttonScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    self.buttonScrollView.contentOffset = CGPointMake(0, -20);
    
    [self.view addSubview:self.buttonScrollView];
    
    self.myScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-44)];
    
    self.myScrolView.contentSize = CGSizeMake(6*SCREEN_WIDTH, 0);
    self.myScrolView.backgroundColor = [UIColor whiteColor];
    self.myScrolView.pagingEnabled = YES;
    self.myScrolView.bounces = NO;
    self.myScrolView.showsHorizontalScrollIndicator = NO;
    self.myScrolView.delegate = self; // scrollView 代理
    
    [self.view addSubview:self.myScrolView];
    
    
//    searchBar
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    
    self.searBar = [[UISearchBar alloc] init];
    self.searBar.barStyle = UIBarStyleBlack;
    self.searBar.barTintColor = [UIColor whiteColor];
    self.searBar.frame = CGRectMake(10, 20, SCREEN_WIDTH-20, 44);
    self.searBar.placeholder = @"搜索城市";
    self.searBar.delegate = self;
    [self.navigationBar addSubview:self.searBar];
    
}
//


- (void)creatTableView {
    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,CGRectGetHeight(self.myScrolView.frame)) style:UITableViewStylePlain];
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] init];
    tableView1.tableFooterView = view;
    
    [self.myScrolView addSubview:tableView1];
    
//    切换tableView
    self.tableView = tableView1;
    [self.tableViewArray addObject:tableView1];
    
    __weak SecondViewController * weadSelf = self;
    
    
    // 下拉刷新效果
    [_tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class]beginRefresh:^{
        [weadSelf getSecondVCDataWithFirstUrl:weadSelf.nextUrl andisfirst:NO];
        [weadSelf performSelector:@selector(endRefreshHeaderView) withObject:nil afterDelay:0.25];
    }];
    
    
}

// 取消下拉刷新效果
- (void)endRefreshHeaderView {
    
    [self getSecondVCDataWithFirstUrl:self.urlArray[self.count] andisfirst:NO];
    [_tableView footerEndRefreshing];
}

//创建按钮
- (void)createButtonWithArray:(NSArray *)buttonTitles {

    self.buttonScrollView.contentSize = CGSizeMake((SCREEN_WIDTH/5)*buttonTitles.count, 0);
    
    for (UIView *v in self.buttonScrollView.subviews) {
        [v removeFromSuperview];
    }
    
    
    for (int i = 0;i < buttonTitles.count;i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((SCREEN_WIDTH/5)*i, -20, SCREEN_WIDTH/5, 44);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithRed:45/256.0 green:194/256.0 blue:186/256.0 alpha:1] forState:UIControlStateNormal];
        button.tag = i+ 200;
        button.selected = NO;
        [button addTarget:self action:@selector(clicktoolBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor clearColor];
        [self.buttonScrollView addSubview:button];
        self.buttonScrollView.contentOffset = CGPointMake((SCREEN_WIDTH/5)*(self.count), -20);
        
    }
    
    UIView *view = [QuickCreateView addViewWithFrame:CGRectMake(0, 22, SCREEN_WIDTH/5, 2) andBackgroundColor:[UIColor whiteColor] andAddToUIView:self.buttonScrollView];
    view.tag = 199;
    
    [QuickCreateView addViewWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/5 - 20, 2) andBackgroundColor:[UIColor colorWithRed:45/256.0 green:194/256.0 blue:186/256.0 alpha:1] andAddToUIView:view];
    
    
}

#pragma mark - 按钮的点击事件
- (void)clicktoolBarButton:(UIButton *)button {
    
    int tempCount = (int)button.tag - 200;
    
    __weak SecondViewController *weakSelf = self;
    
    UIView *tempview = [self.buttonScrollView viewWithTag:199];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        weakSelf.myScrolView.contentOffset = CGPointMake(SCREEN_WIDTH*(button.tag-200), 0);
        
        tempview.frame = CGRectMake((SCREEN_WIDTH/5)*(button.tag-200), 22, SCREEN_WIDTH/5, 2);
        
    }];
    
    
        self.count = tempCount;
        
        NSMutableArray *marr = (NSMutableArray *)self.allDataArray[tempCount];
        if (marr.count == 0) {
            
            NSArray *api_urls = [self.buttonDictionAtt valueForKey:@"api_url"];
            
            NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
            
//            城市名称编码
            NSString *chineseStr;
            if (self.cityname != nil) {
                chineseStr = [self.cityname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            else {
                chineseStr = [net.cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }

            NSArray *secondCategory = Second_Category;
            
            NSString *urlStr = [NSString stringWithFormat:@"%@&_appid=iphone&_bsize=640_1136&_dev=iPhone%@2C9.2&_idfa=CDF6CC1A-DD2A-446A-8E3F-FEDF04F852A9&_mac=&_udid=86D02864-8E57-4E3B-88B7-2409B8A644BE&_uid=1051165&_utoken=zm8255f61b2768077d1451198476cf6d73&_v=2.0&_version=2.0&category=%@&city=%@",api_urls[tempCount],@"%",secondCategory[tempCount],chineseStr];
            
            //
            self.tableView = self.tableViewArray[self.count-1];
            
            [self getSecondVCDataWithFirstUrl:urlStr andisfirst:NO];
        }
        else {
            self.dataArray = marr;
    }
}



#pragma mark - 设置tableView和scrollView
- (void)setUI {
    
    self.myScrolView.contentSize = CGSizeMake(SCREEN_WIDTH*self.buttonDictionAtt.count, 0);
    
    [self.tableViewArray removeAllObjects];
    for (int i = 2; i <= self.buttonDictionAtt.count; i++) {

        [self creatTableViewWith:i];
    }
}

- (void)creatTableViewWith:(int)i  {
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*(i-1), 0, SCREEN_WIDTH,CGRectGetHeight(self.myScrolView.frame)) style:UITableViewStylePlain];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    tempTableView.backgroundColor = [UIColor whiteColor];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    UIView *view = [[UIView alloc] init];
    tempTableView.tableFooterView = view;
    
    __weak SecondViewController *weakSelf = self;
    
    // 下拉刷新效果
    [tempTableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class]beginRefresh:^{
        [weakSelf getSecondVCDataWithFirstUrl:weakSelf.nextUrl andisfirst:NO];
        [weakSelf performSelector:@selector(endRefreshHeaderView) withObject:nil afterDelay:0.25];
    }];
    
    [self.myScrolView addSubview:tempTableView];
    [self.tableViewArray addObject:tempTableView];

}




#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SecondTableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:@"mySecondCell"];
    if (myCell == nil) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:@"SecondTableViewCell" owner:self options:nil] firstObject];
    }
    
    if (indexPath.row > self.dataArray.count) {
        return myCell;
    }
    
    if (self.dataArray.count > indexPath.row) {
    SecondDetaliData *secondModel = (SecondDetaliData *)self.dataArray[indexPath.row];
    [myCell setCellMessageWith:secondModel];
    
    
        if (self.dataArray.count >= 1) {
        NSDictionary *media = [secondModel.medias firstObject];
        [myCell.iconImage sd_setImageWithURL:[NSURL URLWithString:media[@"url"]] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];
        }
        else {
            [myCell.iconImage setImage:[UIImage imageNamed:@"quesheng.jpg"]];
        }
    }
    return myCell;
}

//跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.myScrolView.contentOffset = CGPointMake(self.myScrolView.frame.origin.x, -20);
    if (self.dataArray.count >= 1) {
    
    SecondDetaliData *model = (SecondDetaliData *)self.dataArray[indexPath.row];
       
        NSDictionary *tempDic = self.buttonDictionAtt[self.count];
        if ([tempDic[@"category"] isEqualToString:@"电影"]) {
            MovieViewController *movieVC = [[MovieViewController alloc] init];
            movieVC.shareUrl = model.share_url;
            movieVC.movieUrl = [model.trailers[0] valueForKey:@"trailerPath"];
            [movieVC setUIWithModel:model];
            [self.navigationController pushViewController:movieVC animated:YES];
            
        }
        else {
        
            SecondWebVC *web = [[SecondWebVC alloc] init];
            web.shareUrl = model.share_url;
            web.titleLable = model.title;
            [web setWebHTMLStr:model.web_url];
            
            [self.navigationController pushViewController:web animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }

}


#pragma mark - scrollView的代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    static int tempCount = 0;
    
    int screen_width = (int)SCREEN_WIDTH;
    int contentOffSet = (int)scrollView.contentOffset.x;
    int count = contentOffSet/SCREEN_WIDTH;
    
    if (scrollView == self.myScrolView) {
        if (contentOffSet%screen_width == 0) {
            
        if (count != tempCount) {
            
            tempCount = count;
            self.count = count;
            
            NSMutableArray *marr = (NSMutableArray *)self.allDataArray[count];
            if (marr.count == 0) {
            
            NSArray *api_urls = [self.buttonDictionAtt valueForKey:@"api_url"];
            
            NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
            
                NSString *chineseStr;
                if (self.cityname != nil) {
                    chineseStr = [self.cityname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
                else {
                    chineseStr = [net.cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }

            NSArray *secondCategory = Second_Category;
            
            NSString *urlStr = [NSString stringWithFormat:@"%@&_appid=iphone&_bsize=640_1136&_dev=iPhone%@2C9.2&_idfa=CDF6CC1A-DD2A-446A-8E3F-FEDF04F852A9&_mac=&_udid=86D02864-8E57-4E3B-88B7-2409B8A644BE&_uid=1051165&_utoken=zm8255f61b2768077d1451198476cf6d73&_v=2.0&_version=2.0&category=%@&city=%@",api_urls[count],@"%",secondCategory[count],chineseStr];
            

                if (self.tableViewArray.count > self.count)  {
                    if (self.count == 0) {
                        self.tableView = self.tableViewArray[0];
                    }
                    else {
                        self.tableView = self.tableViewArray[self.count-1];
                    }
                }
                else {
                    [self creatTableViewWith:self.count];
                     self.tableView = self.tableViewArray[self.count-1];
                }
                
 //        添加加载动画
                if (self.backgoundImageView == nil) {
                    self.backgoundImageView.userInteractionEnabled = YES;
                    self.backgoundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-49)];
                    self.backgoundImageView.backgroundColor = [UIColor whiteColor];
                    [self.backgoundImageView setImage:[UIImage imageNamed:@"fourpage-414w-736h@3x.jpg"]];
                    [self.view addSubview:self.backgoundImageView];
                    
                    UIActivityIndicatorView *action = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    action.frame = CGRectMake(0, 0, 60, 60);
                    action.center = CGPointMake(self.backgoundImageView.bounds.size.width/2, self.backgoundImageView.bounds.size.height/2 - 20);
                    [action startAnimating];
                    
                    action.layer.cornerRadius = 12;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapbackgoundImageView)];
                    [self.backgoundImageView addGestureRecognizer:tap];
                    
                    [self.backgoundImageView addSubview:action];
                }
                else {
                    [self.view bringSubviewToFront:self.backgoundImageView];
                }
            
            
            [self getSecondVCDataWithFirstUrl:urlStr andisfirst:NO];
            }
            else {
                [self.view sendSubviewToBack:self.backgoundImageView];

                self.dataArray = marr;
                }
            }
        }
        __weak SecondViewController *weakSelf = self;
        if (count > 4) {
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.buttonScrollView.contentOffset = CGPointMake((SCREEN_WIDTH/5)*(count - 4), -20);
            }];
        }
        else if (count == 0) {
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.buttonScrollView.contentOffset = CGPointMake(0, -20);
            }];

        }
        
        UIView *view = (UIView *)[self.buttonScrollView viewWithTag:199];
        
        [UIView animateWithDuration:0.25 animations:^{
            view.frame = CGRectMake((SCREEN_WIDTH/5)*count, 22, SCREEN_WIDTH/5, 2);
        }];
        
    }

}

// 加载蒙板的点击事件,不作任何操作
- (void)tapbackgoundImageView {
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    

}



#pragma mark - searchBar的代理方法
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = YES;
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.dataArray removeAllObjects];
    self.cityname = searchBar.text;
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    

        for (UIView *view in self.myScrolView.subviews) {
            [view removeFromSuperview];
        }
        self.tableViewArray = [NSMutableArray array];
        [self creatTableView];
        
        self.isFirstTime = YES;
        self.allDataArray = [NSMutableArray array];
        
        [self getFirstData];
        self.count = 0;
        if (self.tableViewArray.count >= self.count) {
            _tableView = self.tableViewArray[self.count];
            _myScrolView.contentOffset =CGPointMake(0, 0);
            
            
            self.allDataArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < 6; i++) {
                NSMutableArray *marr = [NSMutableArray array];
                [self.allDataArray addObject:marr];
            }
            
            self.urlArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
            
            self.buttonDictionAtt = [NSMutableArray array];
            
            self.countTableView = 0;
    
        self.isFirstTime = NO;
    }
  
}

//获取按钮标题数据
- (void)getDataWithCityName {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    if (net == 0) {
        
        if ([[EGOCache globalCache] hasCacheForKey:@"secondButtonArr"]) {
            
            NSArray *arr = (NSArray *)[[EGOCache globalCache] plistForKey:@"secondButtonArr"];
            
            [self.buttonDictionAtt addObjectsFromArray:arr];
            
            [self.allDataArray removeAllObjects];
            
            for (int i = 0; i < arr.count; i++) {
                NSMutableArray *marr = [NSMutableArray array];
                [self.allDataArray addObject:marr];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *title = [arr valueForKey:@"category"];
                [self createButtonWithArray:title];
                [self setUI];
            });

        }
        
        
        NSLog(@"当前网络不可用!");
    }
    else {
        
        NSString *chineseStr;
        if (self.cityname != nil) {
            chineseStr = [self.cityname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else {
            chineseStr = [net.cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }

        
        NSString *urlStr = [NSString stringWithFormat:@"http://act.myzaker.com/?c=category_list&_appid=iphone&_bsize=640_1136&_dev=iPhone%@2C9.2&_idfa=CDF6CC1A-DD2A-446A-8E3F-FEDF04F852A9&_mac=&_udid=86D02864-8E57-4E3B-88B7-2409B8A644BE&_uid=1051165&_utoken=zm8255f61b2768077d1451198476cf6d73&_v=2.0&_version=2.0&city=%@",@"%",chineseStr];
        
        
        if (self.getData == nil) {
            self.getData = [[FirstVCGetData alloc] init];
        }

        __weak SecondViewController *weakSelf = self;
        [self.getData secondVCGetButtonDataWithUrlStr:urlStr andReturn:^(NSArray *arr) {
            
            [[EGOCache globalCache] setPlist:arr forKey:@"secondButtonArr"];
            
            [weakSelf.buttonDictionAtt addObjectsFromArray:arr];
            
            [weakSelf.allDataArray removeAllObjects];
            
            for (int i = 0; i < arr.count; i++) {
                NSMutableArray *marr = [NSMutableArray array];
                [weakSelf.allDataArray addObject:marr];
            }
            
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *title = [arr valueForKey:@"category"];
            [self createButtonWithArray:title];
            [self setUI];
        });
       
        }];
        
    }
    
}

//获取第二页面显示数据
- (void)getSecondVCDataWithFirstUrl:(NSString *)firstUrl andisfirst:(BOOL)isFirst {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
     NSString *key = [NSString stringWithFormat:@"secondVCDataObject%d",self.count];
    if (self.isFirstTime == NO) {
        
    if ([[EGOCache globalCache] hasCacheForKey:key]) {
        id dataObject = [[EGOCache globalCache] plistForKey:key];
        if (self.dataArray.count >= 1) {
        [self.dataArray removeAllObjects];
        }
        
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:dataObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *tempArr = urlDic[@"data"][@"activities"];
        NSString *nextUrl = urlDic[@"data"][@"info"][@"next_url"];
        
        NSArray *secondDetail = [SecondDetaliData arrayOfModelsFromDictionaries:tempArr];
        
        [self.dataArray addObjectsFromArray:secondDetail];
        self.nextUrl = nextUrl;
        
            //            刷新界面
            [self.tableView reloadData];
            }
        }
    
    if (net.status != 0) {
        
//   判获取数据的对象是否为空
    if (self.getData == nil) {
        self.getData = [[FirstVCGetData alloc] init];
    }
        
    [self.getData secondVCGetDetailDataWithUrlStr:firstUrl andKey:key andFlash:isFirst andReturn:^(NSArray *arr,NSString *nextUrlStr) {
       
        NSArray *secondDetail = [SecondDetaliData arrayOfModelsFromDictionaries:arr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:secondDetail];
            if (self.allDataArray.count <= self.count) {
               
                [self.allDataArray addObjectsFromArray:marr];
            
            }
            else {
                NSMutableArray *tempArr = (NSMutableArray *)self.allDataArray[self.count];
                if (isFirst == NO) {
                    [tempArr addObjectsFromArray:marr];
                }
                else {
                    [tempArr removeAllObjects];
                    [tempArr addObjectsFromArray:marr];
                }
                
            }
            self.dataArray = self.allDataArray[self.count];
            
            [self.urlArray replaceObjectAtIndex:self.count withObject:nextUrlStr];
            
            self.nextUrl = nextUrlStr;
//            刷新界面
            if (self.dataArray != nil) {
                [self.view sendSubviewToBack:self.backgoundImageView];
            }
            else {
                [self.view bringSubviewToFront:self.backgoundImageView];
            }
            [self.tableView reloadData];
            
            
        });
    }];
    }
    else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络不可用" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{
        }];
    }
    
}

//中文转拼音
+(NSString *)tranChinese:(NSString *)chinese{
    int p = [chinese characterAtIndex:0];
    
    if (0x4e00 < p && p < 0x9fff) {
        
        CFStringRef cfstr = (__bridge CFStringRef)chinese;
        CFMutableStringRef mfstr = CFStringCreateMutableCopy(NULL, 0, cfstr);
        
        CFStringTransform(mfstr, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform(mfstr, 0, kCFStringTransformStripDiacritics, NO);
        
        NSMutableString * mstr = (__bridge NSMutableString *)mfstr;
        
        unichar ch;
        for (NSUInteger i = 0; i < [mstr length]; i++){
            ch = [mstr characterAtIndex:i];
            if (ch == ' ') {
                [mstr deleteCharactersInRange:NSMakeRange(i, 1)];
            }
        }
        return mstr;
    }
    return nil;
}


-(void)viewWillAppear:(BOOL)animated {
    
    MyTabBarController *tab = [MyTabBarController shareTabController];
    tab.bgImageView.alpha = 1;
    if (self.buttonScrollView != nil)
    self.buttonScrollView.contentOffset = CGPointMake(0, -20);
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    if (net.status == 0) {
        self.myScrolView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    }
    
//    清空上次保留的数据源
    if (self.dataArray != nil) {
        if (![net.cityName isEqualToString:self.cityname])
            [self.dataArray removeAllObjects];
        
//        添加加载动画
            if (self.backgoundImageView == nil) {
                self.backgoundImageView.userInteractionEnabled = YES;
                self.backgoundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-49)];
                self.backgoundImageView.backgroundColor = [UIColor whiteColor];
                [self.backgoundImageView setImage:[UIImage imageNamed:@"fourpage-414w-736h@3x.jpg"]];
                [self.view addSubview:self.backgoundImageView];
                
                UIActivityIndicatorView *action = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                action.frame = CGRectMake(0, 0, 60, 60);
                action.center = CGPointMake(self.backgoundImageView.bounds.size.width/2, self.backgoundImageView.bounds.size.height/2 - 20);
                [action startAnimating];
                action.layer.cornerRadius = 12;
                
//                点击事件，不作任何操作
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapbackgoundImageView)];
                [self.backgoundImageView addGestureRecognizer:tap];
                
                [self.backgoundImageView addSubview:action];
                
            }
            else {
                [self.view bringSubviewToFront:self.backgoundImageView];
            }
        }
    
    [self.tableView reloadData];
    
    
    
    if (![net.cityName isEqualToString:self.cityname] || self.cityname == nil) {
        self.cityname = net.cityName;
        
        for (UIView *view in self.myScrolView.subviews) {
            [view removeFromSuperview];
        }
        self.tableViewArray = [NSMutableArray array];
        [self creatTableView];

        self.isFirstTime = YES;
            self.allDataArray = [NSMutableArray array];
            
            [self getFirstData];
            self.count = 0;
        if (self.tableViewArray.count >= self.count) {
            _tableView = self.tableViewArray[self.count];
            _myScrolView.contentOffset =CGPointMake(0, 0);
            
            
            self.allDataArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < 6; i++) {
                NSMutableArray *marr = [NSMutableArray array];
                [self.allDataArray addObject:marr];
            }
            
            self.urlArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
            
            self.buttonDictionAtt = [NSMutableArray array];
            
            self.countTableView = 0;
            
    }
            self.cityname = net.cityName;
        
    }
    else {
        [self.view sendSubviewToBack:self.backgoundImageView];
        self.isFirstTime = NO;
    
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
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
