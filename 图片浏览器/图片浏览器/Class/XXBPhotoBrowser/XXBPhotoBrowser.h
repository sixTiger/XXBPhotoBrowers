//
//  XXBPhotoBrowser.h
//  图片浏览器
//
//  Created by 小小兵 on 15/2/25.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXBPhotoBrowser;
@protocol XXBPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
- (void)photoBrowser:(XXBPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end
@interface XXBPhotoBrowser : UIViewController

// 代理
@property (nonatomic, weak) id<XXBPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

// 显示
- (void)show;

@end
