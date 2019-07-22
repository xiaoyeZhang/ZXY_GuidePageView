//
//  GuidePageHUD.m
//  GuidePageView
//
//  Created by zhangxiaoye on 2019/7/17.
//  Copyright © 2019 zhangxiaoye. All rights reserved.
//

#import "GuidePageHUD.h"
#import "CustomPageControl.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#define DDHidden_TIME   2.0
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

@interface GuidePageHUD()<UIScrollViewDelegate>

@property (nonatomic ,assign) CGFloat                    Width;
@property (nonatomic ,assign) CGFloat                    Height;
@property (nonatomic ,strong) UIButton                  *Get_intoBtn;
@property (nonatomic ,strong) UIButton                  *SkipBtn;
@property (nonatomic ,strong) UIScrollView              *mainScrollView;
@property (nonatomic ,strong) CustomPageControl         *pageControl;
@property (nonatomic ,strong) NSArray         *imageArr;

@property (nonatomic, strong) AVPlayerViewController *playerController;

@end

@implementation GuidePageHUD

- (instancetype)zxy_initWithFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray{
    
    if ([super initWithFrame:frame]) {
        
        _Width = frame.size.width;
        
        _Height = frame.size.height;
     
        self.imageArr = imagesArray;
        
        [self addScrollView];
        
        [self addPageControl];
        
        [self addSkipBtn];
        
        [self addGet_intoBtn];
    }
    
    return self;
    
}

- (instancetype)zxy_initWithFrame:(CGRect)frame videoURL:(NSString *)videoURL{
    
    if ([super initWithFrame:frame]) {

        self.playerController = [[AVPlayerViewController alloc]init];

        if ([videoURL hasPrefix:@"http://"] || [videoURL hasPrefix:@"https://"]) {

            self.playerController.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:videoURL]];

        }else{
            
            self.playerController.player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:videoURL ofType:nil]]];

        }

        self.playerController.showsPlaybackControls = false;
        self.playerController.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.playerController.player play];
        [self addSubview:self.playerController.view];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        [self addSubview:self.Get_intoBtn];
        
        [self.Get_intoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-70);
            
        }];

    }
    
    return self;
}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification{
    
    [self rerunPlayVideo];
    
}

//视频重播

-(void)rerunPlayVideo{
    if (!self.playerController.player) {
        return;
    }
    CGFloat a=0;
    NSInteger dragedSeconds = floorf(a);
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.playerController.player seekToTime:dragedCMTime];
    [self.playerController.player play];
}

/**
 添加scrollView
 */
- (void)addScrollView{
    
    [self addSubview:self.mainScrollView];
    
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self);
    }];
    
    self.mainScrollView.contentSize = CGSizeMake(_Width * [_imageArr count], 0);
    
    for (int i = 0; i < [_imageArr count]; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(_Width * i, 0, _Width, _Height)];

        NSData *localData;
        ///。 网络资源
        if ([[_imageArr objectAtIndex:i] hasPrefix:@"http://"] || [[_imageArr objectAtIndex:i] hasPrefix:@"https://"]) {

            localData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_imageArr objectAtIndex:i]]];
            
           NSString *imageType = [GuidePageHUD dh_contentTypeForImageData:localData];
            
            if ([imageType isEqualToString:@"gif"]) {
            
                UIImageView *imageView = [[YYAnimatedImageView alloc]initWithFrame:image.frame];
                [imageView yy_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:i]] options:YYWebImageOptionSetImageWithFadeAnimation];

                image = imageView;
            
            }else{

                [image yy_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:i]] options:YYWebImageOptionSetImageWithFadeAnimation];

            }
        }else{
            
            localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[_imageArr objectAtIndex:i] ofType:nil]];
            
            NSString *imageType = [GuidePageHUD dh_contentTypeForImageData:localData];

            if ([imageType isEqualToString:@"gif"]) {
                
                UIImageView *imageView = [[YYAnimatedImageView alloc]initWithFrame:image.frame];
                imageView.yy_imageURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[_imageArr objectAtIndex:i] ofType:nil]];
                
                image = imageView;
                
            }else{
                
                image.yy_imageURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[_imageArr objectAtIndex:i] ofType:nil]];

            }
            

        }

        [self.mainScrollView addSubview:image];
        
    }
    
}

#pragma mark - 通过图片Data数据第一个字节来获取图片扩展名
+ (NSString *)dh_contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

/**
 添加PageControl
 */
- (void)addPageControl{
    
    [self addSubview:self.pageControl];
    
    self.pageControl.numberOfPages = [_imageArr count];
    CGSize size= [self.pageControl sizeForNumberOfPages:[_imageArr count]];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-30);
        make.width.equalTo(@(self->_Width));
        make.height.equalTo(@(size.height));
    }];
}

/**
 添加跳过按钮
 */
- (void)addSkipBtn{
    
    [self addSubview:self.SkipBtn];
    
    [self.SkipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(kStatusBarHeight + 20);
        make.right.equalTo(self).offset(-23);
    }];
}

/**
 添加进来按钮
 */
- (void)addGet_intoBtn{
    
    [self.mainScrollView addSubview:self.Get_intoBtn];
    
    [self.Get_intoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mainScrollView).offset(self->_Width * ([self->_imageArr count] - 1));
        make.bottom.equalTo(self).offset(-70);
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // pageControl 与 scrollView 联动
    CGFloat offsetWidth = scrollView.contentOffset.x;
    int pageNum = offsetWidth / _Width;
    self.pageControl.currentPage = pageNum;
    
}

- (void)get_intoClick:(UIButton *)sender{
    
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(get_intoClick:)]) {
        
        [self.selectDelegate get_intoClick:sender];
    }else{
        
        [UIView animateWithDuration:DDHidden_TIME animations:^{
            self.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DDHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
            });
        }];
        
    }
    
}

- (void)removeGuidePageHUD {
    [self removeFromSuperview];
}

- (void)setCurrentImage:(UIImage *)currentImage{
    
    self.pageControl.currentImage = currentImage;

}

- (void)setInactiveImage:(UIImage *)inactiveImage{
    
    self.pageControl.inactiveImage = inactiveImage;
}

- (void)setSkipBtnImage:(UIImage *)SkipBtnImage{
    
    [_SkipBtn setImage:SkipBtnImage forState:UIControlStateNormal];

}

- (void)setGet_intoBtnImage:(UIImage *)Get_intoBtnImage{
    
    [_Get_intoBtn setImage:Get_intoBtnImage forState:UIControlStateNormal];

}

- (UIScrollView *)mainScrollView{
    
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]init];
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = YES;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainScrollView;
}

- (CustomPageControl *)pageControl{
    
    if (!_pageControl) {
        self.pageControl = [[CustomPageControl alloc]init];
        
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.userInteractionEnabled = NO;
        self.pageControl.inactiveImage = [UIImage imageNamed:@"page"];
        self.pageControl.currentImage = [UIImage imageNamed:@"选中状态"];
        
        //去掉系统自带样式
        self.pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
        self.pageControl.pageIndicatorTintColor = [UIColor clearColor];
    }
    
    return _pageControl;
}

- (UIButton *)SkipBtn{
    
    if (!_SkipBtn) {
        _SkipBtn = [[UIButton alloc]init];
        
        [_SkipBtn setImage:[UIImage imageNamed:@"跳过"] forState:UIControlStateNormal];
        
        [_SkipBtn addTarget:self action:@selector(get_intoClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _SkipBtn;
}

- (UIButton *)Get_intoBtn{
    
    if (!_Get_intoBtn) {
        _Get_intoBtn = [[UIButton alloc]init];
        [_Get_intoBtn setImage:[UIImage imageNamed:@"开始体验"] forState:UIControlStateNormal];
        
        [_Get_intoBtn addTarget:self action:@selector(get_intoClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _Get_intoBtn;
}

@end
