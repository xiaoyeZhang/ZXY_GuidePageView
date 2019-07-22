# ZXY_GuidePageView
## 项目引导页
# 使用ZXY_GuidePageView

三步完成主流App框架搭建：

- 第一步：使用CocoaPods导入ZXY_GuidePageView
- 第二步：初始化GuidePageHUD类,同时传入图片地址,或GIF地址,视频地址
- 第三不:   (可选)实现代理方法,自定义进入APP首页

# 第一步：使用CocoaPods导入ZXY_GuidePageView

CocoaPods 导入

在文件 Podfile 中加入以下内容：

pod 'ZXY_GuidePageView'
然后在终端中运行以下命令：

pod install
或者这个命令：
```
禁止升级 CocoaPods 的 spec 仓库，否则会卡在 Analyzing dependencies，非常慢
pod install --verbose --no-repo-update
或者
pod update --verbose --no-repo-update
```
完成后，CocoaPods 会在您的工程根目录下生成一个 .xcworkspace 文件。您需要通过此文件打开您的工程，而不是之前的 .xcodeproj。
# 第二步：初始化GuidePageHUD类,同时传入图片地址,或GIF地址,视频地址

```

GuidePageHUD *view = [[GuidePageHUD alloc] zxy_initWithFrame:self.view.frame imagesArray:@[@"搜索.png",@"信息同步.png",@"背景.png"]];

[self.view addSubview:view];
```

# 第三步（可选）：实现代理方法,自定义进入APP首页

```

GuidePageHUD *view = [[GuidePageHUD alloc] zxy_initWithFrame:self.view.frame imagesArray:@[@"搜索.png",@"信息同步.png",@"背景.png"]];

view.selectDelegate = self;

[self.view addSubview:view];


- (void)get_intoClick:(UIButton *)intoBtn{

    NSLog(@"点击跳过或立即进入");
}

``` 
