//
//  CollectViewController.m
//  FunnyTime
//
//  Created by qf1 on 15/12/26.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "CollectViewController.h"
#import "TestCollectionViewCell.h"
#import "DetailViewController.h"
@interface CollectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>



@property (nonatomic,strong) AFHTTPSessionManager *session;
@property (nonatomic,strong) UICollectionView *collectView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int count;
@property (nonatomic,assign) BOOL isReflesh;
@end


@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *cityid = [user objectForKey:@"cityid"];
    
    [self getDataMethod:cityid];
    
//    延时调用刷新方法
    [self performSelector:@selector(reloadCollectData) withObject:nil afterDelay:0.75];
    
}

//刷新CollectView显示内容
- (void)reloadCollectData {
    [self.collectView reloadData];
}

- (void)getDataMethod:(NSString *)cityId {
    
//    读缓存
    if ([[EGOCache globalCache] hasCacheForKey:@"collectVCData"]) {
        
        id dataObject = [[EGOCache globalCache] plistForKey:@"collectVCData"];
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:dataObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *arr = urlDic[@"data"][@"list"];
        
        NSArray *apps = [APPDataModel myDataModelWithArray:arr];
        
            self.count = 0;
            [self.dataArray removeAllObjects];
        self.isReflesh = YES;
        
            [self.dataArray addObjectsFromArray:apps];
            [self.collectView reloadData];
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/RecommendDetailList?cityId=%@&step=10&page=0",cityId];
    
    [self getdataFromNetWithUrl:urlStr andBool:YES];

}

- (void)creatUI {
    //    屏幕适配
    if(SCREEN_HEIGHT > 480){
        self.autoSizeScaleX = SCREEN_WIDTH/320;
        self.autoSizeScaleY = SCREEN_HEIGHT/568;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
    self.count = 0;
    self.isReflesh = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *Flayout = [[UICollectionViewFlowLayout alloc] init];
    [Flayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    Flayout.headerReferenceSize = CGSizeMake(10, 60);
    
    
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) collectionViewLayout:Flayout];
    
    [self.collectView registerClass:[TestCollectionViewCell class] forCellWithReuseIdentifier:@"collectCell"];
    
    self.collectView.alwaysBounceVertical = YES;
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectView];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    
    
    
    [QuickCreateView addViewWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.collectView];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:42];
    
    UILabel *titleLable = [QuickCreateView addLabelWithFrame:CGRectMake(10*self.autoSizeScaleX, 10*self.autoSizeScaleY, SCREEN_WIDTH/2, 36) andBackgroundColor:[UIColor clearColor] andText:@"美辑精选" andTextFont:15 andTextAlignment:NSTextAlignmentLeft andAddToUIView:self.collectView];
    titleLable.textColor = [UIColor blackColor];
    

}


#pragma mark - collectView代理
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.dataArray.count;
    return self.dataArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(140*self.autoSizeScaleX,182*self.autoSizeScaleY);
}
//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *collectIndentify = @"collectCell";
    TestCollectionViewCell *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:collectIndentify forIndexPath:indexPath];

    
    if (collectCell == nil) {
        collectCell = [[[NSBundle mainBundle] loadNibNamed:@"TestCollectionViewCell" owner:self options:nil] firstObject];
    }
    
//    判断数组不为空才操作，防止越界
    if (self.dataArray.count >= 1) {
    APPDataModel *app = (APPDataModel *)self.dataArray[indexPath.row];
    
    collectCell.textView.text = app.name;
    
    NSString *imageUrlStr = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",app.headImg];
    [collectCell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];
    }
    
    return collectCell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 13*self.autoSizeScaleX, 0,13*self.autoSizeScaleX);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//选中cell回调的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NetWorkStatus *net = [NetWorkStatus NetWorkStatusDefault];
    
    if (net.status == 0) {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else {
    
    APPDataModel *app = (APPDataModel *)self.dataArray[indexPath.row];

    
    DetailViewController *detailVC = [[DetailViewController alloc] initWithId:app.ID];
    detailVC.autoSizeScaleX = self.autoSizeScaleX;
    detailVC.autoSizeScaleY = self.autoSizeScaleY;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    }


}


-(void)getdataFromNetWithUrl:(NSString *)urlStr andBool:(BOOL)reflash {
    
    
    __weak CollectViewController *weakSelf = self;
    self.session = [AFHTTPSessionManager manager];
    self.session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.session GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        缓存
        [[EGOCache globalCache] setPlist:responseObject forKey:@"collectVCData"];
        
//        NSLog(@"%@",urlDic);
        
       NSArray *arr = urlDic[@"data"][@"list"];
        
        NSArray *apps = [APPDataModel myDataModelWithArray:arr];
        
        if (reflash == YES) {
            weakSelf.count = 0;
            [weakSelf.dataArray removeAllObjects];
            weakSelf.isReflesh = YES;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.dataArray addObjectsFromArray:apps];
            [self.collectView reloadData];
        });

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    if (self.collectView.contentOffset.y+CGRectGetHeight(self.collectView.frame) > self.collectView.contentSize.height -100) {
        if (self.isReflesh == YES) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *cityId = [user objectForKey:@"cityid"];
            NSString *urlStr = [NSString stringWithFormat:@"https://api.108tian.com/mobile/v3/RecommendDetailList?cityId=%@&step=10&page=%d",cityId,++self.count];
            
            [self getdataFromNetWithUrl:urlStr andBool:NO];
            
            self.isReflesh = NO;
        }
        
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
