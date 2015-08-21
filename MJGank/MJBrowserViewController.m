//
//  MJBrowserViewController.m
//
//
//  Created by WangMinjun on 15/7/28.
//
//

#import "MJBrowserViewController.h"
#import "MBProgressHUD.h"

@interface MJBrowserViewController ()

@property (nonatomic, strong) UIWebView* webView;

@end

@implementation MJBrowserViewController

- (void)viewDidLoad
{
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];

    [hud showAnimated:YES
        whileExecutingBlock:^{

            dispatch_sync(dispatch_get_main_queue(), ^{
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
                [self.webView loadRequest:request];
            });

        }
        completionBlock:^{
            [hud removeFromSuperview];
        }];
}

- (UIWebView*)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.webView];
    }
    return _webView;
}

@end
