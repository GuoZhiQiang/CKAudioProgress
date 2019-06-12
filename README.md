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

#### 3. 从外部改变进度条进度

该组件有个对象方法，接收从外部传递过来的当前播放的进度 `progress`(0-1) 以及总时间 `audioLength` 单位是秒 ：
```
- (void)updateProgress:(CGFloat)progress audioLength:(NSInteger)audioLength;
```

## 可自定义的属性

- `UIColor *cachedBgColor` 该属性表示 缓冲 进度背景颜色
- `UIColor *progressBgColor` 该属性表示 进度条 默认填充背景色

>已经播放的进度条渐变色, 存储 CGColorRef 对象的数组 *注意: 该属性和 playedBgColor 二选一
- `NSArray *colors`

>已经播放的进度条背景颜色 *注意 该属性和colors 二选一
- `UIColor *playedBgColor`

- `CGFloat cornerRadius` 进度条的 `cornerRadius`
- `CGRect slideViewBounds` 拖拽区域(圆点或时间进度)的大小

## 代理方法
当用户拖拽时，用来返回当前的播放时间和播放进度：

1. 用户开始拖拽进度条时，会触发下面代理方法，告知用户开始拖拽： 
```
- (void)audioProgressTouchBegin;
```

2. 用户在拖拽过程中，会触发下面代理方法，返回拖拽的进度：
```
- (void)audioProgressTouchMovePercent:(CGFloat)percent;
```

3. 用户拖拽结束，会触发下面代理方法，返回最终的进度和总时间(如果有)：
```
- (void)audioProgresstouchEndhPercent:(CGFloat)percent totalTime:(NSInteger)totalTime;
```

