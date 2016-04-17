//
//  SearchViewController.m
//  FunnyTime
//
//  Created by qf1 on 15/12/22.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeModelJS.h"
#import "MyToolBar.h"
#import "ManyButton.h"
#import "ThemeModelJS.h"
#import "ThemeTableViewCell.h"
#import "JHRefresh.h"
#import "secondDetailViewController.h"
#import "FinshViewController.h"
#import "UIImage+GIF.h"



#define CELL_HEIGHT 220

@interface ThemeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,assign) int count;
@property (nonatomic,assign) BOOL oneceTap;

@property (nonatomic,strong) MyToolBar *toolBar;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,assign) IndexW2Model *curentModel;
@property (nonatomic,assign) int currentBackView;

@property (nonatomic,strong) UIButton *curentButton;

@property (nonatomic,strong) AFHTTPSessionManager *session;
@property (nonatomic,strong) UIImageView *loadImageView;

//当前主题
@property (nonatomic,strong) NSString *currentTheme;

@end

@implementation ThemeViewController


- (instancetype)initWithID:(NSString *)cityID 
{
    self = [super init];
    if (self) {
        self.cityId = cityID;
        NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/SceneList?cityId=%@&step=10&theme=0&page=0",cityID];
        [self getDataFromNet:urlStr];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    [self setControl];
    [self flashTableView];
    
}

- (void)setControl {
    self.currentTheme = @"0";
    self.oneceTap = YES;
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@""] andNomalImage:[UIImage imageNamed:@"arrow180-1.png"] andTitle:@"" andTitleColor:[UIColor colorWithRed:0.337 green:0.624 blue:0.906 alpha:1.000]];
    self.navigationBar.leftButton.selected = NO;
    
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationBar.titleLable.textColor = [UIColor blackColor];
    
    self.backView = [QuickCreateView addViewWithFrame:CGRectMake(0, 64+34, SCREEN_WIDTH, 0) andBackgroundColor:[UIColor whiteColor] andAddToUIView:self.view];
    self.backView.clipsToBounds = YES;
    
    
}

#pragma mark - 创建界面
- (void)creatUI {
    
    self.toolBar = [[MyToolBar alloc] initWithBackImage:[UIImage imageNamed:@""] andFirstButtonImage:[UIImage imageNamed:@"5u0Gme8kaQGOAzv.png"] andSecondButtonimage:[UIImage imageNamed:@"5u0Gme8kaQGOAzv.png"] andThreeButtonImage:[UIImage imageNamed:@"5u0Gme8kaQGOAzv.png"] andViewController:self];
    
    [self.view addSubview:self.toolBar];
    
    _dataArray = [NSMutableArray array];
    self.count = 0;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+34, SCREEN_WIDTH, SCREEN_HEIGHT-64-34) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    
//    创建蒙板
    self.loadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
    self.loadImageView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *loadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadView.center = CGPointMake(SCREEN_WIDTH/2, self.loadImageView.bounds.size.height/2-40);
    [self.loadImageView addSubview:loadView];
    
    
    NSString *name = @"jiazai.gif";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    loadView.image = [UIImage sd_animatedGIFWithData:imageData];
    
    [self.view addSubview:self.loadImageView];
    [self.view sendSubviewToBack:self.loadImageView];
    
    
    
}

#pragma mark - toolbar的按钮点击事件
-(void)clickButton:(UIButton *)button {
    
////    设置栏的backView显示隐藏
    for (UIView *buttonView in self.toolBar.subviews) {
        UIView *tempView = [buttonView viewWithTag:30];
        tempView.hidden = YES;
        if (button == buttonView) {
            tempView.hidden = NO;
        }
        else if ([buttonView isKindOfClass:NSClassFromString(@"UIButton")]){
            UIButton *b = (UIButton *)buttonView;
            b.selected = NO;
            
        }
    }
    

    
//    点击弹出，在点击推出
    CGRect rect = self.backView.frame;
    
    if (self.curentButton == button && self.backView.bounds.size.height == 0) {
    rect.size.height = 75;
        if (button == self.toolBar.secondButton) {
            rect.size.height = SCREEN_HEIGHT-64-29;

        }
    
    __weak ThemeViewController *weakSelf = self;
    [UIView animateWithDuration:0.125 animations:^{
       
        weakSelf.backView.frame = rect;
    }];
    }
    else if (self.curentButton == button && self.backView.bounds.size.height != 0) {
        
        
        rect.size.height = 0;
        
        __weak ThemeViewController *weakSelf = self;
        [UIView animateWithDuration:0.125 animations:^{
            
            weakSelf.backView.frame = rect;
        }];
    }
    else {
        rect.size.height = 75;
        if (button == self.toolBar.secondButton) {
            rect.size.height = SCREEN_HEIGHT-64-29;
            
        }
        __weak ThemeViewController *weakSelf = self;
        [UIView animateWithDuration:0.125 animations:^{
            
            weakSelf.backView.frame = rect;
        }];
    }
    
    
//    判断选择的按钮
    switch (button.tag) {
        case 1: {
            self.currentBackView = 1;
            break;
        }
        case 2: {
            self.currentBackView = 2;
            break;
        }
        case 3: {
            self.currentBackView = 3;
            break;
        }
            
        default:
            break;
    }
    [self buildManyButton:self.indexModels];
    
    self.curentButton = button;
    
}

- (void)buildManyButton:(NSArray *)models {
    
    ManyButton *tempMany = (ManyButton *)[self.backView viewWithTag:106];
    
        [tempMany removeFromSuperview];
    IndexW2Model *model = [models firstObject];
    self.currentTheme = model.ID;
    if (self.currentBackView == 1) {
        
        ManyButton *many = [[ManyButton alloc] initWithFrame:CGRectMake(10, 6, (SCREEN_WIDTH - 40), 60)];
        many.tag = 106;
    NSArray *arr = [models valueForKey:@"name"];
    
    [many setManyButtonViewWithButtonImages:arr andButtonTitles:arr andlineNum:4 andTargert:self andSEL:@selector(reloTableData:) andIsBackgoundImage:NO];
    
    [self.backView addSubview:many];

    }
    else if (self.currentBackView == 2) {
        
        ManyButton *many = [[ManyButton alloc] initWithFrame:CGRectMake(10, 6, (SCREEN_WIDTH - 40), 200)];
        many.tag = 106;
        
        NSArray *placeNameArr = [self.dataArray valueForKey:@"name"];
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < placeNameArr.count; i++) {
            if (i == 11) {
                break;
            }
            else {
                [tempArr addObject:placeNameArr[i]];
            }
            
        }
        
        NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
        if (net.localArr == nil) {
            net.localArr = @[@"位置未知"];
        }
        [many setManyButtonViewWithButtonImages:net.localArr andButtonTitles:net.localArr andlineNum:1 andTargert:self andSEL:@selector(reloTableData:) andIsBackgoundImage:NO];
        
        [self.backView addSubview:many];
    
    }
    else {
        
        ManyButton *many = [[ManyButton alloc] initWithFrame:CGRectMake(10, 6, (SCREEN_WIDTH - 40), 60)];
        many.tag = 106;
        
        NSArray *sortArr = SORTARRAY;
        [many setManyButtonViewWithButtonImages:sortArr andButtonTitles:sortArr andlineNum:2 andTargert:self andSEL:@selector(reloTableData:) andIsBackgoundImage:NO];
        [self.backView addSubview:many];
    }
    
    
    for (UIView *buttonView in self.toolBar.subviews) {
        if ([buttonView isKindOfClass:NSClassFromString(@"UIButton")]) {
            UIButton *button = (UIButton *)buttonView;
            button.selected = NO;
        }
    }

}

- (void)flashTableView {
__weak ThemeViewController * weadSelf = self;

// 下拉刷新效果
[self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
    
    [weadSelf performSelector:@selector(endRefreshHeaderView) withObject:nil afterDelay:0.125];
}];

// 上拉加载效果
[self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
    
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
    
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/SceneList?cityId=%@&step=10&theme=%@&page=%d",self.cityId,self.currentTheme,++self.count];
    
    [self getDataFromNet:urlStr];
    
}

//点击地图图片
- (void)tapMapImage:(UITapGestureRecognizer *)tap {
   
    


}


- (void)reloTableData:(UIButton *)button {
    
    CGRect rect = self.backView.frame;
    rect.size.height = 0;
    
    __weak ThemeViewController *weakSelf = self;
    [UIView animateWithDuration:0.125 animations:^{
        
        weakSelf.backView.frame = rect;
        
    }];
    
    
    if (self.currentBackView == 1) {
//        移除所有对象
        self.count = 0;
        [self.dataArray removeAllObjects];
        
        IndexW2Model *tempModel = self.indexModels[button.tag-10];
        
        NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/SceneList?cityId=%@&step=10&theme=%@&page=%d",self.cityId,tempModel.ID,self.count];
        
        [self getDataFromNet:urlStr];
        
        self.curentModel = tempModel;
        
    }
    else if (self.currentBackView == 2) {
       
        
        
    }
    else {
        [self sortTableDataArrayWithPrice:button.tag];
        
        /*********************************************************/
//        NSLog(@"%d",button.tag);
        
    }


}



#pragma mark -  按钮的点击事件
- (void)clickLeftButton:(UIButton *)button {
    if (button == self.navigationBar.rightButton) {
        
        NSLog(@"弹出详情按钮");
        
    }
    else {
        self.isShowTabBar = YES;
        [self.navigationController popViewControllerAnimated:YES];
        }
}


#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     ThemeTableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:@"themeCell"];
    if (myCell == nil) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:@"ThemeTableViewCell" owner:self options:nil] firstObject];
    }
    if (self.dataArray.count >= 1) {
    ThemeModelJS *model = (ThemeModelJS *)self.dataArray[indexPath.row];
    [myCell setCellWithIndexW2Model:model andtag:(int)indexPath.row andTargert:self];
    }
    
    return myCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.isShowTabBar = NO;
    CGRect rect = self.backView.frame;
    rect.size.height = 0;
    
    __weak ThemeViewController *weakSelf = self;
    [UIView animateWithDuration:0.125 animations:^{
        
        weakSelf.backView.frame = rect;
        
    }];
    
    ThemeModelJS *model = (ThemeModelJS *)self.dataArray[indexPath.row];
    self.isShowTabBar = NO;
    
    if (self.oneceTap) {
    NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/SceneDetail?id=%@&uuid=77db2a8539c06750ca9c14d5ea441e2eb3dd5e1a",model.id];
    
    self.session = [AFHTTPSessionManager manager];
    self.session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.session GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *d = dic[@"data"];
        NSArray *arr = d.allKeys;
        
        if ([arr containsObject:@"content"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                FinshViewController *finshVC = [[FinshViewController alloc] init];
                [finshVC showWebWebView:dic[@"data"][@"content"]];
                
                [self.navigationController pushViewController:finshVC animated:YES];
                self.oneceTap = YES;
            });
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                secondDetailViewController *secondDetail = [[secondDetailViewController alloc] init];
                [secondDetail getDataFormNet:urlStr];
                [self.navigationController pushViewController: secondDetail animated:YES];
                secondDetail.isShowTabBar = YES;
                self.oneceTap = YES;
                    });
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.oneceTap = NO;
}



- (void)getDataFromNet:(NSString *)urlStr {
    
    
    self.session = [AFHTTPSessionManager manager];
    self.session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __weak ThemeViewController *weakSelf = self;
//    获取主要信息
    [self.session GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlDic.allKeys containsObject:@"data"]) {
            
       NSArray *temparr = urlDic[@"data"][@"list"];
            if (temparr.count != 0) {
        [weakSelf.dataArray addObjectsFromArray:[ThemeModelJS arrayOfModelsFromDictionaries:temparr]];
        
                dispatch_async(dispatch_get_main_queue(), ^{
//                    奇葩的刷新tableView的方法
                    [self.view sendSubviewToBack:self.loadImageView];
                    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                });
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //        NSLog(@"%@",error);
    }];
    
//    获取toolbar信息
    [self.session GET:@"https://api.108tian.com/mobile/v3/ThemeItems?type=event&timeStamp=1449922178901" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGRect rect = self.backView.frame;
    rect.size.height = 0;
    
    __weak ThemeViewController *weakSelf = self;
    [UIView animateWithDuration:0.125 animations:^{
        
        weakSelf.backView.frame = rect;
        
    }];

}

- (void)sortTableDataArrayWithPrice:(NSInteger)index {
//    价格数组
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:[self.dataArray valueForKey:@"price"]];
    
//    热度数组
     NSMutableArray *hotArr = [[NSMutableArray alloc] initWithArray:[self.dataArray valueForKey:@"fav"]];
    
//    坐标素组
    NSMutableArray *distanceArr = [[NSMutableArray alloc] initWithCapacity:42];
    for (ThemeModelJS *theme  in self.dataArray) {
        NSArray *lngLat = theme.lngLatitude;
        [distanceArr addObject:lngLat];
    }
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
 
    for (int i = 0;i < tempArr.count-1;i++) {
        for (int j = i+1; j < tempArr.count;j++) {
        
            switch (index) {
                case 10: {
                        float price1 = [tempArr[i] floatValue];
                        float price2 = [tempArr[j] floatValue];
                    
                    if (price1 > price2) {
                       
                        [tempArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                        [self.dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    }
                    break;
                }
                case 11: {
                    
                    int fav1 = [hotArr[i] floatValue];
                    int fav2 = [hotArr[j] floatValue];
                    
                    if (fav1 < fav2) {
                        [hotArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                        [self.dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    }
                    break;
                }
                case 12: {
                    if ([@"Free"isEqualToString:tempArr[i]]) {
                        continue;
                    }
                    else {
                        float price1 = [tempArr[i] floatValue];
                        float price2 = [tempArr[j] floatValue];
                        
                        if (price1 < price2) {
                            [tempArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                            [self.dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];   
                        }
                    }
                    break;
                }
                case 13: {
                    
                    CGFloat lat1 = [[distanceArr[i] lastObject] floatValue];
                    CGFloat lng1 = [[distanceArr[i] firstObject] floatValue];
                    
                    CGFloat lat2 = [[distanceArr[j] lastObject] floatValue];
                    CGFloat lng2 = [[distanceArr[j] firstObject] floatValue];
                    
                    CGFloat distance1 = [ThemeViewController distanceBetweenOrderBy:net.latitude :lat1 :net.longitude :lng1];
                     CGFloat distance2 = [ThemeViewController distanceBetweenOrderBy:net.latitude :lat2 :net.longitude :lng2];
                    
                    if (distance1 > distance2) {
                        [tempArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                        [self.dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    }
                    
                    break;
                }

                default:
                    break;
            }
        }
    }
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    
    [self.tableView reloadData];

}

// 计算经纬度之间的距离
+(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2{
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //km  返回
    //     return  distance*1000;
    //返回 m
    return   distance;
}



#pragma mark - tabbar的隐藏与显示
//tabbar收起
- (void)viewWillAppear:(BOOL)animated {
    
    if (self.dataArray.count < 1) {
        [self.view bringSubviewToFront:self.loadImageView];
    }
    
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
