//
//  RZFilePreview.h
//  EntranceGuard
//
//  Created by 若醉 on 2018/5/8.
//  Copyright © 2018年 rztime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RZFilePreview : UIViewController

/**
 预览文件
 */
+ (void)previewFileURL:(NSString *)url;
/**
 预览文件 (如果是图片点击进入，可以走这个)
 */
+ (void)previewFileURL:(NSString *)url actionView:(UIView *)actionView;

/**
 预览图片
 
 @param images 可以是image；也可以是url
 @param view 当前显示的view
 @param index 当前的索引
 */
+ (void)rz_imageBrowser:(NSArray *)images from:(UIView *)view index:(NSInteger)index;
@end

@interface RZFilePreview (fileType)
// fileType：URL的后缀，如MP3，png
+ (BOOL)isMusic:(NSString *)fileType;
+ (BOOL)isVideo:(NSString *)fileType;
+ (BOOL)isWord:(NSString *)fileType;
+ (BOOL)isExcel:(NSString *)fileType;
+ (BOOL)isPPT:(NSString *)fileType;
+ (BOOL)isPDF:(NSString *)fileType;
+ (BOOL)isTXT:(NSString *)fileType;
+ (BOOL)isZip:(NSString *)fileType;
+ (BOOL)isImage:(NSString *)fileType;

@end
