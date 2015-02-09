//
//  EHListPickerView.m
//  EHealth
//
//  Created by WangXun on 15/1/27.
//  Copyright (c) 2015年 focuschina. All rights reserved.
//

#import "YKButtonPopoverView.h"

#define kTagCellText 20002
#define kTagCellCheckBox 20001

//高度，宽度
#define kWidthDefault 270.0f
#define kHeightDefault 175.0f
#define kHeightButton 40.0f

#define kMarginHorizontal 18.0f
#define kMarginVertical 17.0f
#define kSpacingVertical 10.0f

#define kFrameCheckBoxButton CGRectMake(205,22.5,15,15)
#define kFrameTableDefault CGRectMake(0,45,kWidthDefault,kHeightMin-45)
#define kFrameText CGRectMake(kMarginHorizontal,0,kWidthDefault-55,kHeightCell)

//颜色，字体
#define kColorButton RGB(80, 80, 80)
#define kFontButton [UIFont systemFontOfSize:17.0f]

#define kTagButtonBase 1000

@interface YKButtonPopoverView()

/**
 *  展示的点，UIWindow坐标
 */
@property (nonatomic) CGPoint showPoint;

@property (nonatomic, weak) UIButton *btnMask;

@property (nonatomic, strong) NSArray *aryTitle;
@property (nonatomic, strong) NSArray *aryImg;
@property (nonatomic, strong) UIView *customView;

@end

@implementation YKButtonPopoverView

#pragma mark - Initialization
- (instancetype)initWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidthDefault, kHeightDefault)];
    if (self) {
        _aryTitle = titleArray;
        _aryImg = imageArray;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidthDefault, kHeightDefault)];
    if (self) {
        _customView = customView;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    //bg
    UIImageView *imvBG = [[UIImageView alloc] initWithFrame:self.bounds];
    imvBG.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIImage *resizeedImage = [UIImage imageNamed:@"bg_window_670x315.png"];
    imvBG.image = resizeedImage;
    [self addSubview:imvBG];
    
    //
    if (_customView) {
        _customView.frame = self.bounds;
        [self addSubview:_customView];
    }
    else {
        CGFloat currentY = kMarginVertical;
        for (int i = 0; i < _aryTitle.count; i++) {
            UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(kMarginHorizontal, currentY, self.bounds.size.width - kMarginHorizontal*2, kHeightButton)];
            [aButton setBackgroundImage:[UIImage imageNamed:@"button_510x80_normal.png"] forState:UIControlStateNormal];
            [aButton setBackgroundImage:[UIImage imageNamed:@"button_510x80_click.png"] forState:UIControlStateHighlighted];
            [aButton setTitleColor:kColorButton forState:UIControlStateNormal];
            [aButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];

            if (i < _aryImg.count) {
                UIImage *buttonImg = _aryImg[i];
                [aButton setImage:buttonImg forState:UIControlStateNormal];
            }
            
            [aButton setTitle:_aryTitle[i] forState:UIControlStateNormal];
            
            [aButton setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 10)];
            [aButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 10)];
            aButton.tag = kTagButtonBase + i;
            [aButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:aButton];
            currentY += kHeightButton + kSpacingVertical;
            
        }
        
    }

}


#pragma mark - Method
- (void)show
{
    UIButton *btnMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMask setFrame:[UIScreen mainScreen].bounds];
    [btnMask setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    [btnMask addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btnMask.alpha = 0.0f;
    [btnMask addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:btnMask];
    self.btnMask = btnMask;
    
//    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:btnMask];
    self.center = CGPointMake(btnMask.bounds.size.width/2, btnMask.bounds.size.height/2);
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
        btnMask.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
        self.btnMask.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        [self.btnMask removeFromSuperview];
    }];
}

- (void)clickButton:(UIButton *)sender
{
    NSInteger index = sender.tag - kTagButtonBase;
    if (self.selectIndexBlock) {
        self.selectIndexBlock(index);
    }
}

@end
