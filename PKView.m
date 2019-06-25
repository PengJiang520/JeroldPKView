//
//  PKView.m
//  动态圆柱
//
//  Created by jerold on 2019/5/27.
//  Copyright © 2019 CodingFire. All rights reserved.
//

#import "PKView.h"
#define kViewWidth(View) CGRectGetWidth(View.frame)
#define kViewHeight(View) CGRectGetHeight(View.frame)
#define JERGAP 5

@interface PKView()
@property (strong, nonatomic)CAGradientLayer *leftLayer,*rightLayer;//左右两个view的动画layer
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) float leftRate;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end


@implementation PKView


//- (void)drawRect:(CGRect)rect {
//
//}

#pragma mark -- init
- (instancetype)initWithLeftRate:(float)leftRate frame:(CGRect)frame
{
    //votedNum代表左边leftview占的比例
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWIthLeftRate:leftRate frame:(CGRect)frame];
    }
    return self;
}

- (void)commonInitWIthLeftRate:(float)leftRate frame:(CGRect)frame
{
    self.frame = frame;
    if (leftRate==0) {
        leftRate = 0.12;
    }else if (leftRate==1) {
        leftRate = 0.88;
    }
    self.leftRate = leftRate;
    float rightRate = 1 - leftRate;
    
    self.leftLayer.frame =  CGRectMake(0, 0, leftRate*self.frame.size.width+JERGAP, self.frame.size.height);
    self.rightLayer.frame = CGRectMake(self.leftLayer.frame.size.width-JERGAP-2,0, rightRate*self.frame.size.width+JERGAP, self.frame.size.height);
    if (self.leftLayer.superlayer || self.rightLayer.superlayer) {
        [self.leftLayer removeFromSuperlayer];
        [self.rightLayer removeFromSuperlayer];
    }
    [self.layer addSublayer:self.leftLayer];
    [self.layer addSublayer:self.rightLayer];//test
    
    //遮罩
    // 添加路径关键点array
    NSMutableArray *pointArray = [NSMutableArray array];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, 0.f))];//1st point
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(self.leftLayer)-2*JERGAP, 0.f))];//2nd point
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(self.leftLayer), self.leftLayer.frame.size.height))];//3th point
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, kViewHeight(self.leftLayer)))];//4th point
    CAShapeLayer *shapLayerLeft = [CAShapeLayer layer];
    shapLayerLeft.path = [self getPathByPoints:pointArray].CGPath;
    self.leftLayer.mask = shapLayerLeft;//test
    
    NSMutableArray *pointArray1 = [NSMutableArray array];
    [pointArray1 addObject:NSStringFromCGPoint(CGPointMake(0.f, 0.f))];
    [pointArray1 addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(self.rightLayer), 0.f))];
    [pointArray1 addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(self.rightLayer), self.rightLayer.frame.size.height))];
    [pointArray1 addObject:NSStringFromCGPoint(CGPointMake(2*JERGAP, kViewHeight(self.rightLayer)))];
    CAShapeLayer *shapLayerRight = [CAShapeLayer layer];
    shapLayerRight.path = [self getPathByPoints:pointArray1].CGPath;
    self.rightLayer.mask = shapLayerRight;
    
    [self updateAnimation];
    
}



#pragma mark -- 动画
- (void)updateAnimation
{
    
    //动画
    [self animateWithLayerFromBounds:CGRectMake(0, 0, 0, self.leftLayer.bounds.size.height) toBounds:CGRectMake(0,0,self.leftLayer.bounds.size.width,self.leftLayer.bounds.size.height) Layer:self.leftLayer positionFrom:CGPointMake(-(self.leftLayer.bounds.size.width/2.0), self.bounds.size.height/2.0) potionTo:CGPointMake(self.leftLayer.bounds.size.width/2.0, self.bounds.size.height/2.0)];
    
    [self animateWithLayerFromBounds:CGRectMake(0, 0, 0, self.rightLayer.frame.size.height) toBounds:CGRectMake(0,0,self.rightLayer.frame.size.width+JERGAP,self.rightLayer.frame.size.height) Layer:self.rightLayer positionFrom:CGPointMake(self.frame.size.width+(self.rightLayer.frame.size.width/2.0), self.frame.size.height/2.0) potionTo:CGPointMake(self.leftLayer.frame.size.width-2*JERGAP + self.rightLayer.frame.size.width/2.0 + JERGAP, self.frame.size.height/2.0)];
}

- (void)animateWithLayerFromBounds:(CGRect)fromBounds toBounds:(CGRect)toBounds Layer:(CALayer*)layer positionFrom:(CGPoint)fromValue potionTo:(CGPoint)toValue
{
//    CABasicAnimation *aniBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
//    aniBounds.fromValue = [NSValue valueWithCGRect:fromBounds];//原始bounds
//    aniBounds.toValue = [NSValue valueWithCGRect:toBounds];//目标位置的bounds
    
    //position指的是锚点(layer中心点)的初始位置,移动到目标位置
    CABasicAnimation *aniPosition = [CABasicAnimation animationWithKeyPath:@"position"];
    aniPosition.fromValue = [NSValue valueWithCGPoint:fromValue];
    aniPosition.toValue = [NSValue valueWithCGPoint:toValue];
    
    CAAnimationGroup *anis = [CAAnimationGroup animation];
    anis.animations = @[aniPosition];
    anis.duration = 2;
    anis.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anis.removedOnCompletion = NO;
    anis.fillMode = kCAFillModeForwards;
    [layer addAnimation:anis forKey:nil];
}

#pragma mark -- getter

- (CAGradientLayer *)leftLayer
{
    if (!_leftLayer) {
        CAGradientLayer *itemLayer = [CAGradientLayer layer];
        //蓝色
        itemLayer.colors = @[(__bridge id) [self fmut_colorWithRGB:0x79C0FF].CGColor,
                             (__bridge id) [self fmut_colorWithRGB:0x589AFF].CGColor];
        itemLayer.locations = @[@0, @1.0];
        itemLayer.startPoint = CGPointMake(0, 0);//渐变色以x轴为方向渐变
        itemLayer.endPoint = CGPointMake(1.0, 0);
        _leftLayer = itemLayer;
        
    }
    return _leftLayer;
}

- (CAGradientLayer *)rightLayer
{
    if (!_rightLayer) {
        CAGradientLayer *itemLayer = [CAGradientLayer layer];
        //红色
        itemLayer.colors = @[(__bridge id) [self fmut_colorWithRGB:0xFF73C9].CGColor,
                             (__bridge id) [self fmut_colorWithRGB:0xFF86DF].CGColor];
        itemLayer.locations = @[@0, @1.0];
        itemLayer.startPoint = CGPointMake(0, 0);//渐变色以x轴为方向渐变
        itemLayer.endPoint = CGPointMake(1.0, 0);
        _rightLayer = itemLayer;
    }
    return _rightLayer;
}

#pragma mark -- Tools

- (UIColor *)fmut_colorWithRGB:(uint32_t)rgbValue
{
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

- (UIBezierPath*)getPathByPoints:(NSArray*)points
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < points.count; i++) {
        CGPoint retrievedPoint = CGPointFromString([points objectAtIndex:i]);
        if (i == 0) {
            [path moveToPoint:retrievedPoint];
        }else
            [path addLineToPoint:retrievedPoint];
    }
    [path closePath];
    return  path;
}

@end
