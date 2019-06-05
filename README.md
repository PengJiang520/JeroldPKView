# JeroldPKView
PK动画
![演示](http://ww4.sinaimg.cn/large/006tNc79ly1g3qcwjueyhg30f00qoad8.gif)
### 1.需求：
1.两边的条状颜色为渐变色
2.动画方向如上图所示，从两边往中间延展
3.两边的条状图形不规则

### 2.实现方式：
1.渐变色
CAGradientLayer可以实现渐变色
```
- (CAGradientLayer *)leftLayer {
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

- (CAGradientLayer *)rightLayer {
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

- (UIColor *)fmut_colorWithRGB:(uint32_t)rgbValue{
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

```
2.动画
要实现这个从两边往中间延展的动画，我用的是CAAnimationGroup，两个CABasicAnimation作为一组动画。一个是CAGradientLayer的position位置动画，还有一个是bounds动画，两个合成一组，就能实现这个需求。关键点是，CABasicAnimation的position变化是以layer的锚点也就是中心点为对象的。

3.不规则图形
要画出左右layer的不规则形状，我们拆分一下，view的外轮廓用切圆角实现，那么剩下就是如何画出中间部分的斜边。用关键点画贝塞尔线的方式来实现，然后用CAShapeLayer作为左右layer的mask
```
CAShapeLayer *shapLayerRight = [CAShapeLayer layer];
shapLayerRight.path = [self getPathByPoints:pointArray1].CGPath;
self.rightLayer.mask = shapLayerRight;

//利用关键点画贝塞尔线
- (UIBezierPath*)getPathByPoints:(NSArray*)points {
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
```

### 3.使用方法：
```
self.pkView = [[PKView alloc]initWithTotalNum:100 votedNum:50 frame:CGRectMake(15, 200, SCREEN_WIDTH-30, 36)];
self.pkView.layer.cornerRadius = 18;
self.pkView.layer.masksToBounds = YES;
[self.view addSubview:self.pkView];
```

