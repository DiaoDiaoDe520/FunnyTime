//
//  ViewController.m
//  TestCell
//
//  Created by qf1 on 15/11/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModel.h"
#import "AppDelegate.h"
#import "FinshViewController.h"
#import "Recommend.h"
#import "secondDetailViewController.h"
#define CELL_HEIGHT (120*self.autoSizeScaleY)
#define HEADERVIEW_HEIGHT (180*self.autoSizeScaleY)
#define SCROLVIEW_HEIGHT (160*self.autoSizeScaleY)
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UILabel *subTitle;

//防止tabBar显示出来
@property (nonatomic,assign) BOOL isShowTabBar;


@end

@implementation DetailViewController

// 初始化数据
- (instancetype)initWithId:(NSString *)ID
{
    self = [super init];
    if (self) {
        [self getDataFromNet:ID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self setControl];
    
    [self setMianTableView];
    
    
}

#pragma mark  -  设置返回
- (void)setControl {
    self.isShowTabBar = YES;
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@"arrow180-1.png"] andNomalImage:[UIImage imageNamed:@""] andTitle:@"" andTitleColor:[UIColor blueColor]];
    [self.navigationBar setLeftBarButtonSize:CGSizeMake(45, 24)];
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.25 target:self selector:@selector(scrollviewAutoScroll) userInfo:nil repeats:YES];
    
}

- (void)setMianTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    屏幕适配
    if(SCREEN_HEIGHT > 480){
        self.autoSizeScaleX = SCREEN_WIDTH/320;
        self.autoSizeScaleY = SCREEN_HEIGHT/568;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
    
    // 初始化TableView的数据数组
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *myView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 210 )];
    myView.backgroundColor = [UIColor greenColor];
    myView.userInteractionEnabled = YES;
    myView.contentMode = UIViewContentModeScaleToFill;
    [myView setImage:[UIImage imageNamed:@"IMG_08m.png"]];
    
    _subTitle = [QuickCreateView addLabelWithFrame:CGRectMake(SCREEN_WIDTH,10, SCREEN_WIDTH, 30) andBackgroundColor:[UIColor blackColor] andText:self.model.subtitle andTextFont:24 andTextAlignment:NSTextAlignmentCenter andAddToUIView:myView];
    _subTitle.tag = 26;
    
    myView.tag = 4;
    
    [self.tableView setTableHeaderView:myView];
    
    //    主界面的滚动视图
    self.myScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCROLVIEW_HEIGHT)];
    
    self.myScrolView.pagingEnabled = YES;
    self.myScrolView.delegate = self;
    self.myScrolView.showsHorizontalScrollIndicator = NO;
    self.myScrolView.showsVerticalScrollIndicator = NO;
    self.myScrolView.bounces = NO;
    
    self.myScrolView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    
    self.myScrolView.backgroundColor = [UIColor whiteColor];
    
    
    //    设置pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100*self.autoSizeScaleY)/2, SCROLVIEW_HEIGHT -30, 100*self.autoSizeScaleX, 22*self.autoSizeScaleY)];
    [self.myScrolView addSubview:self.pageControl];
    
    [myView addSubview:self.myScrolView];
    
    
       [myView addSubview:self.pageControl];
    [myView bringSubviewToFront:self.pageControl];
    [myView bringSubviewToFront:self.subTitle];
    
    [self.view addSubview:_tableView];
}

//添加ScrolView的图片
- (void)setScrolViewWithImage:(NSArray *)images {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    
    for (UIView *view in self.myScrolView.subviews) {
        [view removeFromSuperview];
    }
    
    if (images.count < 1) {
        return;
    }
    
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:images];
    [marr addObject:[images firstObject]];
    [marr insertObject:[images lastObject] atIndex:0];
    
    self.myScrolView.contentSize = CGSizeMake(SCREEN_WIDTH*(marr.count), 0);
    
    _subTitle.text = self.model.subtitle;
    
//    添加标题
    
    for (int i = 0; i < marr.count; i++) {
        
        UIImageView *scrolImage = [QuickCreateView addImageVierWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCROLVIEW_HEIGHT) andBackgroundColor:[UIColor whiteColor] andBackgroundImage:[UIImage imageNamed:@""] andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill andAddToUIView:self.myScrolView];
        scrolImage.tag = 100 + i;
        NSString *urlStr = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",marr[i]];
        [scrolImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];
        
       
        if (images.count == 1) {
            self.myScrolView.contentSize = CGSizeMake(SCREEN_WIDTH, SCROLVIEW_HEIGHT);
        }
        
        
        [self.myScrolView sendSubviewToBack:scrolImage];
        
    }
    
    
    self.pageControl.numberOfPages = images.count;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.9 alpha:0.6];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.backgroundColor = [UIColor clearColor];
    
    [self.pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
        
    });
    
}
//改变pageControl调用该方法
- (void)pageChange:(UIPageControl *)page {
    
    [self.timer invalidate];
    
    [self.myScrolView setContentOffset:CGPointMake((page.currentPage+1)*SCREEN_WIDTH, 0) animated:YES];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.25 target:self selector:@selector(scrollviewAutoScroll) userInfo:nil repeats:YES];
}

#pragma mark - scrolView 代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}


//定时滚动
- (void)scrollviewAutoScroll {
    
    __weak DetailViewController *weakSelf = self;
    
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



- (void)clickLeftButton {
    self.isShowTabBar = YES;
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.model.items firstObject] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADERVIEW_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10*self.autoSizeScaleY;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identify = @"DetailCell";
    UITableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        
        UILabel *title = [QuickCreateView addLabelWithFrame:CGRectMake(10*self.autoSizeScaleX, 4*self.autoSizeScaleY, SCREEN_WIDTH, 24) andBackgroundColor:[UIColor clearColor] andText:@"" andTextFont:18 andTextAlignment:NSTextAlignmentLeft andAddToUIView:myCell.contentView];
        title.tag = 18;
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10*self.autoSizeScaleX, 26*self.autoSizeScaleY, (SCREEN_WIDTH-20), CELL_HEIGHT - 10*self.autoSizeScaleY)];
        textView.tag = 19;
        textView.font = [UIFont systemFontOfSize:13];
        textView.allowsEditingTextAttributes = NO;
        textView.showsVerticalScrollIndicator = NO;
        textView.bounces = NO;
        textView.editable = NO;
        textView.scrollEnabled = NO;
        textView.textColor = [UIColor grayColor];
        [textView sizeThatFits:CGSizeMake(SCREEN_WIDTH-20, 0)];
        [myCell.contentView addSubview:textView];
        
        [QuickCreateView addButtonWithFrame:CGRectMake(SCREEN_WIDTH-85*self.autoSizeScaleX, CELL_HEIGHT-20*self.autoSizeScaleY, 75, 36) title:@"GO->" tag:(int)indexPath.section target:self action:@selector(pushNextVC:) andAddToUIView:myCell.contentView];
        
    }
    
    for (UIView *v in myCell.contentView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            v.tag = indexPath.section;
        }
    }
    
    UILabel *lable = (UILabel *)[myCell.contentView viewWithTag:18];
    UITextView *textView = (UITextView *)[myCell.contentView viewWithTag:19];
    
    if (self.model != nil) {
    Item *item = [self.model.items[0] objectAtIndex:indexPath.section];
    lable.text = item.name;
    textView.text = item.desc;
    }
    
    return myCell;
}

//头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *header = @"headerViews";
    UITableViewHeaderFooterView *hView = (UITableViewHeaderFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    
    
    UIImageView *headerVew1;
    if (hView == nil) {
        
//        组头的复用
        hView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
        
            headerVew1 = [QuickCreateView addImageVierWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADERVIEW_HEIGHT) andBackgroundColor:[UIColor whiteColor] andBackgroundImage:[UIImage imageNamed:@""] andUsInterfaceEnable:YES andContextMode:UIViewContentModeScaleToFill andAddToUIView:nil];
        headerVew1.tag = section;
        [hView addSubview:headerVew1];
        
//        添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushNextVC:)];
        [headerVew1 addGestureRecognizer:tap];
        
    }
    else {
        for (UIView *view in hView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                view.tag = section;
                headerVew1 = (UIImageView *)view;
            }
        }
    }
    
    Item *item = [[self.model.items firstObject] objectAtIndex:section];
    NSString *urlStr = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",item.img];
    
    [headerVew1 sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];

    
    return hView;
}

// 跳转到详情页
- (void)pushNextVC:(id)object {
    self.isShowTabBar = NO;
    long index;
    
    if ([object isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)object;
        index = button.tag;
    }
    else {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)object;
        index = tap.view.tag;
    }
    
    NSArray *items = [self.model.items firstObject];
    Item *item = (Item*)items[index];
    Recommend *recommend = (Recommend *)item.recommend;
    
//    NSLog(@"%@",recommend.ID);
    
    
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:recommend.type];
    NSString *tempType = [mstr capitalizedString];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/%@Detail?id=%@&uuid=77db2a8539c06750ca9c14d5ea441e2eb3dd5e1a",tempType,recommend.ID];
    
    if ([mstr isEqualToString:@"scene"]) {
        secondDetailViewController *secondDetailVC = [[secondDetailViewController alloc] init];
        secondDetailVC.isShowTabBar = YES;
        [secondDetailVC getDataFormNet:urlStr];
        [secondDetailVC transTitleLable:recommend.label];
        [self.navigationController pushViewController:secondDetailVC animated:YES];
    }
    else {
        FinshViewController *finalVC = [[FinshViewController alloc] init];
        finalVC.isShowTabBar = self.isShowTabBar;
        [finalVC getDataFormNet:urlStr];
        [finalVC transTitleLable:recommend.label];
        [self.navigationController pushViewController:finalVC animated:YES];
    }
    
    
}


//tabbar收起
- (void)viewWillAppear:(BOOL)animated {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    if (net.status == 0) {
       
    }
    
    MyTabBarController *tab = [MyTabBarController shareTabController];
    __weak MyTabBarController *weakTab = tab;
    [UIView animateWithDuration:0.65 animations:^{
//        
//        weakTab.bgImageView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 49);
        weakTab.bgImageView.alpha = 0;
    }];
    
}

//tabbar弹出
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.isShowTabBar) {
    MyTabBarController *tab = [MyTabBarController shareTabController];
    __weak MyTabBarController *weakTab = tab;
    
    [UIView animateWithDuration:0.65 animations:^{
//
//        weakTab.bgImageView.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
        weakTab.bgImageView.alpha = 1;
        }];
    }
}

#pragma mark - 获取数据

- (void)getDataFromNet:(NSString *)ID {
    
    self.session = [NSURLSession sharedSession];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/RecommendDetail?id=%@",ID];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    [request setHTTPMethod:@"GET"];
    
    __weak DetailViewController *weakSelf = self;
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        weakSelf.model = [APPDataModel myDataModelWithDictionary:urlDic[@"data"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [self setScrolViewWithImage:self.model.imgs];
        [self.tableView reloadData];
        });
    }];
    
    [task resume];
    
    
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:YES];
    
    [self performSelector:@selector(invalueTimer:) withObject:t afterDelay:2];


}

//刷新数据，前两秒
- (void)MyreloData {
    
    if (self.model != nil) {
     
        [self setScrolViewWithImage:self.model.imgs];
        [self.tableView reloadData];
    }
}

- (void)invalueTimer:(NSTimer *)timer {
    
    [timer invalidate];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
