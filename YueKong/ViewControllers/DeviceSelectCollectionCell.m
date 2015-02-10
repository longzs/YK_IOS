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
@property (nonatomic, weak) IBOutlet UIImageView *imgSelected;
@end

@implementation DeviceSelectCollectionCell

- (void)awakeFromNib {
    // Initialization code
//    UIView *aBg = [[UIView alloc] initWithFrame:self.bounds];
//    aBg.backgroundColor = [UIColor blueColor];
//    aBg.autoresizingMask = UIViewAutoresizingFlexibleWidth |     UIViewAutoresizingFlexibleHeight;
//    self.selectedBackgroundView = aBg;
    
}

- (void)setTextOfCell:(NSString *)textOfCell
{
    _lblText.text = textOfCell;
}

- (void)setShowSelected:(BOOL )bselected
{
    if (bselected) {
        _imgSelected.image = [UIImage imageNamed:@"menu_click_"];
    }
    else{
        _imgSelected.image =  nil;
    }
}

@end
