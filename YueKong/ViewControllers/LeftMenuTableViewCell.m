//
//  LeftMenuTableViewCell.m
//  YueKong
//
//  Created by WangXun on 15/3/25.
//  Copyright (c) 2015年 yuekong. All rights reserved.
//

#import "LeftMenuTableViewCell.h"

#define kColorNomarl RGB(201, 201, 201)
#define kColorSelect RGB(40, 140, 225)
#define kColorDisable RGB(70, 70, 70)

@interface LeftMenuTableViewCell()

@property (nonatomic, strong) UIImage *imgNomarl;
@property (nonatomic, strong) UIImage *imgSelect;
@property (nonatomic, strong) UIImage *imgDisable;

@property (nonatomic, weak) IBOutlet UIImageView *imvIcon;
@property (nonatomic, weak) IBOutlet UIImageView *imvArrow;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@end

@implementation LeftMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (_cellDisable) {
        return;
    }
    
    if (selected) {
        _imvIcon.image = _imgSelect;
        _imvArrow.highlighted = YES;
        _lblTitle.textColor = kColorSelect;
    
    }
    else {
        _imvIcon.image = _imgNomarl;
        _imvArrow.highlighted = NO;
        _lblTitle.textColor = kColorNomarl;
    }
    
}

- (void)setCellTitle:(NSString *)cellTitle
{
    _lblTitle.text = cellTitle;
}

- (NSString *)cellTitle
{
    return _lblTitle.text;
}

- (void)setCellDisable:(BOOL)cellDisable
{
    if (_cellDisable == cellDisable) {
        return;
    }
    _cellDisable = cellDisable;
    if (_cellDisable) {
        _imvIcon.image = _imgDisable;
        _lblTitle.textColor = kColorDisable;
    }
    else {
        _imvIcon.image = _imgNomarl;
        _lblTitle.textColor = kColorNomarl;
    }
}

- (void)setCellState:(LeftMenuTableViewCellState)cellState
{
    NSString *nameNomral = nil;
    NSString *nameSelect = nil;
    NSString *nameDisable = nil;
    switch (cellState) {
        case LeftMenuTableViewCellStateNomarl:
            nameNomral = @"icon_UCON01_white.png";
            nameSelect = @"icon_UCON01_blue.png";
            nameDisable = @"icon_UCON01_gray.png";
            break;
        case LeftMenuTableViewCellStateFull:
            nameNomral = @"icon_UCON02_white.png";
            nameSelect = @"icon_UCON02_blue.png";
            nameDisable = @"icon_UCON02_gray.png";
            break;
        case LeftMenuTableViewCellStateAddNew:
            nameNomral = @"icon_UCONadd_white.png";
            nameSelect = @"icon_UCONadd_blue.png";
            nameDisable = @"icon_UCONadd_gray.png";
            break;
        default:
            break;
    }
    
    _imgNomarl = [UIImage imageNamed:nameNomral];
    _imgSelect = [UIImage imageNamed:nameSelect];
    _imgDisable = [UIImage imageNamed:nameDisable];
    
    _imvIcon.image = _imgNomarl;
    
}


@end
