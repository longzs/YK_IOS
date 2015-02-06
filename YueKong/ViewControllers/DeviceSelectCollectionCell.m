//
//  DeviceSelectCollectionCell.m
//  YueKong
//
//  Created by WangXun on 15/2/6.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "DeviceSelectCollectionCell.h"

@interface DeviceSelectCollectionCell()

@property (nonatomic, weak) IBOutlet UILabel *lblText;

@end

@implementation DeviceSelectCollectionCell

- (void)awakeFromNib {
    // Initialization code
    UIView *aBg = [[UIView alloc] initWithFrame:self.bounds];
    aBg.backgroundColor = [UIColor blueColor];
    aBg.autoresizingMask = UIViewAutoresizingFlexibleWidth |     UIViewAutoresizingFlexibleHeight;
    self.selectedBackgroundView = aBg;
    
}

- (void)setTextOfCell:(NSString *)textOfCell
{
    _lblText.text = textOfCell;
    
}

@end
