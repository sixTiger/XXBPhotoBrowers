//
//  XXBWaterImageView.h
//  waterPreTest
//
//  Created by Jinhong on 15/2/9.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//  为了保证最佳的效果 这个view请设置成正方形的

#import <UIKit/UIKit.h>

@interface XXBWaterView : UIView
/**
 *  圆球的百分比
 */
@property(nonatomic , assign)CGFloat waterPrecent;
/**
 *  水纹的速率 默认值是2
 */
@property(nonatomic , assign)NSInteger waterSpeed;
/**
 *  水纹的波动幅度 默认是1
 */
@property(nonatomic , assign)CGFloat waterMargin;
/**
 *  一个窗口中出现的水波的个数相关参数 waterCount越大 水波的个数越少
 */
@property(nonatomic , assign)CGFloat waterCount;
/**
 *  水纹的颜色
 */
@property(nonatomic , strong)UIColor *waterColor;
/**
 *  要显示的图片
 */
@property(nonatomic , strong)UIImage *image;
/**
 *  开始动画
 */
- (void)waterAnimationStart;
/**
 *  结束动画
 */
- (void)waterAnimationStop;

@end
