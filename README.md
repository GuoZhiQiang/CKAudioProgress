## CKAudioProgress
简单易用的音视频进度条

## 效果
![音视频进度条](https://github.com/GuoZhiQiang/CKAudioProgress/blob/master/CKAudioProgress/Images/audioprogress.gif)

## 安装

在`Podfile` 文件里添加 `pod 'CKAudioProgress'`

然后在终端运行: `pod install`

>注意：如果使用 `pod search CKAudioProgress` 搜不到，那么，你需要

 ```
 pod setup
 rm -rf ~/Library/Caches/Cocoapods
 ```
 
## 使用

有两种样式可以选择：
```
typedef NS_ENUM(NSInteger, CKAudioProgressType) {
    CKAudioProgressTypeNormal,  ///默认拖拽区域是个 实体圆圈
    CKAudioProgressTypeTimeline ///表示拖拽区域是个 显示时间的时间进度
};
```

#### 1. 拖拽区域 是个实体圆圈
```
CKAudioProgressView *normalP = [[CKAudioProgressView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50) type:CKAudioProgressTypeNormal];
```

#### 2. 拽区域是个 显示时间的时间进度

```
CKAudioProgressView *timelineP = [[CKAudioProgressView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 50) type:CKAudioProgressTypeTimeline];
```

## 可自定义的属性

- `UIColor *cachedBgColor` 该属性表示 缓冲 进度背景颜色
- `UIColor *progressBgColor` 该属性表示 进度条 默认填充背景色
- `NSArray *colors`
>已经播放的进度条渐变色, 存储 CGColorRef 对象的数组 *注意: 该属性和 playedBgColor 二选一

- `UIColor *playedBgColor`
>已经播放的进度条背景颜色 *注意 该属性和colors 二选一

- `CGFloat cornerRadius` 进度条的 `cornerRadius`
- `CGRect slideViewBounds` 拖拽区域(圆点或时间进度)的大小

## 代理方法
目前没有提供代理方法，只有 `delegate` 属性，可以自行定义 `delegate` 方法

