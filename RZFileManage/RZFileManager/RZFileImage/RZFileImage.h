//
//  RZFileImage.h
//  EntranceGuard
//
//  Created by 若醉 on 2018/5/7.
//  Copyright © 2018年 rztime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 常用文件类型
 音频
 视频
 word
 excel
 ppt
 pdf
 txt
 zip
 图片
 其他
 */
@interface RZFileImage : NSObject

/** 通过文件类型获取到对应的图片 */
+ (UIImage *)imageByType:(NSString *)fileType;


+ (instancetype)appearance;
// 自定义对应文件类型的图片
@property (nonatomic, copy) NSString *musicImageName;
@property (nonatomic, copy) NSString *videoImageName;
@property (nonatomic, copy) NSString *wordTypeImageName;
@property (nonatomic, copy) NSString *excelImageName;
@property (nonatomic, copy) NSString *pptImageName;
@property (nonatomic, copy) NSString *pdfImageName;
@property (nonatomic, copy) NSString *txtImageName;
@property (nonatomic, copy) NSString *zipImageName;
@property (nonatomic, copy) NSString *imageFileImageName;
@property (nonatomic, copy) NSString *noneImageName;

@end
