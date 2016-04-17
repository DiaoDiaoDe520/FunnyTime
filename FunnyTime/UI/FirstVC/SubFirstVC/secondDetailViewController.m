//
//  FinshViewController.m
//  FunnyTime
//
//  Created by qf1 on 15/12/19.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "secondDetailViewController.h"
#import "SecondDetailModelJS.h"
#import "AppDelegate.h"
#import <math.h>

#define IMAGEVIEW_WIDTH (SCREEN_WIDTH-20)
#define IMAGEVIEW_HEIGHT (180)

@interface secondDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *myScrolView;
@property (nonatomic,strong) UIImageView *headImage;

@property (nonatomic,strong) NSMutableArray *photoArr;

@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) SecondDetailModelJS *secondModel;

@property (nonatomic,assign) CGFloat tempFloat;
@end
static CGFloat kImageOriginHight = 180;
static CGFloat kTempHeight = 80.0f;

@implementation secondDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self setControl];
    
}


#pragma mark - 创建界面
- (void)creatUI {
    //    屏幕适配
    if(SCREEN_HEIGHT > 480){
        self.autoSizeScaleX = SCREEN_WIDTH/320;
        self.autoSizeScaleY = SCREEN_HEIGHT/568;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    self.navigationBar.alpha = 0;
    
    self.myScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.myScrolView.contentInset = UIEdgeInsetsMake(180,0, 0,0);
    
    self.myScrolView.backgroundColor = [UIColor whiteColor];
    self.myScrolView.delegate = self;
    [self.view addSubview:self.myScrolView];
    
    
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, SCREEN_WIDTH , (SCREEN_WIDTH/320)*180*self.autoSizeScaleY)];
    self.headImage.tag = 44;
    [self.myScrolView addSubview:self.headImage];
    
    UILabel *titleLable = [QuickCreateView addLabelWithFrame:CGRectMake(0, 10*self.autoSizeScaleY, SCREEN_WIDTH, 36*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"景区名称" andTextFont:18 andTextAlignment:NSTextAlignmentCenter andAddToUIView:self.myScrolView];
    titleLable.tag = 19;
    
    
    UILabel *tip1Lable = [QuickCreateView addLabelWithFrame:CGRectMake(0, 44*self.autoSizeScaleY, SCREEN_WIDTH, 36*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"商家信息" andTextFont:16 andTextAlignment:NSTextAlignmentCenter andAddToUIView:self.myScrolView];
    tip1Lable.tag = 18;
    
    UILabel *tip2Lable = [QuickCreateView addLabelWithFrame:CGRectMake(30*self.autoSizeScaleX, 75*self.autoSizeScaleY, SCREEN_WIDTH/4, 36*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"开放时间:" andTextFont:15 andTextAlignment:NSTextAlignmentRight andAddToUIView:self.myScrolView];
    tip2Lable.textColor = [UIColor grayColor];
    tip2Lable.tag = 18;
    
    UILabel *time1Lable = [QuickCreateView addLabelWithFrame:CGRectMake(SCREEN_WIDTH/4+44*self.autoSizeScaleX, 75*self.autoSizeScaleY, SCREEN_WIDTH-100, 22*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"旺季:" andTextFont:15 andTextAlignment:NSTextAlignmentLeft andAddToUIView:self.myScrolView];
    time1Lable.textColor = [UIColor grayColor];
    time1Lable.tag = 21;
    
    UILabel *time2Lable = [QuickCreateView addLabelWithFrame:CGRectMake(SCREEN_WIDTH/4+44*self.autoSizeScaleX, 98*self.autoSizeScaleY, SCREEN_WIDTH-100, 22*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"淡季:" andTextFont:15 andTextAlignment:NSTextAlignmentLeft andAddToUIView:self.myScrolView];
    time2Lable.textColor = [UIColor grayColor];
    time2Lable.tag = 22;
    
    [QuickCreateView addImageVierWithFrame:CGRectMake(10*self.autoSizeScaleX, 83*self.autoSizeScaleY, 20, 20) andBackgroundColor:[UIColor clearColor] andBackgroundImage:[UIImage imageNamed:@"dateImage.png"] andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill andAddToUIView:self.myScrolView];
    
    [QuickCreateView addImageVierWithFrame:CGRectMake(10*self.autoSizeScaleX, 150*self.autoSizeScaleY, 20, 20) andBackgroundColor:[UIColor clearColor] andBackgroundImage:[UIImage imageNamed:@"house.png"] andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill andAddToUIView:self.myScrolView];
    
    
    UILabel *caseLable = [QuickCreateView addLabelWithFrame:CGRectMake(30*self.autoSizeScaleX, 142*self.autoSizeScaleY, SCREEN_WIDTH/4, 36*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"最佳时间:" andTextFont:15 andTextAlignment:NSTextAlignmentRight andAddToUIView:self.myScrolView];
    caseLable.textColor = [UIColor grayColor];
    caseLable.tag = 18;
    
    UILabel *caseValueLable = [QuickCreateView addLabelWithFrame:CGRectMake(SCREEN_WIDTH/5+60*self.autoSizeScaleX, 142*self.autoSizeScaleY, SCREEN_WIDTH-100, 36*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"最佳时间:" andTextFont:15 andTextAlignment:NSTextAlignmentLeft andAddToUIView:self.myScrolView];
    caseValueLable.textColor = [UIColor grayColor];
    caseValueLable.tag = 23;
    
    UILabel *tip3Lable = [QuickCreateView addLabelWithFrame:CGRectMake(0, 180*self.autoSizeScaleY, SCREEN_WIDTH, 36*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"优惠消息" andTextFont:16 andTextAlignment:NSTextAlignmentCenter andAddToUIView:self.myScrolView];
    tip3Lable.tag = 18;
    
    UILabel *priceLable = [QuickCreateView addLabelWithFrame:CGRectMake(36*self.autoSizeScaleX, 213*self.autoSizeScaleY, SCREEN_WIDTH-60, 80*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"优惠:" andTextFont:15 andTextAlignment:NSTextAlignmentLeft andAddToUIView:self.myScrolView];
    priceLable.numberOfLines = 0;
    priceLable.textColor = [UIColor grayColor];
    priceLable.tag = 24;
    
    
//
    UILabel *tip4Lable = [QuickCreateView addLabelWithFrame:CGRectMake(0, 294*self.autoSizeScaleY, SCREEN_WIDTH, 36*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"特色看点" andTextFont:16 andTextAlignment:NSTextAlignmentCenter andAddToUIView:self.myScrolView];
    tip4Lable.tag = 18;
    
    UILabel *title2Lable = [QuickCreateView addLabelWithFrame:CGRectMake(0, 334*self.autoSizeScaleY, SCREEN_WIDTH, 36*self.autoSizeScaleY) andBackgroundColor:[UIColor whiteColor] andText:@"长隆公园" andTextFont:16 andTextAlignment:NSTextAlignmentLeft andAddToUIView:self.myScrolView];
    title2Lable.textColor = [UIColor grayColor];
    title2Lable.tag = 25;
    
    
//    创建导航路线文本
    
    UILabel *busLable = [QuickCreateView addLabelWithFrame:CGRectMake(10*self.autoSizeScaleX, 0, 1, 1) andBackgroundColor:[UIColor clearColor] andText:@"" andTextFont:16 andTextAlignment:NSTextAlignmentLeft andAddToUIView:self.myScrolView];
    busLable.tag = 26;
    busLable.textColor = [UIColor grayColor];
    
    UILabel *carLable = [QuickCreateView addLabelWithFrame:CGRectMake(10*self.autoSizeScaleX, 0, 1, 1) andBackgroundColor:[UIColor clearColor] andText:@"" andTextFont:16 andTextAlignment:NSTextAlignmentLeft andAddToUIView:self.myScrolView];
    carLable.tag = 27;
    carLable.textColor = [UIColor grayColor];
    
    UILabel *bustipLable1 = [QuickCreateView addLabelWithFrame:CGRectMake(10*self.autoSizeScaleX, 0, 1, 1) andBackgroundColor:[UIColor clearColor] andText:@"巴士路线" andTextFont:18 andTextAlignment:NSTextAlignmentCenter andAddToUIView:self.myScrolView];
    bustipLable1.tag = 28;
    
    UILabel *cartipLable1 = [QuickCreateView addLabelWithFrame:CGRectMake(10*self.autoSizeScaleX, 0, 1, 1) andBackgroundColor:[UIColor clearColor] andText:@"自驾路线" andTextFont:18 andTextAlignment:NSTextAlignmentCenter andAddToUIView:self.myScrolView];
    cartipLable1.tag = 29;
    
    
    
//    纪录y的位置
    self.tempFloat = 334*self.autoSizeScaleY + 36*self.autoSizeScaleY;
   
    
//    延时处理
//    [self performSelector:@selector(howToGetHere) withObject:nil afterDelay:0.45];
   
}




- (void)setControl {
    self.photoArr = [NSMutableArray array];
   
    UIButton *backButton = [QuickCreateView addButtonWithFrame:CGRectMake(12, 26, 60, 30) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"arrow180-1.png"] andSeletedImage:[UIImage imageNamed:@""] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(clickLeftButton) andAddToUIView:self.view];
    backButton.tag = 45;
    
    
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@""] andNomalImage:[UIImage imageNamed:@"arrow180-1.png"] andTitle:@"" andTitleColor:[UIColor colorWithRed:0.337 green:0.624 blue:0.906 alpha:1.000]];
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma  mark - tableView的滚动代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    
    if (scrollView.contentOffset.y >= -160*self.autoSizeScaleY || scrollView.contentOffset.y <= -100*self.autoSizeScaleY) {
        self.navigationBar.alpha = 1+(scrollView.contentOffset.y)/60.0;
    }
    
//    拉伸
//    CGFloat yOffset  = scrollView.contentOffset.y;
//    if (yOffset < -200*self.autoSizeScaleY) {
//        CGRect f =self.headImage.frame;
//        f.origin.y = yOffset;
//        f.size.height =  -yOffset;
//        self.headImage.frame = f;
//    }
    
//    缩放
    CGFloat yOffset  = scrollView.contentOffset.y;
//    NSLog(@"yOffset===%f",yOffset);
    CGFloat xOffset = (yOffset + kImageOriginHight)/2;
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.headImage.frame;
        f.origin.y = yOffset - kTempHeight;
        f.size.height =  -yOffset + kTempHeight;
        f.origin.x = xOffset;
        f.size.width = SCREEN_WIDTH + fabs(xOffset)*2;
        self.headImage.frame = f;
    }
}



#pragma  mark -  获取去数据
- (void)getDataFormNet:(NSString *)urlStr {
    
    
    NetWorkStatus *netStastus = [NetWorkStatus NetWorkStatusDefault];
    
    if (netStastus.status != 0) {
    self.session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    [request setHTTPMethod:@"GET"];
    
//    __weak secondDetailViewController *weakSelf = self;
    
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *modelDic = urlDic[@"data"];
        
       
        self.secondModel = [[SecondDetailModelJS alloc] initWithDictionary:modelDic error:nil];

        NSArray *tempArr = urlDic[@"data"][@"details"][@"paragraph"];
        
        NSArray *a = [tempArr[0] objectForKey:@"body"];
        NSString *briefStr = modelDic[@"brief"];
        
//        返回主程序执行UI的操作
        
//        操作UI返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self transTitleLable:modelDic[@"name"]];
            self.navigationBar.titleLable.textColor = [UIColor blackColor];
            [self hadDataFromNet:a andBriefText:briefStr];
            
            NSDictionary *urlsDic = [modelDic[@"albums"] firstObject];
            NSArray *urls = urlsDic[@"urls"];
            
            /***** 还没有用到的图片数组 *******/
            [self.photoArr addObjectsFromArray:[urls valueForKey:@"url"]];
        });
        
        }];
    [task resume];
        
    }
    else {
        
//        弹出对话框
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络不可用，请检查网络连接。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alertVC addAction:action];
        
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    
    }
}


//自适应
- (void)creatImageView:(NSArray *)tempArr andBriefText:(NSString *)briefText {
    
    NSArray *textArr = [tempArr valueForKey:@"text"];
    
     NSDictionary * fornDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSMutableArray *marr = [[NSMutableArray alloc] initWithCapacity:42];
    
    CGRect briefRect = [briefText boundingRectWithSize:CGSizeMake(IMAGEVIEW_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fornDic context:nil];
    
    UILabel *briefLable = [QuickCreateView addLabelWithFrame:CGRectMake(10*self.autoSizeScaleX, 13*self.autoSizeScaleY + self.tempFloat, IMAGEVIEW_WIDTH, CGRectGetHeight(briefRect)) andBackgroundColor:[UIColor clearColor] andText:briefText andTextFont:15 andTextAlignment:NSTextAlignmentLeft andAddToUIView:self.myScrolView];
    briefLable.textColor = [UIColor grayColor];
    briefLable.numberOfLines = 0;
    
    self.tempFloat = CGRectGetMaxY(briefLable.frame);
    
    
    for (id obj in textArr) {
        if ([obj isKindOfClass:[NSString class]]) {
            [marr addObject:obj];
//            NSLog(@"%@",obj);
        }
    }
    
    for (int i = 0; i < marr.count; i++) {
        
        CGRect rect;
        
//        NSLog(@"marr:%ld",marr.count);
        
       rect = [marr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fornDic context:nil];
        
        [marr replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:rect.size.height]];
        
    }
    
//    主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
    
//    视图高度自适应布局
    int tempCount = 0;
    for (NSDictionary *dic in tempArr) {
        
        if ([dic.allKeys containsObject:@"text"]) {
//            NSLog(@"%d",tempCount);
            UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(10*self.autoSizeScaleX, 10*self.autoSizeScaleY+self.tempFloat, IMAGEVIEW_WIDTH, [marr[tempCount] floatValue])];
            textLable.text = dic[@"text"];
            textLable.font = [UIFont systemFontOfSize:15];
            textLable.textColor = [UIColor grayColor];
            textLable.numberOfLines = 0;
            [self.myScrolView addSubview:textLable];
            
            self.tempFloat = textLable.frame.origin.y + textLable.bounds.size.height;
            
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*self.autoSizeScaleY, 10*self.autoSizeScaleY+self.tempFloat, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
        
        [self.myScrolView addSubview:imageView];
        
        NSString *tempStr = dic[@"img"][@"url"];
        NSString *imageImageUrlStr;
        if ([tempStr hasPrefix:@"http:"]) {
            imageImageUrlStr = tempStr;
        }
        else {
            imageImageUrlStr = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",dic[@"img"][@"url"]];
        }
        
        if (dic[@"img"][@"url"] == nil) {
            continue;
        }
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageImageUrlStr] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];
        
        self.tempFloat = imageView.frame.origin.y + IMAGEVIEW_HEIGHT;
        
        self.myScrolView.contentSize = CGSizeMake(0,self.tempFloat);
    }
        [self howToGetHere];
        });
    
}


#pragma mark -  获取数据之后的赋值
- (void)hadDataFromNet:(NSArray *)tempArr andBriefText:(NSString *)briefText {
    
    self.myScrolView.contentSize = CGSizeMake(0, 2*SCREEN_HEIGHT);
    
    NSString *urlStr = [NSString stringWithFormat:@"http://pic.108tian.com/pic/%@",self.secondModel.headImg];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"quesheng.jpg"]];
    
    UILabel *lable0 = (UILabel *)[self.myScrolView viewWithTag:19];
    UILabel *lable1 = (UILabel *)[self.myScrolView viewWithTag:21];
    UILabel *lable2 = (UILabel *)[self.myScrolView viewWithTag:22];
    UILabel *lable3 = (UILabel *)[self.myScrolView viewWithTag:23];
    UILabel *lable4 = (UILabel *)[self.myScrolView viewWithTag:24];
    UILabel *lable5 = (UILabel *)[self.myScrolView viewWithTag:25];
//    UILabel *lable6 = (UILabel *)[self.myScrolView viewWithTag:26];
    
    lable0.text = [NSString stringWithFormat:@"%@",self.secondModel.name];
    lable1.text = [NSString stringWithFormat:@"%@%@",lable1.text,[self clearUnusefulChar:self.secondModel.openinghours[@"peakSeason"]]];
    lable2.text = [NSString stringWithFormat:@"%@%@",lable2.text,[self clearUnusefulChar:self.secondModel.openinghours[@"lowSeason"]]];
    lable3.text = [NSString stringWithFormat:@"%@",self.secondModel.suggestTime];
    lable4.text = [self clearUnusefulChar:self.secondModel.tickets[@"desc"]];
    lable5.text = [NSString stringWithFormat:@"%@",self.secondModel.name];
    
    [self creatImageView:tempArr andBriefText:briefText];
    
//    [self performSelectorOnMainThread:@selector(creatImageView:) withObject:tempArr waitUntilDone:YES];
    
    
}
- (void)howToGetHere {
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    
    UILabel *bus = (UILabel *)[self.myScrolView viewWithTag:26];
    UILabel *car = (UILabel *)[self.myScrolView viewWithTag:27];
    UILabel *bustip = (UILabel *)[self.myScrolView viewWithTag:28];
    UILabel *cartip = (UILabel *)[self.myScrolView viewWithTag:29];
    
//    
    bustip.frame = CGRectMake(0, 10+self.tempFloat, SCREEN_WIDTH, 36*self.autoSizeScaleY);
    
    self.tempFloat = bustip.frame.origin.y + bustip.bounds.size.height;
    
//    
    bus.text = self.secondModel.trafficInfo[@"busLines"];
    
    CGRect rect = [bus.text boundingRectWithSize:CGSizeMake(IMAGEVIEW_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    bus.frame = CGRectMake(10*self.autoSizeScaleX, 10*self.autoSizeScaleY+self.tempFloat, IMAGEVIEW_WIDTH, rect.size.height);
    bus.numberOfLines = 0;
    self.tempFloat = bus.frame.origin.y + bus.bounds.size.height;
    
//
    
    cartip.frame = CGRectMake(0, 10+self.tempFloat, SCREEN_WIDTH, 36*self.autoSizeScaleY);
    
    self.tempFloat = cartip.frame.origin.y + cartip.bounds.size.height;
    
    
    
//    
    car.text = self.secondModel.trafficInfo[@"carLines"];
    
    CGRect rect2 = [car.text boundingRectWithSize:CGSizeMake(IMAGEVIEW_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    car.frame = CGRectMake(10*self.autoSizeScaleX, 10*self.autoSizeScaleY+self.tempFloat, IMAGEVIEW_WIDTH, rect2.size.height);
    car.numberOfLines = 0;
    self.tempFloat = car.frame.origin.y + car.bounds.size.height;
    
    
    self.myScrolView.contentSize = CGSizeMake(0, self.tempFloat + 44*self.autoSizeScaleY);



}

#pragma mark － 移除多余的字符
- (NSString *)clearUnusefulChar:(NSString *)string {
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"</pbr>"];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByCharactersInSet:charSet]];
    
    [tempArr removeObject:@""];
    [tempArr removeObject:@" "];
    
    
    return [tempArr componentsJoinedByString:@""];

}


#pragma mark - tabbar的隐藏与显示
//tabbar收起
- (void)viewWillAppear:(BOOL)animated {
    
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
