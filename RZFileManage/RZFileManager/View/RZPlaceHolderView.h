//
//  RZPlaceHolderView.h
//  EntranceGuard
//
//  Created by 若醉 on 2018/4/25.
//  Copyright © 2018年 rztime. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RZPlaceHolderViewType) {
    RZPlaceHolderViewTypeNoData = 0, // 无数据
    RZPlaceHolderViewTypeNoServer = 1, // 无服务（无网络，服务器报错）
};

@interface RZPlaceHolderView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *textLabel;
@property (nonatomic, strong) UIButton    *button;

+ (RZPlaceHolderView *)showTo:(UIView *)view type:(RZPlaceHolderViewType)type message:(NSString *)msg handle:(void(^)(void))handle;

+ (RZPlaceHolderView *)showTo:(UIView *)view type:(RZPlaceHolderViewType)type  message:(NSString *)msg handle:(void(^)(void))handle btnHandle:(void(^)(void))btnHandle;

+ (void)removeFormView:(UIView *)view;

@end
