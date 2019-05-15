//
//  UIView+CKViewCategory.h
//  CKAudioProgress
//
//  Created by guo on 2019/5/14.
//  Copyright © 2019 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (CKLayerCategory)

@property (nonatomic) CGFloat ckOriginY;
@property (nonatomic) CGFloat ckOriginX;
@property (nonatomic) CGFloat ckWidth;

@end

@interface UIView (CKViewCategory)

@property (nonatomic) CGFloat ckOriginY;
@property (nonatomic) CGFloat ckCenterX;

@end

NS_ASSUME_NONNULL_END
