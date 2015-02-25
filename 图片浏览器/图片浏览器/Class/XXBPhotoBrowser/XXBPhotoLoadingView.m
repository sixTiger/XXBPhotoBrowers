//
//  XXBPhotoLoadingView.m
//  图片浏览器
//
//  Created by 小小兵 on 15/2/25.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBPhotoLoadingView.h"
#import "XXBWaterView.h"

@interface XXBPhotoLoadingView ()
{
    UILabel *_failureLabel;
    XXBWaterView *_progressView;
}
@end

@implementation XXBPhotoLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)showFailure
{
    [_progressView removeFromSuperview];
    
    if (_failureLabel == nil) {
        _failureLabel = [[UILabel alloc] init];
        _failureLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 44);
        _failureLabel.textAlignment = NSTextAlignmentCenter;
        _failureLabel.center = self.center;
        _failureLabel.text = @"网络不给力，图片下载失败";
        _failureLabel.font = [UIFont boldSystemFontOfSize:20];
        _failureLabel.textColor = [UIColor whiteColor];
        _failureLabel.backgroundColor = [UIColor clearColor];
        _failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    [self addSubview:_failureLabel];
}

- (void)showLoading
{
    [_failureLabel removeFromSuperview];
    
    if (_progressView == nil) {
        _progressView = [[XXBWaterView alloc] init];
        _progressView.bounds = CGRectMake( 0, 0, 100, 100);
        _progressView.waterMargin = 0.3;
        _progressView.waterCount = 3;
        _progressView.center = self.center;
        [_progressView waterAnimationStart];
    }
    _progressView.waterPrecent = kMinProgress;
    [self addSubview:_progressView];
}

#pragma mark - customlize method
- (void)setProgress:(float)progress
{
    _progress = progress;
    _progressView.waterPrecent = progress;
    if (progress >= 1.0) {
        [_progressView waterAnimationStop];
        [_progressView removeFromSuperview];
    }
}

@end
