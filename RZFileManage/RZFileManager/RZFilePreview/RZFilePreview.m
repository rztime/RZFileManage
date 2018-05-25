//
//  RZFilePreview.m
//  EntranceGuard
//
//  Created by 若醉 on 2018/5/8.
//  Copyright © 2018年 rztime. All rights reserved.
//

#import "RZFilePreview.h"
#import "RZWebView.h"
#import "RZPlaceHolderView.h"
#import <KSPhotoBrowser.h>

#define RGBGRAY(value) [UIColor colorWithRed:value/255.0 green:value/255.0 blue:value/255.0 alpha:1]
// 屏幕宽度
#define kScreenWidth          ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define kScreenHeight         ([UIScreen mainScreen].bounds.size.height)
// 导航栏高度
#define kNavBarHeight 44.f
// 状态栏高度
#define kStatusBarHeight (kiPhoneX ? 44.f: 20.f)
// 导航栏+状态栏高度
#define kNavHeight (kNavBarHeight + kStatusBarHeight)

// 是否是iPhone X
#define kiPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))
@interface RZFilePreview ()

@property (nonatomic, strong) RZWebView *webView;
@property (nonatomic, copy)   NSString *url;

@end

@implementation RZFilePreview

- (void)dealloc {
    NSLog(@"文件预览，销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBGRAY(245);
    self.title = [self.url lastPathComponent];
    
    _webView = [[RZWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, self.view.frame.size.height - kNavHeight)];
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_webView];
    


    [self loadURL];
    __weak typeof(self) weakSelf = self;
    self.webView.loadProgress = ^(CGFloat progress, BOOL finish) {
       
    };
    
    self.webView.didFinishLoadHtml = ^(NSError *error, CGFloat bodyHeight) {
        if (error) {
            [RZPlaceHolderView showTo:weakSelf.view type:RZPlaceHolderViewTypeNoServer message:error.domain handle:^{
                [weakSelf loadURL];
            }];
        } else {
            [RZPlaceHolderView removeFormView:weakSelf.view];
        }
    };
}
- (void)loadURL {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

#pragma mark - 预览
/**
 预览文件
 */
+ (void)previewFileURL:(NSString *)url {
    [self previewFileURL:url actionView:nil];
}

+ (void)previewFileURL:(NSString *)url actionView:(UIView *)actionView {
    NSString *houzuiName = [url pathExtension];
    if ([self isImage:houzuiName]) {
        [self rz_imageBrowser:@[url] from:actionView index:0];
        return ;
    }
    RZFilePreview *vc = [[RZFilePreview alloc] init];
    vc.url = url;
    [self.currentViewController.navigationController pushViewController:vc animated:YES];
}


+ (void)rz_imageBrowser:(NSArray *)images from:(UIView *)view index:(NSInteger)index {
    NSMutableArray *items = [NSMutableArray new];
    UIImageView *imageView;
    BOOL needRemove = NO;
    if ([view isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *)view;
    } else if(view) {
        needRemove = YES;
        CGRect frame = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
        imageView = [[UIImageView alloc] initWithFrame:frame];
        [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    }
    
    for (id image in images) {
        if ([image isKindOfClass:[UIImage class]]) {
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:image];
            [items addObject:item];
        } else {
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:image]];
            [items addObject:item];
        }
    }
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    [browser showFromViewController:self.currentViewController];
    if (needRemove) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [imageView removeFromSuperview];
        });
    }
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [self getCurrentVCFrom:[rootVC presentedViewController]];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }  else if([rootVC  isKindOfClass:[NSClassFromString(@"RTContainerController") class]]){
        // 根视图为非导航类
        currentVC = [self getCurrentVCFrom:[rootVC valueForKeyPath:@"contentViewController"]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)currentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    if ([currentVC isMemberOfClass:[NSClassFromString(@"RTContainerController") class]]) {
        return [currentVC valueForKeyPath:@"contentViewController"];
    }
    return currentVC;
}


#pragma mark - 文件类型判断
+ (BOOL)isMusic:(NSString *)fileType {
    NSArray *types = @[@"mp3", @"MP3",
                       @"WAV", @"wav",
                       @"WMA", @"wma",
                       @"CD", @"cd",
                       @"APE", @"ape",
                       @"MIDI", @"midi",
                       @"RealAudio", @"REALAUDIO", @"realaudio",
                       @"VQF", @"vqf",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isVideo:(NSString *)fileType {
    NSArray *types = @[@"AVI", @"avi",
                       @"RMVB", @"rmvb",
                       @"RM", @"rm",
                       @"ASF", @"asf",
                       @"DIVX", @"divx",
                       @"MPG", @"mpg",
                       @"MPEG", @"mpeg",
                       @"WMV", @"wmv",
                       @"MP4", @"mp4",
                       @"MKV", @"mkv",
                       @"VOB", @"vob",
                       ];
    
    return [types containsObject:fileType];
}
+ (BOOL)isWord:(NSString *)fileType {
    NSArray *types = @[@"DOC", @"doc",
                       @"DOCX", @"docx",
                       @"DOCM", @"docm",
                       @"DOTX", @"dotx",
                       @"DOTM", @"dotm",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isExcel:(NSString *)fileType {
    NSArray *types = @[@"XLS", @"xls",
                       @"XLSX", @"xlsx",
                       @"XLSM", @"xlsm",
                       @"XLTX", @"xltx",
                       @"XLTM", @"xltm",
                       @"XLSB", @"xlsb",
                       @"XLAM", @"xlam",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isPPT:(NSString *)fileType {
    NSArray *types = @[@"PPT", @"ppt",
                       @"PPTX", @"pptx",
                       @"PPTM", @"pptm",
                       @"PPSX", @"ppsx",
                       @"PPTX", @"potx",
                       @"POTM", @"potm",
                       @"PPAM", @"ppam",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isPDF:(NSString *)fileType {
    NSArray *types = @[@"PDF", @"pdf"];
    
    return [types containsObject:fileType];
}

+ (BOOL)isTXT:(NSString *)fileType {
    NSArray *types = @[@"TXT", @"txt",
                       @"HTM", @"htm",
                       @"ASP", @"asp",
                       @"BAT", @"bat",
                       @"C", @"c",
                       @"BAS", @"bas",
                       @"PRG", @"prg",
                       @"CMD", @"cmd",
                       @"LOG", @"log",
                       @"RTF", @"rtf",
                       ];
    
    return [types containsObject:fileType];
}


+ (BOOL)isZip:(NSString *)fileType {
    NSArray *types = @[@"ZIP", @"zip",
                       @"RAR", @"rar",
                       @"7Z", @"7z",
                       @"CAB", @"cab",
                       @"ISO", @"iso",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isImage:(NSString *)fileType {
    NSArray *types = @[@"BMP", @"bmp",
                       @"JPG", @"jpg",
                       @"PNG", @"png",
                       @"TIFF", @"tiff",
                       @"GIF", @"gif",
                       @"PCX", @"pcx",
                       @"TGA", @"tga",
                       @"EXIF", @"exif",
                       @"FPX", @"fpx",
                       @"SVG", @"svg",
                       @"PSD", @"psd",
                       @"CDR", @"cdr",
                       @"PCD", @"pcd",
                       @"DXF", @"dxf",
                       @"UFO", @"ufo",
                       @"EPS", @"eps",
                       @"AI", @"ai",
                       @"RAW", @"raw",
                       @"WMF", @"WMF",
                       @"WEBP", @"webp",
                       ];
    
    return [types containsObject:fileType];
}
@end
