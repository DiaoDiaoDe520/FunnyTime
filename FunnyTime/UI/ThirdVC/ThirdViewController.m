//
//  ViewController.m
//  TestCell
//
//  Created by qf1 on 15/11/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ThirdModel.h"
#import "ThirdViewController.h"
#import "UIImageView+WebCache.h"
#import "SubThirdViewController.h"
#import "ThirdTableViewCell.h"
#import "ThirdWebViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CELL_HEIGHT (SCREEN_WIDTH/320)*136


@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSString *cityid;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,assign) int count;
@property (nonatomic,assign) BOOL dataFlag;
@property (nonatomic,strong) NSString *nextUrl;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataFlag = YES;
    [self creatUI];
    [self initDataWithReflash:YES];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.cityid = [user objectForKey:@"cityid"];
    
    
}
#pragma mark - 创建界面
- (void)creatUI {
    self.count = 0;
    _dataArray = [NSMutableArray array];
    
    self.navigationBar.titleLable.text = @"逛逛小店";
    self.navigationBar.titleLable.textColor = [UIColor blackColor];
    
//    navigation下划线
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    
}


#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
//    判断网络状态
    if (net.status == 0) {
        
//        没有网络提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    }
    else {
        ThirdModel *model = self.dataArray[indexPath.row];
        
        
        ThirdWebViewController *webVC = [[ThirdWebViewController alloc] init];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://api.guozhoumoapp.com/v1/posts/%@",model.ID];
//
        [webVC transTitleLable:model.title];
        [webVC getDataFormNetWith:urlStr];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * thirdIdentify = @"thirdCell";
    ThirdTableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:thirdIdentify];
    if (myCell == nil) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:@"ThirdTableViewCell" owner:self options:nil] firstObject];
    }
    
    ThirdModel *model = self.dataArray[indexPath.row];
    [myCell setCellWith:model];
    
    
    return myCell;
}


#pragma mark - scrollview代理，用于加载更多数据
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > (self.dataArray.count - 6)*136.0 && self.dataFlag == YES) {
        [self initDataWithReflash:NO];
        self.dataFlag = NO;
    }

}


- (void)initDataWithReflash:(BOOL)isFlash {
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    if ([[EGOCache globalCache] hasCacheForKey:@"thirdData"] && isFlash == YES) {
        
        id dataObject = [[EGOCache globalCache] plistForKey:@"thirdData"];
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:dataObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *arr = urlDic[@"data"][@"items"];
        
        if (arr != nil) {
        NSArray *thirdModel = [ThirdModel myDataModelWithArray:arr];
        [self.dataArray addObjectsFromArray:thirdModel];
        [self.tableView reloadData];
        }
        
    }
    else {
        
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //    网络状态
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"%ld",status);
    }];
    
    //    开始监听
    [manager.reachabilityManager startMonitoring];
    
    //    数据下载
    
        if (net.status == 0) {
            
        }
        else {
        
    if (isFlash == YES) {
        [self.dataArray removeAllObjects];
    }
           
            NSString *urlStr = [NSString stringWithFormat:@"http://api.guozhoumoapp.com/v1/channels/12/items?limit=20&offset=%d",self.count];
            
            if (self.nextUrl != nil) {
                urlStr = self.nextUrl;
            }
        
        
    //    返回数据类型 返回二进制数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak ThirdViewController *weakSelf = self;
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        缓存
        
        if (isFlash == YES) {
            [[EGOCache globalCache] setPlist:responseObject forKey:@"thirdData"];
        }
        
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSArray *arr = urlDic[@"data"][@"items"];
        
        weakSelf.dataFlag = YES;
        NSString *tempStr = urlDic[@"data"][@"paging"][@"next_url"];
        weakSelf.nextUrl = tempStr;
        if ([tempStr isKindOfClass:[NSNull class]]) {
            weakSelf.dataFlag = NO;
        }
        
        
        if (arr != nil) {
            NSArray *thirdModel = [ThirdModel myDataModelWithArray:arr];
            [weakSelf.dataArray addObjectsFromArray:thirdModel];
        }
//          回到主线程刷新tableView
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    }
}


//#pragma mark - 跳转操作
//// 通知反响传回参数
//- (void)viewDidAppear:(BOOL)animated {
//    
//    static dispatch_once_t just_one;
//    
//    dispatch_once(&just_one, ^{
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"tranCity" object:nil];
//    });
//    
//}
//
////更新信息，并且tableView回到表头
//- (void)notificationAction:(NSNotification *)noti {
//    self.cityid = noti.userInfo[@"cityid"];
//    
//}

- (void)viewWillAppear:(BOOL)animated {
    MyTabBarController *tab = [MyTabBarController shareTabController];
    tab.bgImageView.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
