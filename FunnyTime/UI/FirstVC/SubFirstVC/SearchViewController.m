//
//  SearchViewController.m
//  FunnyTime
//
//  Created by qf1 on 15/12/22.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchModelJS.h"
#import "SearchTableViewCell.h"
#import "secondDetailViewController.h"
#import "FinshViewController.h"
#define CELL_HEIGHT  (SCREEN_WIDTH/320)*180

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) UIWebView *mywebView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    [self setControl];
}

- (void)setControl {
    
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@""] andNomalImage:[UIImage imageNamed:@"arrow180-1.png"] andTitle:@"" andTitleColor:[UIColor colorWithRed:0.337 green:0.624 blue:0.906 alpha:1.000]];
    self.navigationBar.leftButton.selected = NO;
    
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationBar.titleLable.text = @"搜索";
    self.navigationBar.titleLable.textColor = [UIColor blackColor];
    
    
//    UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    
    self.mywebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-44-44)];
    self.mywebView.dataDetectorTypes = UIDataDetectorTypeAll;
    //    self.vewView.scalesPageToFit = YES;
    self.mywebView.backgroundColor = [UIColor colorWithRed:158/256.0 green:189/256.0 blue:96/256.0 alpha:1];
    self.mywebView.hidden = YES;
    [self.view addSubview:self.mywebView];
    
    
    
    
}

#pragma mark - 创建界面
- (void)creatUI {
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-64-20) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}


#pragma mark -  按钮的点击事件
- (void)clickLeftButton:(UIButton *)button {
    if (button == self.navigationBar.rightButton) {
        
        NSLog(@"弹出详情按钮");
        
    }
    else {
        if (self.navigationBar.leftButton.selected == YES) {
            self.navigationBar.leftButton.selected = NO;
            self.mywebView.hidden = YES;
        }
        else {
            self.isShowTabBar = YES;
        [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    if (net.status == NetworkReachabilityStatusNotReachable) {
        return 0;
    }
   
    NSArray *tempArr = SEARCH_ARRAY;
    return _dataArray.count > 0 ? _dataArray.count:tempArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _dataArray.count > 0 ? CELL_HEIGHT:44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchTableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (myCell == nil) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] firstObject];
    }
    
    if (self.dataArray.count != 0) {
        if ([[self.dataArray firstObject] isKindOfClass:[SearchModelJS class]]) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [myCell setCellFromModel:self.dataArray[indexPath.row]];
        }
        else {
            [myCell.headImage setImage:[UIImage imageNamed:@"quesheng@2x.jpg"]];
        }
        
        
    }
    else {
        NSArray *tempArr = SEARCH_ARRAY;
        myCell.textLabel.text = tempArr[indexPath.row];
    
    }
    
    return myCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        //    弹起webView
        self.mywebView.hidden = YES;
        //    NSLog(@"%@",urlStr);
        SearchModelJS *search = (SearchModelJS *)self.dataArray[indexPath.row];
        
        
        NSMutableString *mstr = [[NSMutableString alloc] initWithString:search.type];
        NSString *tempStr = [mstr capitalizedString];
        
        NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/%@Detail?id=%@&uuid=77db2a8539c06750ca9c14d5ea441e2eb3dd5e1a",tempStr,search.ID];
        
        
        if ([search.type isEqualToString:@"scene"]) {
            
            secondDetailViewController *secondDetailVC = [[secondDetailViewController alloc] init];
            [secondDetailVC getDataFormNet:urlStr];
            secondDetailVC.isShowTabBar = YES;
            [secondDetailVC transTitleLable:search.name];
            [self.navigationController pushViewController:secondDetailVC animated:YES];
            
        }
        else {
            FinshViewController *finalVC = [[FinshViewController alloc] init];
            [finalVC getDataFormNet:urlStr];
            [finalVC transTitleLable:search.name];
            [self.navigationController pushViewController:finalVC animated:YES];
        }
        
        self.navigationBar.leftButton.selected = YES;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        NSArray *tempArr = SEARCH_ARRAY;
        
//        假数据
        [self.dataArray addObjectsFromArray:@[@"",@"",@"",@""]];
        [self.tableView reloadData];
        [self getDataFromNet:tempArr[indexPath.row]];
        return;
    }
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.isShowTabBar = NO;
    self.mywebView.hidden = YES;
    [self getDataFromNet:searchBar.text];
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    
}

- (void)getDataFromNet:(NSString *)searchStr {
    
    NSString *netStr = [searchStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/Search?cityId=%@&keyword=%@",self.cityId,netStr];
   
    
    self.session = [AFHTTPSessionManager manager];
    self.session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    __weak SearchViewController *weakSelf = self;
    
    [self.session GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *urlArr = urlDic[@"data"][@"list"];
        
//        把数组置空
        [weakSelf.dataArray removeAllObjects];
        
        for (NSDictionary *dic in urlArr) {
            [weakSelf.dataArray addObject:[[SearchModelJS alloc] initWithDic:dic]];
        }

//        NSLog(@"%@",urlArr);
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
    }];
    
}


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
