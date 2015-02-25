//
//  SDWebImageManager+XXB.h
//  图片浏览器
//
//  Created by Jinhong on 15/2/25.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//  预先下载图片的

#import "SDWebImageManager.h"

@interface SDWebImageManager (XXB)
// 预先下载图片
+ (void)downloadWithURL:(NSURL *)url;
@end
