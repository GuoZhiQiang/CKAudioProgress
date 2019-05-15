//
//  UIView+CKViewCategory.m
//  CKAudioProgress
//
//  Created by guo on 2019/5/14.
//  Copyright © 2019 guo. All rights reserved.
//

#import "CALayer+CKViewCategory.h"

@implementation CALayer (CKLayerCategory)

- (CGFloat)ckOriginX {
    return self.frame.origin.x;
}

- (void)setCkOriginX:(CGFloat)ckOriginX {
    CGRect frame = self.frame;
    frame.origin.x = ckOriginX;
    self.frame = frame;
}

- (CGFloat)ckOriginY {
    return self.frame.origin.y;
}

- (void)setCkOriginY:(CGFloat)ckOriginY {
    CGRect frame = self.frame;
    frame.origin.y = ckOriginY;
    self.frame = frame;
}

- (CGFloat)ckWidth {
    return self.frame.size.width;
}

- (void)setCkWidth:(CGFloat)ckWidth {
    CGRect frame = self.frame;
    frame.size.width = ckWidth;
    self.frame = frame;
}

@end

@implementation UIView (CKViewCategory)

- (CGFloat)ckOriginY {
    return self.frame.origin.y;
}

- (void)setCkOriginY:(CGFloat)ckOriginY {
    CGRect frame = self.frame;
    frame.origin.y = ckOriginY;
    self.frame = frame;
}

- (CGFloat)ckCenterX {
    return self.center.x;
}
- (void)setCkCenterX:(CGFloat)ckCenterX {
    CGPoint center = self.center;
    center.x = ckCenterX;
    self.center = center;
}

@end
