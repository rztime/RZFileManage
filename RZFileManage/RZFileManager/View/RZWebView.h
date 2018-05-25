//
//  RZWebView.h
//  EntranceGuard
//
//  Created by 若醉 on 2018/5/7.
//  Copyright © 2018年 rztime. All rights reserved.
//

#import <WebKit/WebKit.h>


@interface RZWebView : WKWebView


/**
 自动适配文字和图片大小 必须设置view的width 默认YES
 */
@property (nonatomic, assign) BOOL autoFitScreenWidth;

@property (nonatomic, copy) NSString *html;

/**
 加载完成之后的回调
 */
@property (nonatomic, copy) void(^didFinishLoadHtml)(NSError *error, CGFloat bodyHeight);
/**
 加载中进度回调
 */
@property (nonatomic, copy) void(^loadProgress)(CGFloat progress, BOOL finish);

/**
 显示进度条 默认YES
 */
@property (nonatomic, assign) BOOL showProgressView;
@end
