//
//  MovieViewController.m
//  FunnyTime
//
//  Created by qf1 on 16/1/5.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "MovieViewController.h"
#import "MyTabBarController.h"
#import "StarView.h"
#import "MoviePlayerViewController.h"

#define myFont 14
@interface MovieViewController ()
{
    NSString *_share_contens;
}

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *moviePhotoImageView;

@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *autorLable;
@property (nonatomic,strong) UILabel *caltgetyLable;
@property (nonatomic,strong) UILabel *timeLable;
@property (nonatomic,strong) UILabel *subtitleLable;
@property (nonatomic,strong) UILabel *detailtextView;

@property (nonatomic,strong) StarView *starView;

@property (nonatomic,strong) UIScrollView *detailCcrollView;

@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UIButton *detailButton;

@property (nonatomic,assign) CGFloat tempFloat;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createMainUI];

}

- (void)createMainUI {
    
    //    屏幕适配
    if(SCREEN_HEIGHT > 480){
        self.autoSizeScaleX = SCREEN_WIDTH/320;
        self.autoSizeScaleY = SCREEN_HEIGHT/568;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
//    创建scrollView
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT+80);
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.mainScrollView];
    
    
//    导航栏设置
    [self.navigationBar setLeftBarButtonWithBackgoundImage:[UIImage imageNamed:@"arrow180-1.png"] andNomalImage:[UIImage imageNamed:@""] andTitle:@"" andTitleColor:[UIColor blueColor]];
    [self.navigationBar setLeftBarButtonSize:CGSizeMake(45, 24)];
    
    [self.navigationBar.leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationBar.alpha = 0.75;
    
    

    //    设置分割线
    [QuickCreateView addViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1) andBackgroundColor:[UIColor grayColor] andAddToUIView:self.navigationBar];
    
    
//    表头背景图片
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, -200, SCREEN_WIDTH + 400, (SCREEN_WIDTH - SCREEN_WIDTH/5) + 200)];
    self.imageView.userInteractionEnabled = YES;
    
    [self.mainScrollView addSubview:self.imageView];
    
//    蒙板
    UIView *viewM = [[UIView alloc] initWithFrame:self.imageView.bounds];
    viewM.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    
    [self.imageView addSubview:viewM];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
    
    
    
//    电影图片
    self.moviePhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20*self.autoSizeScaleX, 64*self.autoSizeScaleX, 120*self.autoSizeScaleX , 150*self.autoSizeScaleY)];
    
    
    self.moviePhotoImageView.userInteractionEnabled = YES;
    UIGestureRecognizer *tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(clickPictureToPlayMP4:)];
    [self.moviePhotoImageView addGestureRecognizer:tap];
    
    [self.mainScrollView addSubview:self.moviePhotoImageView];
    
//    电影名
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moviePhotoImageView.frame) + 20*self.autoSizeScaleX, 68*self.autoSizeScaleY, SCREEN_WIDTH - (CGRectGetMaxX(self.moviePhotoImageView.frame))- 40, 30)];
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.font = [UIFont boldSystemFontOfSize:22];
    
    
    [self.mainScrollView addSubview:self.titleLable];
    
//    评级星星
    self.starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moviePhotoImageView.frame) + 20*self.autoSizeScaleX, CGRectGetMaxY(self.titleLable.frame)+4*self.autoSizeScaleY, 120, 32)];
    
    [self.mainScrollView addSubview:self.starView];
    
//    出演演员
    self.autorLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moviePhotoImageView.frame) + 20*self.autoSizeScaleX, CGRectGetMaxY(self.starView.frame)+4*self.autoSizeScaleY,  SCREEN_WIDTH - (CGRectGetMaxX(self.moviePhotoImageView.frame))- 30, 36)];
    self.autorLable.numberOfLines = 2;
    self.autorLable.textColor = [UIColor whiteColor];
    self.autorLable.font = [UIFont boldSystemFontOfSize:myFont];
    
    
    [self.mainScrollView addSubview:self.autorLable];
    
//    电影的类别 + 电影时长
    self.caltgetyLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moviePhotoImageView.frame) + 20*self.autoSizeScaleX, CGRectGetMaxY(self.autorLable.frame)+4*self.autoSizeScaleY,  SCREEN_WIDTH - (CGRectGetMaxX(self.moviePhotoImageView.frame))- 30, 16)];
    self.caltgetyLable.textColor = [UIColor whiteColor];
    self.caltgetyLable.font = [UIFont boldSystemFontOfSize:myFont];
    
    [self.mainScrollView addSubview:self.caltgetyLable];
    
    
    
//    上映时间
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moviePhotoImageView.frame) + 20*self.autoSizeScaleX, CGRectGetMaxY(self.caltgetyLable.frame)+4*self.autoSizeScaleY,  SCREEN_WIDTH - (CGRectGetMaxX(self.moviePhotoImageView.frame))- 40, 16)];
    self.timeLable.textColor = [UIColor whiteColor];
    self.timeLable.font = [UIFont boldSystemFontOfSize:myFont];
    [self.mainScrollView addSubview:self.timeLable];
    
    
//    电影的简介
    self.detailtextView = [[UILabel alloc] initWithFrame:CGRectMake(20*self.autoSizeScaleX, CGRectGetMaxY(self.imageView.frame) + 4*self.autoSizeScaleY, SCREEN_WIDTH-40, 100)];
    
    self.detailtextView.textColor = [UIColor whiteColor];
    self.detailtextView.font = [UIFont systemFontOfSize:15];
    self.detailtextView.numberOfLines = 4;
    
    self.detailtextView.textColor = [UIColor blackColor];
    
    [self.mainScrollView addSubview:self.detailtextView];
    
    self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailButton.frame = CGRectMake((SCREEN_WIDTH - 20)/2, CGRectGetMaxY(self.detailtextView.frame),20,20);
    
    [self.detailButton setBackgroundImage:[UIImage imageNamed:@"downBurron"] forState:UIControlStateNormal];
    [self.detailButton setBackgroundImage:[UIImage imageNamed:@"Screen.png"] forState:UIControlStateSelected];
    self.detailButton.selected = NO;
    [self.detailButton addTarget:self action:@selector(clickDetailButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainScrollView addSubview:self.detailButton];
    
    
//    分割View
    UIView *view = [QuickCreateView addViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.detailtextView.frame)+30*self.autoSizeScaleY, SCREEN_WIDTH, 20) andBackgroundColor:[UIColor lightGrayColor] andAddToUIView:self.mainScrollView];
    view.tag = 100;
    
//    图片标题
    self.subtitleLable = [QuickCreateView addLableWithFrame:CGRectMake(20, CGRectGetMaxY(view.frame)+20*self.autoSizeScaleY, 100, 24) text:@"精彩图集" textColor:[UIColor blackColor] andAddToUIView:self.mainScrollView];
    self.subtitleLable.font = [UIFont systemFontOfSize:18];
    
    self.detailCcrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.self.subtitleLable.frame)+10*self.autoSizeScaleY, SCREEN_WIDTH-20, 160)];
    self.detailCcrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self.mainScrollView addSubview:self.detailCcrollView];
    
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(CGRectGetMaxX(self.moviePhotoImageView.frame) - 72, CGRectGetMaxY(self.moviePhotoImageView.frame)-72, 44, 44);
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"video_play.png"] forState:UIControlStateNormal];
    
    [self.playButton addTarget:self action:@selector(clickPictureToPlayMP4:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainScrollView addSubview:self.playButton];
    
    
}

- (void) imageWithArray:(NSArray *)images {
    
    CGFloat image_width = (SCREEN_WIDTH - 40)/2.1;
    self.detailCcrollView.contentSize = CGSizeMake(image_width*images.count, 0);
    
    for (int i = 0; i < images.count; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(image_width*i, 0, image_width, CGRectGetHeight(self.detailCcrollView.frame))];
        
        [image sd_setImageWithURL:[NSURL URLWithString:images[i]]];
        
        [self.detailCcrollView addSubview:image];
    }
}


- (void) setUIWithModel:(SecondDetaliData *)model {
    
    NSString *urlStr = [model.medias firstObject][@"url"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    NSString *m_urlStr = [model.medias firstObject][@"m_url"];
    [self.moviePhotoImageView sd_setImageWithURL:[NSURL URLWithString:m_urlStr]];
    
    
    self.starView.myView.frame = CGRectMake(0, 0, [model.score floatValue]*6.2, CGRectGetHeight(self.starView.frame));
    
    self.titleLable.text = model.title;
    
    NSString *authorStr = [NSString stringWithFormat:@"演员:%@",model.actor];
    self.autorLable.text = authorStr;
    
    self.caltgetyLable.text = model.movie_type;
    
    NSString *timeStr = [NSString stringWithFormat:@"上映时间:%@",model.publish_time];
    self.timeLable.text = timeStr;
    
    self.detailtextView.text = model.share_content;
    _share_contens = model.share_content;
    
    NSArray *images = [model.galleries valueForKey:@"url"];
    
//    scrollView的素材
    [self imageWithArray:images];
    
    
}


/**************************   播放器问题  *******************************/
#pragma mark - 响应事件
- (void)clickPictureToPlayMP4:(UIButton *)button
{
    
    if (self.movieUrl != nil) {
    MoviePlayerViewController *mVC = [[MoviePlayerViewController alloc]init];
        
        [mVC setPlayerViewControlWithURL:[NSURL URLWithString:self.movieUrl] andIsLocation:NO];
    
    [self presentViewController:mVC animated:YES completion:nil];
    
    //设置播放器
        
    
    }
    
}

- (void)clickLeftButton {
    
    MyTabBarController *tab = [MyTabBarController shareTabController];
    tab.bgImageView.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickDetailButton {
    
    
    if (self.detailButton.selected == NO) {
        self.detailtextView.numberOfLines = 0;
    NSDictionary * fornDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect Rect = [_share_contens boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fornDic context:nil];

    CGRect tempRect = self.detailtextView.frame;
    tempRect.size.height = Rect.size.height;
    self.detailtextView.frame = tempRect;
    }
    else {
        self.detailtextView.numberOfLines = 4;
        self.detailtextView.frame = CGRectMake(20*self.autoSizeScaleX, CGRectGetMaxY(self.imageView.frame) + 4*self.autoSizeScaleY, SCREEN_WIDTH-40, 100);
    }
    
    self.detailButton.selected = !self.detailButton.selected;
    
    self.detailButton.frame = CGRectMake((SCREEN_WIDTH - 20)/2, CGRectGetMaxY(self.detailtextView.frame),20,20);
    
    //    分割View
    UIView *view = [self.mainScrollView viewWithTag:100];
    view.frame = CGRectMake(0, CGRectGetMaxY(self.detailtextView.frame)+30*self.autoSizeScaleY, SCREEN_WIDTH, 20);
    
    //    图片标题
    self.subtitleLable.frame = CGRectMake(20, CGRectGetMaxY(view.frame)+20*self.autoSizeScaleY, 100, 24);
    
    self.detailCcrollView.frame = CGRectMake(10, CGRectGetMaxY(self.self.subtitleLable.frame)+10*self.autoSizeScaleY, SCREEN_WIDTH-20, 160);
    
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.detailCcrollView.frame) + 20*self.autoSizeScaleY);
    
}




- (void)viewWillAppear:(BOOL)animated {
    MyTabBarController *tab = [MyTabBarController shareTabController];
    tab.bgImageView.alpha = 0;
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
