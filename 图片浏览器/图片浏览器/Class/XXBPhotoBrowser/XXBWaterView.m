//
//  XXBWaterImageView.m
//  waterPreTest
//
//  Created by Jinhong on 15/2/9.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBWaterView.h"

@interface XXBWaterView ()

{
    NSInteger _waterSpeed;
    CGFloat water_x;
    CGFloat precent;
}
@property(nonatomic , weak)UIImageView *imageView;
@property(nonatomic , strong)NSTimer *animationTimer;
@end

@implementation XXBWaterView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupWaterView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupWaterView];
    }
    return self;
}

- (void)setupWaterView
{
    [self setBackgroundColor:[UIColor clearColor]];
}
/**
 *  开始动画
 */
- (void)waterAnimationStart
{
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}
/**
 *  结束动画
 */
- (void)waterAnimationStop
{
    [self.animationTimer invalidate];
    self.waterColor = [UIColor clearColor];
    [self animateWave];
}

-(void)animateWave
{
    water_x+=self.waterSpeed/100.0;
    
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画圆
    CGFloat viewHight = self.frame.size.height;
    CGFloat viewWidth = self.frame.size.width;
    CGFloat bigRadius = self.frame.size.width * 0.5;
    CGFloat centerX = viewWidth * 0.5;
    CGFloat centerY = viewHight * 0.5;
    CGContextAddArc(context,centerX , centerY, bigRadius, 0, M_PI * 2, 0);
    //切割
    CGContextClip(context);
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [self.waterColor CGColor]);
    
    float waterHight;
    CGFloat waterPrecent = 1- self.waterPrecent;
    CGPathMoveToPoint(path, NULL, 0, 0);
    for(float x=0;x<=viewWidth;x ++)
    {
        waterHight= self.waterMargin * sin( x/(self.waterCount * M_PI ) + 4 * water_x/M_PI ) * 5 + viewHight * waterPrecent;
        CGPathAddLineToPoint(path, nil, x, waterHight);
    }
    CGPathAddLineToPoint(path, nil, viewWidth, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGPathRelease(path);
}

#pragma mark - 懒加载
- (UIColor *)waterColor
{
    if(_waterColor == nil)
    {
        _waterColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1];
        
    }
    return _waterColor;
}
- (NSTimer *)animationTimer
{
    if (_animationTimer == nil) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
    }
    return _animationTimer;
}
- (CGFloat)waterPrecent
{
    if (_waterPrecent <= 0) {
        _waterPrecent = 0.2;
    }
    return  _waterPrecent;
}
- (CGFloat)waterMargin
{
    if (_waterMargin <= 0) {
        _waterMargin = 1;
    }
    return _waterMargin;
}
- (NSInteger)waterSpeed
{
    if (_waterSpeed <= 0) {
        _waterSpeed = 2;
    }
    return _waterSpeed;
}
- (CGFloat)waterCount
{
    if (_waterCount <= 0) {
        _waterCount = 9;
    }
    return _waterCount;
}
- (UIImageView *)imageView
{
    if (_image == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}
@end
