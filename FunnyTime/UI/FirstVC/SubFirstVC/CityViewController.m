//
//  ViewController.m
//  TestCell
//
//  Created by qf1 on 15/11/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CityViewController.h"
#import <Foundation/Foundation.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CELL_HEIGHT (44*self.autoSizeScaleY)

@interface CityViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation CityViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

// 初始化数据
- (void)saveData:(CityModel *)city {
    self.compareArr = [NSMutableArray array];
    NSMutableArray *tempArr = [NSMutableArray array];
//
    NSArray *pros = city.openCity;

    for (Prosion *p in pros) {
        for (City *c in p.citys) {
            
            NSString *cityName = [CityViewController tranChinese:c.name];
            
            [tempArr addObject:cityName];
        }
    }
//    NSLog(@"%@",tempArr);
//     重新排列
    NSArray *upChArr = [self sortArr:tempArr];
    
    for (int i = 0; i < upChArr.count;i++) {
        Prosion *pro = [[Prosion alloc] init];
        pro.citys = [NSMutableArray array];
        pro.isShow = YES;
        for (Prosion *p in pros) {
            for (City *c in p.citys) {
//                NSLog(@"%@",c.city);
                
                if ([c.city hasPrefix:self.compareArr[i]]) {
                    [pro.citys addObject:c];
//                    NSLog(@"%@",c.city);
                }
                
            }
        }
        [self.dataArray addObject:pro];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setControl];
    
    [self creatUI];
    
}

- (void)setControl {
    
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@""] andNomalImage:[UIImage imageNamed:@"arrow180-1.png"] andTitle:@"" andTitleColor:[UIColor colorWithRed:0.337 green:0.624 blue:0.906 alpha:1.000]];
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self transTitleLable:@"城市列表"];
    
}

- (void)clickLeftButton:(UIButton *)button {
    if (button == self.navigationBar.rightButton) {
        
        NSLog(@"弹出详情按钮");
        
    }
    else {
    [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 创建界面
- (void)creatUI {
    
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }

    
}

#pragma mark - UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    Prosion *pro = self.dataArray[section];
    
    if (pro.isShow == NO) {
        return 0;
    }
    
    return pro.citys.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32*self.autoSizeScaleY;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identify = @"DetailCell";
    UITableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    if (self.dataArray.count >= 1) {
    Prosion *pro = self.dataArray[indexPath.section];
    City * c = (City *)pro.citys[indexPath.row];
    myCell.textLabel.text = c.name;
    }
    
    return myCell;
}

//头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headViewIdentify = @"headViewButton";
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewIdentify];
    
    if (headView == nil) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headViewIdentify];
        headView.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH,32*self.autoSizeScaleY);
    [button setBackgroundImage:[UIImage imageNamed:@"prosionName"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [headView addSubview:button];
        
    UILabel *lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(8*self.autoSizeScaleX, 12*self.autoSizeScaleY, 70*self.autoSizeScaleY, 18*self.autoSizeScaleY);
    lable.font = [UIFont systemFontOfSize:16];
        lable.textColor = [UIColor blackColor];
        lable.tag = 12;
    [button addTarget:self action:@selector(clickTableViewHeadView:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:lable];
    
        
    }
    
//    赋值
    for (UIView *view in headView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.tag = section;
            
            UILabel *lable = (UILabel *)[button viewWithTag:12];
            if ([lable isKindOfClass:[UILabel class]]){
            lable.text = self.compareArr[section];
            }
        }
    }
    
    
    return headView;
}

//城市首字母索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray *cityNameArr = [NSMutableArray array];
    
    [self.compareArr enumerateObjectsUsingBlock:^(NSString *chStr, NSUInteger idx, BOOL *stop) {
        
        const char ch = [chStr UTF8String][0];
        NSString *strName = [NSString stringWithFormat:@"%c",ch-32];
        //        NSLog(@"%@",strName);
        [cityNameArr addObject:strName];
        
    }];
    
    return cityNameArr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Prosion *pro = self.dataArray[indexPath.section];
    City * c = (City *)pro.citys[indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *idstr = [NSString stringWithFormat:@"%ld",(long)[c.ID integerValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tranCity" object:idstr userInfo:@{@"city":c.name,@"cityid":c.ID}];
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    net.cityName = c.name;
    net.cityId = c.ID;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:c.ID forKey:@"cityid"];
    
}

//收回－闪开
- (void)clickTableViewHeadView:(UIButton *)button {
    NSLog(@"%ld",(long)button.tag);
   
    Prosion *p = (Prosion *)self.dataArray[button.tag];
    p.isShow = !p.isShow;
    
    [self.tableView reloadData];
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
    
    MyTabBarController *tab = [MyTabBarController shareTabController];
    __weak MyTabBarController *weakTab = tab;
    
    [UIView animateWithDuration:0.65 animations:^{

        weakTab.bgImageView.alpha = 1;
    }];
    
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

//排序
- (NSArray *)sortArr:(NSArray *)arr {

    NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:42];
    for (NSString *capCh in arr) {
        const char *ch = [capCh UTF8String];
        char c = ch[0];
        NSString *chStr = [NSString stringWithFormat:@"%c",c-32];
        NSString *tempChStr = [NSString stringWithFormat:@"%c",c];
        
        if (![mArr containsObject:chStr]) {
            [mArr addObject:chStr];
        }
        if (![self.compareArr containsObject:tempChStr]) {
            [self.compareArr addObject:tempChStr];
        }
        
//        排序
        [mArr sortUsingSelector:@selector(compare:)];
        [self.compareArr sortUsingSelector:@selector(compare:)];
    }
    return mArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
