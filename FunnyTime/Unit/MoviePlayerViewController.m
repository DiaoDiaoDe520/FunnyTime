

#define screenHeight [UIScreen mainScreen].bounds.size.height

#define screenWidth [UIScreen mainScreen].bounds.size.width

#import "MoviePlayerViewController.h"

#import <MediaPlayer/MediaPlayer.h>


@interface MoviePlayerViewController ()

@property(nonatomic,strong)MPMoviePlayerViewController *mVC;

@property(nonatomic,strong)UIView *headView;

@property(nonatomic,strong)UIView *footView;

@property(nonatomic,strong)UISlider *playerSlider;

@property(nonatomic,strong)NSTimer *playerTimer;

@property(nonatomic,strong)NSMutableArray *valueChangeArray;

@property(nonatomic,assign)BOOL canChange;

@end

@implementation MoviePlayerViewController

-(void)viewWillAppear:(BOOL)animated{
    //通知监听播放结束事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MPPlayerFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    self.valueChangeArray = [NSMutableArray array];
    
    self.canChange = YES;
    // Do any additional setup after loading the view.
}

#pragma mark 设置播放器
-(void)setPlayerViewControlWithURL:(NSURL *)url andIsLocation:(BOOL)isLocation{
//    NSLog(@"%@",url);
    //创建播放器vc
    //ContentURL:网络视频或者本地视频的URL地址
    //本地路径URL使用fileURLWithPath
    self.mVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    
    //播放器播放模式（None没有播放器操作界面）
    //在创建vc时设置状态
    self.mVC.moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    self.mVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    [self.view addSubview:self.mVC.view];
    
    [self addChildViewController:self.mVC];
    
    //设置操作栏
    [self setControlBar];

    
    //设置播放器的进度监听时间
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playerTimeChange) userInfo:nil repeats:YES];
}

#pragma mark 设置时间监听
-(void)playerTimeChange{
    
    float currentTime = self.mVC.moviePlayer.currentPlaybackTime;
    
    float durationTime = self.mVC.moviePlayer.duration;
    
    //设置进度条时间
    self.playerSlider.value = currentTime / durationTime;
}

#pragma mark 设置操作栏
-(void)setControlBar{
    //添加上部操作栏
    self.headView = [[UIView alloc]init];
    
    self.headView.frame = CGRectMake(0, 0, screenWidth, 64);
    
    self.headView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.headView];
    
    //结束按钮
    UIButton *doneButton = [[UIButton alloc]init];
    
    doneButton.frame = CGRectMake(10, 20, 60, 44);
    
    [doneButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headView addSubview:doneButton];
    
    
    //设置播放进度条
    self.playerSlider = [[UISlider alloc]init];
    
    self.playerSlider.frame = CGRectMake(90, 20, 200, 44);
    



    
    //监听变化状态
    [self.playerSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.headView addSubview:self.playerSlider];
    
    
    //添加上部操作栏
    self.footView = [[UIView alloc]init];
    
    self.footView.frame = CGRectMake(0, screenHeight - 44, screenWidth, 44);
    
    self.footView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.footView];
    
    
    //播放按钮制作
    UIButton *playButton = [[UIButton alloc]init];
    
    playButton.frame = CGRectMake(screenWidth/2 - 27/2, 44/2 - 32/2, 27, 32);
    
    [playButton setBackgroundImage:[UIImage imageNamed:@"play-lan_play.png"] forState:UIControlStateNormal];
    
    [playButton setBackgroundImage:[UIImage imageNamed:@"play-lan_stop.png"] forState:UIControlStateSelected];
    
    [playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    playButton.selected = YES;
    
    [self.footView addSubview:playButton];
}

-(void)playButtonClick:(UIButton *)button{
    button.selected = !button.selected;
    
    if (button.selected) {
        [self.mVC.moviePlayer play];
    }
    else{
        [self.mVC.moviePlayer pause];
    }
}

#pragma mark 处理播放结束按钮事件
-(void)doneButtonClick{
    //停止播放事件
    [self.mVC.moviePlayer stop];
}

#pragma mark 进度条值变化响应事件
-(void)sliderValueChange:(UISlider *)slider{
    
    //进度条的当前位置 * 总时间 ＝ 当前播放时间
//    self.mVC.moviePlayer.currentPlaybackTime = slider.value * self.mVC.moviePlayer.duration;
    
    //使用数据存储变化量
    [self.valueChangeArray addObject:[NSString stringWithFormat:@"%f",slider.value]];
    
    //在滑动过程中停止时间(暂停)
    self.playerTimer.fireDate = [NSDate distantFuture];
    
    if (self.canChange) {
        [self performSelector:@selector(valueChange) withObject:nil afterDelay:0.5];
        
        //在0.5秒期间内不能继续进入修改value方法
        self.canChange = NO;
    }
}

-(void)valueChange{
    //取出数组中最后一个元素，作为改变量
    NSString *lastValue = [self.valueChangeArray lastObject];
    
    //进度条的当前位置 * 总时间 ＝ 当前播放时间
    self.mVC.moviePlayer.currentPlaybackTime = [lastValue floatValue] * self.mVC.moviePlayer.duration;
    
    self.canChange = YES;
    
    //在滑动过程中开启时间(继续)
    self.playerTimer.fireDate = [NSDate distantPast];
    
    //把数组清空
    [self.valueChangeArray removeAllObjects];
}

-(void)MPPlayerFinish{
    //结束返回到上一个界面
    [self dismissViewControllerAnimated:YES completion:nil];
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
