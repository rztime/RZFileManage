//
//  RZFileImage.m
//  EntranceGuard
//
//  Created by 若醉 on 2018/5/7.
//  Copyright © 2018年 rztime. All rights reserved.
//

#import "RZFileImage.h"
#import "RZFilePreview.h"

#define rz_file_name(name) [NSString stringWithFormat:@"RZFileImage.bundle/%@", name]

@implementation RZFileImage
/** 通过文件类型获取到对应的图片 */
+ (UIImage *)imageByType:(NSString *)fileType {
    RZFileImage *images = [RZFileImage appearance];
    if ([RZFilePreview isMusic:fileType]) {
        return [UIImage imageNamed:images.musicImageName];
    }
    if ([RZFilePreview isVideo:fileType]) {
        return [UIImage imageNamed:images.videoImageName];
    }
    if ([RZFilePreview isWord:fileType]) {
        return [UIImage imageNamed:images.wordTypeImageName];
    }
    if ([RZFilePreview isExcel:fileType]) {
        return [UIImage imageNamed:images.excelImageName];
    }
    if ([RZFilePreview isPPT:fileType]) {
        return [UIImage imageNamed:images.pptImageName];
    }
    if ([RZFilePreview isPDF:fileType]) {
        return [UIImage imageNamed:images.pdfImageName];
    }
    if ([RZFilePreview isTXT:fileType]) {
        return [UIImage imageNamed:images.txtImageName];
    }
    if ([RZFilePreview isZip:fileType]) {
        return [UIImage imageNamed:images.zipImageName];
    }
    if ([RZFilePreview isImage:fileType]) {
        return [UIImage imageNamed:images.imageFileImageName];
    }
    return [UIImage imageNamed:images.noneImageName];
}

+ (instancetype) appearance {
    static RZFileImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        image = [[RZFileImage alloc] init];
    });
    return image;
}

- (instancetype)init {
    if (self = [super init]) {
        self.musicImageName = rz_file_name(@"音频");
        self.videoImageName = rz_file_name(@"视频");
        self.wordTypeImageName = rz_file_name(@"word");
        self.excelImageName = rz_file_name(@"excel");
        self.pptImageName = rz_file_name(@"PPT");
        self.pdfImageName = rz_file_name(@"PDF");
        self.txtImageName = rz_file_name(@"txt");
        self.zipImageName = rz_file_name(@"压缩包");
        self.imageFileImageName = rz_file_name(@"图片");
        self.noneImageName = rz_file_name(@"未知类型");
    }
    return self;
}
@end
