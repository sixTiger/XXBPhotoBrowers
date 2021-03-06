//
//  XXBPhotoBrowser.m
//  图片浏览器
//
//  Created by 小小兵 on 15/2/25.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBPhotoBrowser.h"
#import "XXBPhoto.h"
#import "XXBPhotoView.h"
#import "SDWebImageManager+XXB.m"
#import "XXBPhotoToolbar.h"
#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface XXBPhotoBrowser ()<UIScrollViewDelegate , XXBPhotoViewDelegate>
{
    // 滚动的view
    UIScrollView *_photoScrollView;
    // 所有的图片view
    NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
    // 工具条
    XXBPhotoToolbar *_toolbar;
}
@end

@implementation XXBPhotoBrowser
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.创建UIScrollView
    [self createScrollView];
    // 2.创建工具条
    [self createToolbar];
}
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
#pragma mark -  这里直接来了个背景色 可以来一个背景图片
    self.view.backgroundColor = [UIColor blackColor];
    [window.rootViewController addChildViewController:self];
    if (_currentPhotoIndex == 0)
    {
        [self showPhotos];
    }
}
#pragma mark 创建工具条
- (void)createToolbar
{
    CGFloat barHeight = 44;
    CGFloat barY = self.view.frame.size.height - barHeight;
    _toolbar = [[XXBPhotoToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.photos = _photos;
    [self.view addSubview:_toolbar];
    [self updateTollbarState];
}
#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
    _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
    [self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    if (photos.count > 1)
    {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    for (int i = 0; i<_photos.count; i++)
    {
        XXBPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}
#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    for (int i = 0; i<_photos.count; i++)
    {
        XXBPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    if ([self isViewLoaded])
    {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width , 0);
        // 显示所有的相片
        [self showPhotos];
    }
}
#pragma mark - XXBPhotoView代理
- (void)photoViewSingleTap:(XXBPhotoView *)photoView
{
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    [_toolbar removeFromSuperview];
}
- (void)photoViewDidEndZoom:(XXBPhotoView *)photoView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
//工具条相关
- (void)photoViewImageFinishLoad:(XXBPhotoView *)photoView
{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}
#pragma mark 显示照片
- (void)showPhotos
{
    // 只有一张图片
    if (_photos.count == 1)
    {
        [self showPhotoViewAtIndex:0];
        return;
    }
    CGRect visibleBounds = _photoScrollView.bounds;
    NSInteger firstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
    // 回收不再显示的ImageView
    NSInteger photoViewIndex;
    for (XXBPhotoView *photoView in _visiblePhotoViews)
    {
        photoViewIndex = kPhotoViewIndex(photoView);
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex)
        {
            [_reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2)
    {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    for (NSUInteger index = firstIndex; index <= lastIndex; index++)
    {
        if (![self isShowingPhotoViewAtIndex:index])
        {
            [self showPhotoViewAtIndex:index];
        }
    }
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSInteger)index
{
    XXBPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView)
    { // 添加新的图片view
        photoView = [[XXBPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;

    XXBPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}
#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(NSInteger)index
{
    if (index > 0)
    {
        XXBPhoto *photo = _photos[index - 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
    if (index < _photos.count - 1)
    {
        XXBPhoto *photo = _photos[index + 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
}
#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index
{
    for (XXBPhotoView *photoView in _visiblePhotoViews)
    {
        if (kPhotoViewIndex(photoView) == index)
        {
            return YES;
        }
    }
    return  NO;
}

#pragma mark 循环利用某个view
- (XXBPhotoView *)dequeueReusablePhotoView
{
    XXBPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}
#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width + 0.5;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self showPhotos];
    [self updateTollbarState];
}
@end
