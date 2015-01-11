//
//  EHWebViewController.m
//  EHealth
//
//  Created by WangXun on 14/12/15.
//  Copyright (c) 2014年 focuschina. All rights reserved.
//

#import "EHWebViewController.h"


@interface EHWebViewController ()
<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation EHWebViewController
#pragma mark - Basic
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_titleString) {
        self.title = _titleString;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if (_urlString) {
        NSString *codedUrlString = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:codedUrlString]];
        [_webView loadRequest:request];
    }
                             
}

+ (instancetype)instantiateFromMainStoryboard
{
    return (EHWebViewController *)[Utils controllerStroyboardWithName:@"AdditionalFun" storyboardID:@"EHWebViewController"];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoading];
    
    [Utils showSimpleAlert:@"网络错误，请稍候再试"];
}

@end
