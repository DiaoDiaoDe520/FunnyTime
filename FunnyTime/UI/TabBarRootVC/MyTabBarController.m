//
//  ViewController.m
//  DIYTabBarController
//
//  Created by diaoD520 on 15/11/18.
//  Copyright (c) 2016年 cc All rights reserved.
//

#import "MyTabBarController.h"
#import "QuickCreateView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"
#import "NavagationBarView.h"
#import "Common.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/*************************************************************/
#define SELECTED_BUTTON 0
#define TAB_LOGO 1
/*************************************************************/

static MyTabBarController *mytab = nil;

@interface  MyTabBarController ()

{
    UIImage * _backgoundImage;
    UIColor * _backgoundColor;
    UIImage * _buttonBackgoundImage;
    UIColor * _buttonBackColor;
    UIColor * _buttonSeleteBackColor;
    long _testLablefont;
    UIColor * _lableTextColor;
    UIColor * _lableTextSeleteColor;
}

//当前选中按钮
@property(nonatomic,strong)UIButton *currentSelectedButton;
@property (nonatomic,strong) UIViewController * currentViewController;
@property (nonatomic,strong) NSMutableArray * photoArr;
@property (nonatomic,strong) NSMutableArray * seletePhotoArr;
@property (nonatomic,strong) NSMutableArray * VCArr;
@property (nonatomic,strong) NSMutableArray * titleArr;


@end

@implementation MyTabBarController

//单例
+ (instancetype)shareTabController {
    
    if (mytab == nil) {
    mytab = [[MyTabBarController alloc] init];
    }
    return mytab;
}


- (id)init {
    
    if (self == [super init]) {
        _photoArr = [NSMutableArray array];
        _seletePhotoArr = [NSMutableArray array];
        _VCArr = [NSMutableArray array];
        _titleArr = [NSMutableArray array];
        
//        获取数据
        [self getDataFromPlist];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarImageView];
}

#pragma mark - 设置bar栏UI
-(void)setTabBarImageView{
    
//   数据修改区
/*************************************************************/
//    tabBar修改
    _backgoundImage = [UIImage imageNamed:@"nearInputbox"];
    _backgoundColor = [UIColor colorWithRed:0.863 green:0.863 blue:0.859 alpha:1.000];
    
//    tabBarButton修改
    _buttonBackgoundImage = [UIImage imageNamed:@""];
    _buttonBackColor = [UIColor clearColor];
    _buttonSeleteBackColor = [UIColor clearColor];
    
//    lable修改
    _testLablefont = 12;
    _lableTextColor = [UIColor colorWithRed:0.714 green:0.710 blue:0.714 alpha:1.000];
    _lableTextSeleteColor = [UIColor blackColor];
    
/*************************************************************/
    
//    设置背景
    
    self.bgImageView = [QuickCreateView addImageVierWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49) andBackgroundColor:_backgoundColor andBackgroundImage:_backgoundImage andUsInterfaceEnable:YES andContextMode:UIViewContentModeScaleToFill andAddToUIView:self.view];
    
    for (int i = 0; i < self.photoArr.count; i++) {
    
        UIButton * button = [QuickCreateView addButtonWithFrame:CGRectMake(SCREEN_WIDTH/self.photoArr.count * i, 0, SCREEN_WIDTH/self.photoArr.count, 49) andBackgroundColor:_buttonBackColor andImage:[UIImage imageNamed:_photoArr[i]] andSeletedImage:[UIImage imageNamed:_seletePhotoArr[i]] andBackgroundImage:_buttonBackgoundImage andTarget:self andSelector:@selector(buttonClick:) andAddToUIView:self.bgImageView];
    
//        NSLog(@"%@",_photoArr[i]);
        button.tag = 100 + i;
        
        // button 的偏移
        if (![_titleArr[0] isEqualToString:@""]) {
        [button setImageEdgeInsets:UIEdgeInsetsMake(-16, 0, 0, 0)];
        }
        
        UILabel * lable = [QuickCreateView addLabelWithFrame:CGRectMake(0, 49 - 20, SCREEN_WIDTH/self.photoArr.count, 15) andBackgroundColor:[UIColor clearColor] andText:_titleArr[i]  andTextFont:_testLablefont andTextAlignment:NSTextAlignmentCenter andAddToUIView:button];
        
//     lable的设置
       lable.tag = 1001;
        lable.textColor = _lableTextColor;
        
//     默认选中第一个
        if (i == SELECTED_BUTTON) {
            
            button.selected = YES;
            [button setBackgroundColor:_buttonSeleteBackColor];
            lable.textColor = _lableTextSeleteColor;
//     设置当前选中的按钮是第一个按钮
            self.currentSelectedButton = button;
            
           UINavigationController * fvc = self.VCArr[SELECTED_BUTTON];
            fvc.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
            fvc.view.backgroundColor = [UIColor whiteColor];
            fvc.navigationBar.translucent = YES;
            fvc.navigationBar.hidden = YES;
//      修改Title的Text
            [[fvc.childViewControllers firstObject] transTitleLable:_titleArr[SELECTED_BUTTON]];
            
            [self.view addSubview:fvc.view];
            [self addChildViewController:fvc];
           
            _currentViewController = fvc;
            
            [self.view bringSubviewToFront:self.bgImageView];
        }
    }
}

-(void)buttonClick:(UIButton *)button{
    
    //把原来的按钮selected状态设置为NO
    self.currentSelectedButton.selected = NO;
    button.selected = YES;
    
    //还原原来label颜色
    UILabel * curresentlabel = (UILabel *)[self.currentSelectedButton viewWithTag:1001];
    curresentlabel.textColor = _lableTextColor;
    
    //还原原来label颜色
    UILabel *label2 = (UILabel *)[button viewWithTag:1001];
    label2.textColor = _lableTextSeleteColor;
    
    
//    修改Button的背景颜色
    [self.currentSelectedButton setBackgroundColor:_buttonBackColor];
    [button setBackgroundColor:_buttonSeleteBackColor];
    
    //重新给当前按钮赋值
    self.currentSelectedButton = button;
    
//    移除覆盖过了的子视图 removeFromParentViewController
    [_currentViewController removeFromParentViewController];
    [self.currentViewController.view removeFromSuperview];
    
//    切换VC
    UINavigationController * vc = self.VCArr[button.tag%100];
    vc.navigationController.navigationBar.translucent = NO;
    vc.navigationBarHidden = YES;
    vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    
//    设置title
    [[vc.childViewControllers firstObject] transTitleLable:label2.text];
    
    _currentViewController = vc;
    
    [self.view bringSubviewToFront:self.bgImageView];
}

//  读取plist文件，获取UI创建需要的数据
- (void)getDataFromPlist {

    NSString * PlistPath = [[NSBundle mainBundle] pathForResource:@"ViewController" ofType:@"plist"];
    
    NSArray * ViewControllers = [[NSArray alloc] initWithContentsOfFile:PlistPath];
    
    Class VCClass;
    for (NSDictionary * dic in ViewControllers) {
        NSString * VCString = dic[@"ViewController"];
        NSString * title = dic[@"title"];
        NSString * image = dic[@"icon"];
        NSString * seleteImage = dic[@"seletedIcon"];
        
        VCClass = NSClassFromString(VCString);
        Common * vc = [[VCClass alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [_VCArr addObject:nc];
        [_titleArr addObject:title];
        [_photoArr addObject:image];
        [_seletePhotoArr addObject:seleteImage];
    }
}

#if STATUS_BAR
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#endif

//- (void)viewWillAppear:(BOOL)animated {
//    [self welcome];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
