//
//  TestCollectionViewCell.m
//  FunnyTime
//
//  Created by qf1 on 15/12/26.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "TestCollectionViewCell.h"

@implementation TestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        self.imageView = [QuickCreateView addImageVierWithFrame:CGRectMake(3, 3,CGRectGetWidth(self.frame)-6, CGRectGetHeight(self.frame)-40) andBackgroundColor:[UIColor clearColor] andBackgroundImage:[UIImage imageNamed:@""] andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleAspectFill andAddToUIView:self];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), CGRectGetWidth(self.frame) , 45)];
        
        self.textView.font = [UIFont systemFontOfSize:12];
        self.textView.selectable = NO;
        self.textView.scrollEnabled = NO;
        self.textView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textView];
        
        
        
    }
    return self;
}





- (void)awakeFromNib {
    // Initialization code
}

@end
