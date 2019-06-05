//
//  PKView.h
//  动态圆柱
//
//  Created by liudj on 2019/5/27.
//  Copyright © 2019 CodingFire. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKView : UIView
- (instancetype)initWithTotalNum:(NSInteger)total votedNum:(NSInteger)votedNum frame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
