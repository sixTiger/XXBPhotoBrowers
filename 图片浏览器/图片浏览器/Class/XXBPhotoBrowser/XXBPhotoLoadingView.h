//
//  XXBPhotoLoadingView.h
//  图片浏览器
//
//  Created by Jinhong on 15/2/25.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

//默认进度
#define kMinProgress 0.0001
@interface XXBPhotoLoadingView : UIView

/**
 *  百分比
 */
@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure;
@end
