//
//  RZPlaceHolderView.m
//  EntranceGuard
//
//  Created by 若醉 on 2018/4/25.
//  Copyright © 2018年 rztime. All rights reserved.
//

#import "RZPlaceHolderView.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBGRAY(value) RGBA(value, value, value, 1)

#define rzFont(font) [UIFont systemFontOfSize:font]
// 屏幕宽度
#define kScreenWidth          ([UIScreen mainScreen].bounds.size.width)
@interface RZPlaceHolderView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation RZPlaceHolderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBGRAY(245);
        [self textLabel];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
        }];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = rzFont(14);
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = RGBGRAY(153);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(20);
            make.left.mas_greaterThanOrEqualTo(self.contentView);
            make.right.mas_lessThanOrEqualTo(self.contentView);
            make.width.mas_lessThanOrEqualTo(@(kScreenWidth - 40));
            make.bottom.mas_lessThanOrEqualTo(self.contentView);
            make.centerX.equalTo(self.contentView);
        }];
    }
    return _textLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundColor:RGBA(30, 130, 30, 0.8)];
        _button.titleLabel.font = rzFont(14);
        [self.contentView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLabel.mas_bottom).offset(20);
            make.width.equalTo(@120);
            make.height.equalTo(@30);
            make.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.left.mas_greaterThanOrEqualTo(self.contentView);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        }];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 3;
    }
    _button.enabled = YES;
    return _button;
}

- (void)removeBtn {
    if (_button) {
        [_button removeFromSuperview];
    }
}

+ (RZPlaceHolderView *)showTo:(UIView *)view type:(RZPlaceHolderViewType)type message:(NSString *)msg handle:(void(^)(void))handle{
    return [self showTo:view type:type message:msg handle:handle btnHandle:nil];
}
+ (RZPlaceHolderView *)showTo:(UIView *)view type:(RZPlaceHolderViewType)type message:(NSString *)msg handle:(void(^)(void))handle btnHandle:(void(^)(void))btnHandle {
    __block RZPlaceHolderView *placeHolderView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[RZPlaceHolderView class]]) {
            placeHolderView = obj;
            *stop = YES;
        }
    }];
    
    if (!placeHolderView) {
        placeHolderView = [[RZPlaceHolderView alloc]initWithFrame:view.bounds];
    }
    placeHolderView.frame = ({
        CGRect frame = view.bounds;
        frame.origin.y = 0;
        frame;
    });
    
    if (type == RZPlaceHolderViewTypeNoData) {
        placeHolderView.imageView.image = [UIImage imageNamed:@"Rz_file_Resource.bundle/暂无数据"];
    } else if(type == RZPlaceHolderViewTypeNoServer) {
        placeHolderView.imageView.image = [UIImage imageNamed:@"Rz_file_Resource.bundle/暂无网络"];
    }
    
    if (handle && ![msg containsString:@"重试"] && type == RZPlaceHolderViewTypeNoServer) {
        msg = [NSString stringWithFormat:@"%@\n请点击屏幕重试", msg];
    }
    placeHolderView.textLabel.text = msg;
    
    if(handle) {
        
        [placeHolderView bk_whenTapped:^{
            if(handle) {
                handle();
            }
        }];
    }
    
    if(btnHandle) {
        [placeHolderView.contentView addSubview:placeHolderView.button];
        [placeHolderView.button bk_addEventHandler:^(id sender) {
            if (btnHandle) {
                btnHandle();
            }
        } forControlEvents:UIControlEventTouchUpInside];
    } else {
        [placeHolderView removeBtn];
    }
    [view layoutIfNeeded];
    [view addSubview:placeHolderView];
    return placeHolderView;
}

+ (void)removeFormView:(UIView *)view {
    __block RZPlaceHolderView *placeHolderView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[RZPlaceHolderView class]]) {
            placeHolderView = obj;
            *stop = YES;
        }
    }];
    if (placeHolderView) {
        [placeHolderView removeFromSuperview];
    }
}

@end
