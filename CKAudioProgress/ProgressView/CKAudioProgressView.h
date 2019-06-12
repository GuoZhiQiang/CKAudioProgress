//
//  CKAudioProgressView.h
//  CKAudioProgress
//
//  Created by guo on 2019/5/14.
//  Copyright © 2019 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CKAudioProgressViewDelegate <NSObject>

@optional
- (void)audioProgressTouchBegin;
- (void)audioProgressTouchMovePercent:(CGFloat)percent;
- (void)audioProgresstouchEndhPercent:(CGFloat)percent totalTime:(NSInteger)totalTime;
@end

typedef NS_ENUM(NSInteger, CKAudioProgressType) {
    CKAudioProgressTypeNormal, ///默认拖拽view是个圆点
    CKAudioProgressTypeTimeline ///表示拖拽view是个时间进度
};
@interface CKAudioProgressView : UIView

@property (nonatomic, strong) UIColor *cachedBgColor; ///缓冲进度条背景颜色
@property (nonatomic, strong) UIColor *progressBgColor; ///进度条默认填充背景色

/**
 @desc 已经播放的进度条渐变色, 存储 CGColorRef 对象的数组
 @note 该属性和 playedBgColor 二选一
 */
@property (nonatomic, copy  ) NSArray *colors;
/**
 @desc 已经播放的进度条背景颜色
 @note 该属性和colors 二选一
 */
@property (nonatomic, strong) UIColor *playedBgColor;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGRect slideViewBounds; ///拖拽view(圆点或时间进度)的大小

@property (nonatomic, weak  ) id<CKAudioProgressViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(CKAudioProgressType)progressType;
/**
 @note 修改当前进度，可以根据后面参数计算出当前播放时长并显示在时间lable上
 @param progress 进度百分比
 @param audioLength 总时间
 */
- (void)updateProgress:(CGFloat)progress audioLength:(NSInteger)audioLength;
@end

NS_ASSUME_NONNULL_END
