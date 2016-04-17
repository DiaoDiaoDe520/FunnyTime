//
//  NaviViewController.m
//  MovieProgram
//
//  Created by qf1 on 15/11/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Common.h"

@interface Common ()

@end

@implementation Common

// 导航栏
- (void)setNavigationBar {
    
    //    NavigationBar 状态修改
/********************************************************************/
    UIImage * backgoundImage = [UIImage imageNamed:@"navigationbar"];
        UIColor * backColor = [UIColor whiteColor];
    
    NSString * logoImageName = @"";
    NSString * title = @"";
    
    UIImage * leftButtonImage1 = [UIImage imageNamed:@""];
    UIImage * leftButtonSeleteImage1 = [UIImage imageNamed:@""];
    
    UIImage * rightButtonImage2 = [UIImage imageNamed:@""];
    UIImage * rightButtonSeleteImage2 = [UIImage imageNamed:@""];
    
    UIColor * statusBarColor = [UIColor whiteColor];
    
/********************************************************************/
    
    _navigationBar = [[NavagationBarView alloc] initWithNavigationBarWithBackImage:backgoundImage andLeftButtonImage:leftButtonImage1 andSeletedLeftImage:leftButtonSeleteImage1 andRightImage:rightButtonImage2 andSeletedRightImage:rightButtonSeleteImage2 angLogeImageName:logoImageName andBackColor:backColor andBarColor:statusBarColor andTitle:title];
    
    [self.view addSubview:_navigationBar];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
//      如果这方法调用写在 viewDidLoad 就会赋值在先，viewDidLoad在后
    [self setNavigationBar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setNavigationBar];

}

#pragma 修改标题
- (void)transTitleLable:(NSString *)string {

    _navigationBar.titleLable.text = string;
    
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
