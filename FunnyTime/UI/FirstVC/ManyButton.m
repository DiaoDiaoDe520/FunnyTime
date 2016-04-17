//
//  ManyButton.m
//  ManyButtonPackaging
//
//  Created by qf1 on 15/12/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ManyButton.h"
#import "AppDelegate.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation ManyButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

// 设置多按钮的View
- (void)setManyButtonViewWithButtonImages:(NSArray *)images andButtonTitles:(NSArray *)titles andlineNum:(long)lineNum andTargert:(id)target andSEL:(SEL)sel andIsBackgoundImage:(BOOL)isBackgound {
    
    long count;
    long temp = images.count%lineNum;
    if (temp == 0) {
        count = images.count/lineNum;
    }
    else {
        count = images.count/lineNum + 1;
    }
    
    
    CGFloat buttonWidth = self.bounds.size.width/lineNum;
    CGFloat buttonHight = self.bounds.size.height/count;
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    
    
    for (int i = 0; i < images.count; i++) {
        
        int row = i/lineNum;
        int low = i%lineNum;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(low*buttonWidth, row*buttonHight, buttonWidth, buttonHight);
        button.tag = 10 + i;
        
        UIImageView *buttonImage = [[UIImageView alloc] init];
        buttonImage.frame = CGRectMake((buttonWidth-36)/2, 10*delegate.autoSizeScaleY, 44*delegate.autoSizeScaleX, 44*delegate.autoSizeScaleY);
        
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        if (![images[0] isEqualToString:titles[0]] && isBackgound == NO) {
            [buttonImage setImage:[UIImage imageNamed:images[i]]];
            [button addSubview:buttonImage];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, (-1)*button.bounds.size.height/3*2*delegate.autoSizeScaleY, -10*delegate.autoSizeScaleX)];
        }
        
        [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
    }
}





@end
