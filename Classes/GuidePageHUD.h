//
//  GuidePageHUD.h
//  GuidePageView
//
//  Created by zhangxiaoye on 2019/7/17.
//  Copyright © 2019 zhangxiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GuidePageHUDDelegate <NSObject>
@optional

- (void)get_intoClick:(UIButton *)intoBtn;

@end

@interface GuidePageHUD : UIView

@property (nonatomic, weak) id<GuidePageHUDDelegate> selectDelegate;

// pageControl未选中状态
@property (nonatomic, strong) UIImage *inactiveImage;

// pageControl选中状态
@property (nonatomic, strong) UIImage *currentImage;

// 跳过按钮图片
@property (nonatomic, strong) UIImage *SkipBtnImage;

// 立即进入按钮图片
@property (nonatomic, strong) UIImage *Get_intoBtnImage;

- (instancetype)zxy_initWithFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray;

- (instancetype)zxy_initWithFrame:(CGRect)frame videoURL:(NSString *)videoURL;

@end

NS_ASSUME_NONNULL_END
