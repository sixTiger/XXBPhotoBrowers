//
//  XXBPhoto.m
//  图片浏览器
//
//  Created by Jinhong on 15/2/25.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBPhoto.h"

@implementation XXBPhoto
#pragma mark 截图
- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView
{
    _srcImageView = srcImageView;
    _placeholder = srcImageView.image;
    if (srcImageView.clipsToBounds) {
        _capture = [self capture:srcImageView];
    }
}
@end
