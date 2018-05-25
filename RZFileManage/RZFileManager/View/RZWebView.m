//
//  RZWebView.m
//  EntranceGuard
//
//  Created by 若醉 on 2018/5/7.
//  Copyright © 2018年 rztime. All rights reserved.
//

#import "RZWebView.h"

// 屏幕宽度
#define kScreenWidth          ([UIScreen mainScreen].bounds.size.width)

@interface RZWebView()<WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation RZWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.navigationDelegate = self;
        self.showProgressView = YES;
        _autoFitScreenWidth = YES;
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 4)];
        self.progressView.backgroundColor = [UIColor whiteColor];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)setHtml:(NSString *)html {
    _html = html;
    
    if (_autoFitScreenWidth) {
        if (![_html hasPrefix:@"<header>"]) {
            NSString *headerString = [NSString stringWithFormat:@"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:%fpx !important;}</style></header>", self.frame.size.width - 20];
            _html = [headerString stringByAppendingString:_html];
        }
    }
    [self loadHTMLString:_html baseURL:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"body Height :%@", result);
        if (weakSelf.didFinishLoadHtml) {
            weakSelf.didFinishLoadHtml(nil, [result floatValue]);
        }
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.didFinishLoadHtml) {
        self.didFinishLoadHtml(error, CGFLOAT_MIN);
    }
}
- (void)dealloc {
    NSLog(@"网页销毁");
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(self.loadProgress) {
        self.loadProgress(0, NO);
    }
    if (self.showProgressView) {
        [self progress:0 finish:NO];
    } else {
        self.progressView.hidden = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if(self.loadProgress) {
            self.loadProgress(self.estimatedProgress, self.estimatedProgress == 1);
        }
        if (self.showProgressView) {
            [self progress:self.estimatedProgress finish:self.estimatedProgress == 1];
        } else {
            self.progressView.hidden = YES;
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)progress:(CGFloat)progress finish:(BOOL)finish {
    self.progressView.progress = progress;
    if (finish) {
        /*
         *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
         *动画时长0.25s，延时0.3s后开始动画
         *动画结束后将progressView隐藏
         */
        
        [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
        } completion:^(BOOL finished) {
            self.progressView.hidden = YES;
            
        }];
    } else {
        //开始加载网页时展示出progressView
        self.progressView.hidden = NO;
        //开始加载网页的时候将progressView的Height恢复为1.5倍
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        //防止progressView被网页挡住
        [self bringSubviewToFront:self.progressView];
    }
}

@end
