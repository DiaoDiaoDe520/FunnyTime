

#import <UIKit/UIKit.h>

@interface MoviePlayerViewController : UIViewController

//制定输入方法所需要的参数
-(void)setPlayerViewControlWithURL:(NSURL *)url andIsLocation:(BOOL)isLocation;

@end
