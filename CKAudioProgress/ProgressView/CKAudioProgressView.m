//
//  CKAudioProgressView.m
//  CKAudioProgress
//
//  Created by guo on 2019/5/14.
//  Copyright © 2019 guo. All rights reserved.
//

#import "CKAudioProgressView.h"
#import "CALayer+CKViewCategory.h"

@interface CKAudioProgressView()

@property (nonatomic, assign) BOOL    isSliding;
@property (nonatomic, assign) NSInteger audioLength;

@property (nonatomic, strong) UIView  *slideView;
@property (nonatomic, strong) UILabel *lb_time;
@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong) CALayer *cachedLayer;
@property (nonatomic, strong) CAShapeLayer *dotLayer;
@property (nonatomic, strong) CAGradientLayer *playedLayer;
@property (nonatomic, assign) CKAudioProgressType progressType;

@end

@implementation CKAudioProgressView

- (instancetype)initWithFrame:(CGRect)frame type:(CKAudioProgressType)progressType {
    self = [super initWithFrame:frame];
    if (self) {
        self.progressType = progressType;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    [self.layer addSublayer:self.bgLayer];
    [self.layer addSublayer:self.cachedLayer];
    [self.layer addSublayer:self.playedLayer];
    
    if (CKAudioProgressTypeNormal == self.progressType) {
        [self addSubview:self.slideView];
    }
    else {
        [self addSubview:self.lb_time];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat originY = (self.bounds.size.height-2)/2;
    self.bgLayer.ckOriginY = originY;
    self.bgLayer.ckWidth = self.frame.size.width;
    self.cachedLayer.ckOriginY = originY;
    self.playedLayer.ckOriginY = originY;
    
    if (CKAudioProgressTypeNormal == self.progressType) {
        CGFloat w = _slideView.bounds.size.width;
        CGFloat h = _slideView.bounds.size.height;
        _slideView.ckOriginY = (self.bounds.size.height-h)/2;
        _dotLayer.frame = CGRectMake(w/4, w/4, w/2, w/2);
        _dotLayer.cornerRadius = w/4;
    }
    else {
        _lb_time.ckOriginY = (self.bounds.size.height-_lb_time.bounds.size.height)/2;
    }
}

#pragma mark - Action
static CGFloat percent = 0.0;
- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    UIGestureRecognizerState state = gesture.state;
    if (UIGestureRecognizerStateBegan == state) {
        _isSliding = YES;
        percent = 0.0;
        if (_delegate && [_delegate respondsToSelector:@selector(audioProgressTouchBegin)]) {
            [_delegate audioProgressTouchBegin];
        }
    }
    else if (UIGestureRecognizerStateChanged == state) {
        CGPoint translation = [gesture translationInView:self];
        CGPoint slideViewCenter = CGPointMake(gesture.view.center.x+ translation.x, gesture.view.center.y);
        if (CKAudioProgressTypeNormal == self.progressType) {
            slideViewCenter.x = MAX(_dotLayer.bounds.size.width/2, slideViewCenter.x);
            slideViewCenter.x = MIN(self.bounds.size.width-_dotLayer.bounds.size.width/2, slideViewCenter.x);
        }
        else {
            slideViewCenter.x = MAX(gesture.view.bounds.size.width/2, slideViewCenter.x);
            slideViewCenter.x = MIN(self.bounds.size.width-gesture.view.bounds.size.width/2, slideViewCenter.x);
        }
        gesture.view.center = slideViewCenter;
        [gesture setTranslation:CGPointZero inView:self];
        
        _playedLayer.ckWidth = CKAudioProgressTypeNormal == self.progressType ? gesture.view.frame.origin.x+(_slideView.bounds.size.width/2-_dotLayer.bounds.size.width/2) : gesture.view.frame.origin.x;
        
        CGFloat totalWith = CKAudioProgressTypeTimeline == self.progressType ? self.bounds.size.width-_lb_time.bounds.size.width : self.bounds.size.width-_dotLayer.bounds.size.width;
        NSInteger audioProgress = _playedLayer.ckWidth/totalWith*self.audioLength;
        if (CKAudioProgressTypeTimeline == self.progressType) {
            [self setProgress:audioProgress total:self.audioLength];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(audioProgressTouchMovePercent:)]) {
            [_delegate audioProgressTouchMovePercent:percent];
        }
    }
    else if (UIGestureRecognizerStateEnded == state ||
             UIGestureRecognizerStateCancelled == state) {
        _isSliding = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(audioProgresstouchEndhPercent:totalTime:)]) {
            [_delegate audioProgresstouchEndhPercent:percent totalTime:self.audioLength];
        }
    }
}

- (void)setProgress:(NSInteger)progress total:(NSInteger)total {
    NSString *title = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",progress/60,progress%60,total/60,total%60];
    _lb_time.text = title;
}

- (void)updateProgress:(CGFloat)progress audioLength:(NSInteger)audioLength {
    if (isnan(percent) || isinf(percent)) {
        percent = 0;
    }
    if (audioLength <= 0) {
        return;
    }
    if (!_isSliding) {
        
        self.audioLength = audioLength;
        [self setProgress:(NSInteger)(percent*audioLength) total:audioLength];
        
        CGFloat totalWith = CKAudioProgressTypeTimeline == self.progressType ? self.bounds.size.width-_lb_time.bounds.size.width : self.bounds.size.width-_dotLayer.bounds.size.width;
        CGFloat playedWidth  = totalWith*percent;
        _playedLayer.ckWidth = playedWidth;
        
        if (CKAudioProgressTypeTimeline == self.progressType) {
            _lb_time.ckCenterX = playedWidth+_lb_time.bounds.size.width/2;
        }
        else {
            _slideView.ckCenterX = playedWidth+_dotLayer.bounds.size.width/2;
        }
    }
}

#pragma mark - Getter & Setter

- (void)setCachedBgColor:(UIColor *)cachedBgColor {
    if (cachedBgColor) {
        _cachedBgColor = cachedBgColor;
        self.cachedLayer.backgroundColor = cachedBgColor.CGColor;
    }
}
- (void)setProgressBgColor:(UIColor *)progressBgColor {
    if (progressBgColor) {
        _progressBgColor = progressBgColor;
        self.bgLayer.backgroundColor = progressBgColor.CGColor;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.cornerRadius = cornerRadius;
    self.bgLayer.cornerRadius = cornerRadius;
    self.cachedLayer.cornerRadius = cornerRadius;
    self.playedLayer.cornerRadius = cornerRadius;
}

- (void)setColors:(NSArray *)colors {
    if (!_playedBgColor && colors) {
        _colors = colors;
        self.playedLayer.colors = colors;
    }
}
- (void)setPlayedBgColor:(UIColor *)playedBgColor {
    if (!_colors && playedBgColor) {
        _playedBgColor = playedBgColor;
        self.playedLayer.backgroundColor = playedBgColor.CGColor;
    }
}

- (void)setSlideViewBounds:(CGRect)slideViewBounds {
    if (slideViewBounds.size.width > 0) {
        _slideViewBounds = slideViewBounds;
        
        if (CKAudioProgressTypeNormal == self.progressType) {
            self.slideView.bounds = slideViewBounds;
        }
        else {
            self.lb_time.bounds = slideViewBounds;
        }
        [self setNeedsLayout];
    }
}

- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        _bgLayer.backgroundColor = _progressBgColor ? _progressBgColor.CGColor : [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1].CGColor;
        _bgLayer.frame = CGRectMake(0, (self.bounds.size.height-2)/2, self.bounds.size.width, 2);
    }
    return _bgLayer;
}

- (CALayer *)cachedLayer {
    if (!_cachedLayer) {
        _cachedLayer = [CALayer layer];
        _cachedLayer.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        _cachedLayer.frame = CGRectMake(0, (self.bounds.size.height-2)/2, 0, 2);
    }
    return _cachedLayer;
}

- (CAGradientLayer *)playedLayer {
    if (!_playedLayer) {
        _playedLayer = [CAGradientLayer layer];
        _playedLayer.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:170/255.0 blue:100/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:247/255.0 green:100/255.0 blue:63/255.0 alpha:1.0].CGColor];
        _playedLayer.startPoint = CGPointMake(0.0, 0.0);
        _playedLayer.frame = CGRectMake(0, (self.bounds.size.height-2)/2, 0, 2);
    }
    return _playedLayer;
}

- (UIView *)slideView {
    if (!_slideView) {
        _slideView = [UIView new];
        _slideView.frame = CGRectMake(-(24-24/2-12/2), 0, 24, 24);
        CAShapeLayer *dotLayer = [CAShapeLayer layer];
        dotLayer.fillColor = [UIColor whiteColor].CGColor;
        dotLayer.frame = CGRectMake((24-12)/2, (24-12)/2, 12, 12);
        dotLayer.cornerRadius = 6;
        dotLayer.shadowColor = [UIColor colorWithRed:255/255.0 green:120/255.0 blue:2/255.0 alpha:1.0].CGColor;
        dotLayer.shadowOffset = CGSizeMake(0,0);
        dotLayer.shadowOpacity = 1;
        dotLayer.shadowRadius = 10;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:dotLayer.bounds];
        dotLayer.path = path.CGPath;
        self.dotLayer = dotLayer;
        [_slideView.layer addSublayer:dotLayer];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [_slideView addGestureRecognizer:panGes];
    }
    return _slideView;
}

- (UILabel *)lb_time {
    if (!_lb_time) {
        _lb_time = [UILabel new];
        _lb_time.font = [UIFont systemFontOfSize:12];
        _lb_time.textAlignment = NSTextAlignmentCenter;
        _lb_time.textColor = [UIColor colorWithRed:241/255.0 green:245/255.0 blue:255/255.0 alpha:1];
        _lb_time.frame = CGRectMake(0, 0, 82, 26);
        _lb_time.layer.cornerRadius = 14;
        _lb_time.layer.shadowColor = [UIColor colorWithRed:87/255.0 green:92/255.0 blue:111/255.0 alpha:0.5].CGColor;
        _lb_time.layer.shadowOffset = CGSizeMake(0,0);
        _lb_time.layer.shadowOpacity = 1;
        _lb_time.layer.shadowRadius = 6;
        _lb_time.layer.backgroundColor = [UIColor colorWithRed:66/255.0 green:72/255.0 blue:93/255.0 alpha:1.0].CGColor;
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        _lb_time.userInteractionEnabled = YES;
        [_lb_time addGestureRecognizer:panGes];
    }
    return _lb_time;
}

@end
