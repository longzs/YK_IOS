//
//  DeviceManagerCollectionHeaderView.m
//  YueKong
//
//  Created by zhoushaolong on 15-1-20.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "DeviceManagerCollectionHeaderView.h"

@implementation DeviceManagerCollectionHeaderView

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if (self) {
        self.labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
        self.labTitle.backgroundColor = [UIColor clearColor];
        self.labTitle.font = [UIFont boldSystemFontOfSize:18.f];
        self.labTitle.textAlignment = NSTextAlignmentLeft;
        self.labTitle.numberOfLines=2.0;
        self.labTitle.textColor = [UIColor darkGrayColor];
        [self addSubview:self.labTitle];
        
//        UIImage *moreImage=[UIImage imageNamed:@"destination_more.png"];
//        UIButton *rightImage=[UIButton buttonWithType:UIButtonTypeCustom];
//        rightImage.frame=CGRectMake(self.dgWidth-30/2.0-moreImage.size.width, (self.dgHeight-moreImage.size.height)/2.0, moreImage.size.width, moreImage.size.height);
//        rightImage.tag=self.tag;
//        [rightImage setBackgroundImage:moreImage forState:UIControlStateNormal];
//        [rightImage setBackgroundImage: moreImage  forState:UIControlStateHighlighted];
//        
//        [rightImage addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self addSubview: rightImage];
        
    }
    return self;
}

@end
