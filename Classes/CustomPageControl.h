//
//  CustomPageControl.h
//  WuxiAgriculture
//
//  Created by zhangxiaoye on 2019/2/12.
//  Copyright © 2019年 zhangxiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomPageControl : UIPageControl


@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *inactiveImage;

@property (nonatomic, assign) CGSize currentImageSize;
@property (nonatomic, assign) CGSize inactiveImageSize;

@end

NS_ASSUME_NONNULL_END
