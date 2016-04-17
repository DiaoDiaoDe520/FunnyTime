//
//  FiveViewController.m
//  MyLoveFreeInTimeTest
//
//  Created by qf1 on 15/12/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "FirstViewController.h"
#import "JHRefresh.h"
#import "FirstVCGetData.h"
#import "FirstTableViewCell.h"
#import "ManyButton.h"
#import "DetailViewController.h"
#import "CityViewController.h"
#import "IndexWhatModel.h"
#import "IndexW2Model.h"
#import "FinshViewController.h"
#import "Recommend.h"
#import "SearchViewController.h"
#import "ThemeViewController.h"
#import "CollectViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "EGOCache.h"

#define CELL_HEIGHT (235*self.autoSizeScaleY)

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *localtionManager;

@property (nonatomic,strong) UIScrollView *backScrolView;

//tableView
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
//scrollView
@property (nonatomic,strong) UIScrollView *myScrolView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UISegmentedControl *seg;

@property (nonatomic,assign) long count;

@property (nonatomic,strong) CityModel *currentCity;
@property (nonatomic,strong) NSMutableArray *cityNameArr;
@property (nonatomic,strong)  UISearchBar * searchBar;
@property (nonatomic,strong) FirstVCGetData *firstVCGetData;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSString *pointStr;

@property (nonatomic,strong) CollectViewController *collectionVC;
@property (nonatomic,strong) NSTimer *quickTimer;


// 屏幕适配
@property float autoSizeScaleX;
@property float autoSizeScaleY;

@end

static dispatch_once_t oneTimeWarmming;

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self setBarButton];

    [self setMianTableView];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *cityId = [user objectForKey:@"cityid"];
    if (cityId == nil) {
        cityId = @"6270";
    }
    
    [self getDataFromNet:cityId andReflash:YES];
    
    [self getCityDataFromNetWithCityID:cityId];
    
    
//    定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.25 target:self selector:@selector(scrollviewAutoScroll) userInfo:nil repeats:YES];
    
    [self performSelector:@selector(late:) withObject:cityId afterDelay:3];
    
}

//获取城市列表 重新请求
- (void)late:(NSString *)cityid {
    
    if (self.cityNameArr.count == 0) {
        
        self.quickTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getCityDataFromNetWithCityID:) userInfo:cityid repeats:YES];
    }

}

#pragma - mark 定位功能
- (void)_startLocation {
    
    self.localtionManager = [[CLLocationManager alloc] init];
    self.localtionManager.delegate = self;
//    精确度为十米
    self.localtionManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.localtionManager requestAlwaysAuthorization];
    self.localtionManager.distanceFilter = 10.0f;
    
//    开始实时定位
    [self.localtionManager startUpdatingLocation];
    
}

#pragma mark - locationManager的代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D coordinate2D = newLocation.coordinate;
    
//    NSLog(@"%f-=-=-%f",coordinate2D.latitude,coordinate2D.longitude);

    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    net.latitude = coordinate2D.latitude;
    net.longitude = coordinate2D.longitude;
    
    [self.localtionManager stopUpdatingLocation];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *placemark in placemarks) {
            
            NSDictionary *location = [placemark addressDictionary];
//            NSLog(@"国家:%@",[location objectForKey:@"Country"]);
//            NSLog(@"城市:%@",[location objectForKey:@"State"]);
//            NSLog(@"区:%@",[location objectForKey:@"SubLocality"]);
//            
//            NSLog(@"位置:%@",placemark.name);
//            NSLog(@"国家:%@",placemark.country);
//            NSLog(@"城市:%@",placemark.locality);
//            NSLog(@"区:%@",placemark.thoroughfare);
//            NSLog(@"街道:%@",placemark.thoroughfare);
//            NSLog(@"子街道:%@",placemark.subThoroughfare);
            
            net.localArr = @[[NSString stringWithFormat:@"国家:%@",[location objectForKey:@"Country"]],[NSString stringWithFormat:@"城市:%@",[location objectForKey:@"State"]],[NSString stringWithFormat:@"区:%@",[location objectForKey:@"SubLocality"]],[NSString stringWithFormat:@"街道:%@",placemark.thoroughfare],[NSString stringWithFormat:@"具体位置:%@",placemark.subThoroughfare]];
            
            NSString *cityName = [placemark.locality substringToIndex:placemark.locality.length-1];
            net.cityId = self.cityId;
            
            if (![self.currentCity.cityName isEqualToString:cityName] && self.currentCity.cityName != nil) {
                
                //只执行一次
                
                dispatch_once(&oneTimeWarmming, ^{
                
            NSString *placeStr = [NSString stringWithFormat:@"当前城市为%@,是否切换至%@",cityName,placemark.locality];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            UIAlertController *aleat = [UIAlertController alertControllerWithTitle:@"提示" message:placeStr preferredStyle:UIAlertControllerStyleAlert];
            
                __weak FirstViewController *weakSelf = self;
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                for (NSDictionary *cityDic in weakSelf.cityNameArr) {
                    if ([cityName isEqualToString:cityDic[@"name"]]) {
//                        NSLog(@"%@",cityDic[@"id"]);
                        NSString *idstr = [NSString stringWithFormat:@"%@",cityDic[@"id"]];
//                        切换城市
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.count = 0;
                            [self getDataFromNet:idstr andReflash:YES];
                            [self getCityDataFromNetWithCityID:idstr];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"tranCity" object:idstr userInfo:@{@"city":cityName,@"cityid":idstr}];
                            
                            [self.collectionVC getDataMethod:idstr];
                            
                            net.cityName = cityName;
                            net.cityId = idstr;
                            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                            [user setObject:idstr forKey:@"cityid"];
                        });
                        
                        NSLog(@"切换成功");
                        break;
                    }
                }
   
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"取消！");
            }];
            [aleat addAction:action1];
            [aleat addAction:action2];
            
                [self presentViewController:aleat animated:YES completion:  ^{}];
                });
            });
            }
        }
    }];
    
}

/*********************************************************/
#pragma merk - 设置UI
- (void)setBarButton {
    
//    添加底部scrolView
    self.backScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height)];
    self.backScrolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backScrolView];
    self.backScrolView.pagingEnabled = YES;
    self.backScrolView.delegate = self;
    self.backScrolView.tag = 77;
    self.backScrolView.bounces = NO;
    self.backScrolView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    /*********************************************************/
    self.collectionVC = [[CollectViewController alloc] init];
    self.collectionVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.backScrolView addSubview:self.collectionVC.view];
    [self addChildViewController:self.collectionVC];
    
    /*********************************************************/
    
    
//    设置分割线
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
//    屏幕适配
    if(SCREEN_HEIGHT > 480){
        self.autoSizeScaleX = SCREEN_WIDTH/320;
         self.autoSizeScaleY = SCREEN_HEIGHT/568;
    }else{
        self.autoSizeScaleX = 1.0;
         self.autoSizeScaleY = 1.0;
    }
    
    
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@"fsyzm"] andNomalImage:[UIImage imageNamed:@"Type_Arrow_Black"] andTitle:@"城市" andTitleColor:[UIColor blackColor]];
    
    [self.navigationBar setLeftBarButtonImageEdge:UIEdgeInsetsMake(0, 0, 0, -70) andTitleEdge:UIEdgeInsetsMake(0, -26, 0, 0)];
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.navigationBar setRightBarButtonWithBackgoundImage:[UIImage imageNamed:@"search_1"] andNomalImage:[UIImage imageNamed:@""] andTitle:@"" andTitleColor:[UIColor blackColor]];
    self.navigationBar.rightButton.frame = CGRectMake(SCREEN_WIDTH-45, 25, 36*self.autoSizeScaleX, 36*self.autoSizeScaleY);
    [self.navigationBar.rightButton addTarget:self action:@selector(clickNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//    分段选择器
    self.seg = [[UISegmentedControl alloc] initWithItems:@[@"推荐",@"美辑"]];
    self.seg.backgroundColor = [UIColor whiteColor];
    self.seg.selectedSegmentIndex = 0;
    self.seg.frame = CGRectMake((SCREEN_WIDTH - 100)/2, 28, 100, self.seg.bounds.size.height);

    self.seg.tintColor = [UIColor blackColor];
    
    [self.navigationBar addSubview:self.seg];
    
    [self.seg addTarget:self action:@selector(segmenttedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - UISegmentedControl的值发生改变
- (void)segmenttedControlValueChanged:(UISegmentedControl *)segmentd {
    
    __weak FirstViewController *weakSelf = self;
    [UIView animateWithDuration:0.35 animations:^{
    weakSelf.backScrolView.contentOffset = CGPointMake(SCREEN_WIDTH*segmentd.selectedSegmentIndex, 0);
    }];
}


- (void)setMianTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化TableView的数据数组
    _dataArray = [NSMutableArray array];
    _cityNameArr = [NSMutableArray array];
    self.firstVCGetData = [[FirstVCGetData alloc] init];
    
    
    _count = 0;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-29) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.backgroundColor = Theme_color;
    
    UIImageView *myView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH    , (210 + 10)*self.autoSizeScaleY)];
    myView.backgroundColor = [UIColor whiteColor];
    myView.userInteractionEnabled = YES;
    myView.contentMode = UIViewContentModeScaleToFill;
    [myView setImage:[UIImage imageNamed:@"IMG_08m.png"]];
    
    myView.tag = 4;
    
//    主界面的滚动视图
    self.myScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130*self.autoSizeScaleY)];
    self.myScrolView.pagingEnabled = YES;
    self.myScrolView.delegate = self;
    self.myScrolView.tag = 74;
    self.myScrolView.showsHorizontalScrollIndicator = NO;
    self.myScrolView.showsVerticalScrollIndicator = NO;
    self.myScrolView.bounces = NO;
    
    //    设置pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100*self.autoSizeScaleY)/2, 103*self.autoSizeScaleY, 100*self.autoSizeScaleX, 22*self.autoSizeScaleY)];
    [self.myScrolView addSubview:self.pageControl];
    
    [myView addSubview:self.myScrolView];
    
    
//    多按钮View
    ManyButton *manyButton = [[ManyButton alloc] initWithFrame:CGRectMake(0, 130*self.autoSizeScaleY, SCREEN_WIDTH, 80*self.autoSizeScaleY)];
    [manyButton setManyButtonViewWithButtonImages:BUTTON_IMAGES andButtonTitles:BUTTON_TITLES andlineNum:4 andTargert:self andSEL:@selector(clickManyButton:) andIsBackgoundImage:NO];
    
    [myView addSubview:manyButton];
    [myView addSubview:self.pageControl];
    [myView bringSubviewToFront:self.pageControl];
    

    [self.tableView setTableHeaderView:myView];
    
    /*********************************************************/
    [self.backScrolView addSubview:_tableView];
    /*********************************************************/
    
    __weak FirstViewController * weadSelf = self;
    
    // 下拉刷新效果
    [_tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        
        [weadSelf performSelector:@selector(endRefreshHeaderView) withObject:nil afterDelay:0.125];
    }];
    
    // 上拉加载效果
    [_tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        [weadSelf performSelector:@selector(endRefreshFooderView) withObject:nil afterDelay:0.525];
    }];
    
}
// 取消下拉刷新效果
- (void)endRefreshHeaderView {
    
    [_tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
}
// 取消上拉加载效果
- (void)endRefreshFooderView {
    
    [_tableView footerEndRefreshing];
    
    [self getDataFromNet:self.cityId andReflash:NO];

}

//跳转去城市列表
- (void)clickNavigationBarButton:(UIButton *)button {
//     移除通知接收
    
        dispatch_once(&oneTimeWarmming, ^{
            //       把定位提示关闭
        });
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (button == self.navigationBar.leftButton) {
        
        CityViewController *cityline = [[CityViewController alloc] init];
        cityline.city = self.currentCity;
        [cityline saveData:self.currentCity];
        
        cityline.autoSizeScaleX = self.autoSizeScaleX;
        cityline.autoSizeScaleY = self.autoSizeScaleY;
        
        [self.navigationController pushViewController:cityline animated:YES];
        
    }
    else if (button == self.navigationBar.rightButton) {
    
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.cityId = self.cityId;
        [self.navigationController pushViewController:searchVC animated:YES];
    
    }

}

// 按钮的点击事件
- (void)clickManyButton:(UIButton *)button {

//    NSLog(@"%ld",(long)button.tag);
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    if (net.status == 0) {
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
    else {
    
    NSArray *titleArr = BUTTON_TITLES;
    ThemeViewController *themeVC = [[ThemeViewController alloc] initWithID:self.cityId];
        
        themeVC.navigationBar.titleLable.text = titleArr[button.tag - 10];
        themeVC.indexModels = [[NSMutableArray alloc] initWithArray:self.currentCity.indexWhat];

    [self.navigationController pushViewController:themeVC animated:YES];
        
        
        
    }
    
    
    
}

#pragma mark - scrolView的方法以及代理方法 

//添加ScrolView的图片
- (void)setScrolViewWithImage:(NSArray *)images {
    
    
    for (UIView *view in self.myScrolView.subviews) {
        [view removeFromSuperview];
    }
    
    
     NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:images];
    [marr addObject:[images firstObject]];
    [marr insertObject:[images lastObject] atIndex:0];
    
    self.myScrolView.contentSize = CGSizeMake(SCREEN_WIDTH*(marr.count), 0);
    self.myScrolView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    
    
    for (int i = 0; i < marr.count; i++) {
        
        UIImageView *scrolImage = [QuickCreateView addImageVierWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 130*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andBackgroundImage:[UIImage imageNamed:@""] andUsInterfaceEnable:YES andContextMode:UIViewContentModeScaleToFill andAddToUIView:self.myScrolView];
        scrolImage.tag = 100 + i;
        NSString *urlStr = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",marr[i]];
        [scrolImage sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScrolView:)];
        
        if (marr.count == 1) {
            self.myScrolView.contentSize = CGSizeMake(SCREEN_WIDTH, 130*self.autoSizeScaleY);
        }
        
        [self.myScrolView sendSubviewToBack:scrolImage];
        [scrolImage addGestureRecognizer:tap];
    }
    
    
    self.pageControl.numberOfPages = images.count;
    self.pageControl.currentPage = 0;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.backgroundColor = [UIColor clearColor];
    
    [self.pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];

}
//改变pageControl调用该方法
- (void)pageChange:(UIPageControl *)page {
    
    [self.timer invalidate];
    
    [self.myScrolView setContentOffset:CGPointMake((page.currentPage+1)*SCREEN_WIDTH, 0) animated:YES];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.25 target:self selector:@selector(scrollviewAutoScroll) userInfo:nil repeats:YES];
}


//点击scroView图片响应事件
- (void)clickScrolView:(UITapGestureRecognizer *)tap {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    if (net.status == 0) {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else {

    IndexWhatModel *model = (IndexWhatModel *)self.currentCity.indexBanner[tap.view.tag-101];
    
    DetailViewController *detailVC = [[DetailViewController alloc] initWithId:model.to];
    detailVC.autoSizeScaleX = self.autoSizeScaleX;
    detailVC.autoSizeScaleY = self.autoSizeScaleY;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    }

}
- (void)clickDetailImage:(UITapGestureRecognizer *)tapGes {

//    NSLog(@"%d",tapGes.view.tag);

}


#pragma mark - scrolView 代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    if (scrollView.tag == 74) {
    [self.timer invalidate];
    
    CGFloat x = self.myScrolView.contentOffset.x;
    
    if (x >= self.myScrolView.contentSize.width - SCREEN_WIDTH) {
        self.myScrolView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
    
    if (x < SCREEN_WIDTH) {
        self.myScrolView.contentOffset = CGPointMake(self.myScrolView.contentSize.width-(SCREEN_WIDTH)*2, 0);
    }
    
    self.pageControl.currentPage = x/SCREEN_WIDTH-1;
    
    if (x >= self.myScrolView.contentSize.width - SCREEN_WIDTH) {
        self.pageControl.currentPage = 0;
    }
    else if (x < SCREEN_WIDTH) {
        self.pageControl.currentPage = (self.myScrolView.contentSize.width- SCREEN_WIDTH)/SCREEN_WIDTH;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.25 target:self selector:@selector(scrollviewAutoScroll) userInfo:nil repeats:YES];
    }
    else {
        if (scrollView.contentOffset.x >= SCREEN_WIDTH) {
            self.seg.selectedSegmentIndex = 1;
        }
        else {
            self.seg.selectedSegmentIndex = 0;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.tag == 74) {
    [self.timer invalidate];
    }
    else {
    
    }
}

//scrolView正在滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 77) {
        self.navigationBar.leftButton.alpha = 1 - (self.backScrolView.contentOffset.x)/SCREEN_WIDTH;
        self.navigationBar.rightButton.alpha = 1 - (self.backScrolView.contentOffset.x)/SCREEN_WIDTH;
    }

}



//定时滚动
- (void)scrollviewAutoScroll {
    
    __weak FirstViewController *weakSelf = self;
    
    [UIView animateWithDuration:0.75 animations:^{
    
    weakSelf.myScrolView.contentOffset = CGPointMake(weakSelf.myScrolView.contentOffset.x + SCREEN_WIDTH, 0);
        
    } completion:^(BOOL finished) {
        
        
        CGFloat x = weakSelf.myScrolView.contentOffset.x;
        if (x >= weakSelf.myScrolView.contentSize.width - SCREEN_WIDTH) {
            
            weakSelf.myScrolView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }
        
        if (x < SCREEN_WIDTH) {
            
            weakSelf.myScrolView.contentOffset = CGPointMake(weakSelf.myScrolView.contentSize.width-(SCREEN_WIDTH)*2, 0);
            
        }
        
        weakSelf.pageControl.currentPage = x/SCREEN_WIDTH-1;
        
        if (x >= weakSelf.myScrolView.contentSize.width - SCREEN_WIDTH) {
            weakSelf.pageControl.currentPage = 0;
        }
        else if (x <= SCREEN_WIDTH) {
            weakSelf.pageControl.currentPage = (weakSelf.myScrolView.contentSize.width - SCREEN_WIDTH)/SCREEN_WIDTH;
        }
    }];
}


#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    APPDataModel *app = self.dataArray[section];
    NSArray *items = [app.items firstObject];
    
    return items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identify = @"limitCell";
    FirstTableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (myCell == nil) {
        myCell = [[FirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        myCell.myImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToFinalVC:)];
        [myCell.myImageView addGestureRecognizer:tap];
        
    }
    

//     防止没有数据导致越界
    if (self.dataArray.count != 0) {
    APPDataModel *app = self.dataArray[indexPath.section];
    NSArray *items = [app.items firstObject];
        
        Item *item = [items objectAtIndex:indexPath.row];
        
        myCell.myImageView.tag = 100*indexPath.section+indexPath.row;

    [myCell setControlWithAppDataModel:item andTag:indexPath.row andTarget:self];
    }
        
    return myCell;
}
// 当前选择的Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 79.0*self.autoSizeScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10*self.autoSizeScaleY;
}

// 设置分组标题头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.dataArray.count == 0) {
        return nil;
    }
    APPDataModel *app = (APPDataModel *)self.dataArray[section];
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*self.autoSizeScaleY , SCREEN_WIDTH, 69*self.autoSizeScaleY)];
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.frame = CGRectMake(0, 15, SCREEN_WIDTH, 20*self.autoSizeScaleY);
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:17];
    titleLable.text = app.name;
    [myView addSubview:titleLable];
//
    UILabel *subTitleLable = [[UILabel alloc] init];
    subTitleLable.frame = CGRectMake(0, 42, SCREEN_WIDTH, 20*self.autoSizeScaleY);
    subTitleLable.textAlignment = NSTextAlignmentCenter;
    subTitleLable.font = [UIFont systemFontOfSize:14];
    subTitleLable.textColor = [UIColor lightGrayColor];
    subTitleLable.text = app.subtitle;
    [myView addSubview:subTitleLable];
    
    myView.backgroundColor = [UIColor whiteColor];
    
//    添加分组隔栏
    
    [QuickCreateView addImageVierWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10*self.autoSizeScaleY) andBackgroundColor:Theme_color andBackgroundImage:[UIImage imageNamed:@""] andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill andAddToUIView:myView];
    
    return myView;

}

#pragma mark -  传递ID
- (void)goToFinalVC:(UITapGestureRecognizer *)tap {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
//    判断网络状态
    if (net.status == 0) {
        
        FinshViewController *finalVC = [[FinshViewController alloc] init];
        finalVC.isShowTabBar = YES;
        [self.navigationController pushViewController:finalVC animated:YES];
        NSLog(@"当前网络不可用!");
    }
    else {
    APPDataModel *app = self.dataArray[tap.view.tag/100];
    NSArray *items = [app.items firstObject];
    
    Item *item = [items objectAtIndex:tap.view.tag%100];
    Recommend *re = (Recommend *)item.recommend;
    
    FinshViewController *finalVC = [[FinshViewController alloc] init];
    finalVC.isShowTabBar = YES;
    
    
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:re.type];
    NSString *tempStr = [mstr capitalizedString];
        finalVC.type = tempStr;
        finalVC.comefromsave = NO;
        finalVC.ID = re.ID;
        
    NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/%@Detail?id=%@&uuid=77db2a8539c06750ca9c14d5ea441e2eb3dd5e1a",tempStr,re.ID];
        
        NSString *shareUrlStr = [NSString stringWithFormat:@"https://m.108tian.com/weekly/%@.html?version=4.3.4&hmsr=weixin_timeline&hmmd=iphoneApp_4.3.4&from=timeline&isappinstalled=1",re.ID];
        finalVC.shareUrlStr = shareUrlStr;

    [finalVC transTitleLable:app.subtitle];
    
    [finalVC getDataFormNet:urlStr];
    
    [self.navigationController pushViewController:finalVC animated:YES];
    }

}

#pragma  mark - 地图显示
- (void)turnToTheMapView:(UITapGestureRecognizer *)tap {

//
}


// firstVC获取数据的方法
- (void)getDataFromNet:(NSString *)ID andReflash:(BOOL)isReflash {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
//    取出缓存数据
//    static dispatch_once_t firstCarche;
//    dispatch_once(&firstCarche, ^{
    
    if (self.dataArray.count == 0) {
    
    if ([[EGOCache globalCache] hasCacheForKey:@"firstVCData"]) {
        
        id cacheData = [[EGOCache globalCache] plistForKey:@"firstVCData"];
    
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *dataArr = urlDic[@"data"][@"list"];
        if (urlDic != nil || dataArr.count != 0) {
            
            NSArray *modelArr = [APPDataModel myDataModelWithArray:dataArr];
            
            [self.dataArray addObjectsFromArray:modelArr];
            
                [self.tableView reloadData];
    
            }
        }
    }
//    });
    
    if (net.status == 0) {
        NSLog(@"当前网络不可用!");
    }
    else {
    
    if (isReflash) {
        [self.dataArray removeAllObjects];
    }
    
    NSString *url = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/RecommendDetailList?cityId=%@&step=2&page=%ld",ID,self.count++];
    
    __weak FirstViewController *weakSelf = self;
    [self.firstVCGetData getDataFirstVCWithURL:url andMesBlock:^(NSArray *arr) {
        [weakSelf.dataArray addObjectsFromArray:arr];
        
//        缓存数据
//        [[EGOCache globalCache] setPlist:arr forKey:@"firstVCData"];
        
        
        if (arr.count > 0) {
            
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        });
            
        }
    }];
    }
    
}

//获取城市列表，和当前选择城市的信息
- (void)getCityDataFromNetWithCityID:(NSString *)cityId {
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    if ([[EGOCache globalCache] hasCacheForKey:@"cityData"]) {
        id cityDataObject = [[EGOCache globalCache] plistForKey:@"cityData"];
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:cityDataObject options:NSJSONReadingMutableContainers error:nil];
        if (urlDic != nil) {
            
            self.currentCity = [CityModel myDataModelWithDictionary:urlDic];
            net.cityName = urlDic[@"data"][@"cityName"];
            
            [self.navigationBar.leftButton setTitle:self.currentCity.cityName forState:UIControlStateNormal];
            
            NSDictionary *dic = urlDic[@"data"];
            //        获取城市列表
            self.cityId = dic[@"cityId"];
            self.navigationBar.leftButton.titleLabel.text = dic[@"cityName"];
            
            NSDictionary *cityDic = dic[@"openCity"];
            for (NSString *proName in cityDic.allKeys) {
                
                NSArray *citys = cityDic[proName];
                [self.cityNameArr addObjectsFromArray:citys];
            }
            
            [self setScrolViewWithImage:[dic[@"indexBanner"] valueForKey:@"img"]];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:dic[@"cityId"] forKey:@"cityid"];
            
        }

    }
    
    if (net.status == 0) {
        NSLog(@"当前网络不可用!");
    }
    else {
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/Home?cityId=%@",cityId];
    __weak FirstViewController *weakSelf = self;
    [self.firstVCGetData getCityDataWithURL:urlStr andCityBlock:^(NSDictionary *dic) {
        weakSelf.currentCity = [CityModel myDataModelWithDictionary:dic];
        [weakSelf.navigationBar.leftButton setTitle:self.currentCity.cityName forState:UIControlStateNormal];
        
//        注销定时器
        [weakSelf.quickTimer invalidate];
        
//        获取城市列表
        weakSelf.cityId = dic[@"cityId"];
        weakSelf.navigationBar.leftButton.titleLabel.text = dic[@"cityName"];
        
        NSDictionary *cityDic = dic[@"openCity"];
        for (NSString *proName in cityDic.allKeys) {
            
            NSArray *citys = cityDic[proName];
            [weakSelf.cityNameArr addObjectsFromArray:citys];
        }
        
        
        [weakSelf setScrolViewWithImage:[weakSelf.currentCity.indexBanner valueForKey:@"img"]];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:dic[@"cityId"] forKey:@"cityid"];
        
    }];
    }

}

/*********************************************************/
#pragma mark - 跳转操作
// 通知反响传回参数
- (void)viewDidAppear:(BOOL)animated {
    
    [self.navigationBar.leftButton setTitle:self.currentCity.cityName forState:UIControlStateNormal];
    
}

// 加入通知
- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"tranCity" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
//    定位
    [self _startLocation];
    
    MyTabBarController *tab = [MyTabBarController shareTabController];
    tab.bgImageView.alpha = 1;
    
}

//更新信息，并且tableView回到表头
- (void)notificationAction:(NSNotification *)noti {
    
    self.count = 0;
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.cityId = noti.object;
    [self getDataFromNet:noti.object andReflash:YES];
    [self getCityDataFromNetWithCityID:noti.object];
    
    self.navigationBar.leftButton.titleLabel.text = noti.userInfo[@"city"];
    [self.collectionVC getDataMethod:noti.userInfo[@"cityid"]];

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
