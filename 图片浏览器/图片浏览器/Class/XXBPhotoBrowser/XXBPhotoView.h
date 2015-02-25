//
//  XXBPhotoView.h
//  图片浏览器
//
//  Created by Jinhong on 15/2/25.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXBPhotoView , XXBPhoto;

@protocol XXBPhotoViewDelegate <NSObject>

- (void)photoViewImageFinishLoad:(XXBPhotoView *)photoView;
- (void)photoViewSingleTap:(XXBPhotoView *)photoView;
- (void)photoViewDidEndZoom:(XXBPhotoView *)photoView;

@end


@interface XXBPhotoView : UIScrollView

// 图片
@property (nonatomic, strong) XXBPhoto *photo;
// 代理
@property (nonatomic, weak) id<XXBPhotoViewDelegate> photoViewDelegate;
@end
