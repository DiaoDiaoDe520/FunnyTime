//
//  SaveViewController.m
//  FunnyTime
//
//  Created by qf1 on 16/1/6.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "SaveViewController.h"
#import "EGOCache.h"
#import "FinalModel.h"
#import "SaveTableViewCell.h"
#import "FinshViewController.h"
#import "MyTabBarController.h"


@interface SaveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) UILabel *tipeLable;


@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self creatUI];
    [self initData];
    
}
#pragma mark - 创建界面
- (void)creatUI {
    _dataArray = [NSMutableArray array];
    [self transTitleLable:@"收藏"];
    self.navigationBar.alpha = 1;
    
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@"arrow180-1.png"] andNomalImage:[UIImage imageNamed:@""] andTitle:@"" andTitleColor:[UIColor blueColor]];
    [self.navigationBar setLeftBarButtonSize:CGSizeMake(45, 24)];
    
    [self.navigationBar setRightBarButtonWithBackgoundImage:[UIImage imageNamed:@""] andNomalImage:[UIImage imageNamed:@"classification_2.png"] andTitle:@"" andTitleColor:[UIColor clearColor]];
    self.navigationBar.rightButton.selected = NO;
    
    [self.navigationBar.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
    //    navigation下划线
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.editing = NO;
    
    UIView *footView = [[UIView alloc] init];
    [_tableView setTableFooterView:footView];
    
    [self.view addSubview:_tableView];
    
}

- (void)clickRightButton:(UIButton *)button {
    
    if (button.selected == NO) {
        self.tableView.editing = YES;
    }
    else {
        self.tableView.editing = NO;
    }
    button.selected = !button.selected;

}

- (void)clickLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SaveTableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:@"saveCell"];
    if (myCell == nil) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:@"SaveTableViewCell" owner:self options:nil] firstObject];
    }
    
    NSDictionary *modelDic = self.dataArray[indexPath.row];
    
    myCell.nameLable.text =  modelDic[@"name"];
    
    myCell.favLable.text = modelDic[@"fav"];
    
    myCell.adressLable.text = modelDic[@"label"];
    
    NSString *headImgUrlStr = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",modelDic[@"headImg"]];
    [myCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:headImgUrlStr]];
    

    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *modelDic = self.dataArray[indexPath.row];
    
    [self goToFinalVCWithModelDic:modelDic];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

//tableviewCell的删除

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.dataArray];
        
        [[EGOCache globalCache] setPlist:marr forKey:@"fav"];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert){
        NSLog(@"insert");
    }
    else {
        NSLog(@"None");
    }
    
    if (self.dataArray.count < 1 && self.tipeLable == nil) {
        
        self.tipeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 64)];
        self.tipeLable.center = CGPointMake(SCREEN_WIDTH/2, 250);
        self.tipeLable.text = @"亲，你还没有任何收藏，快去收藏吧=(^.^)=。";
        self.tipeLable.font = [UIFont systemFontOfSize:15];
        self.tipeLable.textAlignment = NSTextAlignmentCenter;
        self.tipeLable.numberOfLines = 0;
        self.tipeLable.textColor = [UIColor  grayColor];
        
        [self.view addSubview:self.tipeLable];
        
    }
    else {
        [self.tipeLable removeFromSuperview];
    }
    
    [tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark -  传递ID
- (void)goToFinalVCWithModelDic:(NSDictionary *)dic {
    
    
    FinalModel *final = [[FinalModel alloc] initWithDictionary:dic error:nil];
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    //    判断网络状态
    if (net.status == 0) {
        
        FinshViewController *finalVC = [[FinshViewController alloc] init];
        finalVC.navigationBar.rightButton.selected = YES;
        finalVC.final = final;
        finalVC.comefromsave = YES;
        finalVC.isShowTabBar = YES;
        [self.navigationController pushViewController:finalVC animated:YES];
        NSLog(@"当前网络不可用!");
    }
    else {
        
        
        FinshViewController *finalVC = [[FinshViewController alloc] init];
        finalVC.navigationBar.rightButton.selected = YES;
        finalVC.final = final;
        finalVC.dic = dic;
        finalVC.isShowTabBar = YES;
        finalVC.comefromsave = YES;
        NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/%@Detail?id=%@&uuid=77db2a8539c06750ca9c14d5ea441e2eb3dd5e1a",dic[@"myType"],dic[@"id"]];
        
        NSString *shareUrlStr = [NSString stringWithFormat:@"https://m.108tian.com/weekly/%@.html?version=4.3.4&hmsr=weixin_timeline&hmmd=iphoneApp_4.3.4&from=timeline&isappinstalled=1",dic[@"id"]];
        
        finalVC.shareUrlStr = shareUrlStr;
        
        //    NSLog(@"%@",urlStr);
        [finalVC transTitleLable:dic[@"name"]];
        
        [finalVC getDataFormNet:urlStr];
        finalVC.navigationBar.rightButton.selected = YES;
        [self.navigationController pushViewController:finalVC animated:YES];
    }
    
}



- (void)initData {
    
    if ([[EGOCache globalCache] hasCacheForKey:@"fav"]) {
        NSArray *tempArr = (NSArray *)[[EGOCache globalCache] plistForKey:@"fav"];
        [self.dataArray addObjectsFromArray:tempArr];
        [self.tableView reloadData];
    
    if (tempArr.count < 1 && self.tipeLable == nil) {
        
        self.tipeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 64)];
        self.tipeLable.center = CGPointMake(SCREEN_WIDTH/2, 250);
        self.tipeLable.text = @"亲，你还没有任何收藏，快去收藏吧=(^.^)=。";
        self.tipeLable.font = [UIFont systemFontOfSize:15];
        self.tipeLable.textAlignment = NSTextAlignmentCenter;
        self.tipeLable.numberOfLines = 0;
        self.tipeLable.textColor = [UIColor  grayColor];
        
        [self.view addSubview:self.tipeLable];
        
        }
    else {
        [self.tipeLable removeFromSuperview];
    }
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.dataArray.count < 1) {
        
    }
    else {
        [self.dataArray removeAllObjects];
        [self initData];
    }
    
    MyTabBarController *tab = [MyTabBarController shareTabController];
    tab.bgImageView.alpha = 0;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    MyTabBarController *tab = [MyTabBarController shareTabController];
    tab.bgImageView.alpha = 1;

}


    
@end
