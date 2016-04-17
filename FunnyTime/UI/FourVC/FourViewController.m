//
//  FourViewController.m
//  FramePackaging
//
//  Created by qf1 on 15/12/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "FourViewController.h"
#import "SaveViewController.h"
#import "SDImageCache.h"
#import "AboutViewController.h"


@interface FourViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) UILabel *manySave;

@end

@implementation FourViewController

-(void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    
    [self getData];
}

#pragma mark - 创建界面
- (void)creatUI {

    _dataArray = [NSMutableArray array];
    
    self.navigationBar.alpha = 0;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -100, SCREEN_WIDTH, SCREEN_HEIGHT+100) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 320)];
    
    [bgImageView setImage:[UIImage imageNamed:@"bgimage.jpg"]];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    logoImageView.center = CGPointMake((SCREEN_WIDTH)/2, CGRectGetHeight(bgImageView.frame) - 120);
    logoImageView.image = [UIImage imageNamed:@"logo.png"];
    [bgImageView addSubview:logoImageView];
    
    
    [_tableView setTableHeaderView:bgImageView];
    
    
    
    
    [self.view addSubview:_tableView];
    
}
#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identify = @"aboutMeCell";
    UITableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        
        if (indexPath.section == 1 && indexPath.row == 0 && self.manySave == nil) {
        //    缓存提醒
        self.manySave = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 5, 80, 32)];
        self.manySave.textColor = [UIColor grayColor];
            self.manySave.textAlignment = NSTextAlignmentRight;
            self.manySave.font = [UIFont systemFontOfSize:14];
            
            
            NSInteger fileSize = [[SDImageCache sharedImageCache] getSize];
            fileSize = fileSize / 1024.0 / 1024.0;
            self.manySave.text = [NSString stringWithFormat:@"%ldM",fileSize];
            myCell.accessoryType = UITableViewCellAccessoryNone;
            [myCell addSubview:self.manySave];
        
        }
        else {
         myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    NSDictionary *dic = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
    
    myCell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
    myCell.textLabel.text = dic[@"title"];
   
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        SaveViewController *saveVC = [[SaveViewController alloc] init];
        
        [self.navigationController pushViewController:saveVC animated:YES];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定清理缓存？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                NSInteger fileSize = [[SDImageCache sharedImageCache] getSize];
                fileSize = fileSize / 1024.0 / 1024.0;
                self.manySave.text = [NSString stringWithFormat:@"%ldM",(long)fileSize];
            });
            
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:^{
        }];
    
    }
    else {
        AboutViewController *about = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
        
    
    }
    
}

- (void)getData {
    
    NSArray *tempArr = @[@[@{@"title":@"我的收藏",@"icon":@"A74ED81E48"}],@[@{@"title":@"清理缓存",@"icon":@"21311D77413644624B0C287D6F0C171F.png"},@{@"title":@"关于FunnyTime",@"icon":@"B0C287D6F0C1"}]];
    
    [self.dataArray addObjectsFromArray:tempArr];
    
    [self.tableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
    
    MyTabBarController *tab = [MyTabBarController shareTabController];
    tab.bgImageView.alpha = 1;

    NSInteger fileSize = [[SDImageCache sharedImageCache] getSize];
    fileSize = fileSize / 1024.0 / 1024.0;
    self.manySave.text = [NSString stringWithFormat:@"%ldM",(long)fileSize];
}


@end

