//
//  PKView.h
//  动态圆柱
//
//  Created by jerold on 2019/5/27.
//  Copyright © 2019 CodingFire. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKView : UIView
- (instancetype)initWithLeftRate:(float)leftRate frame:(CGRect)frame;
- (void)updateAnimation;//动画更新
@end

NS_ASSUME_NONNULL_END
